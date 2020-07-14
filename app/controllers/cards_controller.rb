class CardsController < ApplicationController
  before_action :set_card, only: [:show, :edit, :update, :destroy]

  require './lib/cards_pdf'

  def index
    return_cards
  end

  def export
    return_cards
    show_in_pdf(@cards)
  end

  def show
  end

  def new
    @card = Card.new
  end

  def edit
  end

  def create
    (0..params[:card][:parcels].to_i).each do |index|
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
      @tribute = params[:tribute]
      @payment_method = params[:payment_method]

      send_tribute(@tribute)
      send_payment_method(@payment_method)

      search_cards(@tribute, @payment_method)
    end

    def search_cards(tribute, payment_method)
      if params[:to].present? && params[:from].present?
        @cards = (params[:only_particular_cards].to_i == 1) ? Card.between_dates(params[:from], params[:to], tribute, payment_method).pessoal : Card.between_dates(params[:from], params[:to], tribute, payment_method).profissional
      else
        @cards = (params[:only_particular_cards].to_i == 1) ? Card.is_tribute_or_payment_blank?(tribute, payment_method).pessoal : Card.is_tribute_or_payment_blank?(tribute, payment_method).profissional
      end
    end

    def show_in_pdf(cards)
        puts cards
        @won = cards.where(action: :recebimento).sum(:value)
        @spent = cards.where(action: :gasto).sum(:value)

        @total = @won - @spent

        pdf = CardsPdf::cards(cards, @won.truncate(2), @spent.truncate(2), @total.truncate(2))
        send_data pdf.render, filename: 'relatorio.pdf', 
        type: 'application/pdf', disposition: 'inline'
    end

    def send_tribute(tribute)
        if tribute == "geral"
          @tribute = 0
        elsif tribute == "pessoa_física"
          @tribute = 1
        elsif tribute == "pessoa_jurídica"
          @tribute = 2
        end
      end
    
      def send_payment_method(payment_method)
        if payment_method == "cheque"
          @payment_method = 0
        elsif payment_method == "débito"
          @payment_method = 1
        elsif payment_method == "crédito"
          @payment_method = 2
        elsif payment_method == "transferência_bancária"
          @payment_method = 3
        elsif payment_method == "boleto"
          @payment_method = 4
        elsif payment_method == "dinheiro"
          @payment_method = 5
        end
      end
    
    def set_card
      @card = Card.find(params[:id])
    end


    def card_params
      params.require(:card).permit(:name, :document, :value, :description, :on_date, :action, :tribute, :payment_method, :receipt, :invoice, :done, :card_type, :category_id)
    end
end
