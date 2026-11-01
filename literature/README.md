# Literature comparison (bizim yöntemle literatürdeki sonuçların karşılaştırılması)

Her alt klasör bir makaleye ayrılmıştır (klasör adı: basım yılı – makale adı). Her klasörde: `karsilastirma.md` (madde madde eşleme ve değerlendirme), `solutions.md` (bizim yöntemle elde edilen karakterizasyon), ham çıktılar (`free_*.txt`) ve varsa ekler. Kod: `scripts/free_target.jl` (serbest hedefli sayım), `scripts/literature_compare.py`, `scripts/literature_compare_items.py` (sembolik sınıflandırma ve madde testleri).

## Yöntem uyarlaması: İki makalenin problemi bizim problemden nasıl farklı, yöntem nasıl uyarlandı

Bizim (2021 ve LAA makalesi) problemde hedef spektrum σ **verilidir**. Bu iki makalede hedef {p3,q3} (ya da {α3,β3}) **serbesttir**: "bir p3,q3 için kuadratik" = kombinasyonun spektrumu en çok iki elemanlı. Bu, yöntemin küçük bir genellemesiyle aynı çerçeveye oturur:

- Bilinmeyen vektör **u = (a1, a2, p3, q3) ∈ C⁴** (homojen). Desen λ=(ξ1,ξ2) için koşul ξ1a1+ξ2a2 ∈ {p3,q3}, yani **iki hiperdüzlemin birleşimi**: (ξ1,ξ2,−1,0)·u=0 ∪ (ξ1,ξ2,0,−1)·u=0. Bizim motorun "desen → RHS'ler üzerinden hiperdüzlem birleşimi" adımı "desen → iki satır" olarak değiştirildi; kesişim (Lemma 2), budama (Lemma 3), kapanış ve bileşen gösterimi (RREF) aynen kullanıldı. Sıfırdan farklılık koşulu yalnız a1,a2 için; p3,q3 bilinmeyen olduğundan bir bileşen bir başkasının içinde kalabilir — bu yüzden bileşen listesine **içerme budaması** eklendi (önceki problemlerde gerek yoktu).
- Tüm bileşenler lineer altuzaylardır; a'nın ölçeklenmesi {p3,q3}'ü de ölçekler (bu makalelerde a'nın skaler katı serbesttir).
- Yapı (hangi sistemler çözülebilir, kaç bileşen) iki farklı rastgele rasyonel özelleştirmede Julia ile hesaplandı; **tam sembolik** sınıflandırma (jenerik mi, yoksa yalnız parametreler bir polinom bağıntısını sağlarken mi çözülebilir) sympy ile yapıldı: bir bileşen, deseni p3-grubu / q3-grubu olarak ikiye ayırmaktır; grup içi eşitlikler a2/a1 oranı üzerinde koşullardır, iki farklı oran koşulu bir **parametre bağıntısı** (2×2 determinant) gerektirir.
- Sonuç olarak jenerik parametrelerde **en çok 3 desenli** sistemler çözülebilir (2 bilinmeyen a ve en fazla bir oran koşulu). 4 ve daha çok desenli yapılar ancak parametreler özel bağıntılar sağlarsa (ör. tripotent: 1+(−1)=2·0) çözülebilir. Bu, iki makalenin 4–5 bloklu maddelerinin çoğunun jenerik olarak **boş** olmasının nedenidir (aşağıda).

Sayılar (Julia, iki tohum aynı): [PÖG22] 6 desen → 39 çözülebilir sistem (1→6, 2→15, 3→18), 39'u da kapalı, k_max=3. [DÜ25] 9 desen → 123 çözülebilir (1→9, 2→36, 3→78), hepsi kapalı, k_max=3. Sembolik sınıflandırma aynı sayıları verir; ayrıca bağıntı altında çözülebilen yapılar: [PÖG22] 4-desen 11, 5-desen 4, 6-desen 1; [DÜ25] 4→105, 5→90, 6→51, 7→18, 8→3 (etiketli yapı; aşağıda çerçeveye/realize edilebilirliğe göre süzülmüştür).

---

## Genel çıkarımlar: Yöntem açısından çıkarımlar (LAA makalesi için)

1. Serbest hedef, bilinmeyenlere p3,q3'ü ekleyip deseni iki hiperdüzlemin birleşimine dönüştürerek **aynı algoritmayla** çözülür; tek ek: bileşenlerde içerme budaması. Bu, makaleye bir uzantı paragrafı/Remark olarak eklenebilir (iki matrisli durumda sayım saniyenin altında).
2. Jenerik parametrelerde k_max = m+1 = 3 (bir oran koşulu); daha büyük bloklar yalnız **parametre bağıntıları** altında — bizim 2-kübik Remark'ındaki istisnai küme kavramının aynısı. Bu, literatürdeki 4–5 bloklu maddelerin neden "jenerik boş" olduğunu açıklar.
3. Etiket (p↔q↔r) simetrisi: sembolik problemde G trivialdir ama parametre **yeniden adlandırma** simetrisi vardır; bir teoremin eksiksizliği için kapsanan yapı kümesinin bu simetri altında kapalı olması gerekir — [DÜ25]'te kapalı değildir, [PÖG22]'de kapalıdır.
