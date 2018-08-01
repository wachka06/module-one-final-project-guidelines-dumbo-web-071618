class ChangeSalaryrangeColumnToStringInActors < ActiveRecord::Migration[5.0]
  def change
    change_column :actors, :salary_range, :string
  end
end
