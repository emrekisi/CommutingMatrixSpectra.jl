## Demirkol–Ünlütürk (2025): iki esas kübik matris, serbest {p3,q3} hedefi — jenerik parametrelerde çözülebilir esas-kübik blok yapıları (bizim yöntem)

Jenerik p1,q1,r1,p2,q2,r2 için çözülebilir sistemler en çok 3 desenlidir; esas kübiklik en az 3 desen gerektirir; dolayısıyla tam 6 'permütasyon' yapısı vardır, her biri 3 bileşen (C^4'te doğru) içerir. Gösterim: {p3-grubu} / {q3-grubu}: bileşen.

- P = {(p1,p2), (q1,q2), (r1,r2)}
    - {(p1,p2)} / {(q1,q2), (r1,r2)}: a2/a1 = -(q1 - r1)/(q2 - r2); p3 = a1*(p1*q2 - p1*r2 - p2*q1 + p2*r1)/(q2 - r2); q3 = -a1*(q1*r2 - q2*r1)/(q2 - r2)
    - {(p1,p2), (q1,q2)} / {(r1,r2)}: a2/a1 = -(p1 - q1)/(p2 - q2); p3 = -a1*(p1*q2 - p2*q1)/(p2 - q2); q3 = -a1*(p1*r2 - p2*r1 - q1*r2 + q2*r1)/(p2 - q2)
    - {(p1,p2), (r1,r2)} / {(q1,q2)}: a2/a1 = -(p1 - r1)/(p2 - r2); p3 = -a1*(p1*r2 - p2*r1)/(p2 - r2); q3 = -a1*(p1*q2 - p2*q1 + q1*r2 - q2*r1)/(p2 - r2)
- P = {(p1,p2), (q1,r2), (r1,q2)}
    - {(p1,p2)} / {(q1,r2), (r1,q2)}: a2/a1 = (q1 - r1)/(q2 - r2); p3 = a1*(p1*q2 - p1*r2 + p2*q1 - p2*r1)/(q2 - r2); q3 = a1*(q1*q2 - r1*r2)/(q2 - r2)
    - {(p1,p2), (q1,r2)} / {(r1,q2)}: a2/a1 = -(p1 - q1)/(p2 - r2); p3 = -a1*(p1*r2 - p2*q1)/(p2 - r2); q3 = -a1*(p1*q2 - p2*r1 - q1*q2 + r1*r2)/(p2 - r2)
    - {(p1,p2), (r1,q2)} / {(q1,r2)}: a2/a1 = -(p1 - r1)/(p2 - q2); p3 = -a1*(p1*q2 - p2*r1)/(p2 - q2); q3 = -a1*(p1*r2 - p2*q1 + q1*q2 - r1*r2)/(p2 - q2)
- P = {(p1,q2), (q1,p2), (r1,r2)}
    - {(p1,q2)} / {(q1,p2), (r1,r2)}: a2/a1 = -(q1 - r1)/(p2 - r2); p3 = a1*(p1*p2 - p1*r2 - q1*q2 + q2*r1)/(p2 - r2); q3 = a1*(p2*r1 - q1*r2)/(p2 - r2)
    - {(p1,q2), (q1,p2)} / {(r1,r2)}: a2/a1 = (p1 - q1)/(p2 - q2); p3 = a1*(p1*p2 - q1*q2)/(p2 - q2); q3 = a1*(p1*r2 + p2*r1 - q1*r2 - q2*r1)/(p2 - q2)
    - {(p1,q2), (r1,r2)} / {(q1,p2)}: a2/a1 = -(p1 - r1)/(q2 - r2); p3 = -a1*(p1*r2 - q2*r1)/(q2 - r2); q3 = -a1*(p1*p2 - p2*r1 - q1*q2 + q1*r2)/(q2 - r2)
- P = {(p1,q2), (q1,r2), (r1,p2)}
    - {(p1,q2)} / {(q1,r2), (r1,p2)}: a2/a1 = (q1 - r1)/(p2 - r2); p3 = a1*(p1*p2 - p1*r2 + q1*q2 - q2*r1)/(p2 - r2); q3 = a1*(p2*q1 - r1*r2)/(p2 - r2)
    - {(p1,q2), (q1,r2)} / {(r1,p2)}: a2/a1 = -(p1 - q1)/(q2 - r2); p3 = -a1*(p1*r2 - q1*q2)/(q2 - r2); q3 = -a1*(p1*p2 - p2*q1 - q2*r1 + r1*r2)/(q2 - r2)
    - {(p1,q2), (r1,p2)} / {(q1,r2)}: a2/a1 = (p1 - r1)/(p2 - q2); p3 = a1*(p1*p2 - q2*r1)/(p2 - q2); q3 = a1*(p1*r2 + p2*q1 - q1*q2 - r1*r2)/(p2 - q2)
- P = {(p1,r2), (q1,p2), (r1,q2)}
    - {(p1,r2)} / {(q1,p2), (r1,q2)}: a2/a1 = -(q1 - r1)/(p2 - q2); p3 = a1*(p1*p2 - p1*q2 - q1*r2 + r1*r2)/(p2 - q2); q3 = a1*(p2*r1 - q1*q2)/(p2 - q2)
    - {(p1,r2), (q1,p2)} / {(r1,q2)}: a2/a1 = (p1 - q1)/(p2 - r2); p3 = a1*(p1*p2 - q1*r2)/(p2 - r2); q3 = a1*(p1*q2 + p2*r1 - q1*q2 - r1*r2)/(p2 - r2)
    - {(p1,r2), (r1,q2)} / {(q1,p2)}: a2/a1 = (p1 - r1)/(q2 - r2); p3 = a1*(p1*q2 - r1*r2)/(q2 - r2); q3 = a1*(p1*p2 - p2*r1 + q1*q2 - q1*r2)/(q2 - r2)
- P = {(p1,r2), (q1,q2), (r1,p2)}
    - {(p1,r2)} / {(q1,q2), (r1,p2)}: a2/a1 = (q1 - r1)/(p2 - q2); p3 = a1*(p1*p2 - p1*q2 + q1*r2 - r1*r2)/(p2 - q2); q3 = a1*(p2*q1 - q2*r1)/(p2 - q2)
    - {(p1,r2), (q1,q2)} / {(r1,p2)}: a2/a1 = (p1 - q1)/(q2 - r2); p3 = a1*(p1*q2 - q1*r2)/(q2 - r2); q3 = a1*(p1*p2 - p2*q1 + q2*r1 - r1*r2)/(q2 - r2)
    - {(p1,r2), (r1,p2)} / {(q1,q2)}: a2/a1 = (p1 - r1)/(p2 - r2); p3 = a1*(p1*p2 - r1*r2)/(p2 - r2); q3 = a1*(p1*q2 + p2*q1 - q1*r2 - q2*r1)/(p2 - r2)