require 'rails_helper'

RSpec.describe AuthorizeApiRequest do
  let(:user) { create(:user) }
  let(:header) { { 'Authorization' => token_generator(user.id) } }
  subject(:request_object) { described_class.new(header) }
  subject(:invalid_request_object) { described_class.new({}) }
  
  describe '#call' do
    context 'when valid request' do
      it 'returns the user object' do
        result = request_object.call
        expect(result[:user]).to eq(user)
      end
    end
    
    context 'when invalid request' do
      context 'when missing token' do
        it 'raises a MissingToken error' do
          expect { invalid_request_object.call }.to raise_error(ExceptionHandler::MissingToken, 'Missing token')
        end
      end
    
      context 'when invalid token' do
        subject (:invalid_request_object){
          described_class.new('Authorization' => token_generator(5))
        }
        
        it 'raises an InvalidToken error' do
          expect { invalid_request_object.call }.to raise_error(ExceptionHandler::InvalidToken, /Invalid token/)
        end
      end
    
      context 'when token is expired' do
        let(:header) { { 'Authorization' => expired_token_generator(user) } }
        subject(:request_object) { described_class.new(header) }
        
        it 'raises an ExpiredToken error' do
          expect{ request_object.call }.to raise_error(ExceptionHandler::InvalidToken, 'Signature has expired')
        end
      end
    
      context 'when fake token' do
        let(:header) { { 'Authorization' => 'foobar' } }
        subject(:invalid_request_object) { described_class.new(header) }
        
        it 'handles JWT decode error' do
          expect { invalid_request_object.call }.to raise_error(ExceptionHandler::InvalidToken, /Not enough or too many segments/)
        end
      end
    end
  end
end