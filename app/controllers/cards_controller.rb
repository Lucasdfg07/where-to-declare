class CardsController < ApplicationController
  before_action :set_card, only: [:show, :edit, :update, :destroy]

  require './lib/cards_pdf'

  def index
    return_cards
  end

  def export
    show_in_pdf(session[:cards])
  end

  def show
  end

  def new
    @card = Card.new
  end

  def edit
  end

  def create
    (0..params[:card][:parcels].to_i - 1).each do |index|
      @card = Card.new(card_params)
      
      @card.on_date = @card.on_date + (index * 1.month)
      @card.value = (@card.value/params[:card][:parcels].to_i).truncate(2)
      @card.parcel = "#{index + 1}/#{params[:card][:parcels].to_i}"
      
      @card.save  
    end

    redirect_to @card, notice: 'Atividade criada com sucesso.'
  end

  def update
    if @card.update(card_params)
      if params[:url].present?
        redirect_to request.referrer, notice: 'Atividade editada com sucesso.'
      else
        redirect_to @card, notice: 'Atividade editada com sucesso.'
      end
    else
      render :edit
    end
  end

  def destroy
    @card.destroy
    redirect_to request.referrer, notice: 'Card apagado com sucesso!'
  end

  private

    def return_cards
      @q = Card.ransack(params[:q])
      @cards = (params[:only_particular_cards].to_i == 1) ? @q.result.pessoal : @q.result
      
      verify_card_filter

      session[:cards] = @cards
    end

    def verify_card_filter
      if params[:q][:done_eq].to_i == 1
        @cards = @cards.where("date_concluded BETWEEN ? AND ?", params[:date_init], params[:date_end])
      else
        @cards = @cards.where("on_date BETWEEN ? AND ?", params[:date_init], params[:date_end])
      end
    end

    def show_in_pdf(cards)
        pdf = CardsPdf::cards(cards)
        send_data pdf.render, filename: 'relatorio.pdf', 
        type: 'application/pdf', disposition: 'inline'
    end
    
    def set_card
      @card = Card.find(params[:id])
    end


    def card_params
      params.require(:card).permit(:name, :document, :taxes_value, :value, :description, :on_date, :date_concluded, :action, :tribute, :payment_method, :receipt, :invoice, :done, :card_type, :go_to_contability, :category_id)
    end
end
