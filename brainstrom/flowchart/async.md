[Credit Scoring Service]
   ← LoanSubmitted
   - calculate internal score
   - publish event: CreditScored

[Risk Engine Service]
   ← CreditScored
   - call external bureau
   - normalize score
   - publish event: RiskEvaluated

[Credit Scoring Service]
   ← RiskEvaluated
   - finalize decision
   - update status: APPROVED / REJECTED
   - publish event: LoanScored

[Loan Service]
   ← LoanScored
   - update status: APPROVED / REJECTED
   - publish event: LoanApproved / LoanRejected

-----

[Mobile App]
   |
   | POST /api/v1/loans/apply
   v
[Loan Service]
   - validate
   - save loan SUBMITTED
   - publish -> loan.events (LoanSubmitted)
   
[Credit Scoring Service]
   <- internal.credit_scoring.queue
   - consume LoanSubmitted
   - compute internal score
   - publish -> credit_scoring.events (CreditScored)
   
[Risk Engine Service]
   <- risk_engine.queue
   - consume CreditScored
   - call external bureau
   - normalize score
   - publish -> risk_engine.events (RiskEvaluated)

[Credit Scoring Service]
   <- external.credit_scoring.queue
   - consume RiskEvaluated
   - compute extrenal score
   - publish -> credit_scoring.events (CreditScored)
   
[Loan Service]
   <- internal.loan.queue
   - consume CreditScored
   - finalize decision
   - status -> APPROVED / REJECTED
   - publish -> loan.events (LoanApproved / LoanRejected)
   
[Notification Service]
   <- internal.notification.queue
   - consume LoanApproved / LoanRejected
   - send Email / SMS / Push
   - save to DB for notification center
