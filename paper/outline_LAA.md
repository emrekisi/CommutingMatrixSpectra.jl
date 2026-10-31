# LAA makalesi ve CommutingMatrixSpectra.jl deposu — çalışma planı

## 1. Makalenin iddiası (tek cümle)
2018/2021'de verilen kombinatorik yöntem ve algoritma, aşırı belirli sistemleri ele almadığı için karakterizasyonları en fazla m bloklu köşegen yapılarla sınırlıdır; biz (i) aşırı belirli sistemleri kesişim + budama + kapanış ile tamamlayıp 2021'deki dört problemin (iki kuadripotent, iki kübik, üç tripotent, dört involutif) **tam** karakterizasyonunu veriyoruz, (ii) dört tripotent için ilk tam sayımı (3058 karakteristik) elde ediyoruz, (iii) Julia ile zaman/bellek-optimize, disk akışlı, paralel bir uygulama sunuyoruz ve (iv) problem ailesinin çözülebilirlik sınırlarını (m tripotent, kuadripotent, kübik) ölçüme dayalı olarak belirliyoruz.

## 2. Önerilen başlık / dergi
"Complete spectral characterization of linear combinations of commuting diagonalizable matrices: overdetermined systems, closure, and computational limits" — Linear Algebra and its Applications.

## 3. Bölüm planı
1. Introduction — problem, [Kişi–Özdemir 2018], [Kişi ve ark. 2021], Remark 3'teki boşluk, katkılar.
2. Preliminaries — eşzamanlı köşegenleştirme, örüntü kümesi S, U(λ), çöz(S).
3. Theory
   - Lemma 1 (intersection): çöz(S∪S') = çöz(S) ∩ çöz(S').  → aşırı belirli sistemler iki alt sistemden.
   - Lemma 2 (pruning): çöz(S)=∅ ⇒ tüm üst kümeler boş; seviye-seviye sayımın sonluluğu ve durma ölçütü (ilk boş seviye).
   - Lemma 3 (components): çöz(S) sonlu sayıda ayrık afin alt uzayın birleşimi; RREF kanonik temsil; k ≥ m'de tüm bileşenler nokta; yeni bileşen yalnızca pozitif boyutlu kesişimlerden doğar (havuz sonlu).
   - Definition/Prop. (closure): kap(S); çöz(kap(S)) = çöz(S); kapalı sistemler ↔ farklı çözüm kümeleri; Teorem: T ∈ sınıf ⇔ ∃ kapalı S: örüntüler ⊆ S ve c ∈ çöz(S) (tam ve tekrarsız).
   - Prop. (symmetry): B_m etkisi; işaret değişimi yalnızca simetrik spektrumlu, permütasyon yalnızca eş spektrumlu matrisler arasında; karakteristik = yörünge. [2021]'deki |·| gösterimiyle ilişki; (d4)/(d5) örneği (aynı yörünge).
   - Prop. (lower bound): tam sayım ≥ 2^{k_max}; k_max/|L| gözlemleri.
   - Not: 7–8 denklemli sistemlerin 9'luya kapanması gibi "kapanış doyması" (m=3: seviye 4, m=4: seviye 9) — gözlem + kısmi açıklama.
4. Algorithm — hibrit: k ≤ m klasik katlı-sağ-yanlı RREF (benchmark: 5–7× daha hızlı), k > m kesişim (nokta kimlikleri), kapanış = bit-maske VE, yörünge = bayt-LUT kanonikleştirme, bağımsız doğrulayıcı.
5. Implementation & technologies — Julia 1.13 (Rational{Int}/BigInt; Q(ω) için özel tam sayı alanı; kübik için rasyonel fonksiyon alanı), bileşen havuzu, sıralı seviye dosyaları + Channel tabanlı tembel üretim (RAM = O(grup)), Threads.@spawn işçiler, tek yazıcı; ölçülen darboğazlar.
6. Results — 2021'deki dört problemin güncellenmiş (tam) karakterizasyonları:
   - 2 kuadripotent (Q(ω) aritmetiği), 2 kübik (sembolik α,β,γ — genel konum varsayımları açıkça), 3 tripotent (47 karakteristik: 29 + 18 yeni), 4 involutif.
   - 4 tripotent: 279 192 024 sistem, 415 916 kapalı, 3058 karakteristik — yalnızca özet + GitHub.
