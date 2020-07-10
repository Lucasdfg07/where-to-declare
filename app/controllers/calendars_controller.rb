class CalendarsController < ApplicationController
    def index
        @cards = Card.all.order(:name).group_by(&:on_date)
    	@date = params[:date] ? Date.parse(params[:date]) : Date.today
    end
end
