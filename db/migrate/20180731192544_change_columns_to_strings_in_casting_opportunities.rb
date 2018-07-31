class ChangeColumnsToStringsInCastingOpportunities < ActiveRecord::Migration[5.0]
  def change
    change_column :casting_opportunities, :age_range, :string
    change_column :casting_opportunities, :salary, :string
  end
end
