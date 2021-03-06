module ExceptionHandler
  extend ActiveSupport::Concern
  
  class AuthenticationError < StandardError; end
  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end
  
  included do
    rescue_from ActiveRecord::RecordNotFound, with: :not_found_handler
    rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_handler
    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized_handler
    rescue_from ExceptionHandler::MissingToken, with: :unprocessable_handler
    rescue_from ExceptionHandler::InvalidToken, with: :unprocessable_handler
  end
  
  private
  
  # 422 error
  def unprocessable_handler(e)
    json_response({ message: e.message }, :unprocessable_entity)
  end
  
  # 401 error
  def unauthorized_handler(e)
    json_response({ message: e.message }, :unauthorized)
  end
  
  # 404 error
  def not_found_handler(e)
    json_response({ message: e.message }, :not_found)
  end
end