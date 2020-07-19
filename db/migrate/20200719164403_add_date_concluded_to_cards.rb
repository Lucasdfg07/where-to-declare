class AddDateConcludedToCards < ActiveRecord::Migration[5.2]
  def change
    add_column :cards, :date_concluded, :date
  end
end
