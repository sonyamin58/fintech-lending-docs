[Mobile App] 
    |
    | <multipart-data>
   {
        "email": "string|email",
        "phone_number": "numeric|min:10|max15|rules:provider_indonesia"
        "fullname": "string|min:3",
        "ktp_number": "string|min:16|max:16"
        "ktp_image_file": <image>,
        "selfie_image_file": <image>
   }
   |
   | POST /api/v1//auth/register
   v
[API Gateway]
   |
   v
[Auth Service]
   - create user credential
   - hash password
   - generate user_id
   - send email success (password user)
   |
   v
[User Service]
   - save profile data
   - status active
   |
   v
[KYC Service]
   - upload KTP & selfie
   - status = PENDING
   - send event: KYCSubmitted
   |
   v
[Mobile App]
   - Response: 201 Created
   - user_status: SUCCESS
   - kyc_status: PENDING
