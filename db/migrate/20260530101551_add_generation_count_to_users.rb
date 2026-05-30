class AddGenerationCountToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :daily_generation_count, :integer, default: 0, null: false
    add_column :users, :last_generation_date, :date
  end
end
