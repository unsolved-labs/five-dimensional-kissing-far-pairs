#!/usr/bin/env python3
"""Generate exact Bernstein subdivision certificates for Unsolved Labs R008.

The generator uses only Python's standard library.  It reconstructs the
normalized Gegenbauer polynomials from their three-term recurrence, forms the
three frozen R008 certificate polynomials, and subdivides each target interval
until every Bernstein coefficient has the required strict sign.

The generated JSON is a proof certificate, not a search transcript.  A small
Lean checker can validate each affine polynomial identity and use Bernstein
basis nonnegativity to derive the interval sign.
"""

from __future__ import annotations

from dataclasses import dataclass
from fractions import Fraction as Q
from hashlib import sha256
from math import comb
from pathlib import Path
import json
from typing import Iterable, Literal

ROOT = Path(__file__).resolve().parent
PROJECT_ROOT = ROOT.parent
LEAN_ROOT = PROJECT_ROOT / "lean-overlay" if (PROJECT_ROOT / "lean-overlay").is_dir() else PROJECT_ROOT
OUT_JSON = ROOT / "bernstein_certificates.json"
OUT_SUMMARY = ROOT / "certificate_summary.json"
OUT_LEAN = LEAN_ROOT / "R008" / "Generated" / "BernsteinData.lean"

Poly = list[Q]
Sign = Literal["negative", "positive"]

N = 41
A_STRONG = Q(442, 625)
A_MODERATE = Q(133, 200)
LOCAL_CAP = Q(2311, 22311)
AXIS_TARGET = Q(779, 1000)

STRONG = {0: Q(13939907, 100000000),1: Q(12103401, 25000000),2: Q(139479103, 100000000),3: Q(30090377, 25000000),4: Q(41787773, 25000000),9: Q(38538027, 50000000)}
MODERATE = {0: Q(6113963, 50000000),1: Q(3549967, 10000000),2: Q(59464043, 50000000),3: Q(11303433, 12500000),4: Q(17480877, 12500000),9: Q(29954461, 50000000)}
LOCAL = {0: Q(99999, 100000),1: Q(153764653, 50000000),2: Q(89219103, 25000000),3: Q(163063619, 100000000),6: Q(13716513, 100000000)}

def trim(p: Iterable[Q]) -> Poly:
    out=list(p)
    while len(out)>1 and out[-1]==0: out.pop()
    return out or [Q(0)]
def add(a,b):
    out=[Q(0)]*max(len(a),len(b))
    for i,x in enumerate(a): out[i]+=x
    for i,x in enumerate(b): out[i]+=x
    return trim(out)
def neg(a): return [-x for x in a]
def sub(a,b): return add(a,neg(b))
def scale(c,a): return trim(c*x for x in a)
def mul(a,b):
    out=[Q(0)]*(len(a)+len(b)-1)
    for i,x in enumerate(a):
        for j,y in enumerate(b): out[i+j]+=x*y
    return trim(out)
def mul_x(a): return [Q(0)]+list(a)
def evaluate(a,x):
    value=Q(0)
    for c in reversed(a): value=value*x+c
    return value

def raw_gegenbauer(k,d):
    lam=Q(d-2,2)
    if k==0: return [Q(1)]
    if k==1: return [Q(0),2*lam]
    c0=[Q(1)]; c1=[Q(0),2*lam]
    for n in range(1,k):
        c2=scale(Q(1,n+1),sub(scale(2*(Q(n)+lam),mul_x(c1)),scale(Q(n)+2*lam-1,c0)))
        c0,c1=c1,c2
    return c1

def normalized_gegenbauer(k,d):
    p=raw_gegenbauer(k,d); at_one=evaluate(p,Q(1)); assert at_one!=0
    return scale(Q(1,1)/at_one,p)
def polynomial_from_gegenbauer(coefficients,d):
    out=[Q(0)]
    for k,coefficient in sorted(coefficients.items()): out=add(out,scale(coefficient,normalized_gegenbauer(k,d)))
    return out

def affine_substitute(p,a,b):
    affine=[a,b-a]; out=[Q(0)]; power=[Q(1)]
    for coefficient in p:
        out=add(out,scale(coefficient,power)); power=mul(power,affine)
    return trim(out)
def power_to_bernstein(power,degree=None):
    n=max(len(power)-1,0) if degree is None else degree
    if len(power)-1>n: raise ValueError("degree too small")
    padded=power+[Q(0)]*(n+1-len(power)); beta=[]
    for k in range(n+1):
        value=Q(0)
        for i in range(k+1):
            if padded[i]!=0: value+=padded[i]*Q(comb(k,i),comb(n,i))
        beta.append(value)
    return beta
def bernstein_evaluate(beta,u):
    n=len(beta)-1
    return sum(beta[k]*Q(comb(n,k))*(u**k)*((1-u)**(n-k)) for k in range(n+1))
