class RenameCastingOpportunitysToCastingOpportunitiesAgain < ActiveRecord::Migration[5.0]
  def change
    rename_table :castingopportunities, :casting_opportunities
  end
end
