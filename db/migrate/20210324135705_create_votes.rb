class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :vote_type, null: false
      t.references :parent, polymorphic: true, null: false

      t.timestamps
    end
  end
end
