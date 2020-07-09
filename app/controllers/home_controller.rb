class HomeController < ApplicationController
    require './lib/cards_pdf'

    def index
    end

    def export 
        send_tribute(params["/"][:tribute])
        send_payment_method(params["/"][:payment_method])

        if params[:to].present? && params[:from].present?
            @cards = Card.between_dates(params[:from], params[:to], @tribute, @payment_method)
        else
            @cards = Card.is_tribute_or_payment_blank?(@tribute, @payment_method)
        end

        show_in_pdf(@cards)
    end

    private

    def show_in_pdf(cards)
        @won = cards.where(action: :recebimento).sum(:value)
        @spent = cards.where(action: :gasto).sum(:value)

        @total = @won - @spent

        pdf = CardsPdf::cards(cards, @won, @spent, @total)
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
        elsif payment_method == "cartão"
          @payment_method = 1
        elsif payment_method == "dinheiro"
          @payment_method = 2
        end
      end
end
