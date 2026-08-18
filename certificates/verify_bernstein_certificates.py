#!/usr/bin/env python3
"""Independent structural verifier for generated R008 Bernstein certificates."""
from __future__ import annotations
from fractions import Fraction as Q
from hashlib import sha256
from math import comb
from pathlib import Path
import json
ROOT=Path(__file__).resolve().parent; CERT_PATH=ROOT/"bernstein_certificates.json"; SUMMARY_PATH=ROOT/"certificate_summary.json"
def q(value): assert set(value)=={"numerator","denominator"}; return Q(int(value["numerator"]),int(value["denominator"]))
def trim(p):
    p=list(p)
    while len(p)>1 and p[-1]==0: p.pop()
    return p or [Q(0)]
def add(a,b):
    out=[Q(0)]*max(len(a),len(b))
    for i,x in enumerate(a): out[i]+=x
    for i,x in enumerate(b): out[i]+=x
    return trim(out)
def scale(c,p): return trim([c*x for x in p])
def mul(a,b):
    out=[Q(0)]*(len(a)+len(b)-1)
    for i,x in enumerate(a):
        for j,y in enumerate(b): out[i+j]+=x*y
    return trim(out)
def evaluate(p,x):
    out=Q(0)
    for coefficient in reversed(p): out=out*x+coefficient
    return out
def affine_substitute(p,left,right):
    affine=[left,right-left]; power=[Q(1)]; out=[Q(0)]
    for coefficient in p: out=add(out,scale(coefficient,power)); power=mul(power,affine)
    return trim(out)
def power_to_bernstein(p,n):
    assert len(p)-1<=n; coefficients=p+[Q(0)]*(n+1-len(p)); return [sum(coefficients[i]*Q(comb(k,i),comb(n,i)) for i in range(k+1)) for k in range(n+1)]
def bernstein_eval(beta,x):
    n=len(beta)-1; return sum(beta[k]*comb(n,k)*x**k*(1-x)**(n-k) for k in range(n+1))
def main():
    raw=CERT_PATH.read_bytes(); document=json.loads(raw); summary=json.loads(SUMMARY_PATH.read_text()); assert document["schemaVersion"]==1 and document["release"]=="R008"; assert sha256(raw).hexdigest()==summary["certificateSha256"]
    expected_names={"strongNonfarNegative","strongFarBelowOne","moderateNonfarNegative","moderateFarBelowOne","localNegative"}; seen=set(); total_pieces=0
    for certificate in document["certificates"]:
        name=certificate["name"]; assert name in expected_names and name not in seen; seen.add(name); sign=certificate["requiredSign"]; assert sign in {"negative","positive"}; degree=int(certificate["degree"]); original=[q(x) for x in certificate["powerCoefficientsAscending"]]; assert len(original)==degree+1; original_left=q(certificate["originalInterval"]["left"]); original_right=q(certificate["originalInterval"]["right"]); assert original_left<original_right; pieces=certificate["pieces"]; assert len(pieces)==summary["pieceCount"][name]; total_pieces+=len(pieces); previous_right=original_left; max_depth=0; strict_margins=[]
        for piece in pieces:
            left,right=q(piece["left"]),q(piece["right"]); assert left==previous_right and left<right; previous_right=right; depth=int(piece["depth"]); max_depth=max(max_depth,depth); affine_power=[q(x) for x in piece["affinePowerCoefficientsAscending"]]; beta=[q(x) for x in piece["bernsteinCoefficients"]]; assert len(beta)==degree+1; assert affine_power==affine_substitute(original,left,right); assert beta==power_to_bernstein(affine_power,degree); margin=q(piece["strictMargin"])
            if sign=="negative": assert all(value<0 for value in beta) and margin==max(beta)<0
            else: assert all(value>0 for value in beta) and margin==min(beta)>0
            strict_margins.append(margin)
            for j in range(degree+3):
                u=Q(j,degree+2); t=left+(right-left)*u; lhs=evaluate(original,t); assert lhs==evaluate(affine_power,u)==bernstein_eval(beta,u)
        assert previous_right==original_right and max_depth==summary["maximumDepth"][name]; controlling=max(strict_margins) if sign=="negative" else min(strict_margins); assert controlling==q(summary["strictMargins"][name])
    assert seen==expected_names and total_pieces==48; print("R008 BERNSTEIN CERTIFICATE JSON VERIFIED"); print(f"certificate sha256: {summary['certificateSha256']}"); print(f"certificates: {len(seen)}; interval pieces: {total_pieces}")
if __name__=="__main__": main()
