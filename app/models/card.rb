class Card < ApplicationRecord
    scope :between_dates, -> (from, to, tribute, payment_method) {
        if tribute.blank? && payment_method.blank?
            where("on_date between (?) and (?)", from, to)
        
        elsif !tribute.blank? && !payment_method.blank?
            where("on_date between (?) and (?) AND tribute = ? AND payment_method = ?", from, to, tribute, payment_method)
        
        elsif tribute.blank?
            where("on_date between (?) and (?) AND payment_method = ?", from, to, payment_method)
        
        elsif payment_method.blank?
            where("on_date between (?) and (?) AND tribute = ?", from, to, tribute)
        end
    } 

    scope :is_tribute_or_payment_blank?, -> (tribute, payment_method) {
        if !tribute.blank? && !payment_method.blank?
            where("tribute LIKE ? AND payment_method = ?", tribute, payment_method)
        
        elsif tribute.blank?
            where("payment_method = ?", payment_method)
        
        elsif payment_method.blank?
            where("tribute = ?", tribute)
        end
    } 

    belongs_to :category

    enum action: [:recebimento, :gasto]
    
    enum tribute: [:geral, :pessoa_física, :pessoa_jurídica]

    enum payment_method: [:cheque, :cartão, :dinheiro]

    validates_presence_of :action, :tribute, :value, :payment_method, :on_date
end
