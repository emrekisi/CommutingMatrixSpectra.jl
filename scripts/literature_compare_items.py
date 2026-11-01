"""Coefficient conditions of [PÖG22] Theorem 2.7 (item1_eqs) and [DÜ25] Theorem 8 (item_eqs), transcribed from the papers,
and the helpers used for the numerical tests in the session (see literature/*/comparison.md).  c2 of Theorem 8 is taken with a2
(the theorem statement has a typo a1).  Globals pp1..rr2, W (= {1:p1, 2:q1}) hold the numeric parameter values."""
import sympy as sp, re, itertools

def c_all(a1v, a2v, p3v, q3v):
    pp1,qq1,rr1,pp2,qq2,rr2 = [valsS[s] for s in (p1,q1,r1,p2,q2,r2)]
    a3 = a1v*rr1 + a2v*rr2
    return dict(c1=a1v**2*(pp1+qq1-2*rr1) + a1v*(2*a3-p3v-q3v), c2=a2v**2*(pp2+qq2-2*rr2) + a2v*(2*a3-p3v-q3v),
                c3=-a1v**2*(pp1-rr1)*(qq1-rr1), c4=-a2v**2*(pp2-rr2)*(qq2-rr2), c5=(a3-p3v)*(a3-q3v), a1=a1v, a2=a2v)