7. Performance — süre/bellek tabloları (m=3: <0,2 s; m=4: 506 s + 58 s, 1,1 GB RAM, 10,4 GB disk; iş parçacığı ölçekleme 1/4/12); k≤m klasik vs kesişim karşılaştırması; GitHub'daki uzun koşular (saatler/günler) için tablo.
8. Limits — m tripotent (|L| = (3^m−1)/2; k_max tahmini; 2^{k_max} alt sınırı; m=5 için [2021] kapsamı 2,08×10^8 sistem: ölçülecek), kuadripotent (|L| = (4^m−1)/… ; 2 kuadripotent 15 sol yan, 3 kuadripotent 63), kübik (sembolik; 2 kübik 9, 3 kübik 27 sol yan). Her biri için ölçülmüş ilk seviyeler + ekstrapolasyon.
9. Conclusion & open problems.

## 4. Yapılacaklar (sıralı)
A. Sayı alanları: (a) Rational — hazır; (b) Q(ω) (ω²+ω+1=0) için `struct Eisenstein{T<:Rational}`: +,−,×,inv,iszero,==,hash, işaret-yarılama için kanonik sıralama; (c) kübik için rasyonel fonksiyon alanı — AbstractAlgebra.jl/Nemo (Pkg erişimi gerekir) ya da küçük çok değişkenli polinom tipi; sıfır testi tam, bölen ≠ 0 varsayımları çıktıya "genel konum koşulu" olarak yazılır.
B. Hibrit seviye motoru: k ≤ m klasik RREF → kanonik bileşenler → havuz; k > m mevcut akışlı motor.
C. 2021'deki dört problemin koşulması ve [2021] teoremleriyle otomatik eşleştirme (madde ↔ kapalı yörünge tablosu; (d4)/(d5) türü tekrarların listesi).
D. Matris koşullarının (eş. (11) benzeri) programatik türetilmesi (k-potent problemlerde).
E. Üst sınır deneyleri: 5 tripotent ilk 6 seviye; 3 kuadripotent; 3 kübik — süre/bellek, k_max tahmini.
F. Makale metni (LaTeX, elsarticle), GitHub deposu, Zenodo DOI.

## 5. Depo planı: emrekisi/CommutingMatrixSpectra.jl
```
CommutingMatrixSpectra.jl/
├── Project.toml                 (name, uuid, julia ≥ 1.10; deps: yok / opsiyonel AbstractAlgebra)
├── README.md                    (kurulum, 3 satırlık örnek, sonuç tabloları, atıf)
├── LICENSE                      (MIT)
├── src/
│   ├── CommutingMatrixSpectra.jl (module; export characterize, write_report)
│   ├── numbers.jl               (Eisenstein; ileride rasyonel fonksiyon alanı)
│   ├── affine.jl                (Affine, rref_aug, nonzero_ok)
│   ├── pool.jl                  (Pool, intern!, intersect_ids)
│   ├── classical.jl             (k ≤ m katlı-sağ-yanlı RREF)
│   ├── levels.jl                (GroupStream: sıralı seviye dosyaları, Channel, işçiler, yazıcı)
│   ├── closure.jl               (bit maskeleri, kapalı sistemler)
│   ├── symmetry.jl              (B_m tabloları, bayt-LUT kanonikleştirme)
│   ├── verify.jl                (bağımsız köşegen-matris doğrulaması)
│   └── report.jl                (Markdown/JSON/LaTeX çıktı)
├── test/runtests.jl             (2 idempotent, 2 tripotent, 3 tripotent sayımları; [2021] 377 sistemin yeniden üretimi; Python referans JSON'ları)
├── benchmarks/                  (classical_vs_intersection.jl, scaling.jl, limits.jl; sonuç CSV'leri)
├── results/
│   ├── tripotent3/              (characteristics.md, characteristics.json, closed_systems.bin)
│   ├── tripotent4/              (3058 karakteristik; seviye özetleri; 1,97 MB rapor)
│   ├── quadripotent2/, cubic2/, involutive4/ ...
│   └── logs/                    (stream4.log, scaling4.log …)
├── docs/                        (algoritma notu; makale ekleri)
└── paper/                       (LaTeX kaynak; tablolar results/ içinden otomatik üretilir)
```
Veri formatı: her karakteristik için JSON satırı {id, n_eq, patterns, orbit_size, solutions:[{type:"point"|"affine", coords|rows}]} — makaledeki tablolar ve GitHub listeleri aynı dosyadan üretilir.

## 6. Şimdiki durum / engeller
- Sandbox'ın ağ erişimi şu an kapalı: Julia yeniden indirilemiyor, GitHub'a itme yapılamıyor. Dosyalar hazır olduğunda ya bağlantı dönünce (GitHub kimlik bilgisi: Customize → Credentials → GitHub) ya da sizin yerel olarak itmeniz için bir zip olarak teslim edilir.
- Kuadripotent ve kübik problemler için sayı alanı genişletmesi henüz yazılmadı (A maddesi).
