# Demirkol, Ünlütürk (2025), Axioms 14, 848 — comparison with Theorem 8

Problem: A1 essentially {p1,q1,r1}-cubic, A2 essentially {p2,q2,r2}-cubic (spectrum equal to the full three-element set), commuting; when is a1A1+a2A2 {p3,q3}-quadratic for some p3,q3? Main result: Theorem 8 (34 items; Tables 1–5 list 69 "intersection cases", 37 distinct block structures). Method and notation: `../README.md`. Files: `solutions.md` (our characterization), `table5_pattern_sets.md` (the cases of Table 5 as pattern sets, with the required relations), `tripotent_tripotent.md` (the special case of two tripotent matrices and its coverage), `free_cubic_cubic_seed1.txt`, `free_tripotent_tripotent.txt`.

## Generic parameters

Essential cubicity (all three eigenvalues of A1 and of A2 must occur) needs at least 3 patterns; generically at most 3 patterns are solvable; hence the generically solvable essentially-cubic structures are exactly the **6 "permutation" structures** {(x1,y1),(x2,y2),(x3,y3)} (the xᵢ and the yᵢ permutations of the eigenvalues), each with **3 components** (choice of the coinciding pair), 18 lines in total (`solutions.md`). In Theorem 8 these are characterized **only by items 2, 11 and 28** (each covers 2 structures × 3 lines via the (i,j) option; with a1=1: 12 solutions = 3 lines × 2 structures × p3↔q3): the solution sets of these three items coincide **exactly** with ours. The other **31 items are void for generic parameters** (their coefficient equations have no solution with a1a2≠0; verified with sympy at generic values such as (3,7,19,5,13,29)):