def item_eqs(n, i, j, c):
    c1,c2,c3,c4,c5,a1v,a2v = c['c1'],c['c2'],c['c3'],c['c4'],c['c5'],c['a1'],c['a2']
    wi, wj = W[i], W[j]; A = a1v*a2v; P2R=pp2-rr2; Q2R=qq2-rr2; P2Q=pp2-qq2; WI=wi-rr1; WJ=wj-rr1; WIJ=wi-wj
    E = {
     1: [c1, c3 + c2*P2Q + 2*A*WI*P2R, c4 + P2R*(c2+2*A*WI), c5 + c3],
     2: [c3 + WJ*(c1+2*A*P2R) + c2*P2Q, c4 - c1*WIJ + P2R*(c2+2*A*WJ), c5 + c1*WIJ - c2*P2Q - 2*A*WJ*P2R],
     3: [c1 + 2*A*P2R, c4 + P2R*(c2+2*A*WI), c5 - c2*P2Q - 2*A*WI*P2R, c3 + c2*P2Q],
     4: [c3 + c1*WI, c4 + c2*Q2R, c5, -c1*WIJ + c2*P2Q + 2*A*WJ*P2R],
     5: [c1 + 2*A*P2R, c3 + c2*P2Q, c4 + c2*Q2R, c5],
     6: [c4 + c2*Q2R, c5, c3 + WI*(c1+2*A*Q2R), c1*WIJ - c2*P2Q - 2*A*(WJ*P2R - WI*Q2R)],
     7: [c3 + WI*(c1+2*A*Q2R), c4 + c2*Q2R, c5, c1*WIJ - c2*P2Q, WI*Q2R - WJ*P2R],
     8: [c1 + 2*A*P2R, c3 - 2*A*P2R*WI, c4 + c2*Q2R, c2*P2Q + 2*A*WI*P2R, c5],
     9: [c1 + 2*A*P2R, c2 + 2*A*WI, c3 - 2*A*P2R*WI, c4 - 2*A*WI*Q2R, c5],
     10: [c1 + 2*A*Q2R, c2 + 2*A*WI, c5, c4 - 2*A*WI*Q2R + c3],
     11: [c4 + WI*(c1+2*A*P2R) + c2*P2R + c3, c5, -c1*WIJ - c2*P2Q - 2*A*(P2R*WI - WJ*Q2R)],
     12: [c5, c4 + WI*(c1+2*A*P2R) + c2*P2R + c3, c1*(wj-wi) - c2*P2Q, WI*P2R - WJ*Q2R],
     13: [c1 + 2*A*P2R, c2 + 2*A*WI, c5, c4 - 2*A*WI*P2R + c3],
     14: [c3 + c1*WJ, c5, c4 + c2*P2R, -c1*WIJ + c2*P2Q - 2*A*WI*Q2R],
     15: [c4 + c2*P2R, c1 + 2*A*Q2R, c3 - c2*P2Q, c5],
     16: [c1 + 2*A*Q2R, c2 + 2*A*WI, c3 + 2*A*WI*P2Q, c4 - 2*A*WI*P2R, c5],
     17: [c4 + c2*P2R, c5, c3 + WJ*(c1+2*A*P2R), -c1*WIJ + c2*P2Q - 2*A*(Q2R*WI - WJ*P2R)],
     18: [c3 + WJ*(c1+2*A*P2R), c4 + c2*P2R, c5, c1*WIJ - c2*P2Q, WJ*P2R - WI*Q2R],
     19: [c2 + 2*A*WJ, c3 + c1*WI, c4 - 2*A*WJ*P2R, c1*WIJ - 2*A*WJ*P2R, c5],
     20: [c1 + 2*A*Q2R, c2 + 2*A*WI, c3 + 2*A*WI*P2Q, c4 + 2*A*WI*P2R, c5],
     21: [c2, c3 + WI*(c1+2*A*Q2R), c4 + c1*WIJ + 2*A*WI*Q2R, c5 - c1*WIJ - 2*A*WI*Q2R],
     22: [c1, c2, c5 + c3, c5 + c4],
     23: [c1, c2, c4 + 2*A*WI*P2R, c5 + c3, c5 + c4],
     24: [c2, c3 + WJ*(c1+2*A*P2R), c4 - c1*WIJ + 2*A*WJ*P2R, c5 + c4],
     25: [c2, c3 + WI*(c1+2*A*Q2R), c4 + 2*A*WJ*P2R, c5 + c4, c1*WIJ - 2*A*(WJ*P2R - Q2R*WI)],
     26: [c1, c2, c3 + 2*A*WI*Q2R, c4 + 2*A*WJ*P2R, c5 + c4, WJ*P2R - Q2R*WI],
     27: [c1, c2, c4 + 2*A*WI*P2R, c5 + c4, c5 + c3],
     28: [c3 + WI*(c1+2*A*Q2R) - c2*P2Q, c4 + c1*WIJ + Q2R*(c2+2*A*WI), c5 - c1*WIJ + c2*P2Q - 2*A*WI*Q2R],
     29: [c3 + WJ*(c1+2*A*P2R), c4 + P2R*(c2+2*A*WJ), c5 - 2*A*WJ*P2R, -c1*WIJ + c2*P2Q - 2*A*(WI*Q2R - P2R*WJ)],
     30: [c2 + 2*A*WJ, c3 + WJ*(c1+2*A*P2R), c4 - c1*WIJ, c5 + c1*WIJ - 2*A*WJ*P2R],
     31: [c3 + WJ*(c1+2*A*P2R), c4 + c2*P2R, c5, -c1*WIJ + c2*P2Q - 2*A*(WI*Q2R - WJ*P2R)],
     32: [c3 + WJ*(c1+2*A*P2R), c4 + c2*P2R, c5, c1*WIJ - c2*P2Q, WJ*P2R - WI*Q2R],
     33: [c1 + 2*A*Q2R, c2 + 2*A*WI, c5, c3 + 2*A*WI*P2Q, c4 - 2*A*WI*P2R],
     34: [c2, c5 + c4, c3 + WJ*(c1+2*A*P2R), c4 - c1*WIJ + 2*A*WJ*P2R],
    }
    return E[n]


def cvals1(a1v,a2v,p3v,q3v):
    a3 = a1v*G1v + a2v*B2v
    return dict(c1=a1v**2*(A1v+B1v-2*G1v) + a1v*(2*a3-p3v-q3v), c2=a2v**2*(A2v-B2v) + a2v*(2*a3-p3v-q3v), c3=-a1v**2*(A1v-G1v)*(B1v-G1v), c4=(a3-p3v)*(a3-q3v), a1=a1v, a2=a2v)


