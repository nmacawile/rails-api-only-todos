module V1
  class TodosController < ApplicationController
    before_action :set_todo, only: [:show, :update, :destroy]
      
    def index
      @todos = current_user.todos.all
      json_response(@todos)
    end
    
    def show
      json_response(@todo)
    end
    
    def create
      @todo = current_user.todos.create!(todo_params)
      json_response(@todo, :created)
    end
    
    def update
      @todo.update!(todo_params)
      head :no_content
    end
    
    def destroy
      @todo.destroy
      head :no_content
    end
    
    private
    
    def todo_params
      params.require(:todo).permit(:title)
    end
    
    def set_todo
      @todo = Todo.find(params[:id]) 
    end
  end
end