| Item | Table-5 cases | Block structures | Generic solutions (ours) | Coefficient conditions of the item (generic parameters, a1a2≠0) | Assessment |
|---|---|---|---|---|---|
| 1 | (i)-(5), (i)-(7), (i)-(22), (i)-(24) | k=3, k=4 (6 structures) | 3 lines per structure | no solution | void generically; its D=I / A∈{0,I} sub-cases are covered by items 2, 11 or 28 |
| 2 | (i)-(6), (i)-(23) | k=3 (2 structures) | 3 lines per structure | 12 solutions, all inside our components | ✓ characterizes its generic structures completely |
| 3 | (i)-(15), (i)-(16) | k=3, k=4 (4 structures) | 3 lines per structure | no solution | void generically; its D=I / A∈{0,I} sub-cases are covered by items 2, 11 or 28 |
| 4 | (ii)-(6), (ii)-(23) | k=4 (2 structures) | — | no solution | non-void only on a parameter-relation locus (4–5 patterns) |
| 5 | (ii)-(19) | k=4 (1 structures) | — | no solution | non-void only on a parameter-relation locus (4–5 patterns) |
| 6 | (ii)-(9), (ii)-(26) | k=4 (2 structures) | — | no solution | non-void only on a parameter-relation locus (4–5 patterns) |
| 7 | (ii)-(9), (ii)-(26) | k=4 (2 structures) | — | no solution | contains an explicit parameter relation; void generically |
| 8 | (ii)-(15), (ii)-(16) | k=4, k=5 (4 structures) | — | no solution | non-void only on a parameter-relation locus (4–5 patterns) |
| 9 | (ii)-(17), (ii)-(18) | k=4, k=5 (4 structures) | — | no solution | non-void only on a parameter-relation locus (4–5 patterns); **in the 5-block sub-case ((ii)-(17),(ii)-(18)) the conditions are wrong: the tripotent example has solutions that violate them** |
| 10 | (iii)-(8), (iii)-(10), (iii)-(25), (iii)-(27) | k=3, k=4 (6 structures) | 3 lines per structure | no solution | void generically; its D=I / A∈{0,I} sub-cases are covered by items 2, 11 or 28 |
| 11 | (iii)-(9), (iii)-(26) | k=3 (2 structures) | 3 lines per structure | 12 solutions, all inside our components | ✓ characterizes its generic structures completely |
| 12 | (iii)-(9), (iii)-(26) | k=3 (2 structures) | 3 lines per structure | no solution | contains an explicit parameter relation; void generically |
| 13 | (iii)-(17), (iii)-(18) | k=3, k=4 (4 structures) | 3 lines per structure | no solution | void generically; its D=I / A∈{0,I} sub-cases are covered by items 2, 11 or 28 |
| 14 | (iv)-(1), (iv)-(2) | k=4 (2 structures) | — | no solution | non-void only on a parameter-relation locus (4–5 patterns) |
| 15 | (iv)-(3) | k=4 (1 structures) | — | no solution | non-void only on a parameter-relation locus (4–5 patterns) |
| 16 | (iv)-(8), (iv)-(10), (iv)-(25), (iv)-(27) | k=4, k=5 (6 structures) | — | no solution | non-void only on a parameter-relation locus (4–5 patterns) |
| 17 | (iv)-(9), (iv)-(26) | k=4 (2 structures) | — | no solution | non-void only on a parameter-relation locus (4–5 patterns) |
| 18 | (iv)-(9), (iv)-(26) | k=4 (2 structures) | — | no solution | contains an explicit parameter relation; void generically |
| 19 | (iv)-(14), (iv)-(30) | k=4 (2 structures) | — | no solution | non-void only on a parameter-relation locus (4–5 patterns) |
| 20 | (iv)-(12), (iv)-(29) | k=4 (2 structures) | — | no solution | non-void only on a parameter-relation locus (4–5 patterns) |
| 21 | (v)-(1), (v)-(2) | k=4 (2 structures) | — | no solution | non-void only on a parameter-relation locus (4–5 patterns) |
| 22 | (v)-(4) | k=4 (1 structures) | — | no solution | non-void only on a parameter-relation locus (4–5 patterns) |
| 23 | (v)-(5), (v)-(7), (v)-(22), (v)-(24), (viii)-(5), (viii)-(7), (viii)-(22), (viii)-(24) | k=3, k=4, k=5 (12 structures) | 3 lines per structure | no solution | void generically; its D=I / A∈{0,I} sub-cases are covered by items 2, 11 or 28 |
| 24 | (v)-(6), (v)-(23) | k=4 (2 structures) | — | no solution | non-void only on a parameter-relation locus (4–5 patterns) |
| 25 | (v)-(13), (v)-(31) | k=4 (2 structures) | — | no solution | non-void only on a parameter-relation locus (4–5 patterns) |
| 26 | (v)-(13), (v)-(31) | k=4 (2 structures) | — | no solution | contains an explicit parameter relation; void generically |
| 27 | (v)-(11), (v)-(28) | k=3, k=4 (2 structures) | 3 lines per structure | no solution | void generically; the same structures are covered by items 2/11/28 (other branch) |
| 28 | (vi)-(1), (vi)-(2) | k=3 (2 structures) | 3 lines per structure | 12 solutions, all inside our components | ✓ characterizes its generic structures completely |
| 29 | (vi)-(13), (vi)-(31) | k=3 (2 structures) | 3 lines per structure | no solution | void generically; the same structures are covered by items 2/11/28 (other branch) |
| 30 | (vi)-(14), (vi)-(30) | k=3 (2 structures) | 3 lines per structure | no solution | void generically; the same structures are covered by items 2/11/28 (other branch) |
| 31 | (vii)-(9), (vii)-(26) | k=3 (2 structures) | 3 lines per structure | no solution | void generically; the same structures are covered by items 2/11/28 (other branch) |
| 32 | (vii)-(9), (vii)-(26) | k=3 (2 structures) | 3 lines per structure | no solution | contains an explicit parameter relation; void generically |
| 33 | (vii)-(8), (vii)-(10), (vii)-(25), (vii)-(27) | k=3, k=4 (6 structures) | 3 lines per structure | no solution | void generically; the same structures are covered by items 2/11/28 (other branch) |
| 34 | (viii)-(6), (viii)-(23) | k=3 (2 structures) | 3 lines per structure | no solution | void generically; the same structures are covered by items 2/11/28 (other branch) |

