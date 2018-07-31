class RemoveColumnsStartDateEndDateFromCastingOpportunities < ActiveRecord::Migration[5.0]
  def change
    remove_column :casting_opportunities, :start_date
    remove_column :casting_opportunities, :end_date
  end
end
