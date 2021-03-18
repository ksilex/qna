class CreateLinks < ActiveRecord::Migration[6.1]
  def change
    create_table :links do |t|
      t.string :name
      t.string :url
      t.references :parent, polymorphic: true, null: false

      t.timestamps
    end
  end
end
