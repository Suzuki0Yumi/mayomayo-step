class CreateBadges < ActiveRecord::Migration[7.1]
  def change
    create_table :badges do |t|
      t.string :name, null: false
      t.text :description
      t.string :badge_type, null: false
      t.string :image_path, null: false

      t.timestamps
    end

    add_index :badges, :badge_type
  end
end
