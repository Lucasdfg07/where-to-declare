class AddFinalValueAndTaxesToCard < ActiveRecord::Migration[5.2]
  def change
    add_column :cards, :taxes_value, :float, default: 0
  end
end
