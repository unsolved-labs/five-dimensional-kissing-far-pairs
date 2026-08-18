#!/usr/bin/env python3
"""
Dependency-free exact replay for Unsolved Labs R008.

Independent of verifier.py: standard-library Fraction arithmetic, a direct
Gegenbauer recurrence, and an in-file implementation of Sturm root counting.
"""

from __future__ import annotations
from fractions import Fraction as Q

N = 41
A_STRONG = Q(442, 625)
A_MODERATE = Q(133, 200)
STRONG_THRESHOLD = -A_STRONG
MODERATE_THRESHOLD = -A_MODERATE

STRONG = {
    0: Q(13939907, 100000000), 1: Q(12103401, 25000000),
    2: Q(139479103, 100000000), 3: Q(30090377, 25000000),
    4: Q(41787773, 25000000), 9: Q(38538027, 50000000),
}
MODERATE = {
    0: Q(6113963, 50000000), 1: Q(3549967, 10000000),
    2: Q(59464043, 50000000), 3: Q(11303433, 12500000),
    4: Q(17480877, 12500000), 9: Q(29954461, 50000000),
}
LOCAL = {
    0: Q(99999, 100000), 1: Q(153764653, 50000000),
    2: Q(89219103, 25000000), 3: Q(163063619, 100000000),
    6: Q(13716513, 100000000),
}

def trim(p):
    p=list(p)
    while len(p)>1 and p[-1]==0: p.pop()
    return p

def add(a,b):
    out=[Q(0)]*max(len(a),len(b))
    for i,x in enumerate(a): out[i]+=x
    for i,x in enumerate(b): out[i]+=x
    return trim(out)

def neg(a): return [-x for x in a]
def sub(a,b): return add(a,neg(b))
def scale(c,a): return trim([c*x for x in a])
def mul_x(a): return [Q(0)]+list(a)

def evaluate(a,x):
    value=Q(0)
    for c in reversed(a): value=value*x+c
    return value

def derivative(a):
    if len(a)<=1: return [Q(0)]
    return trim([Q(i)*a[i] for i in range(1,len(a))])

def divrem(a,b):
    a,b=trim(a),trim(b)
    if b==[Q(0)]: raise ZeroDivisionError
    q=[Q(0)]*max(1,len(a)-len(b)+1)
    r=list(a)
    while r != [Q(0)] and len(r)>=len(b):
        shift=len(r)-len(b); c=r[-1]/b[-1]; q[shift]+=c
        for j,bj in enumerate(b): r[j+shift]-=c*bj
        r=trim(r)
    return trim(q),trim(r)

def sturm_sequence(p):
    seq=[trim(p),derivative(p)]
    while seq[-1] != [Q(0)]:
        _,r=divrem(seq[-2],seq[-1])
        if r==[Q(0)]: break
        seq.append(neg(r))
    return seq

def sign(x): return (x>0)-(x<0)

def variations_at(seq,x):
    s=[sign(evaluate(p,x)) for p in seq]
    s=[v for v in s if v]
    return sum(a!=b for a,b in zip(s,s[1:]))

def roots_in_open_interval(p,left,right):
    assert evaluate(p,left)!=0 and evaluate(p,right)!=0
    seq=sturm_sequence(p)
    return variations_at(seq,left)-variations_at(seq,right)

def raw_gegenbauer(k,d):
    lam=Q(d-2,2)
    if k==0: return [Q(1)]
    if k==1: return [Q(0),2*lam]
    c0=[Q(1)]; c1=[Q(0),2*lam]
    for n in range(1,k):
        t1=scale(2*(Q(n)+lam),mul_x(c1))
        t2=scale(Q(n)+2*lam-1,c0)
        c2=scale(Q(1,n+1),sub(t1,t2))
        c0,c1=c1,c2
    return c1

def normalized_gegenbauer(k,d):
    p=raw_gegenbauer(k,d)
    return scale(Q(1)/evaluate(p,Q(1)),p)

def polynomial_from_coefficients(coeff,d):
    p=[Q(0)]
    for k,v in coeff.items():
        p=add(p,scale(v,normalized_gegenbauer(k,d)))
    return p

def ceil_fraction(x): return -((-x.numerator)//x.denominator)

def certify_negative(p,left,right,sample):
    assert evaluate(p,left)<0 and evaluate(p,right)<0 and evaluate(p,sample)<0
    assert roots_in_open_interval(p,left,right)==0

def certify_below_one(p,left,right):
    q=sub([Q(1)],p)
    assert evaluate(q,left)>0 and evaluate(q,right)>0
    assert roots_in_open_interval(q,left,right)==0

def main():
    assert all(v>0 for v in STRONG.values())
    assert all(v>0 for v in MODERATE.values())
    assert all(v>0 for v in LOCAL.values())
    fs=polynomial_from_coefficients(STRONG,5)
    fm=polynomial_from_coefficients(MODERATE,5)
    gl=polynomial_from_coefficients(LOCAL,4)

    certify_negative(fs,STRONG_THRESHOLD,Q(1,2),Q(0))
    certify_below_one(fs,Q(-1),STRONG_THRESHOLD)
    certify_negative(fm,MODERATE_THRESHOLD,Q(1,2),Q(0))
    certify_below_one(fm,Q(-1),MODERATE_THRESHOLD)

    sd=N*N*STRONG[0]-N*evaluate(fs,Q(1))
    md=N*N*MODERATE[0]-N*evaluate(fm,Q(1))
    assert sd==Q(209711679,100000000) and ceil_fraction(sd/2)==2
    assert md==Q(912370581,50000000) and ceil_fraction(md/2)==10

    cap=(Q(1,2)-A_MODERATE*A_MODERATE)/(1-A_MODERATE*A_MODERATE)
    assert cap==Q(2311,22311)
    certify_negative(gl,Q(-1),cap,Q(0))
    obj=evaluate(gl,Q(1))/LOCAL[0]
    assert obj==Q(18823697,1999980) and obj<10

    assert 3-6*A_MODERATE<0
    assert (6*6)//4==9<10

    u=(1-A_STRONG)*(1-A_MODERATE)
    v=(1+A_STRONG)*(1+A_MODERATE)
    target=Q(779,1000)
    w=target*target*v-1-u
    assert w>0 and w*w-4*u>0

    assert (1-A_STRONG)/2==Q(183,1250)
    assert (1+A_STRONG)/2==Q(1067,1250)
    assert (1-A_MODERATE)/2==Q(67,400)
    assert (1+A_MODERATE)/2==Q(333,400)

    print("INDEPENDENT R008 CERTIFICATE REPLAY VERIFIED")
    print("strong edges >= 2; moderate edges >= 10; Delta <= 9")
    print("difference-axis bound < 779/1000")

if __name__=="__main__":
    main()
