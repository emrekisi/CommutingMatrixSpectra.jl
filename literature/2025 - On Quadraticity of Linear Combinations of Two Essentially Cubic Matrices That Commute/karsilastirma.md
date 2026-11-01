# Demirkol, Ünlütürk (2025), Axioms 14, 848 — Teorem 8 ile karşılaştırma

Yöntem ve gösterim için `../README.md`. Dosyalar: `solutions.md` (bizim karakterizasyon), `table5_pattern_sets.md` (Tablo 5'in desen kümelerine çevrimi, bağıntılar), `tripotent_tripotent.md` (iki tripotent özel durumu ve kapsama), `free_cubic_cubic_seed1.txt`, `free_tripotent_tripotent.txt`.

## Karşılaştırma

**Jenerik parametreler.** Esas kübiklik (A1'in üç, A2'nin üç özdeğeri de blokta görünmeli) en az 3 desen ister; jenerik olarak en çok 3 desen çözülebilir; dolayısıyla jenerik çözülebilir esas-kübik yapılar tam olarak **6 "permütasyon" yapısı** {(x1,y1),(x2,y2),(x3,y3)} (xᵢ, yᵢ birer permütasyon) ve her birinde **3 bileşen** (çakışan çift seçimi), toplam 18 doğru (`lit_solutions_demirkol.md`). Teorem 8'de bunları **yalnız 2, 11 ve 28. maddeler** karakterize eder (her biri (i,j) seçimiyle 2 yapı × 3 doğru; a1=1 ile 12 çözüm = 3 doğru × 2 yapı × p3↔q3): bu üç maddenin çözüm kümeleri bizimkilerle **birebir aynı**. Diğer **31 madde jenerik parametrelerde boştur** (katsayı denklemlerinin a1a2≠0 çözümü yok; sympy ile (3,7,19,5,13,29) vb. jenerik değerlerde doğrulandı):

| Madde | Tablo-5 durumları | Blok yapıları (k) | Jenerik çözüm (bizim) | Maddenin c-koşulları (jenerik, a1a2≠0) | Değerlendirme |
|---|---|---|---|---|---|
| 1 | (i)-(5), (i)-(7), (i)-(22), (i)-(24) | k=3; k=4: 6 yapı | 3 doğru/yapı | çözüm yok | madde jenerik boş; D=I / A∈{0,I} alt durumları 2, 11 veya 28. maddelerle kapsanıyor |
| 2 | (i)-(6), (i)-(23) | k=3: 2 yapı | 3 doğru/yapı | 12 çözüm (hepsi bizim bileşenlerde) | ✓ jenerik yapı(lar)ı tam olarak karakterize eder |
| 3 | (i)-(15), (i)-(16) | k=3; k=4: 4 yapı | 3 doğru/yapı | çözüm yok | madde jenerik boş; D=I / A∈{0,I} alt durumları 2, 11 veya 28. maddelerle kapsanıyor |
| 4 | (ii)-(6), (ii)-(23) | k=4: 2 yapı | — | çözüm yok | yalnız parametre bağıntısı altında dolu (4–5 desen) |
| 5 | (ii)-(19) | k=4: 1 yapı | — | çözüm yok | yalnız parametre bağıntısı altında dolu (4–5 desen) |
| 6 | (ii)-(9), (ii)-(26) | k=4: 2 yapı | — | çözüm yok | yalnız parametre bağıntısı altında dolu (4–5 desen) |
| 7 | (ii)-(9), (ii)-(26) | k=4: 2 yapı | — | çözüm yok | açık parametre bağıntısı içeriyor; jenerik boş |
| 8 | (ii)-(15), (ii)-(16) | k=4; k=5: 4 yapı | — | çözüm yok | yalnız parametre bağıntısı altında dolu (4–5 desen) |
| 9 | (ii)-(17), (ii)-(18) | k=4; k=5: 4 yapı | — | çözüm yok | yalnız parametre bağıntısı altında dolu (4–5 desen); **5-bloklu alt durumda ((ii)-(17),(ii)-(18)) koşullar yanlış: tripotent örnekte çözüm var, c-koşulları sağlanmıyor** |
| 10 | (iii)-(8), (iii)-(10), (iii)-(25), (iii)-(27) | k=3; k=4: 6 yapı | 3 doğru/yapı | çözüm yok | madde jenerik boş; D=I / A∈{0,I} alt durumları 2, 11 veya 28. maddelerle kapsanıyor |
| 11 | (iii)-(9), (iii)-(26) | k=3: 2 yapı | 3 doğru/yapı | 12 çözüm (hepsi bizim bileşenlerde) | ✓ jenerik yapı(lar)ı tam olarak karakterize eder |
| 12 | (iii)-(9), (iii)-(26) | k=3: 2 yapı | 3 doğru/yapı | çözüm yok | açık parametre bağıntısı içeriyor; jenerik boş |
| 13 | (iii)-(17), (iii)-(18) | k=3; k=4: 4 yapı | 3 doğru/yapı | çözüm yok | madde jenerik boş; D=I / A∈{0,I} alt durumları 2, 11 veya 28. maddelerle kapsanıyor |
| 14 | (iv)-(1), (iv)-(2) | k=4: 2 yapı | — | çözüm yok | yalnız parametre bağıntısı altında dolu (4–5 desen) |
| 15 | (iv)-(3) | k=4: 1 yapı | — | çözüm yok | yalnız parametre bağıntısı altında dolu (4–5 desen) |
| 16 | (iv)-(8), (iv)-(10), (iv)-(25), (iv)-(27) | k=4; k=5: 6 yapı | — | çözüm yok | yalnız parametre bağıntısı altında dolu (4–5 desen) |
| 17 | (iv)-(9), (iv)-(26) | k=4: 2 yapı | — | çözüm yok | yalnız parametre bağıntısı altında dolu (4–5 desen) |
| 18 | (iv)-(9), (iv)-(26) | k=4: 2 yapı | — | çözüm yok | açık parametre bağıntısı içeriyor; jenerik boş |
| 19 | (iv)-(14), (iv)-(30) | k=4: 2 yapı | — | çözüm yok | yalnız parametre bağıntısı altında dolu (4–5 desen) |
| 20 | (iv)-(12), (iv)-(29) | k=4: 2 yapı | — | çözüm yok | yalnız parametre bağıntısı altında dolu (4–5 desen) |
| 21 | (v)-(1), (v)-(2) | k=4: 2 yapı | — | çözüm yok | yalnız parametre bağıntısı altında dolu (4–5 desen) |
| 22 | (v)-(4) | k=4: 1 yapı | — | çözüm yok | yalnız parametre bağıntısı altında dolu (4–5 desen) |
| 23 | (v)-(5), (v)-(7), (v)-(22), (v)-(24), (viii)-(5), (viii)-(7), (viii)-(22), (viii)-(24) | k=3; k=4; k=5: 12 yapı | 3 doğru/yapı | çözüm yok | madde jenerik boş; D=I / A∈{0,I} alt durumları 2, 11 veya 28. maddelerle kapsanıyor |
| 24 | (v)-(6), (v)-(23) | k=4: 2 yapı | — | çözüm yok | yalnız parametre bağıntısı altında dolu (4–5 desen) |
| 25 | (v)-(13), (v)-(31) | k=4: 2 yapı | — | çözüm yok | yalnız parametre bağıntısı altında dolu (4–5 desen) |
| 26 | (v)-(13), (v)-(31) | k=4: 2 yapı | — | çözüm yok | açık parametre bağıntısı içeriyor; jenerik boş |
| 27 | (v)-(11), (v)-(28) | k=3; k=4: 2 yapı | 3 doğru/yapı | çözüm yok | madde jenerik boş; aynı yapılar 2/11/28. maddelerle kapsanıyor (başka dal) |
| 28 | (vi)-(1), (vi)-(2) | k=3: 2 yapı | 3 doğru/yapı | 12 çözüm (hepsi bizim bileşenlerde) | ✓ jenerik yapı(lar)ı tam olarak karakterize eder |
| 29 | (vi)-(13), (vi)-(31) | k=3: 2 yapı | 3 doğru/yapı | çözüm yok | madde jenerik boş; aynı yapılar 2/11/28. maddelerle kapsanıyor (başka dal) |
| 30 | (vi)-(14), (vi)-(30) | k=3: 2 yapı | 3 doğru/yapı | çözüm yok | madde jenerik boş; aynı yapılar 2/11/28. maddelerle kapsanıyor (başka dal) |
| 31 | (vii)-(9), (vii)-(26) | k=3: 2 yapı | 3 doğru/yapı | çözüm yok | madde jenerik boş; aynı yapılar 2/11/28. maddelerle kapsanıyor (başka dal) |
| 32 | (vii)-(9), (vii)-(26) | k=3: 2 yapı | 3 doğru/yapı | çözüm yok | açık parametre bağıntısı içeriyor; jenerik boş |
| 33 | (vii)-(8), (vii)-(10), (vii)-(25), (vii)-(27) | k=3; k=4: 6 yapı | 3 doğru/yapı | çözüm yok | madde jenerik boş; aynı yapılar 2/11/28. maddelerle kapsanıyor (başka dal) |
| 34 | (viii)-(6), (viii)-(23) | k=3: 2 yapı | 3 doğru/yapı | çözüm yok | madde jenerik boş; aynı yapılar 2/11/28. maddelerle kapsanıyor (başka dal) |

**Madde 1, 3, 10, 13, 23 hakkında not.** Bunların Tablo 5 durumları "D ≠ 0" / "A ≠ I" gibi koşullarla D=I, A=0 alt durumlarını da (3-bloklu, jenerik çözülebilir yapılar) kapsar; ancak maddelerin c-koşulları bu alt durumların çözümlerini **sağlamaz** (örn. (i)-(5) D=I iken yapı (i)-(6) ile aynıdır ve çözümler 2. maddenin koşullarını sağlar, 1. maddeninkini değil). Teoremin "veya" yapısı nedeniyle sonuç yine doğru kalır, ama bu maddeler jenerik olarak hiçbir çözüm karakterize etmez.

**Özel parametreler — eksiklik.** Teorem her ayrık p,q,r için geçerli olmalı; makale Sonuç bölümünde (p,q,r) için (1,−1,0)'ın altı sıralamasının da alınabileceğini söyler. Bizim yöntem iki değişmeli **tripotent** matris için (hedef serbest) 108 kapalı yapı, bunların **15'i esas kübik**: 6 üç-desenli (jenerik), **5 dört-desenli, 4 beş-desenli** (`ekB_tripotent_tripotent.md`). Üç-desenliler her etiketlemede kapsanıyor; dört-desenliler 36 etiketlemenin 20'sinde (biri 12'sinde), beş-desenliler yalnız 8'inde kapsanıyor. Somut karşı örnekler:

