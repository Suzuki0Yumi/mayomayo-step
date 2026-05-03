class CreateProposals < ActiveRecord::Migration[7.1]
  def change
    create_table :proposals do |t|
      t.references :user, null: false, foreign_key: true
      t.string :goal, null: false
      t.integer :feeling, null: false, default: 0
      t.integer :time_available, default: 1 
      t.text :suggestion, null: false
      t.integer :status, default: 0, null: false

      t.timestamps
    end

    add_index :proposals, [:user_id, :created_at]
  end
end
