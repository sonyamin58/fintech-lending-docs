OPEN : https://dbdiagram.io

COPY
```
Enum "status_active_inactive" {
  "active"
  "inactive"
}

Enum "kyc_status_type" {
  "pending"
  "verified"
  "rejected"
  "expired"
}

Enum "doc_type_enum" {
  "ktp"
  "sim"
  "npwp"
}

Enum "loan_status_type" {
  "pending"
  "submited"
  "active"
  "approved"
  "rejected"
}

Enum "payment_status_type" {
  "pending"
  "paid"
  "overdue"
}

Enum "risk_level_type" {
  "low"
  "medium"
  "high"
}

Enum "score_source_type" {
  "internal"
  "external"
  "manual"
}

Enum "notif_category_type" {
  "loan"
  "kyc"
  "payment"
  "other"
}

Enum "notif_type_enum" {
  "email"
  "sms"
  "push"
}

Enum "notif_status_type" {
  "pending"
  "sent"
  "failed"
}

Table "users_auth" {
  "auth_id" UUID [pk, default: `uuid_generate_v4()`]
  "email" VARCHAR(255) [unique, not null]
  "phone_number" VARCHAR(20) [unique]
  "password_hash" VARCHAR(255) [not null]
  "is_biometric_enabled" BOOLEAN [default: FALSE]
  "status" status_active_inactive [default: 'active']
  "created_at" TIMESTAMP [default: `CURRENT_TIMESTAMP`]
  "updated_at" TIMESTAMP [default: `CURRENT_TIMESTAMP`]
}

Table "auth_sessions" {
  "id" UUID [pk, default: `uuid_generate_v4()`]
  "auth_id" UUID [not null]
  "refresh_token" VARCHAR(255) [not null]
  "expired_at" TIMESTAMP [not null]
  "created_at" TIMESTAMP [default: `CURRENT_TIMESTAMP`]
  "updated_at" TIMESTAMP [default: `CURRENT_TIMESTAMP`]
}

Table "user_profile" {
  "id" UUID [pk, default: `uuid_generate_v4()`]
  "auth_id" UUID [unique]
  "fullname" VARCHAR(255)
  "email" VARCHAR(255)
  "phone_number" VARCHAR(20)
  "preferences" JSONB [default: '{}']
  "status" status_active_inactive [default: 'active']
  "created_at" TIMESTAMP [default: `CURRENT_TIMESTAMP`]
  "updated_at" TIMESTAMP [default: `CURRENT_TIMESTAMP`]
  "deleted_at" TIMESTAMP
}

Table "user_kyc" {
  "kyc_id" UUID [pk, default: `uuid_generate_v4()`]
  "user_id" UUID [not null]
  "status" kyc_status_type [default: 'pending']
  "document_type" doc_type_enum
  "document_number_hash" VARCHAR(255)
  "document_front_image_path" VARCHAR(255)
  "document_selfie_image_path" VARCHAR(255)
  "created_at" TIMESTAMP [default: `CURRENT_TIMESTAMP`]
  "updated_at" TIMESTAMP [default: `CURRENT_TIMESTAMP`]
}

Table "loans" {
  "loan_id" UUID [pk, default: `uuid_generate_v4()`]
  "user_id" UUID [not null]
  "loan_amount" DECIMAL(15,2) [not null]
  "tenor_month" INT [not null]
  "status" loan_status_type [default: 'pending']
  "monthly_installment_amount" DECIMAL(15,2)
  "monthly_installment_due_date" DATE
  "approved_at" TIMESTAMP
  "rejected_at" TIMESTAMP
  "rejected_reason" TEXT
  "created_at" TIMESTAMP [default: `CURRENT_TIMESTAMP`]
  "updated_at" TIMESTAMP [default: `CURRENT_TIMESTAMP`]
}

Table "loans_payments" {
  "id" UUID [pk, default: `uuid_generate_v4()`]
  "loan_id" UUID [not null]
  "payment_amount" DECIMAL(15,2) [not null]
  "payment_date" TIMESTAMP
  "status" payment_status_type [default: 'pending']
  "sequence_number" INT
  "created_at" TIMESTAMP [default: `CURRENT_TIMESTAMP`]
  "updated_at" TIMESTAMP [default: `CURRENT_TIMESTAMP`]
}

Table "loans_review_history" {
  "id" UUID [pk, default: `uuid_generate_v4()`]
  "loan_id" UUID [not null]
  "old_data" JSONB
  "new_data" JSONB
  "status" loan_status_type
  "credit_score" INT
  "credit_score_reason" TEXT
  "credit_score_source" score_source_type
  "credit_score_updated_at" TIMESTAMP
  "created_at" TIMESTAMP [default: `CURRENT_TIMESTAMP`]
  "updated_at" TIMESTAMP [default: `CURRENT_TIMESTAMP`]
}

Table "credit_scores" {
  "credit_score_id" UUID [pk, default: `uuid_generate_v4()`]
  "user_id" UUID [not null]
  "loan_id" UUID
  "risk_level" risk_level_type
  "risk_level_reason" TEXT
  "internal_score" INT
  "internal_score_mandatory" BOOLEAN [default: FALSE]
  "external_score" INT
  "external_score_mandatory" BOOLEAN [default: FALSE]
  "manual_score" INT
  "manual_score_mandatory" BOOLEAN [default: FALSE]
  "decision" loan_status_type [default: 'pending']
  "created_at" TIMESTAMP [default: `CURRENT_TIMESTAMP`]
  "updated_at" TIMESTAMP [default: `CURRENT_TIMESTAMP`]
}

Table "credit_scores_list" {
  "id" UUID [pk, default: `uuid_generate_v4()`]
  "credit_score_id" UUID [not null]
  "credit_score" INT
  "credit_score_reason" TEXT
  "credit_score_raw" JSONB
  "credit_score_source" score_source_type
  "credit_score_updated_at" TIMESTAMP
}

Ref:"users_auth"."auth_id" < "auth_sessions"."auth_id" [delete: cascade]

Ref:"loans"."loan_id" < "loans_payments"."loan_id" [delete: cascade]

Ref:"loans"."loan_id" < "loans_review_history"."loan_id" [delete: cascade]

Ref:"credit_scores"."credit_score_id" < "credit_scores_list"."credit_score_id" [delete: cascade]
```