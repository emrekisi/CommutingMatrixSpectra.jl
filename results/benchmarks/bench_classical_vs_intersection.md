# Klasik katlı-sağ-yanlı RREF vs kesişim — k ≤ m (eksik belirli + kare) sistemler
Ortam: Python 3 / fractions.Fraction, tek iş parçacığı (aynı dil, aynı veri yapıları; Julia ölçümü ağ bağlantısı gelince tekrarlanacak).
Her iki yöntem aynı kanonik bileşen temsiline (RREF satırları) dönüştürülmüş ve çözüm kümeleri sistem sistem karşılaştırılmıştır.

| Problem | Sistem | Çözümlü | Çözümler özdeş? | Klasik süre | Kesişim süre | Klasik bellek | Kesişim bellek | Skaler işlem (klasik) | Skaler işlem (kesişim) | Katlı sağ yan sütunu |
|---|---|---|---|---|---|---|---|---|---|---|
| 3 tripotent, k ≤ 3 | 377 | 371 | True | 0.52 s | 2.45 s | 1.6 MB | 2.4 MB | 43,830 | 237,832 | 8,463 |
| 4 tripotent, k ≤ 3 | 10700 | 10688 | True | 21.7 s | 148.1 s | 92 MB | 157 MB | 1,553,012 | 14,754,530 | 273,900 |

Yorum:
- k ≤ m seviyelerinde klasik yöntem 4,7× (m=3) ve 6,8× (m=4) daha hızlı; skaler işlem sayısı 5,4× ve 9,5× daha az; bellek de daha düşük. Neden: kesişim, iki pozitif boyutlu bileşenin her çiftini (ör. 6×6 = 36 doğru çifti) ayrı ayrı RREF'e alır ve bunların çoğu tutarsızdır; klasik yöntem k satırı tek seferde indirger, tutarsız sağ yan sütunları aynı indirgemeden ücretsiz elenir.
- Sonuç kümeleri birebir aynıdır (H4 doğrulandı).
- Öneri (makale ve pakette uygulanacak hibrit): k ≤ m için klasik katlı-sağ-yanlı RREF (bileşenleri doğrudan kanonik temsile yaz), k > m için kesişim (bileşenler nokta olduğundan RREF'siz kimlik eşitliği). Kesişimin tek-yöntem avantajı korunur: aynı veri yapısı, aynı budama, aynı kapanış/gruplama; yalnızca ilk m seviyenin üretim yolu değişir.

> Yukarıdaki Python ölçümü **ön çalışmadır**; asıl deney aşağıdaki Julia bölümüdür.

## Julia ölçümü (asıl deney — 31.10.2026)

Ortam: Julia 1.13.3, **tek iş parçacığı**, `Rational{Int64}` tam aritmetik, Windows, her yöntem **ayrı süreçte**
(derleme bir ısınma turuyla dışlandı; tepe bellek = sürecin `Sys.maxrss()` değeri). Kod: `bench_classical.jl`.

- **Klasik:** 2021 algoritması — her k-altküme S (k ≤ m) için katsayı matrisi A (k×m) ve **tüm 3ᵏ sağ yan sütunu tek
  artırılmış matriste** [A | B] indirgenir (çok-sağ-yanlı RREF); tutarlı sütunlardan bileşenler okunur.
- **Kesişim:** `TripotentLC.enumerate_systems` — seviye k sistemleri, (k−2)-öneki ortak iki (k−1)-sistemin çözüm
  kümelerinin bileşen-bileşen kesişimi (yığılmış RREF); doğrudan hiçbir k-sistem çözülmez.
- **ops** = eliminasyon çekirdeğindeki skaler cisim işlemi sayısı (ters alma, çarpma, çıkarma) — kesişim için
  gerçekte yapılan her ikili bileşen kesişimi birebir yeniden oynatılarak sayıldı.

| Ölçek | sistem / çözümlü | bileşen | süre klasik / kesişim | ayrılan bellek (toplam) | tepe RSS | ops klasik / kesişim | ops oranı |
|---|---|---|---|---|---|---|---|
| m=3  k≤3 | 377 / 371 | 3388 | 14.4 ms / 8.4 ms | 16 / 10 MiB | 241 / 315 MiB | 90 244 / 420 676 | 4.7× |
| m=4  k≤3 | 10700 / 10688 | 186916 | 765.0 ms / 627.0 ms | 598 / 534 MiB | 438 / 564 MiB | 3 118 366 / 26 150 919 | 8.4× |
| m=4  k≤4 | 102090 / 99700 | 2859416 | 25672.1 ms / 47819.5 ms | 18592 / 39450 MiB | 3880 / 7826 MiB | 144 746 556 / 1 809 173 345 | 12.5× |

Doğrulama: m=4, k≤4'te 99700 çözümlü sistemin tamamında iki yöntemin çözüm kümeleri (kanonik RREF
bileşen kümeleri) **birebir eşit**, uyumsuzluk 0. (m=3 ve m=4, k≤3 için de eşitlik ayrıca kontrol edildi.)

### Yorum

1. **İşlem sayısı** klasik yöntemde 4.7× (m=3) … 12.5× (m=4, k=4) daha az: kesişimin maliyeti |sol(A)|·|sol(B)| ikili
   kesişimle büyür (m=4'te üç denklemli bir sistemin 27'ye kadar bileşeni olabilir → tek sistem için 729 küçük RREF).
2. **Süre** farkı işlem sayısı farkından çok daha küçük: k ≤ 3'te kesişim **daha hızlı** (8.4 ms vs 14.4 ms; 0.63 s vs
   0.77 s), k = m = 4'te klasik 1.9× daha hızlı (25.7 s vs 47.8 s). Klasik yöntemin zamanı aritmetikte değil, 3ᵏ sağ
   yan sütununun kurulması ve 7.7 milyon sütundan çözüm okunmasında (bellek ayırma) harcanıyor; kesişimin zamanı ise
   `Set{Affine}` karma/eşitlik denetimlerinde.
3. **Bellek:** k ≤ 3'te eşdeğer; k = 4'te kesişim 2× tepe RSS (7.8 GB vs 3.9 GB) — bu RAM-içi referans sürümdür; üretim
   motoru (GroupStream: bileşen havuzu + disk akışı) aynı hesabı 1.1 GB sabit RAM ile yapar (bkz. stream4.log).
4. Python ön ölçümündeki 5–7× fark Julia'da 0.6–1.9×'e düşüyor: Python'da `fractions.Fraction` nesne yükü ikili
   kesişimlerin çok sayıdaki küçük RREF'ini orantısız cezalandırıyordu.

### Makale için sonuç

- k ≤ m (eksik belirtilmiş/kare) sistemlerde klasik çok-sağ-yanlı RREF, işlem sayısı bakımından açık ara,
  süre bakımından ise ancak k = m'de üstün; k > m (aşırı belirtilmiş) sistemler için kesişim tek yoldur
  (klasik yaklaşım 2^|L| alt kümeye ve her birinde 3ᵏ sağ yana ihtiyaç duyar).
- Önerilen **hibrit motor:** seviye k ≤ m klasik RREF ile (sonuçlar bileşen havuzuna yazılır), k > m kesişimle
  (nokta-kimliği eşitliği / alt uzay değerlendirmesi). Kesişimin tek-yöntem sadeliği ve O(grup) RAM profili korunur.
