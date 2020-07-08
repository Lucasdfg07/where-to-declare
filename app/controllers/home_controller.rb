class HomeController < ApplicationController
    require './lib/cards_pdf'

    def index
        @q = Card.ransack(params[:q])
    end

    def export 
        send_tribute(params[:q][:tribute])
        send_payment_method(params[:q][:payment_method])

        @q = Card.ransack(params[:q])

        if params[:to].present? && params[:from].present?
            is_tribute_or_payment_with_date_blank?(params[:from], params[:to], @tribute, @payment_method)
        else
            is_tribute_or_payment_blank?(@tribute, @payment_method)
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

    def is_tribute_or_payment_with_date_blank?(from, to, tribute, payment_method)
        if @tribute.blank? && @payment_method.blank?
            @cards = @q.result.where("on_date between (?) and (?)", from, to)
        elsif !@tribute.blank? && !@payment_method.blank?
            @cards = @q.result.where("on_date between (?) and (?) AND tribute LIKE ? AND payment_method LIKE ?", from, to, @tribute, @payment_method)
        elsif @tribute.blank?
            @cards = @q.result.where("on_date between (?) and (?) AND payment_method LIKE ?", from, to, @payment_method)
        elsif @payment_method.blank?
            @cards = @q.result.where("on_date between (?) and (?) AND tribute LIKE ?", from, to, @tribute)
        end
    end

    def is_tribute_or_payment_blank?(tribute, payment_method)
        if !@tribute.blank? && !@payment_method.blank?
            @cards = @q.result.where("tribute LIKE ? AND payment_method LIKE ?", @tribute, @payment_method)
        elsif @tribute.blank?
            @cards = @q.result.where("payment_method LIKE ?", @payment_method)
        elsif @payment_method.blank?
            @cards = @q.result.where("tribute LIKE ?", @tribute)
        end
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
