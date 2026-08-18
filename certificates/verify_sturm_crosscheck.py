#!/usr/bin/env python3
"""Independent exact Sturm cross-check for the five R008 sign intervals."""
from __future__ import annotations
from fractions import Fraction as Q
from pathlib import Path
import json
ROOT=Path(__file__).resolve().parent; DOC=json.loads((ROOT/"bernstein_certificates.json").read_text())
def q(o): return Q(o["numerator"],o["denominator"])
def trim(p):
    p=list(p)
    while len(p)>1 and p[-1]==0: p.pop()
    return p or [Q(0)]
def evaluate(p,x):
    out=Q(0)
    for c in reversed(p): out=out*x+c
    return out
def derivative(p): return [Q(0)] if len(p)<=1 else trim([Q(i)*p[i] for i in range(1,len(p))])
def divrem(a,b):
    a,b=trim(a),trim(b)
    if b==[Q(0)]: raise ZeroDivisionError
    quotient=[Q(0)]*max(1,len(a)-len(b)+1); remainder=list(a)
    while remainder!=[Q(0)] and len(remainder)>=len(b):
        shift=len(remainder)-len(b); factor=remainder[-1]/b[-1]; quotient[shift]+=factor
        for i,coefficient in enumerate(b): remainder[i+shift]-=factor*coefficient
        remainder=trim(remainder)
    return trim(quotient),trim(remainder)
def negate(p): return [-x for x in p]
def sturm_sequence(p):
    sequence=[trim(p),derivative(p)]
    if sequence[-1]==[Q(0)]: return sequence[:1]
    while True:
        _,remainder=divrem(sequence[-2],sequence[-1])
        if remainder==[Q(0)]: break
        sequence.append(negate(remainder))
    return sequence
def sign(x): return (x>0)-(x<0)
def variations(sequence,x):
    signs=[sign(evaluate(p,x)) for p in sequence]; signs=[s for s in signs if s!=0]; return sum(a!=b for a,b in zip(signs,signs[1:]))
def roots_open(p,left,right):
    assert left<right and evaluate(p,left)!=0 and evaluate(p,right)!=0; sequence=sturm_sequence(p); return variations(sequence,left)-variations(sequence,right)
def main():
    checked=0
    for certificate in DOC["certificates"]:
        name=certificate["name"]; p=[q(x) for x in certificate["powerCoefficientsAscending"]]; left=q(certificate["originalInterval"]["left"]); right=q(certificate["originalInterval"]["right"]); required=certificate["requiredSign"]; count=roots_open(p,left,right); assert count==0,f"{name}: found {count} roots"; endpoint_values=(evaluate(p,left),evaluate(p,right)); assert all(value<0 for value in endpoint_values) if required=="negative" else all(value>0 for value in endpoint_values); checked+=1; print(f"{name}: roots=0, endpoint sign={required}")
    assert checked==5; print("R008 EXACT STURM CROSS-CHECK PASSED")
if __name__=="__main__": main()
