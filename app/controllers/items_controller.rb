class ItemsController < ApplicationController
  before_action :set_todo
  before_action :set_item, only: [:show, :update, :destroy]  

  
  def index
    @items = @todo.items
    json_response(@items)
  end
  
  def show
    json_response(@item)
  end
  
  def create
    @todo.items.create!(item_params)
    json_response(@todo, :created)
  end
  
  def update
    @item.update!(item_params)
    head :no_content
  end
  
  def destroy
    @item.destroy
    head :no_content
  end
  
  private
  
  def item_params
    params.require(:item).permit(:name, :done)
  end
  
  def set_todo
    @todo = Todo.find(params[:todo_id])
  end
  
  def set_item
    @item = Item.find(params[:id])
  end
end
