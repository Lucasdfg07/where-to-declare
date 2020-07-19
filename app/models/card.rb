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

    scope :with_receipt, -> () {
        where(receipt: true)
    }

    scope :with_invoice, -> () {
        where(invoice: true)
    }

    scope :that_will_go_to_contability, -> () {
        where(go_to_contability: true)
    }

    scope :between_dates, -> (from, to, tribute, payment_method) {
        if tribute.blank? && payment_method.blank?
            where("date_concluded between (?) and (?)", from, to)
        
        elsif !tribute.blank? && !payment_method.blank?
            where("date_concluded between (?) and (?) AND tribute = ? AND payment_method = ?", from, to, tribute, payment_method)
        
        elsif tribute.blank?
            where("date_concluded between (?) and (?) AND payment_method = ?", from, to, payment_method)
        
        elsif payment_method.blank?
            where("date_concluded between (?) and (?) AND tribute = ?", from, to, tribute)
        end
    } 

    scope :is_tribute_or_payment_blank?, -> (tribute, payment_method) {
        if !tribute.blank? && !payment_method.blank?
            where("tribute = ? AND payment_method = ?", tribute, payment_method)
        
        elsif tribute.blank?
            where("payment_method = ?", payment_method)
        
        elsif payment_method.blank?
            where("tribute = ?", tribute)
        end
    } 

    belongs_to :category

    enum action: [:recebimento, :gasto]
    
    enum tribute: [:particular, :pessoa_física, :pessoa_jurídica, :OFF]

    enum payment_method: [:cheque, :débito, :crédito, :transferência_bancária, :boleto, :dinheiro, :taxas]

    enum card_type: [:pessoal, :profissional]

    validates_presence_of :action, :tribute, :value, :payment_method, :on_date

    def is_receipt_or_invoice?
        if self.receipt == true && self.invoice == true
            return "Receita e Nota Fiscal"
        
        elsif self.receipt == false && self.invoice == true
            return "Nota Fiscal"
        
        elsif self.receipt == true && self.invoice == false
            return "Recibo"
        
        elsif self.receipt == false && self.invoice == false
            return "-"
        end
    end
end
