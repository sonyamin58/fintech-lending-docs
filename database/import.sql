-- 1. Aktifkan Extension untuk UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 2. Pembuatan Custom ENUM Types
CREATE TYPE status_active_inactive AS ENUM ('active', 'inactive');
CREATE TYPE kyc_status_type AS ENUM ('pending', 'submitted', 'verified', 'rejected', 'expired');
CREATE TYPE doc_type_enum AS ENUM ('ktp', 'sim', 'npwp');
CREATE TYPE loan_status_type AS ENUM ('pending', 'submitted', 'approved', 'rejected');
CREATE TYPE payment_status_type AS ENUM ('pending', 'paid', 'overdue');
CREATE TYPE risk_level_type AS ENUM ('low', 'medium', 'high');
CREATE TYPE score_source_type AS ENUM ('internal', 'external', 'manual');
CREATE TYPE notif_category_type AS ENUM ('loan', 'kyc', 'payment', 'other');
CREATE TYPE notif_type_enum AS ENUM ('email', 'sms', 'push');
CREATE TYPE notif_status_type AS ENUM ('pending', 'sent', 'failed');

-- ==========================================
-- AUTH SERVICE
-- ==========================================

CREATE TABLE users_auth (
    auth_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    phone_number VARCHAR(20) UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    is_biometric_enabled BOOLEAN DEFAULT FALSE,
    status status_active_inactive DEFAULT 'active',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE auth_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    auth_id UUID NOT NULL REFERENCES users_auth(auth_id) ON DELETE CASCADE,
    refresh_token VARCHAR(255) NOT NULL,
    expired_at TIMESTAMP WITH TIME ZONE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================
-- USER SERVICE
-- ==========================================

CREATE TABLE user_profile (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    auth_id UUID UNIQUE NOT NULL,
    fullname VARCHAR(255),
    email VARCHAR(255),
    phone_number VARCHAR(20),
    preferences JSONB DEFAULT '{}',
    status status_active_inactive DEFAULT 'active',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE
);

-- ==========================================
-- KYC SERVICE
-- ==========================================

CREATE TABLE user_kyc (
    kyc_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    status kyc_status_type DEFAULT 'pending',
    document_type doc_type_enum,
    document_number_hash VARCHAR(255),
    document_front_image_path VARCHAR(255),
    document_selfie_image_path VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================
-- LOAN SERVICE
-- ==========================================

CREATE TABLE loans (
    loan_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    loan_amount DECIMAL(15, 2) NOT NULL,
    tenor_month INT NOT NULL,
    status loan_status_type DEFAULT 'pending',
    monthly_installment_amount DECIMAL(15, 2),
    monthly_installment_due_date DATE,
    approved_at TIMESTAMP WITH TIME ZONE,
    rejected_at TIMESTAMP WITH TIME ZONE,
    rejected_reason TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE loans_payments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    loan_id UUID NOT NULL REFERENCES loans(loan_id) ON DELETE CASCADE,
    payment_amount DECIMAL(15, 2) NOT NULL,
    payment_date TIMESTAMP WITH TIME ZONE,
    status payment_status_type DEFAULT 'pending',
    sequence_number INT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE loans_review_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    loan_id UUID NOT NULL REFERENCES loans(loan_id) ON DELETE CASCADE,
    old_data JSONB,
    new_data JSONB,
    status loan_status_type,
    credit_score INT,
    credit_score_reason TEXT,
    credit_score_source score_source_type,
    credit_score_updated_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================
-- CREDIT SCORE SERVICE
-- ==========================================

CREATE TABLE credit_scores (
    credit_score_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    loan_id UUID NOT NULL,
    risk_level risk_level_type,
    risk_level_reason TEXT,
    internal_score INT,
    internal_score_mandatory BOOLEAN DEFAULT FALSE,
    external_score INT,
    external_score_mandatory BOOLEAN DEFAULT FALSE,
    manual_score INT,
    manual_score_mandatory BOOLEAN DEFAULT FALSE,
    decision loan_status_type DEFAULT 'pending',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE credit_scores_list (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    credit_score_id UUID NOT NULL REFERENCES credit_scores(credit_score_id) ON DELETE CASCADE,
    credit_score INT,
    credit_score_reason TEXT,
    credit_score_raw JSONB,
    credit_score_source score_source_type,
    credit_score_updated_at TIMESTAMP WITH TIME ZONE
);