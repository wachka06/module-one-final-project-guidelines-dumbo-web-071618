class AddDatesColumnToCastingOpportunities < ActiveRecord::Migration[5.0]
  def change
    add_column :casting_opportunities, :dates, :string
  end
end
