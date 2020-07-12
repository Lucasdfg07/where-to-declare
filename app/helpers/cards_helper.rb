module CardsHelper
    def sum_won
        @cards.recebimento.sum(:value).truncate(2)
    end

    def sum_spent
        @cards.gasto.sum(:value).truncate(2)
    end
end
