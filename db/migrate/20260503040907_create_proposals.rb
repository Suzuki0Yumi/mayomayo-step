class CreateProposals < ActiveRecord::Migration[7.1]
  def change
    create_table :proposals do |t|
      t.references :user, null: false, foreign_key: true
      t.string :goal , null: false
      t.string :feeling, null: false
      t.string :time_available
      t.text :suggestion, null: false
      t.integer :status, default: 0, null: false

      t.timestamps
    end

    add_index :proposals, [:user_id, :created_at]
  end
end
