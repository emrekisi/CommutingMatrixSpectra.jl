# Literatür karşılaştırması — bizim yöntemle çözüm ve madde madde eşleme

**İncelenen makaleler**
1. **[PÖG22]** T. Petik, H. Özdemir, B. T. Gökmen, *Notes on the quadraticity of linear combinations of a cubic matrix and a quadratic matrix that commute*, Turk. J. Math. 46 (2022) 3373–3390. Problem: A1 {α1,β1,γ1}-kübik, A2 {α2,β2}-kuadratik, A1A2=A2A1; a1A1+a2A2 (a1a2≠0) ne zaman **bir** {α3,β3} için kuadratik? Ana sonuç Teorem 2.7 (15 madde, i=1,2 / (i,j) seçenekleriyle 28 blok yapısı).
2. **[DÜ25]** T. Demirkol, İ. G. Ünlütürk, *On quadraticity of linear combinations of two essentially cubic matrices that commute*, Axioms 14 (2025) 848. Problem: A1 esas {p1,q1,r1}-kübik, A2 esas {p2,q2,r2}-kübik (spektrum tam olarak üç elemanlı), değişmeli; a1A1+a2A2 ne zaman bir {p3,q3} için kuadratik? Ana sonuç Teorem 8 (34 madde; Tablo 1–5'te 69 "kesişim durumu", 37 farklı blok yapısı).

Dosyalar: `free_target.jl` (Julia, bizim motorla serbest-hedefli sayım), `literature_compare.py` (sembolik sınıflandırma, madde testleri), `lit_solutions_petik.md`, `lit_solutions_demirkol.md` (bizim karakterizasyonlar), `ekA_tablo5_desenler.md` ([DÜ25] Tablo 5'in desen kümelerine çevrimi), `ekB_tripotent_tripotent.md` (iki tripotent özel durumu), `free_*.txt` (ham çıktılar).

---

## 0. İki makalenin problemi bizim problemden nasıl farklı, yöntem nasıl uyarlandı

Bizim (2021 ve LAA makalesi) problemde hedef spektrum σ **verilidir**. Bu iki makalede hedef {p3,q3} (ya da {α3,β3}) **serbesttir**: "bir p3,q3 için kuadratik" = kombinasyonun spektrumu en çok iki elemanlı. Bu, yöntemin küçük bir genellemesiyle aynı çerçeveye oturur:

- Bilinmeyen vektör **u = (a1, a2, p3, q3) ∈ C⁴** (homojen). Desen λ=(ξ1,ξ2) için koşul ξ1a1+ξ2a2 ∈ {p3,q3}, yani **iki hiperdüzlemin birleşimi**: (ξ1,ξ2,−1,0)·u=0 ∪ (ξ1,ξ2,0,−1)·u=0. Bizim motorun "desen → RHS'ler üzerinden hiperdüzlem birleşimi" adımı "desen → iki satır" olarak değiştirildi; kesişim (Lemma 2), budama (Lemma 3), kapanış ve bileşen gösterimi (RREF) aynen kullanıldı. Sıfırdan farklılık koşulu yalnız a1,a2 için; p3,q3 bilinmeyen olduğundan bir bileşen bir başkasının içinde kalabilir — bu yüzden bileşen listesine **içerme budaması** eklendi (önceki problemlerde gerek yoktu).
- Tüm bileşenler lineer altuzaylardır; a'nın ölçeklenmesi {p3,q3}'ü de ölçekler (bu makalelerde a'nın skaler katı serbesttir).
- Yapı (hangi sistemler çözülebilir, kaç bileşen) iki farklı rastgele rasyonel özelleştirmede Julia ile hesaplandı; **tam sembolik** sınıflandırma (jenerik mi, yoksa yalnız parametreler bir polinom bağıntısını sağlarken mi çözülebilir) sympy ile yapıldı: bir bileşen, deseni p3-grubu / q3-grubu olarak ikiye ayırmaktır; grup içi eşitlikler a2/a1 oranı üzerinde koşullardır, iki farklı oran koşulu bir **parametre bağıntısı** (2×2 determinant) gerektirir.
- Sonuç olarak jenerik parametrelerde **en çok 3 desenli** sistemler çözülebilir (2 bilinmeyen a ve en fazla bir oran koşulu). 4 ve daha çok desenli yapılar ancak parametreler özel bağıntılar sağlarsa (ör. tripotent: 1+(−1)=2·0) çözülebilir. Bu, iki makalenin 4–5 bloklu maddelerinin çoğunun jenerik olarak **boş** olmasının nedenidir (aşağıda).

Sayılar (Julia, iki tohum aynı): [PÖG22] 6 desen → 39 çözülebilir sistem (1→6, 2→15, 3→18), 39'u da kapalı, k_max=3. [DÜ25] 9 desen → 123 çözülebilir (1→9, 2→36, 3→78), hepsi kapalı, k_max=3. Sembolik sınıflandırma aynı sayıları verir; ayrıca bağıntı altında çözülebilen yapılar: [PÖG22] 4-desen 11, 5-desen 4, 6-desen 1; [DÜ25] 4→105, 5→90, 6→51, 7→18, 8→3 (etiketli yapı; aşağıda çerçeveye/realize edilebilirliğe göre süzülmüştür).

---

## 1. [PÖG22] Teorem 2.7 ile karşılaştırma

**Çerçeve.** Teorem 2.7'nin durum analizi A1'in γ1-özuzayının ve γ1-dışı kısmının **ikisinin de boş olmadığını** varsayar (M2 ve K/Z1,M1 tanımlı). Bizim 6 desenli listede bu çerçeveye giren yapılar: γ1-bloğu K ∈ {(i) (γ1,β2), (ii) (γ1,α2), (iii) ikisi} × γ1-dışı blok L ⊆ {α1,β1}×{α2,β2} (14 boş olmayan, 4'lü hariç) = 42 yapı. Jenerik çözülebilir olanlar: **8 iki-desenli + 14 üç-desenli = 22**; bağıntı altında çözülebilen: **6 dört-desenli**; kalan 14 yapı hiçbir parametre değerinde çözülemez. Teorem 2.7'nin tablosu tam olarak bu 22+6 = **28 yapıyı** içerir; "hipotezlerle çelişen" diye dışarıda bıraktığı 14 kesişim bizim de çözümsüz bulduklarımızdır.

**Madde madde eşleme** (her satır bir blok yapısı; "bileşen" = bizim çözüm kümesinin bir doğrusu/düzlemi):

| Madde | (K)-(L) | Blok yapısı (desenler) | k | Bizim sonuç | Uyum |
|---|---|---|---|---|---|
| (a1) i=2 | (i)-(a) | {(β1,α2), (γ1,β2)} | 2 | jenerik: 2 bileşen (a serbest, boyut 2) | ✓ (çözüm kümeleri aynı) |
| (a1) i=1 | (i)-(h) | {(α1,α2), (γ1,β2)} | 2 | jenerik: 2 bileşen (a serbest, boyut 2) | ✓ (çözüm kümeleri aynı) |
| (a2) i=2 | (i)-(b) | {(β1,α2), (β1,β2), (γ1,β2)} | 3 | jenerik: 1 bileşen (doğru) | ✓ (çözüm kümeleri aynı) |
| (a2) i=1 | (i)-(k) | {(α1,α2), (α1,β2), (γ1,β2)} | 3 | jenerik: 1 bileşen (doğru) | ✓ (çözüm kümeleri aynı) |
| (a3) i=2 | (i)-(c) | {(β1,β2), (γ1,β2)} | 2 | jenerik: 1 bileşen (a serbest, boyut 2) | ✓ (çözüm kümeleri aynı) |
| (a3) i=1 | (i)-(d) | {(α1,β2), (γ1,β2)} | 2 | jenerik: 1 bileşen (a serbest, boyut 2) | ✓ (çözüm kümeleri aynı) |
| (a4) i=2 | (i)-(r) | {(α1,α2), (β1,α2), (β1,β2), (γ1,β2)} | 4 | jenerik ÇÖZÜMSÜZ; yalnız (alpha2 - beta2)*(alpha1 - 2*beta1 + gamma1) = 0 iken çözülebilir | ✓ (boş küme; bağıntı altında ✓) |
| (a4) i=1 | (i)-(n) | {(α1,α2), (α1,β2), (β1,α2), (γ1,β2)} | 4 | jenerik ÇÖZÜMSÜZ; yalnız -(alpha2 - beta2)*(2*alpha1 - beta1 - gamma1) = 0 iken çözülebilir | ✓ (boş küme; bağıntı altında ✓) |
| (a5) (i,j)=(1, 2) | (i)-(f) | {(α1,β2), (β1,α2), (γ1,β2)} | 3 | jenerik: 2 bileşen (doğru) | ✓ (çözüm kümeleri aynı) |
| (a5) (i,j)=(2, 1) | (i)-(l) | {(α1,α2), (β1,β2), (γ1,β2)} | 3 | jenerik: 2 bileşen (doğru) | ✓ (çözüm kümeleri aynı) |
| (a6)  | (i)-(m) | {(α1,α2), (β1,α2), (γ1,β2)} | 3 | jenerik: 2 bileşen (doğru) | ✓ (çözüm kümeleri aynı) |
| (a7) i=2 | (ii)-(a) | {(β1,α2), (γ1,α2)} | 2 | jenerik: 1 bileşen (a serbest, boyut 2) | ✓ (çözüm kümeleri aynı) |
| (a7) i=1 | (ii)-(h) | {(α1,α2), (γ1,α2)} | 2 | jenerik: 1 bileşen (a serbest, boyut 2) | ✓ (çözüm kümeleri aynı) |
| (a8) i=2 | (ii)-(b) | {(β1,α2), (β1,β2), (γ1,α2)} | 3 | jenerik: 1 bileşen (doğru) | ✓ (çözüm kümeleri aynı) |
| (a8) i=1 | (ii)-(k) | {(α1,α2), (α1,β2), (γ1,α2)} | 3 | jenerik: 1 bileşen (doğru) | ✓ (çözüm kümeleri aynı) |
| (a9) i=2 | (ii)-(c) | {(β1,β2), (γ1,α2)} | 2 | jenerik: 2 bileşen (a serbest, boyut 2) | ✓ (çözüm kümeleri aynı) |
| (a9) i=1 | (ii)-(d) | {(α1,β2), (γ1,α2)} | 2 | jenerik: 2 bileşen (a serbest, boyut 2) | ✓ (çözüm kümeleri aynı) |
| (a10) i=2 | (ii)-(g) | {(α1,β2), (β1,α2), (β1,β2), (γ1,α2)} | 4 | jenerik ÇÖZÜMSÜZ; yalnız -(alpha2 - beta2)*(alpha1 - 2*beta1 + gamma1) = 0 iken çözülebilir | ✓ (boş küme; bağıntı altında ✓) |
| (a10) i=1 | (ii)-(p) | {(α1,α2), (α1,β2), (β1,β2), (γ1,α2)} | 4 | jenerik ÇÖZÜMSÜZ; yalnız -(alpha2 - beta2)*(2*alpha1 - beta1 - gamma1) = 0 iken çözülebilir | ✓ (boş küme; bağıntı altında ✓) |
| (a11) (i,j)=(1, 2) | (ii)-(f) | {(α1,β2), (β1,α2), (γ1,α2)} | 3 | jenerik: 2 bileşen (doğru) | ✓ (çözüm kümeleri aynı) |
| (a11) (i,j)=(2, 1) | (ii)-(l) | {(α1,α2), (β1,β2), (γ1,α2)} | 3 | jenerik: 2 bileşen (doğru) | ✓ (çözüm kümeleri aynı) |
| (a12)  | (ii)-(e) | {(α1,β2), (β1,β2), (γ1,α2)} | 3 | jenerik: 2 bileşen (doğru) | ✓ (çözüm kümeleri aynı) |
| (a13) i=2 | (iii)-(a) | {(β1,α2), (γ1,α2), (γ1,β2)} | 3 | jenerik: 1 bileşen (doğru) | ✓ (çözüm kümeleri aynı) |
| (a13) i=1 | (iii)-(h) | {(α1,α2), (γ1,α2), (γ1,β2)} | 3 | jenerik: 1 bileşen (doğru) | ✓ (çözüm kümeleri aynı) |
| (a14) i=2 | (iii)-(c) | {(β1,β2), (γ1,α2), (γ1,β2)} | 3 | jenerik: 1 bileşen (doğru) | ✓ (çözüm kümeleri aynı) |
| (a14) i=1 | (iii)-(d) | {(α1,β2), (γ1,α2), (γ1,β2)} | 3 | jenerik: 1 bileşen (doğru) | ✓ (çözüm kümeleri aynı) |
| (a15) (i,j)=(1, 2) | (iii)-(f) | {(α1,β2), (β1,α2), (γ1,α2), (γ1,β2)} | 4 | jenerik ÇÖZÜMSÜZ; yalnız (alpha2 - beta2)*(alpha1 + beta1 - 2*gamma1) = 0 iken çözülebilir | ✓ (boş küme; bağıntı altında ✓) |
| (a15) (i,j)=(2, 1) | (iii)-(l) | {(α1,α2), (β1,β2), (γ1,α2), (γ1,β2)} | 4 | jenerik ÇÖZÜMSÜZ; yalnız -(alpha2 - beta2)*(alpha1 + beta1 - 2*gamma1) = 0 iken çözülebilir | ✓ (boş küme; bağıntı altında ✓) |

**Doğrulama.** (a) Jenerik: her maddenin c₁..c₄ denklemleri iki farklı jenerik rasyonel parametre setinde a1=1 ile çözüldü; bulunan tüm çözümler bizim bileşenlerin içinde (ters yön: bizim her bileşenin örnek noktaları ilgili maddenin denklemlerini sağlıyor). 2-desenli maddelerde (a1),(a3),(a7),(a9) çözümler parametrik (a serbest) — rastgele örnekleme ile doğrulandı. (b) Özel durumlar: tripotent×idempotent ve tripotent×involütif (Sonuç 2.8 ve 2.11'in çerçevesi) için bizim motor 37'şer kapalı yapı buldu; çerçeve içindeki her yapı, {1,−1,0}'ın her etiketlemesinde ((α1,β1,γ1) için 6, (α2,β2) için 2) Teorem 2.7'nin bir yapısıyla eşleşiyor ve **1503 / 1502 çözüm örneğinin tamamı** eşleşen maddenin katsayı koşullarını sağlıyor.

**Sonuç.** Teorem 2.7 **tam ve doğru**dur; onlarda olup bizde bulunmayan ya da bizde olup onlarda olmayan çözüm yok. Notlar:
- (a4), (a10), (a15) (4-bloklu yapılar) jenerik parametrelerde **boştur**; yalnız **α1,β1,γ1'den biri diğer ikisinin aritmetik ortalaması** iken dolar (bağıntılar yukarıdaki tabloda; tripotentte 0=(1+(−1))/2 sağlanır — Sonuç 2.8'in (a4),(b4) tipi maddeleri buradan gelir). Makale bunu belirtmez.
- "i=1 veya 2" seçeneği α1↔β1 yeniden adlandırmasıdır (bizim G grubumuz sembolik parametrelerde trivialdir; bu bir etiket simetrisidir, matris simetrisi değil).
- Çerçeve dışı 17 yapı (A1 yalnız γ1 veya hiç γ1 içermiyor: 6 tek-desenli, 7 iki-desenli, 4 üç-desenli) Teorem 2.7'nin kapsamı dışındadır; bunlar A1'in aslında kuadratik/skaler olduğu durumlardır ve makalenin atıf yaptığı [22,23] (iki kuadratik matris) sonuçlarına düşer. Bizim listede hepsi vardır (`lit_solutions_petik.md` dosyasındaki filtre kaldırılırsa `free_cubic_quadratic_seed1.txt`).

---

## 2. [DÜ25] Teorem 8 ile karşılaştırma

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

## 3. Yöntem açısından çıkarımlar (LAA makalesi için)

1. Serbest hedef, bilinmeyenlere p3,q3'ü ekleyip deseni iki hiperdüzlemin birleşimine dönüştürerek **aynı algoritmayla** çözülür; tek ek: bileşenlerde içerme budaması. Bu, makaleye bir uzantı paragrafı/Remark olarak eklenebilir (iki matrisli durumda sayım saniyenin altında).
2. Jenerik parametrelerde k_max = m+1 = 3 (bir oran koşulu); daha büyük bloklar yalnız **parametre bağıntıları** altında — bizim 2-kübik Remark'ındaki istisnai küme kavramının aynısı. Bu, literatürdeki 4–5 bloklu maddelerin neden "jenerik boş" olduğunu açıklar.
3. Etiket (p↔q↔r) simetrisi: sembolik problemde G trivialdir ama parametre **yeniden adlandırma** simetrisi vardır; bir teoremin eksiksizliği için kapsanan yapı kümesinin bu simetri altında kapalı olması gerekir — [DÜ25]'te kapalı değildir, [PÖG22]'de kapalıdır.
