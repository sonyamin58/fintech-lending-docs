[Mobile App] 
   |
   {
        "username": "alphanum",
        "password": "string",
        "device_id": "string"
   }
   | POST /api/v1/auth/login
   | response
   {
        "status": true,
        "code": "LOGIN_OK",
        "msg": "berhasil login",
        "data": {
            "access_token":"xxx",
            "access_token_expired": 1000,
            "refresh_token":"xxx"
        }
   }
   v
[API Gateway]
   |
   v
[Auth Service]
   - validate password
   - issue JWT access token, refresh token, expired_token
   |
   v
[Mobile App]
   - Response: 200 OK
   - access_token
   - refresh_token
   - expired_token


[Mobile App] 
   |
   | POST /api/v1/auth/biometric/challenge
   | response
   {
        "challenge": "key...",
        "timeout": 3000
   }
   |
   {
        "public_key_id": "string",
        "signature": "string",
        "client_data": {
            ...
        },
        "device_id": "string"
   }
   | POST /api/v1/auth/biometric/verify
   | response
   {
        "status": true,
        "code": "LOGIN_BIMETRIC_OK",
        "msg": "berhasil login",
        "data": {
            "access_token":"xxx",
            "access_token_expired": 1000,
            "refresh_token":"xxx"
        }
   }
   |
   v
[API Gateway]
   |
   v
[Auth Service]
   - validate biometric token
   - issue JWT access token, refresh token, expired_token
   |
   v
[Mobile App]
   - Response: 200 OK
   - access_token
   - refresh_token
   - expired_token
