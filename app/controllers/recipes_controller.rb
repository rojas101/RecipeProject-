class RecipesController < ApplicationController
  before_action :set_recipe, only: [:edit, :update, :show, :like ] 
  before_action :require_user, except: [:show, :index, :like]
  before_action :require_user_like, only: [:like]
  before_action :require_same_user, only: [:edit, :update]

    def index 
        @recipe = Recipe.paginate(page:params[:page], per_page: 4)
    end 
    
    def show 
    end 
    
    def new
        @recipe = Recipe.new 
    end
    
    def create 
        @recipe = Recipe.new(recipe_params)
        @recipe.chef = current_user 
        
        if @recipe.save
            flash[:success] = "Your recipe was created successfully"
            redirect_to recipes_path
        
        else
            render :new
        end 
    end
    
    def update 
        if @recipe.update(recipe_params)
            flash[:success] = "Your recipe was updated successfully"
            redirect_to recipe_path(@recipe)
        else 
            render :edit
        end 
    end 
    

    def edit 
    end  
    
    def destroy
      @recipe = Recipe.find(params[:id])
      @recipe.destroy
  
      redirect_to recipes_path
    end
    
    def like 
      like = Like.create(like: params[:like], chef: current_user, recipe: @recipe) 
      if like.valid?
        flash[:success] = "Your selection was succssful"
        redirect_back(fallback_location: root_path)

      else
        flash[:danger] = "You can only like/dislike a recipe once"
        redirect_back(fallback_location: root_path)
      end 
    end  
      
       
 
    
    private
        
    def recipe_params
        params.require(:recipe).permit(:picture, :name, :summary, :description, style_ids:[], ingredient_ids: [])
    end 
    
    def set_recipe
        @recipe = Recipe.find(params[:id])
    end 
        
    def require_same_user
      if current_user != @recipe.chef 
        flash[:danger] = "You can only edit your own recipes"
        redirect_to recipes_path
      end 
    end 
        
    def require_user_like
      if !logged_in?
        flash[:danger] = "You must be logged in to perfrom this action"
        redirect_to recipes_path
      end 
    end 

end 