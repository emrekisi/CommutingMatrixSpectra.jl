# Petik, Özdemir, Gökmen (2022), Turk. J. Math. 46, 3373–3390 — Teorem 2.7 ile karşılaştırma

Yöntem ve gösterim için `../README.md`. Dosyalar: `solutions.md` (bizim karakterizasyon), `free_cubic_quadratic_seed1.txt` (jenerik özelleştirme çıktısı), `free_tripotent_idempotent.txt`, `free_tripotent_involutive.txt` (Sonuç 2.8 / 2.11 özel durumları).

## Karşılaştırma

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

