A. User Registrasi + Upload KTP
User Story : User melakukan registrasi dengan data diri, email, nomor telepon dan upload foto beserta KTP
Flow Teknis
  - Mobile App
    - API Gateway
      - Auth Service (create account)
      - User Service (save profile)
      - KYC Service (upload KTP & selfie)
Detail:
1. Auth Service
Simpan email, phone,password (hashed)
Generate user_id
2. User Service
- Simpan nama, email, phone
3. KYC Service
- Simpan foto KTP & selfie
- Status: PENDING
📌 User BELUM boleh pinjam sebelum KYC = VERIFIED

B. User Login
User Story : User melakukan login dengan email dan password
Flow Teknis
  - Mobile App
    - API Gateway
      - Auth Service (login)
Detail:
1. Auth Service
Email & Password:
- Cek email dan password
- Generate access token dan refresh token
- Return access token dan refresh token
Biometric:
- Mobile OS handle biometric
- App kirim biometric token
- Auth Service validasi token
- Generate access token dan refresh token
- Return access token dan refresh token
📌 Biometric ≠ ganti password
📌 Biometric = shortcut auth

C. User Melihat Sisa Hutang & Tagihan
User Story : User dapat melihat sisa hutang dan tagihan per bulan (jika ada)
Flow Teknis
  - Mobile App
    - API Gateway
      - Loan Service
Loan Service Mengembalikan:
- Pinjaman aktif
- Total sisa hutang
- Cicilan per bulan
- Status pinjaman
📌 Jika tidak ada pinjaman → return empty state

D. User Mengajukan Pinjaman
User Story : User dapat meminjam uang max 12 juta, tenor max 1 tahun
Flow Teknis
Validasi:
- KYC status = VERIFIED
- Tidak ada pinjaman aktif
- Nominal <= 12.000.000
- Tenor <= 12 bulan
Mobile App
  → API Gateway
    → Loan Service (publish event)
        → Credit Scoring Service (consume event & hit API loan service)
            → Risk Engine Service (consume event & hit 3rd party & hit API credit scoring service)
                → Third Party Credit Bureau (consume event)

E. Proses Diterima / Ditolak
User Story : User dalam proses peminjaman akan diproses dengan hasil diterima atau ditolak
Flow Teknis
  - Loan Service
    → Credit Scoring Service
      → Risk Engine (external score)
      → Calculate final score
    - Decision:
      APPROVED / REJECTED
    - Publish event to Notification Service

F. Notifikasi Jika Diterima
User Story : Jika pinjaman diterima maka akan ada notifikasi email & nomor telepon
Flow Event-Driven (Best Practice)
Loan Service
  → Publish event: LoanApproved
      → Notification Service
          → Email
          → SMS
📌 Loan Service tidak kirim email langsung

G. User Tidak Bisa Pinjam Jika Masih Ada Pinjaman
User Story : User tidak dapat meminjam jika ada proses pinjaman & belum lunas
Enforcement (HARD RULE)
Dilakukan di Loan Service:
IF active_loan EXISTS
  THEN reject new loan request
📌 Dicek sebelum:
- Credit scoring
- Risk engine
- Vendor call

Ringkasan Flow Besar (One View)
[Register]
Auth → User → KYC

[Login]
Auth

[View Loan]
Loan

[Apply Loan]
Loan
  → Credit Scoring
      → Risk Engine
          → External Bureau

[Decision]
Loan (APPROVED / REJECTED)

[Notification]
Event → Notification Service
