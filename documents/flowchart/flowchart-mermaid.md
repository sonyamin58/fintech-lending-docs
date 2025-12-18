OPEN : https://www.mermaidchart.com
COPY
```
---
config:
  layout: fixed
---
flowchart TB
 subgraph subGraph0["Analisis Risiko (Internal)"]
        Risk["Cek SLIK/BI Checking via Risk Engine"]
        Process["Proses Analisis Credit Scoring"]
        Score["Hitung Skor Kredit Internal"]
  end
    Start(["Mulai Aplikasi"]) --> Onboarding{"User Terdaftar?"}
    Onboarding -- Tidak --> Reg["Registrasi Akun"]
    Reg --> Profile["Lengkapi Profil: Nama, Email, HP"]
    Profile --> KYC["Upload KTP & Foto Selfie"]
    KYC --> KYC_Proc["Sistem Melakukan Verifikasi KYC"]
    KYC_Proc --> Login["Login User"]
    Onboarding -- Ya --> Login
    Login --> Auth{"Pilih Metode Auth"}
    Auth -- Password --> Pwd["Input Password"]
    Auth -- Biometric --> Bio["Face ID / Fingerprint"]
    Pwd --> Dashboard["Masuk ke Dashboard"]
    Bio --> Dashboard
    Dashboard --> CheckLoan{"Cek Status Pinjaman"}
    CheckLoan -- Ada Pinjaman Aktif --> BillView["Tampilkan Detail Tagihan"]
    BillView --> Pay["Bayar Cicilan Bulanan"]
    Pay --> UpdateBal["Update Sisa Hutang Otomatis"]
    CheckLoan -- Tidak Ada Pinjaman --> Apply["Klik Ajukan Pinjaman"]
    Apply --> Val1{"Cek Status KYC"}
    Val1 -- Belum Verified --> KYC
    Val1 -- Verified --> Val2{"Cek Limit & Tenor"}
    Val2 -- > 12 Juta / > 12 Bulan --> Deny["Tampilkan Pesan: Limit Maksimal Dilampaui"]
    Val2 -- Sesuai Aturan --> Process
    Process --> Risk
    Risk --> Score
    Score --> Decision{"Keputusan Akhir"}
    Decision -- Ditolak --> Reject["Status: REJECTED"]
    Decision -- Diterima --> Approve["Status: APPROVED"]
    Reject --> Notif["Kirim Notifikasi via Email & SMS"]
    Approve --> Notif
    Notif --> End(["Selesai"])

    style KYC_Proc fill:#e1f5fe,stroke:#01579b
    style Apply fill:#f9f,stroke:#333,stroke-width:2px
    style Decision fill:#fff4dd,stroke:#d4a017,stroke-width:2px
```