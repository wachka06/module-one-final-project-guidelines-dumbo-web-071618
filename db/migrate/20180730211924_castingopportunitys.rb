class Castingopportunitys < ActiveRecord::Migration[5.0]
  def change
    create_table :castingopportunitys do |t|
      t.string :gender
      t.integer :age_range
      t.string :race
      t.integer :salary
      t.integer :start_date
      t.integer :end_date
      t.integer :actor_id
      t.integer :producer_id
      t.string :status
      t.boolean :request_role
    end
  end
end
