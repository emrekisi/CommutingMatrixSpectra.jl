"""literature_compare.py — symbolic classification of the free-target problems of
Petik–Özdemir–Gökmen (Turk J Math 2022) and Demirkol–Ünlütürk (Axioms 2025) and item-by-item
tests of their main theorems.  Requires sympy.  The Axioms Table 5 is parsed from the text
layer of the PDF (file paper_axioms.txt, produced with pdf text extraction)."""
import sympy as sp, itertools, re, sys, random

# ---------------------------------------------------------------- core classification
def analyze(S):
    """S: list of (x,y) sympy expressions (eigenvalue patterns).  Unknowns u=(a1,a2,p3,q3).
    A component = partition of S into the p3-group P and the q3-group Q (S[0] in P).
    Within a group all values a1*x+a2*y coincide: each pair gives (dx,dy).(a1,a2)=0.
    dx=0 or dy=0 forces a1=0 or a2=0 -> discarded.  Two independent conditions are compatible only on
    the locus dx*dy2-dx2*dy=0 -> 'rels'; generic iff rels is empty.  dim = dimension in C^4."""
    out = []; n = len(S)
    for mask in range(2**(n-1)):
        P = [S[0]] + [S[i] for i in range(1, n) if mask >> (i-1) & 1]
        Qg = [S[i] for i in range(1, n) if not (mask >> (i-1) & 1)]
        conds = []; bad = False
        for grp in (P, Qg):
            for l in grp[1:]:
                dx = sp.expand(grp[0][0] - l[0]); dy = sp.expand(grp[0][1] - l[1])
                if dx == 0 and dy == 0: continue
                if dx == 0 or dy == 0: bad = True; break
                conds.append((dx, dy))
            if bad: break
        if bad: continue
        rels = set()
        for (dx, dy), (dx2, dy2) in itertools.combinations(conds, 2):
            r = sp.factor(sp.expand(dx*dy2 - dx2*dy))
            if r != 0: rels.add(r)
        out.append(dict(P=P, Q=Qg, dim=(2 if not conds else 1) + (1 if not Qg else 0), generic=(len(rels) == 0),
                        rels=sorted(str(r) for r in rels), ratio=(None if not conds else sp.factor(-conds[0][0]/conds[0][1]))))
    return out

def classify_all(L):
    res = {}
    for k in range(1, len(L)+1):
        for S in itertools.combinations(L, k):
            comps = analyze(list(S))
            if comps: res[S] = comps
    return res

a1_,b1_,g1_,a2_,b2_ = sp.symbols('alpha1 beta1 gamma1 alpha2 beta2')
p1,q1,r1,p2,q2,r2 = sp.symbols('p1 q1 r1 p2 q2 r2')
L1 = [(x, y) for x in (a1_, b1_, g1_) for y in (a2_, b2_)]
L2 = [(x, y) for x in (p1, q1, r1) for y in (p2, q2, r2)]

if __name__ == "__main__":
    R1 = classify_all(L1); R2 = classify_all(L2)
    for name, R in (("cubic x quadratic", R1), ("cubic x cubic", R2)):
        gen = {S: [c for c in cs if c['generic']] for S, cs in R.items()}
        print(name, "generic solvable:", sum(1 for S in gen if gen[S]), "by size:",
              {k: sum(1 for S in gen if gen[S] and len(S)==k) for k in range(1,10) if any(gen[S] and len(S)==k for S in gen)},
              "| exceptional-only:", sum(1 for S in R if not gen[S]))
    # the item-by-item tests (coefficient conditions of Theorem 2.7 / Theorem 8) are in the session notebook
    # cells reproduced in literature_compare_items.py
