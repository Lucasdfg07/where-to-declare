class CardsController < ApplicationController
  before_action :set_card, only: [:show, :edit, :update, :destroy]

  require './lib/cards_pdf'

  def index
  end

  def show
  end

  def new
    @card = Card.new
  end

  def edit
  end

  def create
    @card = Card.new(card_params)

    respond_to do |format|
      if @card.save
        format.html { redirect_to @card, notice: 'Atividade criada com sucesso.' }
        format.json { render :show, status: :created, location: @card }
      else
        format.html { render :new }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @card.update(card_params)
        format.html { redirect_to @card, notice: 'Atividade editada com sucesso.' }
        format.json { render :show, status: :ok, location: @card }
      else
        format.html { render :edit }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @card.destroy
    respond_to do |format|
      format.html { redirect_to cards_url, notice: 'Card apagado com sucesso!' }
      format.json { head :no_content }
    end
  end

  private
    
    def set_card
      @card = Card.find(params[:id])
    end


    def card_params
      params.require(:card).permit(:name, :document, :value, :description, :on_date, :action, :tribute, :payment_method, :receipt, :invoice, :category_id)
    end
end
