#!/usr/bin/env python3
"""Independent exact verification of R008 Gegenbauer reference JSON."""
from __future__ import annotations
from fractions import Fraction as Q
from hashlib import sha256
from pathlib import Path
import json
ROOT=Path(__file__).resolve().parent; PATH=ROOT/"gegenbauer_reference.json"
def trim(p):
    p=list(p)
    while len(p)>1 and p[-1]==0:p.pop()
    return p or [Q(0)]
def add(a,b):
    out=[Q(0)]*max(len(a),len(b))
    for i,x in enumerate(a):out[i]+=x
    for i,x in enumerate(b):out[i]+=x
    return trim(out)
def scale(c,a):return trim(c*x for x in a)
def mul_x(a):return [Q(0)]+list(a)
def sub(a,b):return add(a,[-x for x in b])
def evaluate(a,x):
    v=Q(0)
    for c in reversed(a):v=v*x+c
    return v
def raw(k,d):
    lam=Q(d-2,2)
    if k==0:return[Q(1)]
    if k==1:return[Q(0),2*lam]
    c0=[Q(1)];c1=[Q(0),2*lam]
    for n in range(1,k):c2=scale(Q(1,n+1),sub(scale(2*(Q(n)+lam),mul_x(c1)),scale(Q(n)+2*lam-1,c0)));c0,c1=c1,c2
    return c1
def normalized(k,d):
    p=raw(k,d);v=evaluate(p,Q(1));assert v!=0;return scale(Q(1,v),p)
def parse(q):return Q(q["numerator"],q["denominator"])
def main():
    raw_text=PATH.read_text(encoding="utf-8");data=json.loads(raw_text);total=0
    for d_text,entries in data["ambientDimensions"].items():
        d=int(d_text)
        for entry in entries:
            k=int(entry["degree"]);actual=[parse(q) for q in entry["powerCoefficientsAscending"]];expected=normalized(k,d);assert actual==expected,(d,k);assert evaluate(actual,Q(1))==1;total+=1
    digest=sha256(raw_text.encode()).hexdigest();print(f"R008 GEGENBAUER REFERENCE VERIFIED: {total} polynomials");print(f"reference sha256: {digest}")
if __name__=="__main__":main()
