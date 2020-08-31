require 'prawn'

module CardsPdf
  PDF_OPTIONS = {
    # Escolhe o Page size como uma folha A4
    :page_size   => "A4",
    # Define o formato do layout como portrait (poderia ser landscape)
    :page_layout => :portrait,
    # Define a margem do documento
    :margin      => [120, 75],

    :background => "#{Rails.root.to_s}/app/assets/images/letterhead.png"
  }

  def self.cards cards
      Prawn::Document.new(PDF_OPTIONS) do |pdf|
        @cont = 0

        pdf.fill_color "40464e"
        pdf.move_down 40

        pdf.text "Relatório Financeiro", align: :center, size: 24
        pdf.move_down 50

        pdf.font_size 12

        # --------------------------------------------------------
        pdf.text "- Relatório de recebimentos", size: 14
        pdf.move_down 10
        
        data = [["id", "Nome", "Documento", "Valor Cobrado", "Tipo de transação", "Descrição", "Tributação", "Comprovante", "Data", "Pagamento Em", "Categoria"]]
        
        won = 0
        cards.each do |card|
          if card['action'] == "recebimento"
            @cont = @cont + 1

            won += card['value'].to_i

            card = Card.find(card['id'].to_i)
            data += [ [@cont, card.name, card.document, card.value, card.tribute,
                      card.description, card.tribute, card.is_receipt_or_invoice?, card.date_concluded, card.payment_method, card.category.name ] ]
          end
        end

        pdf.table(data, position: :center, :cell_style => {size: 7}, width: 560, :header => true)
        
        pdf.move_down 40

        # --------------------------------------------------------

        pdf.text "- Relatório de gasto", size: 14
        pdf.move_down 10
        
        data = [["id", "Nome", "Documento", "Valor Cobrado", "Tipo de transação", "Descrição", "Tributação", "Comprovante", "Data", "Pagamento Em", "Categoria"]]
        
        total_spent_value = 0
        cards.each do |card|
          if card['action'] == "gasto"
            card = Card.find(card['id'].to_i)
            
            if card.parcel[0].to_i == 1
              @cont = @cont + 1

              # Sum cards of spent, removing parcels
              number_of_parcels = card.parcel[2].to_i

              if number_of_parcels > 1
                card_value = 0
                (1..number_of_parcels).each_with_index do |card_parcel, index|
                  card_value += Card.find(card.id + (index - 1)).value
                end
              else
                card_value = card.value
              end

              total_spent_value += card_value

              data += [ [@cont, card.name, card.document, card_value, card.tribute,
                      card.description, card.tribute, card.is_receipt_or_invoice?, card.date_concluded, card.payment_method, card.category.name ] ]
          
            end
          end
        end

        pdf.table(data, position: :center, :cell_style => {size: 7}, width: 560, :header => true)

        pdf.move_down 50

        pdf.text "Resultado Final", size: 16, :style => :bold

        pdf.text "Total de Recebimento: R$ #{won.truncate(2)}", size: 12, :style => :bold

        pdf.text "Total de Gastos: R$ #{total_spent_value.truncate(2)}", size: 12, :style => :bold

        pdf.move_down 20

        pdf.text "Balanço: R$ #{(won - total_spent_value).truncate(2)}", size: 12, :style => :bold

        pdf.number_pages "Gerado: #{(Time.now).strftime("%d/%m/%y as %H:%M")} - Página <page>", :start_count_at => 0, :page_filter => :all, :at => [pdf.bounds.right - 140, -50], :align => :right, :size => 8
      end
  end
 
end