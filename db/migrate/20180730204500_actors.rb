class Actors < ActiveRecord::Migration[5.0]
  def change
    create_table :actors do |t|
      t.string :first_name
      t.string :last_name
      t.string :gender
      t.integer :age_range
      t.string :race
      t.integer :salary_range
      t.date :available_from
      t.date :available_through
      t.integer :awards_rating
      t.integer :box_office_rating
    end
  end
end
