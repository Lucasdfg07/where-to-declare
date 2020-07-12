class CreateCards < ActiveRecord::Migration[5.2]
  def change
    create_table :cards do |t|
      t.belongs_to :category
      t.string :name
      t.string :document
      t.float :value
      t.string :description
      t.integer :action
      t.integer :tribute
      t.boolean :receipt
      t.boolean :invoice
      t.integer :payment_method
      t.date :on_date
      t.boolean :done
      t.string :parcel
      
      t.timestamps
    end
  end
end
