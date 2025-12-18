---
config:
  layout: elk
---
classDiagram
class MobileApp
class APIGateway
class AuthService {
    +register()
    +login()
    +validateToken()
}
class UserService {
    +saveProfile()
    +getProfile()
}
class KYCService {
    +uploadKTP()
    +uploadSelfie()
    +getKYCStatus()
}
class PostgreSQL
class LoanService {
    +applyLoan()
    +getLoanStatus()
    +decideLoan()
    +sendNotification()
}
class CreditScoreService {
    +generateCreditScore()
}
class MessageBroker
class RiskEngine {
    +runScoring()
}
class NotificationService {
    +sendEmail()
    +sendSMS()
}
class MongoDB
class Redis
MobileApp --> APIGateway
APIGateway --> AuthService
APIGateway --> UserService
APIGateway --> KYCService
APIGateway --> LoanService
AuthService o-- PostgreSQL
UserService o-- PostgreSQL
KYCService o-- PostgreSQL
LoanService o-- PostgreSQL

RiskEngine o-- MongoDB
NotificationService o-- MongoDB
NotificationService o-- Redis
CreditScoreService o-- PostgreSQL
LoanService ..> MessageBroker : publish/subscribe
CreditScoreService ..> MessageBroker : publish/subscribe
RiskEngine ..> MessageBroker : publish/subscribe
NotificationService ..> MessageBroker : subscribe
LoanService ..> CreditScoreService : request credit score
CreditScoreService ..> RiskEngine : request risk score
RiskEngine ..> CreditScoreService : return score
CreditScoreService ..> LoanService : return credit score
LoanService ..> NotificationService : send notification

===

classDiagram
    class users_auth {
        +uuid auth_id
        +string email
        +string phone_number
        +string password_hash
        +enum status
    }

    class user_profile {
        +uuid id
        +uuid auth_id
        +string fullname
        +enum status
    }

    class user_kyc {
        +uuid kyc_id
        +uuid user_id
        +enum status
        +string document_front_image_path
    }

    class loans {
        +uuid loan_id
        +uuid user_id
        +decimal loan_amount
        +int tenor_month
        +enum status
    }

    class loans_payments {
        +uuid id
        +uuid loan_id
        +decimal payment_amount
        +enum status
    }

    class credit_scores {
        +uuid credit_score_id
        +uuid loan_id
        +int internal_score
        +enum risk_level
    }

    users_auth "1" -- "1" user_profile : has
    user_profile "1" -- "1" user_kyc : verifies
    user_profile "1" -- "0..*" loans : applies
    loans "1" -- "0..*" loans_payments : scheduled
    loans "1" -- "1" credit_scores : evaluated_by