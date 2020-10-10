class Card < ApplicationRecord
    scope :to_do, -> () {
        where("on_date between (?) and (?)", Date.today, Date.today + 1.week).order(on_date: :ASC)
    }

    scope :not_received, -> () {
        where("on_date < ? AND action = 0 AND (done = false OR done is ?)", Date.today, nil).order(on_date: :ASC)
    }

    scope :not_paid, -> () {
        where("on_date < ? AND action = 1 AND (done = false OR done is ?)", Date.today, nil).order(on_date: :ASC)
    }

    scope :concluded, -> () {
        where(done: true)
    }

    belongs_to :category

    enum action: [:recebimento, :gasto]
    
    enum tribute: [:particular, :pessoa_física, :pessoa_jurídica, :OFF]

    enum payment_method: [:cheque, :débito, :crédito, :transferência_bancária, :boleto, :dinheiro, :taxas]

    enum card_type: [:pessoal, :profissional]

    validates_presence_of :action, :tribute, :value, :payment_method, :on_date

    def is_receipt_or_invoice?
        if self.receipt == true && self.invoice == true
            return "Recibo e Nota Fiscal"
        
        elsif self.receipt == false && self.invoice == true
            return "Nota Fiscal"
        
        elsif self.receipt == true && self.invoice == false
            return "Recibo"
        
        elsif self.receipt == false && self.invoice == false
            return "-"
        end
    end

    def return_date
        if self.done? 
            self.date_concluded
        else
            self.on_date
        end
    end
end
