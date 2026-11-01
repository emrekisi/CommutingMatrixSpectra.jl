# Petik, Özdemir, Gökmen (2022), Turk. J. Math. 46, 3373–3390 — comparison with Theorem 2.7

Problem: A1 {α1,β1,γ1}-cubic, A2 {α2,β2}-quadratic, A1A2=A2A1; when is a1A1+a2A2 (a1a2≠0) {α3,β3}-quadratic for **some** α3,β3? Main result: Theorem 2.7 (15 items; with the options i=1,2 / (i,j) they describe 28 block structures). Method and notation: `../README.md`. Files: `solutions.md` (our characterization), `free_cubic_quadratic_seed1.txt` (generic specialization), `free_tripotent_idempotent.txt`, `free_tripotent_involutive.txt` (the special cases of Corollaries 2.8 and 2.11).

## Framework

The case analysis of Theorem 2.7 assumes that both the γ1-eigenspace of A1 and its complement are **nonempty** (M2 and K, Z1, M1 are defined). In our list of 6 patterns the structures inside this framework are: γ1-block K ∈ {(i) (γ1,β2), (ii) (γ1,α2), (iii) both} × non-γ1 block L ⊆ {α1,β1}×{α2,β2} (14 nonempty proper subsets) = 42 structures. Generically solvable: **8 two-pattern + 14 three-pattern = 22**; solvable on a relation locus: **6 four-pattern**; the remaining 14 structures are unsolvable for every parameter value. The table of Theorem 2.7 contains exactly these 22+6 = **28 structures**; the 14 intersections excluded there as "contradicting the hypotheses" are exactly the ones we find unsolvable.

## Item-by-item correspondence

Each row is one block structure; "component" = one line/plane of our solution set.

| Item | (K)-(L) | Block structure (patterns) | k | Our result | Agreement |
|---|---|---|---|---|---|
| (a1) i=2 | (i)-(a) | {(β1,α2), (γ1,β2)} | 2 | generic: 2 component(s) (a free, dimension 2) | ✓ (identical solution sets) |
| (a1) i=1 | (i)-(h) | {(α1,α2), (γ1,β2)} | 2 | generic: 2 component(s) (a free, dimension 2) | ✓ (identical solution sets) |
| (a2) i=2 | (i)-(b) | {(β1,α2), (β1,β2), (γ1,β2)} | 3 | generic: 1 component(s) (lines) | ✓ (identical solution sets) |
| (a2) i=1 | (i)-(k) | {(α1,α2), (α1,β2), (γ1,β2)} | 3 | generic: 1 component(s) (lines) | ✓ (identical solution sets) |
| (a3) i=2 | (i)-(c) | {(β1,β2), (γ1,β2)} | 2 | generic: 1 component(s) (a free, dimension 2) | ✓ (identical solution sets) |
| (a3) i=1 | (i)-(d) | {(α1,β2), (γ1,β2)} | 2 | generic: 1 component(s) (a free, dimension 2) | ✓ (identical solution sets) |
| (a4) i=2 | (i)-(r) | {(α1,α2), (β1,α2), (β1,β2), (γ1,β2)} | 4 | generically UNSOLVABLE; solvable only when (alpha2 - beta2)*(alpha1 - 2*beta1 + gamma1) = 0 | ✓ (empty generically; agrees on the relation locus) |
| (a4) i=1 | (i)-(n) | {(α1,α2), (α1,β2), (β1,α2), (γ1,β2)} | 4 | generically UNSOLVABLE; solvable only when -(alpha2 - beta2)*(2*alpha1 - beta1 - gamma1) = 0 | ✓ (empty generically; agrees on the relation locus) |
| (a5) (i,j)=(1, 2) | (i)-(f) | {(α1,β2), (β1,α2), (γ1,β2)} | 3 | generic: 2 component(s) (lines) | ✓ (identical solution sets) |
| (a5) (i,j)=(2, 1) | (i)-(l) | {(α1,α2), (β1,β2), (γ1,β2)} | 3 | generic: 2 component(s) (lines) | ✓ (identical solution sets) |
| (a6)  | (i)-(m) | {(α1,α2), (β1,α2), (γ1,β2)} | 3 | generic: 2 component(s) (lines) | ✓ (identical solution sets) |
| (a7) i=2 | (ii)-(a) | {(β1,α2), (γ1,α2)} | 2 | generic: 1 component(s) (a free, dimension 2) | ✓ (identical solution sets) |
| (a7) i=1 | (ii)-(h) | {(α1,α2), (γ1,α2)} | 2 | generic: 1 component(s) (a free, dimension 2) | ✓ (identical solution sets) |
| (a8) i=2 | (ii)-(b) | {(β1,α2), (β1,β2), (γ1,α2)} | 3 | generic: 1 component(s) (lines) | ✓ (identical solution sets) |
| (a8) i=1 | (ii)-(k) | {(α1,α2), (α1,β2), (γ1,α2)} | 3 | generic: 1 component(s) (lines) | ✓ (identical solution sets) |
| (a9) i=2 | (ii)-(c) | {(β1,β2), (γ1,α2)} | 2 | generic: 2 component(s) (a free, dimension 2) | ✓ (identical solution sets) |
| (a9) i=1 | (ii)-(d) | {(α1,β2), (γ1,α2)} | 2 | generic: 2 component(s) (a free, dimension 2) | ✓ (identical solution sets) |
| (a10) i=2 | (ii)-(g) | {(α1,β2), (β1,α2), (β1,β2), (γ1,α2)} | 4 | generically UNSOLVABLE; solvable only when -(alpha2 - beta2)*(alpha1 - 2*beta1 + gamma1) = 0 | ✓ (empty generically; agrees on the relation locus) |
| (a10) i=1 | (ii)-(p) | {(α1,α2), (α1,β2), (β1,β2), (γ1,α2)} | 4 | generically UNSOLVABLE; solvable only when -(alpha2 - beta2)*(2*alpha1 - beta1 - gamma1) = 0 | ✓ (empty generically; agrees on the relation locus) |
| (a11) (i,j)=(1, 2) | (ii)-(f) | {(α1,β2), (β1,α2), (γ1,α2)} | 3 | generic: 2 component(s) (lines) | ✓ (identical solution sets) |
| (a11) (i,j)=(2, 1) | (ii)-(l) | {(α1,α2), (β1,β2), (γ1,α2)} | 3 | generic: 2 component(s) (lines) | ✓ (identical solution sets) |
| (a12)  | (ii)-(e) | {(α1,β2), (β1,β2), (γ1,α2)} | 3 | generic: 2 component(s) (lines) | ✓ (identical solution sets) |
| (a13) i=2 | (iii)-(a) | {(β1,α2), (γ1,α2), (γ1,β2)} | 3 | generic: 1 component(s) (lines) | ✓ (identical solution sets) |
| (a13) i=1 | (iii)-(h) | {(α1,α2), (γ1,α2), (γ1,β2)} | 3 | generic: 1 component(s) (lines) | ✓ (identical solution sets) |
| (a14) i=2 | (iii)-(c) | {(β1,β2), (γ1,α2), (γ1,β2)} | 3 | generic: 1 component(s) (lines) | ✓ (identical solution sets) |
| (a14) i=1 | (iii)-(d) | {(α1,β2), (γ1,α2), (γ1,β2)} | 3 | generic: 1 component(s) (lines) | ✓ (identical solution sets) |
| (a15) (i,j)=(1, 2) | (iii)-(f) | {(α1,β2), (β1,α2), (γ1,α2), (γ1,β2)} | 4 | generically UNSOLVABLE; solvable only when (alpha2 - beta2)*(alpha1 + beta1 - 2*gamma1) = 0 | ✓ (empty generically; agrees on the relation locus) |
| (a15) (i,j)=(2, 1) | (iii)-(l) | {(α1,α2), (β1,β2), (γ1,α2), (γ1,β2)} | 4 | generically UNSOLVABLE; solvable only when -(alpha2 - beta2)*(alpha1 + beta1 - 2*gamma1) = 0 | ✓ (empty generically; agrees on the relation locus) |

