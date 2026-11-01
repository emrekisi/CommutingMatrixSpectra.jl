# Literature comparison

Each subfolder is devoted to one paper (folder name: year – title). Every folder contains `comparison.md` (item-by-item correspondence and assessment), `solutions.md` (the characterization obtained with our method), the raw outputs `free_*.txt` and, where needed, appendices. Code: `scripts/free_target.jl` (enumeration with a free target), `scripts/literature_compare.py` and `scripts/literature_compare_items.py` (symbolic classification and the tests of the papers' items).

References: **[PÖG22]** T. Petik, H. Özdemir, B. T. Gökmen, Notes on the quadraticity of linear combinations of a cubic matrix and a quadratic matrix that commute, Turk. J. Math. 46 (2022) 3373–3390; **[DÜ25]** T. Demirkol, İ. G. Ünlütürk, On quadraticity of linear combinations of two essentially cubic matrices that commute, Axioms 14 (2025) 848.

## How the problems of these papers differ from ours, and how the method was adapted

In our problems (the 2021 paper and the present article) the target spectrum σ is **prescribed**. In the two papers below the target {p3,q3} (resp. {α3,β3}) is **free**: "quadratic for some p3,q3" means that the spectrum of the combination has at most two elements. This fits into the same framework after a small generalization:

- Unknown vector **u = (a1, a2, p3, q3) ∈ C⁴** (homogeneous). A pattern λ=(ξ1,ξ2) imposes ξ1a1+ξ2a2 ∈ {p3,q3}, i.e. the **union of two hyperplanes** (ξ1,ξ2,−1,0)·u=0 ∪ (ξ1,ξ2,0,−1)·u=0. The step "pattern → union of hyperplanes over the right-hand sides" of our engine becomes "pattern → two rows"; intersection (Lemma 2), pruning (Lemma 3), closures and the echelon-form representation of the components are used unchanged. The nonzero condition applies to a1,a2 only; since p3,q3 are unknowns a component may be contained in another one, so a **containment pruning** of the component list was added (not needed in the prescribed-target problems).
- All components are linear subspaces; scaling a scales {p3,q3} as well (in these papers the scalar multiple of a is free).
- The structure (which systems are solvable, how many components) was computed with the Julia engine at two different random rational specializations; the **exact symbolic** classification (generic, or solvable only when the parameters satisfy a polynomial relation) was done with sympy: a component is a partition of the pattern set into a p3-group and a q3-group; equalities inside a group are conditions on the ratio a2/a1, and two different ratio conditions force a **parameter relation** (a 2×2 determinant).
- Consequently, for generic parameters only systems with **at most 3 patterns** are solvable (two unknowns a and at most one ratio condition). Structures with 4 or more patterns are solvable only when the parameters satisfy special relations (e.g. tripotent matrices: 1+(−1)=2·0). This is why most of the 4–5-block items of both papers are **void for generic parameters** (see below).

Counts (Julia, both seeds agree): [PÖG22] 6 patterns → 39 solvable systems (1→6, 2→15, 3→18), all 39 closed, k_max=3. [DÜ25] 9 patterns → 123 solvable (1→9, 2→36, 3→78), all closed, k_max=3. The symbolic classification gives the same numbers and, in addition, the structures solvable on relation loci: [PÖG22] 4 patterns 11, 5 patterns 4, 6 patterns 1; [DÜ25] 4→105, 5→90, 6→51, 7→18, 8→3 (labelled structures, before the framework/realizability filters applied below).

## General conclusions for the method

1. A free target is handled by **the same algorithm** after adding p3,q3 to the unknowns and turning each pattern into a union of two hyperplanes; the only addition is the containment pruning of components. For two matrices the enumeration takes a fraction of a second.
2. For generic parameters k_max = m+1 = 3 (one ratio condition); larger blocks exist only on **parameter relations** — the same phenomenon as the exceptional set in our remark on two cubic matrices. This explains why the 4–5-block items in the literature are generically void.
3. Relabelling symmetry (p↔q↔r): for symbolic parameters the group G is trivial, but the problem is invariant under **renaming** the parameters; a theorem can be complete only if the set of block structures it covers is closed under this symmetry — it is closed in [PÖG22] and it is not in [DÜ25].
