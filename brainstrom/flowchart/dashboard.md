[Mobile App]
  |
  | GET /api/v1/loans/summary
  | response
  { 
    "success": true,
    "code": "LOAN_ACTIVE",
    "msg": "Ada loan berjalan"
    "data":{
        "load_id": "string",
        "loan_amount": decimal,
        "monthly_installment_amount": decimal,
        "monthly_installment_due_date": "string",
        "status": "string"
    }
  }
  v
[API Gateway]
  |
  v
[Loan Service]
  - check active loan
  - calculate outstanding
  - return summary
  |
  v
[Mobile App]
   - Response: 200 OK
   - load_summary: Object
