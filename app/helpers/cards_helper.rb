module CardsHelper
    def sum_won
        @cards.recebimento.sum(:value).truncate(2)
    end

    def sum_spent
        @cards.gasto.sum(:value).truncate(2)
    end

    def calc_juridic_tax
        @cards.recebimento.where("on_date BETWEEN (?) AND (?)", Date.today - 1.year, Date.today).sum(:value)
    end

    def calc_physical_tax
        @cards.recebimento.where("on_date BETWEEN (?) AND (?)", Time.now.beginning_of_year, Time.now.end_of_year).sum(:value)
    end
end
