class AddContabilityToCards < ActiveRecord::Migration[5.2]
  def change
    add_column :cards, :go_to_contability, :boolean
  end
end
