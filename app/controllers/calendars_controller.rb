class CalendarsController < ApplicationController
    def index
        @cards = (current_user.admin?) ? Card.all.order(:name).group_by(&:on_date) : Card.all.profissional.order(:name).group_by(&:on_date)
    	@date = params[:date] ? Date.parse(params[:date]) : Date.today
    end
end
