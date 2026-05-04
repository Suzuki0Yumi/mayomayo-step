class AddParsedFieldsToProposals < ActiveRecord::Migration[7.1]
  def change
    add_column :proposals, :empathy, :text
    add_column :proposals, :action, :text
    add_column :proposals, :reason, :text
  end
end