def qstr(q): return str(q.numerator) if q.denominator==1 else f"{q.numerator}/{q.denominator}"
def qobj(q): return {"numerator":q.numerator,"denominator":q.denominator}
def lean_q(q):
    if q.denominator==1:
        return f"(-({-q.numerator} : ℚ))" if q.numerator<0 else f"({q.numerator} : ℚ)"
    return f"(-({-q.numerator} : ℚ)) / {q.denominator}" if q.numerator<0 else f"({q.numerator} : ℚ) / {q.denominator}"

@dataclass(frozen=True)
class Task:
    name:str; polynomial:Poly; interval_left:Q; interval_right:Q; sign:Sign; mathematical_statement:str
@dataclass
class Piece:
    left:Q; right:Q; power:Poly; bernstein:list[Q]; depth:int
    def margin(self,sign): return max(self.bernstein) if sign=="negative" else min(self.bernstein)
def sign_ok(coefficients,sign): return all(x<0 for x in coefficients) if sign=="negative" else all(x>0 for x in coefficients)
def subdivide(task,max_depth=24):
    degree=len(task.polynomial)-1; pieces=[]; stack=[(task.interval_left,task.interval_right,0)]
    while stack:
        left,right,depth=stack.pop(); power=affine_substitute(task.polynomial,left,right); beta=power_to_bernstein(power,degree)
        if sign_ok(beta,task.sign): pieces.append(Piece(left,right,power,beta,depth)); continue
        if depth>=max_depth: raise RuntimeError(f"{task.name}: subdivision failed")
        mid=(left+right)/2; stack.append((mid,right,depth+1)); stack.append((left,mid,depth+1))
    pieces.sort(key=lambda piece:piece.left); assert pieces[0].left==task.interval_left and pieces[-1].right==task.interval_right
    for first,second in zip(pieces,pieces[1:]): assert first.right==second.left
    return pieces
def verify_piece(task,piece):
    assert sign_ok(piece.bernstein,task.sign); degree=len(piece.bernstein)-1
    for j in range(degree+3):
        u=Q(j,degree+2); lhs=evaluate(task.polynomial,piece.left+(piece.right-piece.left)*u); rhs=bernstein_evaluate(piece.bernstein,u)
        assert lhs==rhs==evaluate(piece.power,u); assert lhs<0 if task.sign=="negative" else lhs>0
def certificate_json(task,pieces):
    return {"name":task.name,"statement":task.mathematical_statement,"requiredSign":task.sign,"degree":len(task.polynomial)-1,"originalInterval":{"left":qobj(task.interval_left),"right":qobj(task.interval_right)},"powerCoefficientsAscending":[qobj(x) for x in task.polynomial],"pieces":[{"left":qobj(piece.left),"right":qobj(piece.right),"depth":piece.depth,"affinePowerCoefficientsAscending":[qobj(x) for x in piece.power],"bernsteinCoefficients":[qobj(x) for x in piece.bernstein],"strictMargin":qobj(piece.margin(task.sign))} for piece in pieces]}
def lean_list(values): return "[\n    "+",\n    ".join(lean_q(x) for x in values)+"\n  ]"
def generate_lean(tasks_and_pieces):
    lines=["/-!","# Generated exact R008 Bernstein certificate data","","This file is generated by `certificates/generate_bernstein_certificates.py`.","It contains only exact rational data.  The certificate-soundness theorem","belongs in `R008/Bernstein.lean`; no generated declaration is itself a","claim of interval positivity until that checker has compiled.","-/","","import Mathlib.Data.Rat.Defs","","set_option autoImplicit false","","namespace R008.Generated","","structure BernsteinPiece where","  left : ℚ","  right : ℚ","  affinePower : List ℚ","  bernstein : List ℚ","  depth : Nat","deriving Repr, DecidableEq","","structure BernsteinCertificate where","  name : String","  degree : Nat","  wantsNegative : Bool","  originalLeft : ℚ","  originalRight : ℚ","  originalPower : List ℚ","  pieces : List BernsteinPiece","deriving Repr, DecidableEq",""]
    cert_names=[]
    for task,pieces in tasks_and_pieces:
        ident=task.name; cert_names.append(ident); lines += [f"def {ident} : BernsteinCertificate := {{",f"  name := \"{task.name}\"",f"  degree := {len(task.polynomial)-1}",f"  wantsNegative := {'true' if task.sign=='negative' else 'false'}",f"  originalLeft := {lean_q(task.interval_left)}",f"  originalRight := {lean_q(task.interval_right)}",f"  originalPower := {lean_list(task.polynomial)}","  pieces := ["]
        for index,piece in enumerate(pieces):
            comma="," if index+1<len(pieces) else ""; lines += ["    {",f"      left := {lean_q(piece.left)}",f"      right := {lean_q(piece.right)}",f"      affinePower := {lean_list(piece.power)}",f"      bernstein := {lean_list(piece.bernstein)}",f"      depth := {piece.depth}",f"    }}{comma}"]
        lines += ["  ]","}",""]
    lines.append("def allCertificates : List BernsteinCertificate := [")
    for i,name in enumerate(cert_names): lines.append(f"  {name}{',' if i+1<len(cert_names) else ''}")
    lines += ["]","","end R008.Generated",""]
    return "\n".join(lines)

