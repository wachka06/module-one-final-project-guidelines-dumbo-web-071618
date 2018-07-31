class Producers < ActiveRecord::Migration[5.0]
  def change
    create_table :producers do |t|
      t.string :first_name
      t.string :last_name
      t.integer :honesty_rating
    end
  end
end