## Verification

(a) Generic parameters: the coefficient equations c₁..c₄ of every item were solved (a1=1) at two different generic rational parameter sets; all solutions lie in our components, and conversely sample points of every component of ours satisfy the equations of the corresponding item. For the 2-pattern items (a1),(a3),(a7),(a9) the solutions are parametric (a free); they were verified by random sampling. (b) Special cases: for tripotent×idempotent and tripotent×involutive matrices (the framework of Corollaries 2.8 and 2.11) our engine finds 37 closed structures each; every structure inside the framework matches a structure of Theorem 2.7 under every labelling of {1,−1,0} (6 for (α1,β1,γ1), 2 for (α2,β2)), and **all 1503 / 1502 sampled solutions** satisfy the coefficient conditions of the matching item.

## Conclusion

Theorem 2.7 is **complete and correct**: there is no solution in the paper that our method misses, and none in ours that the paper misses. Remarks:
- Items (a4), (a10), (a15) (4-block structures) are **void for generic parameters**; they are non-void only when **one of α1,β1,γ1 is the arithmetic mean of the other two** (relations in the table above; for tripotent matrices 0=(1+(−1))/2 holds — the items of type (a4),(b4) of Corollary 2.8 come from here). The paper does not state this.
- The option "i=1 or 2" is the renaming α1↔β1 (our group G is trivial for symbolic parameters; this is a label symmetry, not a matrix symmetry).
- The 17 structures outside the framework (A1 has only γ1, or no γ1 at all: 6 one-pattern, 7 two-pattern, 4 three-pattern) are outside the scope of Theorem 2.7; they are the cases where A1 is in fact quadratic or scalar and fall under the results on two quadratic matrices cited there as [22,23]. All of them are in our list (`free_cubic_quadratic_seed1.txt`).
