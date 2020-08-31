class HomeController < ApplicationController
    require './lib/cards_pdf'

    def index
        @q = Card.ransack(params[:q])
    end
end