def item1_eqs(n, i, j, c):
    c1,c2,c3,c4,A = c['c1'],c['c2'],c['c3'],c['c4'],c['a1']*c['a2']
    wi, wj = W1[i], W1[j]; D2 = A2v-B2v; WI = wi-G1v; WJ = wj-G1v
    E = {1: [c1*WI + c2*D2 + c3 + 2*A*WI*D2, c4], 2: [c2 + 2*A*WI, c3 + c1*WI, c4], 3: [c3 + c1*WI, c4],
         4: [c1 + 2*A*D2, c2 + 2*A*WI, c3 - 2*A*WI*D2, c4], 5: [c1*WI + c3, c2*D2 + c1*WJ + 2*A*WJ*D2 + c3, c4],
         6: [c1 + 2*A*D2, c3 + c2*D2, c4], 7: [c1*WI + c3 + 2*A*WI*D2, c2*D2 + c4], 8: [c2 + 2*A*WI, c3 + WI*(c1 + 2*A*D2), c4 - 2*A*WI*D2],
         9: [c1*WI + c3 - c2*D2, c2*D2 + c4], 10: [c1, c2 + 2*A*WI, c3 + 2*A*WI*D2, c3 + c4],
         11: [c1*WI + c3 + c4, c2*D2 + c4, c1*WJ + 2*A*WJ*D2 + c3], 12: [c1, c2*D2 - c3, c3 + c4],
         13: [c1*WI + c3 + 2*A*WI*D2, c2, c4], 14: [c1*WI + c3, c2, c4], 15: [c1*WJ + 2*A*WJ*D2 + c3, c2, c4, c3 + c1*WI]}
    return E[n]


def quadratic_on(S, a1v, a2v, p3v, q3v):
    return all((num[x]*a1v + num[y]*a2v) in (p3v, q3v) for x,y in S)


def quad1(S, a1v, a2v, p3v, q3v): return all((num1[x]*a1v + num1[y]*a2v) in (p3v, q3v) for x,y in S)


def expand_sets(pats):
    opt = [p for p in pats if '?' in p[0]]; fixed = [p for p in pats if '?' not in p[0]]
    sets = []
    for k in range(len(opt)+1):
        for sub in itertools.combinations(opt, k):
            s = sorted(set(fixed) | {(p[0].rstrip('?'), p[1]) for p in sub})
            sets.append(tuple(s))
    return sets


def ess_cubic(S):
    return {x for x,_ in S} == {'p1','q1','r1'} and {y for _,y in S} == {'p2','q2','r2'}


def parse_case(c):
    lab = re.match(r"\((\w+)\)-\((\d+)\)", c).groups()
    b1 = re.search(r"B1 = S\[(.*?)\]S", c).group(1); b2 = re.search(r"B2 = S\[(.*?)\]S", c).group(1)
    cons = c[c.index("]S")+2:]  # constraints text
    B1 = blocks(b1); B2 = blocks(b2)
    assert len(B1) == len(B2), (lab, B1, B2)
    pats = set()
    for x, y in zip(B1, B2):
        xs = set(); ys = set()
        if x == "0": xs = {"r1"}
        elif "(p1 − r1)I" == x: xs = {"p1"}
        elif "(q1 − r1)I" == x: xs = {"q1"}
        else:
            # (p1 − q1)D + (q1 − r1)I  with D≠0 → p1 present; D≠I → q1 present ; Z3 ≠ 0, I → both
            var = re.search(r"\(p1 − q1\)(\w+)", x).group(1)
            ne = re.search(var + r"\s*̸=\s*([0I](?:,\s*[0I])?)", c)
            nes = set(ne.group(1).replace(" ","").split(",")) if ne else set()
            xs = set()
            if "0" in nes: xs.add("p1")
            if "I" in nes: xs.add("q1")
            if not nes: xs = {"p1?", "q1?"}
            if nes == {"0"}: xs = {"p1", "q1?"}
            if nes == {"I"}: xs = {"q1", "p1?"}
        if y == "0": ys = {"r2"}
        elif "(p2 − r2)I" == y: ys = {"p2"}
        elif "(q2 − r2)I" == y: ys = {"q2"}
        else: raise ValueError((lab, y))
        for xx in xs:
            for yy in ys: pats.add((xx, yy))
    return lab, sorted(pats), B1, B2


def relabel(S, l1, l2):
    m1 = dict(zip([1,-1,0], l1)); m2 = dict(zip([1,-1,0], l2))
    return frozenset((m1[x]+'1', m2[y]+'2') for x,y in S)
