RSpec.describe 'Users API', type: :request do
  let(:user) { create(:user) }
  let(:headers) { valid_headers.except('Authorization') }
  let(:valid_attributes) do
    attributes_for(:user, password_confirmation: user.password)
  end
  
  describe 'POST /signup' do
    context 'when valid request' do
      before { post '/signup', params: valid_attributes.to_json, headers: headers }
      
      it 'creates a user' do
        expect(response).to have_http_status(201)
      end
      
      it 'retuns a \'success\' message' do
        expect(json['message']).to match(/Account created successfully/)
      end
      
      it 'returns an authentication token' do
        expect(json['auth_token']).not_to be_nil
      end
    end
    
    context 'when invalid request' do
      before { post '/signup', params: {}, headers: headers }
      
      it 'does not create an new account' do
        expect(response).to have_http_status(422)
      end
    end
  end
end