**Note on items 1, 3, 10, 13, 23.** Their Table-5 cases include, through conditions like "D ≠ 0" or "A ≠ I", the sub-cases D=I, A=0 (3-block, generically solvable structures); but the coefficient conditions of these items are **not satisfied** by the solutions of those sub-cases (e.g. (i)-(5) with D=I is the structure (i)-(6), whose solutions satisfy item 2 and not item 1). Because the theorem is a disjunction the statement stays correct, but these items characterize no solution for generic parameters.

## Special parameters — incompleteness

The theorem must hold for all distinct p,q,r; the Conclusions of the paper state that any of the six orderings of (1,−1,0) may be taken as (p,q,r). For two commuting **tripotent** matrices (free target) our method finds 108 closed structures, **15 of them essentially cubic**: 6 three-pattern (generic), **5 four-pattern and 4 five-pattern** (`tripotent_tripotent.md`). The three-pattern ones are covered under every labelling; the four-pattern ones under 20 of the 36 labellings (one of them under 12), the five-pattern ones under 8 only. Concrete counterexamples:

- **Counterexample A** (natural labelling (p1,q1,r1)=(p2,q2,r2)=(1,−1,0)): T1 = diag(1,1,−1,0,0), T2 = diag(−1,0,1,1,0) (both essentially tripotent, commuting), T1+T2 = diag(0,1,0,1,0) is **idempotent**. The block structure {(p1,q2),(p1,r2),(q1,p2),(r1,p2),(r1,r2)} does not occur in Table 5; none of the 34 items applies (the coefficient conditions of items 11, 12, 17, 18, 31, 32 hold, but their matrix equalities — P1=P2, or the B1B2 identities of 17/18 — fail; checked numerically).
- **Counterexample B** (the matrices of the paper's own Example 1): A1 = diag(1,−1,0,0), A2 = diag(0,0,1,−1), A1+A2 involutive. With the labelling chosen in the paper ((1,−1,0),(0,1,−1)) item 5 applies (we confirm this); with the equally admissible labelling (p1,q1,r1)=(1,0,−1), (p2,q2,r2)=(1,−1,0) the coefficient conditions of **no item** hold. Theorem 8 thus depends on the labelling — the set of covered block structures is not closed under permutations of the labels.
- **Item 9** ((ii)-(17),(ii)-(18)): the 5-block sub-case (A ∼ I⊕0) occurs for tripotent matrices, but the coefficient conditions listed there (c3 = 2a1a2(p2−r2)(w_i−r1)) are violated by these solutions (the value c3 = −a1²(p1−r1)(q1−r1) does not match); the conditions of these rows are incorrect.

## Structures solvable on relation loci (labelled, essentially cubic, realizable with distinct parameters)

Our classification: **45 four-pattern** structures (all realizable) and **36 five-pattern** structures (3 of 39 are not realizable with distinct parameters); structures with 6 or more patterns require coinciding parameters (hence do not exist; consistent with k_max=5 for tripotent matrices). Table 5 contains **23 + 8 = 31** of them; the 50 missing structures correspond to genuine solutions, as the tripotent examples show. The relations required for every structure are given in `table5_pattern_sets.md` (e.g. (ii)-(19) {(p1,p2),(q1,p2),(r1,q2),(r1,r2)}: p1p2 − p1r2 − p2q1 + q1q2 − q2r1 + r1r2 = 0).

**Anything in the paper that we do not find?** No: all 37 structures of Table 5 are in our list (6 generic, 31 on relation loci). The solution sets of the generically non-void items 2, 11, 28 coincide with ours; the coefficient conditions of the other items produce no spurious solution at generic values (no solution with a1a2≠0).

## Conclusion

Theorem 8 of [DÜ25] is correct for generic parameters (through three of its items only), but it is **not complete**: for special parameters such as tripotent matrices most of the 4–5-block structures are not covered (depending on the labelling), and the coefficient conditions of at least one item (9, i.e. rows (ii)-(17)/(18)) are wrong; the claim that the idempotency/involutivity of linear combinations of two tripotent matrices follows from the theorem does not hold as stated.
