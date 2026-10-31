# 2021 DAS (Mathematica) çıktıları ↔ tam karakterizasyon karşılaştırması

Kaynak: Kişi–Sarduvan–Özdemir–Kalaycı (2021) veri erişim beyanındaki beş notebook (figshare 10.6084/m9.figshare.14572713.v1).
Notebook'lar akış hâlinde ayrıştırıldı (sistem numarası, sol yan matrisi, RREF, çözüm matrisi); karşılaştırma **çözüm kümesi düzeyinde**
(kanonik RREF bileşen kümeleri, tam aritmetik) yapıldı. Sembolik problemler için parametreler iki bağımsız rastgele rasyonel noktada
(1..3000) özelleştirildi (Schwartz–Zippel); her iki noktada yapı aynı çıktı ve DAS ifadeleri aynı noktada değerlendirilerek birebir karşılaştırıldı.

| Problem | DAS sistem | DAS çözümlü | Bizim (k ≤ m) çözümlü | Birebir eşleşen | DAS'ta fazla / eksik | Bizde yeni (k > m) |
|---|---|---|---|---|---|---|
| 3 kuadratik (sembolik, 8 param.) | 92 | 92 | 92 | 92 | — | **6** dört denklemli |
| 4 kuadratik (sembolik, 10 param.) | 2 516 | 2 492 | 2 416 (+24 boş, DAS ile aynı) | 2 416 | **76 sistem (200 sütun) geçersiz**: rank-eksik sistemlerde yazdırılan "çözümler" hiçbir denklemi sağlamıyor; sistemler jenerik olarak tutarsız | **912** beş + **168** altı denklemli → 504 yeni kapalı karakteristik (toplam 2 612; ≤4 bloklu 2 108) |
| 3 kübik (sembolik, 12 param.) | 3 303 | 3 303 | 3 276 | 3 276 | **27 sistem (486 sütun) geçersiz**: doğrusal bağımlı üçlüler (aynı doğru üzerindeki (α₁,α₂,x), x∈{α₃,β₃,γ₃} vb.), jenerik olarak çözümsüz | **162** dört denklemli (toplam 3 438 karakteristik) |
| 3 quadripotent (Q(ω)) | 41 727 (40 023 yazdırılmış) | 40 023 | 1 531 (ω-indirgenmiş; 42'si sıfır sütunlu) | 40 023 → 1 489 ayrık kanonik sistem, hepsi birebir | 3 276 DAS sistemi ω-katı satır içeriyor (gereksiz); sıfır sütunlu 42 sistem DAS adım 6 ile silinmiş | 13 248 sistem (k = 4…9) → toplam 103 karakteristik (98'i Qᵢ ≠ 0) |
| 4 tripotent (Q) | 102 090 (97 808 yazdırılmış) | 96 344 (+1 464 boş) | 99 700 (3 356'sı sıfır sütunlu) | 96 344 birebir, 1 464 her ikisinde boş | sıfır sütunlu 3 356 sistem DAS adım 6 ile silinmiş | 279 092 324 sistem (k = 5…25) → toplam 3 058 karakteristik |

## Notlar
- Rasyonel ve Q(ω) problemlerinde (4 tripotent, 3 quadripotent) DAS ile **tam uyum**: k ≤ m için her çözümlü sistemin çözüm kümesi aynı; farklar yalnızca
  DAS'ın sildiği sıfır sütunlu sistemler ve ω-indirgemesinden kaynaklanır.
- Sembolik problemlerde DAS'ın rank-eksik (doğrusal bağımlı sol yanlı) sistemler için yazdırdığı çözüm matrisleri geçersizdir: 4 kuadratikte 76/2 516,
  3 kübikte 27/3 303 sistem. Bu sistemlerin jenerik parametrelerde çözümü yoktur (tutarlılık koşulu parametreler üzerinde polinom bir denklemdir).
  2 kübik (Teorem 4) ve 3 kuadratik çıktılarında bu tür sistem yoktur; o sonuçlar doğrudur.
- Aşırı belirli (k > m) sistemler DAS kapsamında olmadığından oradaki tüm karakteristikler yenidir: 3 kuadratik 6, 4 kuadratik 504, 3 kübik 162,
  3 quadripotent ve 4 tripotent için ilgili raporlara bakınız. Sembolik problemlerdeki yeni karakteristiklerin kapalı formu (rasyonel fonksiyonlar)
  AbstractAlgebra ile yalnızca bu sistemler için üretilecektir (2 kübik için yapıldığı gibi).
- 2 kübik: 45 sistem, hepsi Teorem 4 ile aynı; aşırı belirli çözüm yok (jenerik). 2 quadripotent: Teorem 5 tam.

Dosyalar: das_summary.json, das_*.jsonl (ayrıştırılmış notebook'lar), ours_*.tsv (bizim sistem dökümleri), generic_eval.jl (rastgele nokta özelleştirmesi),
vals_*_1.txt (kullanılan parametre değerleri).