- **Karşı örnek A** (doğal etiketleme (p1,q1,r1)=(p2,q2,r2)=(1,−1,0)): T1 = diag(1,1,−1,0,0), T2 = diag(−1,0,1,1,0) (ikisi de esas tripotent, değişmeli), T1+T2 = diag(0,1,0,1,0) **idempotent**. Blok yapısı {(p1,q2),(p1,r2),(q1,p2),(r1,p2),(r1,r2)} Tablo 5'te yok; 34 maddeden hiçbirinin koşulları sağlanmıyor (11, 12, 17, 18, 31, 32'nin katsayı koşulları sağlanır ama matris eşitlikleri — P1=P2, ya da 17/18'in B1B2 eşitlikleri — sağlanmaz; sayısal olarak kontrol edildi).
- **Karşı örnek B** (makalenin kendi Örnek 1 matrisleri): A1 = diag(1,−1,0,0), A2 = diag(0,0,1,−1), A1+A2 involütif. Makalenin seçtiği etiketleme ((1,−1,0),(0,1,−1)) ile 5. madde geçerli (biz de doğruladık); fakat yine makalenin izin verdiği etiketleme (p1,q1,r1)=(1,0,−1), (p2,q2,r2)=(1,−1,0) ile **hiçbir maddenin** katsayı koşulları sağlanmaz. Yani Teorem 8 etiketlemeye bağımlıdır — bu, kapsanan blok yapıları kümesinin etiket permütasyonları altında kapalı olmamasından kaynaklanır.
- **9. madde** ((ii)-(17),(ii)-(18)): 5-bloklu alt durum (A ∼ I⊕0) tripotentlerde gerçekleşir, fakat tablodaki c-koşulları (c3 = 2a1a2(p2−r2)(w_i−r1)) bu çözümlerde sağlanmaz (c3 = −a1²(p1−r1)(q1−r1) değeri uyuşmaz); dolayısıyla o satırların koşulları hatalıdır.

