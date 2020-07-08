class Card < ApplicationRecord
    belongs_to :category

    enum action: [:recebimento, :gasto]
    enum tribute: [:geral, :pessoa_física, :pessoa_jurídica]

    enum payment_method: [:cheque, :cartão, :dinheiro]

    validates_presence_of :action, :tribute, :value, :payment_method, :on_date
end
