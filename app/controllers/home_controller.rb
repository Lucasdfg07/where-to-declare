class HomeController < ApplicationController
    require './lib/cards_pdf'

    def index
    end

    def export 
        redirect_to cards_path(from: params[:from], 
                               to: params[:to], 
                               tribute: params["/"][:tribute], 
                               payment_method: params["/"][:payment_method],
                               only_particular_cards: params["/"][:only_particular_cards])
    end
end
