require 'rails_helper'

RSpec.describe 'Items API', type: :request do
  let!(:todo) { create(:todo) }
  let!(:items) { create_list(:item, 20, todo_id: todo.id) }
  let(:todo_id) { todo.id }
  let(:id) { items.first.id }
  
  describe 'GET /todos/:todo_id/items' do
    before { get "/todos/#{todo_id}/items" }
    
    context 'when todo exists' do
      it 'returns all todo items' do
       expect(json.size).to eq(20)
      end
      
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
    
    context 'when todo does not exist' do
      let(:todo_id) { 0 }
        
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
      
      it 'returns a not found message' do
        expect(response.body).to match(/Couldn\'t find Todo/)
      end
    end
  end
  
  describe 'GET /items/:id' do
    before { get "/items/#{id}" }
    
    context 'when todo item exists' do
      it 'returns the todo item' do
        expect(json['id']).to eq(id)
      end
      
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
    
    context 'when todo item does not exist' do
      let(:id) { 0 }
      
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
      
      it 'returns a not found message' do
        expect(response.body).to match(/Couldn\'t find Item/)
      end
    end
  end
  
  describe 'POST /todos/:todo_id/items' do
    let(:valid_attributes) { { item: { name: 'New Item', done: false } } }
    
    context 'when request attributes are valid' do
      before { post "/todos/#{todo_id}/items/", params: valid_attributes }
      
      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end
    
    context 'when request attributes are invalid' do
      before { post "/todos/#{todo_id}/items", params: { item: { name: '', done: '' } } }
      
      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
      
      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed: Name can't be blank/)
      end
    end
  end
  
  describe 'PUT /items/:id' do
    before { put "/items/#{id}", params: { item: { name: 'Renamed Item' } } }
      
    context 'when item exists' do
      it 'updates the item' do
        item = Item.find(id)
        expect(item.name).to eq('Renamed Item')
      end
      
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
    
    context 'when item does not exist' do
      let(:id) { 0 }
      
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
      
      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Item/)
      end
    end
  end
  
  describe 'DELETE /items/:todo_id' do
    before { delete "/items/#{id}" }
    
    context 'when the item exists' do
      it 'deletes the item' do
        expect(Item.exists?(id)).to be false
      end
      
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end
end