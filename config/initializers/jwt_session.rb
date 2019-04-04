JWTSessions.encryption_key = Rails.application.secrets.secret_jwt_encryption_key

# Bug: cannot be nil...
JWTSessions.public_key = ''
JWTSessions.private_key = ''
