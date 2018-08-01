class AlterActorsTable < ActiveRecord::Migration[5.0]
  def change
    change_column :actors, :age_range, :string
    add_column :actors, :dates, :string
    remove_column :actors, :available_from
    remove_column :actors, :available_through
  end
end
