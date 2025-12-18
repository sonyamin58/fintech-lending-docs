Auth Service
Context: Authentication & Session Management
users_auth
---------------------
auth_id (UUID)
email (VARCHAR(255))
phone_number (VARCHAR(20))
password_hash (VARCHAR(255))
is_biometric_enabled (BOOLEAN)
status (ENUM: active, inactive)
created_at
updated_at

auth_sessions
---------------------
id (UUID)
auth_id (UUID) FK to users_auth.auth_id
refresh_token (VARCHAR(255))
expired_at (TIMESTAMP)
created_at (TIMESTAMP)
updated_at (TIMESTAMP)

User Service
Context: User Management
user_profile
---------------------
id (UUID)
auth_id (UUID)
fullname (VARCHAR(255))
email (VARCHAR(255))
phone_number (VARCHAR(20))
preferences (JSONB)
status (ENUM: active, inactive)
created_at (TIMESTAMP)
updated_at (TIMESTAMP)
deleted_at (TIMESTAMP)

KYC Service
Context: KYC Management
user_kyc
---------------------
kyc_id (UUID)
user_id (UUID)
status (ENUM: pending, verified, rejected, expired)
document_type (ENUM: ktp, sim, npwp)
document_number_hash (VARCHAR(255))
document_front_image_path (VARCHAR(255))
document_selfie_image_path (VARCHAR(255))
created_at (TIMESTAMP)
updated_at (TIMESTAMP)

Loan Service
Context: Loan Management
loans
---------------------
loan_id (UUID)
user_id (UUID)
loan_amount (DECIMAL(10, 2))
tenor_month (INT)
status (ENUM: pending, approved, rejected)
monthly_installment_amount (DECIMAL(10, 2))
monthly_installment_due_date (DATE)
approved_at (TIMESTAMP)
rejected_at (TIMESTAMP)
rejected_reason (TEXT)
created_at (TIMESTAMP)
updated_at (TIMESTAMP)

loans_payments
---------------------
id (UUID)
loan_id (UUID) FK to loans.loan_id
payment_amount (DECIMAL(10, 2)) 
payment_date (TIMESTAMP)
status (ENUM: pending, paid, overdue)
sequence_number (INT)
created_at (TIMESTAMP)
updated_at (TIMESTAMP)

loans_review_history
---------------------
id (UUID)
loan_id (UUID) FK to loans.loan_id
old_data (JSONB)
new_data (JSONB)
status (ENUM: pending, approved, rejected)
credit_score (INT)
credit_score_reason (TEXT)
credit_score_source (ENUM: internal, external, manual)
credit_score_updated_at (TIMESTAMP)
created_at (TIMESTAMP)
updated_at (TIMESTAMP)

Credit Score Service
Context: Credit Score Management
credit_scores
---------------------
credit_score_id (UUID)
user_id (UUID)
loan_id (UUID)
risk_level (ENUM: low, medium, high)
risk_level_reason (TEXT)
internal_score (INT)
internal_score_mandatory (BOOLEAN)
external_score (INT)
external_score_mandatory (BOOLEAN)
manual_score (INT)
manual_score_mandatory (BOOLEAN)
decision (ENUM: pending, approved, rejected)
created_at (TIMESTAMP)
updated_at (TIMESTAMP)

credit_scores_list
---------------------
id (UUID)
credit_score_id (UUID) FK to credit_scores.credit_score_id
credit_score (INT)
credit_score_reason (TEXT)
credit_score_raw (JSONB)
credit_score_source (ENUM: internal, external, manual)
credit_score_updated_at (TIMESTAMP)

Risk Level Service
Context: Risk Level Management
risk_evaluations_collection
---------------------
{
    "_id": "primary key",
    "credit_score_id": "UUID",
    "loan_id": "UUID",
    "vendor_name": "VARCHAR(255)",
    "raw_score": "encrypted jsonb",
    "normalized_score": "jsonb",
    "risk_level": "ENUM: low, medium, high",
    "created_at": "TIMESTAMP"
}

Notification Service
Context: Notification Management
notifications_collection
---------------------
{
    "_id": "primary key",
    "user_id": "UUID",
    "loan_id": "UUID",
    "notification_category": "ENUM: loan, kyc, payment, other",
    "notification_type": "ENUM: email, sms, push",
    "notification_title": "VARCHAR(255)",
    "notification_content": "TEXT",
    "notification_link": "VARCHAR(255)",
    "notification_status": "ENUM: pending, sent, failed",
    "notification_sent_at": "TIMESTAMP",
    "notification_failed_at": "TIMESTAMP",
    "notification_read_at": "TIMESTAMP",
    "created_at": "TIMESTAMP"
}