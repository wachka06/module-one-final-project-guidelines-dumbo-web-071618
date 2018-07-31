class RenameCastingopportunitysToCastingopportunities < ActiveRecord::Migration[5.0]
  def change
    rename_table :castingopportunitys, :castingopportunities
  end
end