**Bağıntı altında çözülebilen yapılar (etiketli, esas kübik, ayrık parametrelerle gerçekleştirilebilir).** Bizim sınıflandırma: **45 dört-desenli** (hepsi gerçekleştirilebilir) ve **36 beş-desenli** (39'dan 3'ü ayrık parametrelerle gerçekleştirilemez); 6 ve daha çok desenli yapılar yalnız çakışan parametrelerle mümkün (dolayısıyla yok; tripotentte k_max=5 ile uyumlu). Tablo 5 bunların **23 + 8 = 31**'ini içerir; eksik olan 50 yapı, tripotent örneklerinin gösterdiği gibi gerçek çözümlere karşılık gelir. Her yapı için gerekli bağıntılar Ek A'da verilmiştir (ör. (ii)-(19) {(p1,p2),(q1,p2),(r1,q2),(r1,r2)}: p1p2 − p1r2 − p2q1 + q1q2 − q2r1 + r1r2 = 0).

**Onlarda olup bizde olmayan?** Yok: Tablo 5'teki 37 yapının hepsi bizim listede (6'sı jenerik, 31'i bağıntı altında). Jenerik dolu olan 2, 11, 28. maddelerin çözüm kümeleri bizimkilerle aynı; diğer maddelerin katsayı koşulları jenerik değerlerde hiçbir yanlış çözüm üretmiyor (a1a2≠0 çözümü yok).

**Sonuç.** [DÜ25] Teorem 8 jenerik parametreler için (yalnız 3 maddesiyle) doğrudur, fakat **tam değildir**: tripotent gibi özel parametrelerde ortaya çıkan 4–5 bloklu yapıların çoğunu (etiketlemeye bağlı olarak) kapsamaz ve en az bir maddesinin ((9), yani (ii)-(17)/(18)) katsayı koşulları yanlıştır; makalenin "iki tripotentin kombinasyonlarının idempotentliği/involütifliği bu teoremden çıkar" iddiası bu haliyle doğru değildir.

---

