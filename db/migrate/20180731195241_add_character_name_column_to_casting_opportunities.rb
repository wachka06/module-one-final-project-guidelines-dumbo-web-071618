class AddCharacterNameColumnToCastingOpportunities < ActiveRecord::Migration[5.0]
  def change
    add_column :casting_opportunities, :character_name, :string
  end
end
