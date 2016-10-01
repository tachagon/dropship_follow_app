class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :code
      t.string :name
      t.integer :superproduct_id
      t.string :status
      t.text :description
      t.boolean :follow, default: true
      t.float :cost_price
      t.string :url
      t.datetime :last_sync
      t.string :image

      t.timestamps
    end
  end
end
