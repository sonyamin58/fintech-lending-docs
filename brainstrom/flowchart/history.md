[Mobile App]
  |
  | GET /api/v1/loans/history/:loan_id
  | response
  { 
    "success": true,
    "code": "LOAN_HISTORY",
    "msg": "Fetch load successfully"
    "data":{
        "load_id": "string",
        "loan_amount": decimal,
        "monthly_installment_amount": decimal,
        "monthly_installment_due_date": "string",
        "status": "string",
        "tenor_month: int,
        "history": [
            {
                "payment_date": "string",
                "payment_amount": decimal,
                "payment_date": "string",
                "status": "string",
                "sequence_number": int
            },
            {
                "payment_date": "string",
                "payment_amount": decimal,
                "payment_date": "string",
                "status": "string",
                "sequence_number": int
            },
            ...
        ]
    }
  }
  v
[API Gateway]
  |
  v
[Loan Service]
  - check active loan
  - calculate outstanding
  - return history & summary
  |
  v
[Mobile App]
   - Response: 200 OK
   - load_summary: Object
