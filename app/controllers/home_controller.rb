class HomeController < ApplicationController
    require './lib/cards_pdf'

    def index
    end

    def export 
        if params[:from].blank? && params[:to].blank? && params["/"][:tribute].blank? && 
           params["/"][:payment_method].blank? && params["/"][:action].blank?

            redirect_to home_index_path, alert: "Preencha a data, método de pagamento ou tributo!"
        
        elsif (params[:from].blank? && !params[:to].blank?) || (!params[:from].blank? && params[:to].blank?)
            redirect_to home_index_path, alert: "Preencha a data corretamente!"
        
        else
            redirect_to cards_path(from: params[:from], 
                                    to: params[:to], 
                                    tribute: params["/"][:tribute], 
                                    payment_method: params["/"][:payment_method],
                                    only_particular_cards: params["/"][:only_particular_cards],
                                    receipt: params["/"][:receipt],
                                    invoice: params["/"][:invoice])
        end
    end
end
