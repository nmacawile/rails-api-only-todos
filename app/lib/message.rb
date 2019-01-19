class Message
  class << self
    def not_found(record = 'record')
      "Sorry, #{record} not found." 
    end
  
    def invalid_credentials
      'Invalid credentials'
    end
    
    def invalid_token
      'Invalid token'
    end
    
    def missing_token
      'Missing token'
    end
    
    def unauthorized
      'Unauthorized request'
    end
    
    def account_created
      'Account created successfully.'
    end
    
    def expired_token
      'Sorry, your token has expired. Please log in to continue.'
    end
  end
end