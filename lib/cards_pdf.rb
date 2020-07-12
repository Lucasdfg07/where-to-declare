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

  def self.cards cards, won, spent, total
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
        
        cards.where(action: :recebimento).each do |card|
          @cont = @cont + 1
          data += [ [@cont, card.name, card.document, card.value, card.tribute,
                    card.description, card.tribute, card.is_receipt_or_invoice?, card.on_date, card.payment_method, card.category.name ] ]
        end

        pdf.table(data, position: :center, :cell_style => {size: 7}, width: 560, :header => true)

        pdf.move_down 20

        pdf.text "Total de Recebimento R$ #{won}", size: 12, :style => :bold, :align => :center
        
        pdf.move_down 40

        # --------------------------------------------------------

        pdf.text "- Relatório de gasto", size: 14
        pdf.move_down 10
        
        data = [["id", "Nome", "Documento", "Valor Cobrado", "Tipo de transação", "Descrição", "Tributação", "Comprovante", "Data", "Pagamento Em", "Categoria"]]
        
        cards.where(action: :gasto).each do |card|
          @cont = @cont + 1
          data += [ [@cont, card.name, card.document, card.value, card.tribute,
                    card.description, card.tribute, card.is_receipt_or_invoice?, card.on_date, card.payment_method, card.category.name ] ]
        end

        pdf.table(data, position: :center, :cell_style => {size: 7}, width: 560, :header => true)

        pdf.move_down 20

        pdf.text "Total de Gastos R$ #{spent}", size: 12, :style => :bold, :align => :center

        pdf.move_down 50

        pdf.text "Resultado Final", size: 16, :style => :bold

        pdf.text "Receita: R$ #{total}", size: 12, :style => :bold

        pdf.number_pages "Gerado: #{(Time.now).strftime("%d/%m/%y as %H:%M")} - Página <page>", :start_count_at => 0, :page_filter => :all, :at => [pdf.bounds.right - 140, -50], :align => :right, :size => 8
      end
  end
 
end