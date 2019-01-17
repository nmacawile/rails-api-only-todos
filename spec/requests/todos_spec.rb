require 'rails_helper'

RSpec.describe 'Todos API', type: :request do
  let!(:todos) { create_list(:todo, 10) }
  let(:todo_id) { todos.first.id }
  
  describe 'GET /todos' do
    before { get '/todos' }
      
    it 'returns todos' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end
    
    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end
  
  describe 'GET /todos/:id' do
    before { get "/todos/#{todo_id}" }
    
    context 'when the record exists' do
      it 'returns the todo' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(todo_id)
      end
      
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
    
    context 'when the record does not exist' do
      let(:todo_id) { 100 }
        
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
      
      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Todo/)
      end
    end
  end
  
  describe 'POST /todos' do
    let(:valid_attributes) { { todo: { title: 'New Post', created_by: '1' } } }
    
    context 'when request is valid' do
      before { post '/todos', params: valid_attributes }
      
      it 'creates a todo' do
        expect(json['title']).to eq('New Post')
      end
      
      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end
    
    context 'when request is invalid' do
      before { post '/todos', params: { todo: { title: '', created_by: '' } } } 
      
      it 'doesn\'t create a todo' do
        expect(Todo.count).to eq(10)
      end
      
      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
    end
  end
  
  describe 'PUT /todos/:id' do
    let (:valid_attributes) { { todo: { title: 'Edited Todo' } } }
      
    context 'when record exists' do
      before { put "/todos/#{todo_id}", params: valid_attributes }
      
      it 'updates the record' do
        expect(response.body).to be_empty
      end
      
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
    
    context 'when record does not exist' do
      before { put '/todos/100', params: valid_attributes }
      
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end
  
  describe 'DELETE /todos/:id' do
    context 'when record exists' do
      before { delete "/todos/#{todo_id}" }
    
      it 'deletes the todo' do
        expect(Todo.exists?(todo_id)).to be false
      end
      
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end
end