Arsitektur dirancang dengan prinsip:
- Microservices Architecture
- API First
- Stateless Services
- Event Driven (Async Processing)
- Security by Design
- Scalable & Fault Tolerant
- Audit & Compliance Ready (Fintech Context)

| Service                     | Tanggung Jawab Utama                              |
| --------------------------- | ------------------------------------------------- |
| **API Gateway**             | Single entry point, security, routing, rate limit |
| **Auth Service**            | Registrasi, login, token & biometric auth         |
| **User Service**            | Data profil user & status akun                    |
| **KYC Service**             | Verifikasi identitas (KTP & selfie)               |
| **Loan Service**            | Proses pinjaman, tenor, cicilan, status           |
| **Credit Scoring Service**  | Penilaian risiko & keputusan internal             |
| **Risk Engine Service**     | Integrasi credit score pihak ke-3                 |
| **Notification Service**    | Email, SMS, notifikasi pinjaman                   |


1. Mobile Application (Client Layer)
Responsibilities:
- UI/UX
- Input validation ringan
- Biometric handling (FaceID / Fingerprint)
- Secure token storage
- Screen state management
Tech (Contoh):
- Flutter / React Native / Native
- Secure Storage (Keychain / Keystore)
Database:
- PostgreSQL

2. API Gateway (Single Entry Point)
Fungsi Utama:
- Routing request ke microservices
- Authentication & Authorization (JWT / OAuth2)
- Rate limiting
- Request validation
- Logging & tracing
- API versioning
Catatan Fintech:
- Menghindari direct access ke service internal
- Centralized security policy
Tech Contoh:
- Kong / NGINX / AWS API Gateway / Apigee

3. Authentication Service
Tanggung Jawab:
- Registrasi user (email, phone, password)
- Login (password)
- Biometric token validation
- Token issuance (Access & Refresh Token)
- Session management
Data:
- Credential
- Device info
- Token session
Catatan:
- Tidak menyimpan data KTP / foto
- Fokus ke identity & access
Database:
- PostgreSQL

4. User Profile Service
Tanggung Jawab:
- Data user (email, phone, full name)  
- Status user (active, blocked)
- Link ke data KYC
- Update profile
Catatan:
- Dipisah dari Auth → lebih aman & scalable
Database:
- PostgreSQL

5. KYC Service
Tanggung Jawab:
- Upload & store foto KTP
- Upload selfie
- Verifikasi KYC (manual / 3rd party)
- Status KYC (PENDING / VERIFIED / REJECTED)
- Enkripsi data sensitif
Integrasi:
- OCR KTP
- Face recognition
- Dukcapil / vendor KYC (opsional)
Catatan Penting:
- Data sensitif → encryption at rest
- Access terbatas
Database:
- PostgreSQL

6. Loan Management Service (Core Business)
Tanggung Jawab:
- Pengajuan pinjaman
- Validasi limit (max 12jt)
- Validasi tenor (max 12 bulan)
- Status pinjaman: (SUBMITTED, APPROVED, REJECTED, ACTIVE, PAID)
- Hitung cicilan
- Cek user masih punya pinjaman aktif
Event Driven
- Publish event to message broker
Trigger:
- Load Submited
- Load Approved
- Load Rejected
Database:
- PostgreSQL
Catatan:
- Loan Service tidak memutuskan sendiri status pinjaman, hanya mengirim event ke message broker

7. Credit Score Service
Tanggung Jawab:
- Hitung credit score
- Cek credit score
- Update credit score
Trigger:
- Loan submitted
Catatan:
- Credit score dihitung berdasarkan data user, kredit score provider (e.g. Credit Karma, Equifax, TransUnion)
- Credit Scoring Service bersifat decision engine
Database:
- PostgreSQL

8. Risk Engine Service
Tanggung Jawab:
- Cek risiko pinjaman
- Update risiko pinjaman
Trigger:
- Loan submitted
Catatan:
- Risiko pinjaman dihitung berdasarkan data user di Bank Indonesia (BI)
Event Driven
- Subscribe dari message broker
Database:
- MongoDB

9. Notification Service
Tanggung Jawab:
- Email notification
- SMS / WhatsApp
- Push notification (future)
- Template management
Trigger:
- Loan approved
- Loan rejected
- Reminder pembayaran
Event Driven
- Subscribe dari message broker
Database:
- MongoDB, Redis

10. Event / Message Broker
Fungsi:
- Async communication
- Loose coupling
- Reliability
Event Contoh:
- LoanSubmitted
- LoanApproved
- LoanRejected
Tech:
- Kafka / RabbitMQ / AWS SNS-SQS