class CategoriesController < ApplicationController
    before_action :set_category, only: [:edit, :update, :destroy]
    def index
        @categories = Category.all
    end

    def new
        @category = Category.new
    end

    def edit
    end

    def create
        @category = Category.new(category_params)

        if @category.save
            redirect_to categories_path, notice: 'Categoria criada com sucesso.'
        else
            redirect_to categories_path, alert: 'Erro ao criar categoria!! Tente novamente mais tarde.'
        end
    end

    def update
        if @category.update(category_params)
            redirect_to categories_path, notice: 'Categoria editada com sucesso.'
        else
            redirect_to categories_path, alert: 'Erro ao editar categoria!! Tente novamente mais tarde.'
        end
    end

    def destroy
        @category.destroy
        redirect_to request.referrer, notice: 'Categoria apagada com sucesso!'
    end

    private

    def set_category
        @category = Category.find(params[:id])
    end

    def category_params
        params.require(:category).permit(:name)
    end
end
