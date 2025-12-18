[Mobile App]
  |
  {
    "loan_amount": "numeric|min:100000|max:12000000",
    "loan_tenor": "int|in:3,6,9,12",
    "loan_purpose": "string"
  }
  | POST /api/v1/loans/apply
  | response
  { 
    "success": true,
    "code": "LOAN_SUBMITED",
    "msg": "Berhasil mengajukan pinjaman"
    "data":{
        "load_id": "string",
        "loan_amount": decimal,
        "monthly_installment_amount": decimal,
        "status": "string"
    }
  }
  v
[API Gateway]
  |
  v
[Loan Service]
  - validate hard rules:
      * KYC = VERIFIED
      * no active loan
      * amount ≤ 12jt
      * tenor ≤ 12
  - create loan (status = SUBMITTED)
  - publish event: LoanSubmitted
  - return 202 Accepted