def main():
    strong_poly=polynomial_from_gegenbauer(STRONG,5); moderate_poly=polynomial_from_gegenbauer(MODERATE,5); local_poly=polynomial_from_gegenbauer(LOCAL,4)
    assert strong_poly==[Q(-143929,400000000),Q(-250986027,6400000000),Q(-472662129,400000000),Q(-7150759147,1600000000),Q(877543233,200000000),Q(94687932339,3200000000),Q(0),Q(-76652135703,1600000000),Q(0),Q(161821175373,6400000000)]
    tasks=[Task("strongNonfarNegative",strong_poly,-A_STRONG,Q(1,2),"negative","f_s(t) < 0 on [-442/625, 1/2]"),Task("strongFarBelowOne",sub([Q(1)],strong_poly),Q(-1),-A_STRONG,"positive","1 - f_s(t) > 0 on [-1, -442/625]"),Task("moderateNonfarNegative",moderate_poly,-A_MODERATE,Q(1,2),"negative","f_m(t) < 0 on [-133/200, 1/2]"),Task("moderateFarBelowOne",sub([Q(1)],moderate_poly),Q(-1),-A_MODERATE,"positive","1 - f_m(t) > 0 on [-1, -133/200]"),Task("localNegative",local_poly,Q(-1),LOCAL_CAP,"negative","g(t) < 0 on [-1, 2311/22311]")]
    results=[]; output={"schemaVersion":1,"release":"R008","method":"exact rational affine subdivision with Bernstein coefficients","generator":Path(__file__).name,"normalization":"P_k^(d)(1)=1; lambda=(d-2)/2 for S^(d-1)","certificates":[]}; summary={"release":"R008","pieceCount":{},"maximumDepth":{},"strictMargins":{},"exactChecks":{}}
    for task in tasks:
        pieces=subdivide(task)
        for piece in pieces: verify_piece(task,piece)
        results.append((task,pieces)); output["certificates"].append(certificate_json(task,pieces)); summary["pieceCount"][task.name]=len(pieces); summary["maximumDepth"][task.name]=max(piece.depth for piece in pieces); margins=[piece.margin(task.sign) for piece in pieces]; summary["strictMargins"][task.name]=qobj(max(margins) if task.sign=="negative" else min(margins))
    strong_deficit=Q(N*N)*STRONG[0]-Q(N)*evaluate(strong_poly,Q(1)); moderate_deficit=Q(N*N)*MODERATE[0]-Q(N)*evaluate(moderate_poly,Q(1)); local_objective=evaluate(local_poly,Q(1))/LOCAL[0]; axis_u=(1-A_STRONG)*(1-A_MODERATE); axis_v=(1+A_STRONG)*(1+A_MODERATE); axis_w=AXIS_TARGET*AXIS_TARGET*axis_v-1-axis_u; axis_discriminant=axis_w*axis_w-4*axis_u
    assert strong_deficit==Q(209711679,100000000); assert moderate_deficit==Q(912370581,50000000); assert LOCAL_CAP==(Q(1,2)-A_MODERATE**2)/(1-A_MODERATE**2); assert local_objective==Q(18823697,1999980)<10; assert axis_w>0 and axis_discriminant>0
    summary["exactChecks"]={"strongDeficit":qobj(strong_deficit),"moderateDeficit":qobj(moderate_deficit),"localCap":qobj(LOCAL_CAP),"localObjective":qobj(local_objective),"axisU":qobj(axis_u),"axisV":qobj(axis_v),"axisW":qobj(axis_w),"axisDiscriminant":qobj(axis_discriminant)}
    encoded=json.dumps(output,indent=2,sort_keys=True)+"\n"; OUT_JSON.write_text(encoded,encoding="utf-8"); summary["certificateSha256"]=sha256(encoded.encode()).hexdigest(); OUT_SUMMARY.write_text(json.dumps(summary,indent=2,sort_keys=True)+"\n",encoding="utf-8"); OUT_LEAN.parent.mkdir(parents=True,exist_ok=True); OUT_LEAN.write_text(generate_lean(results),encoding="utf-8"); print("R008 exact Bernstein certificates generated and verified"); print(f"certificate sha256: {summary['certificateSha256']}")
if __name__=="__main__": main()
