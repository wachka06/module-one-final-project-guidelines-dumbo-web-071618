class Castingrequest < ActiveRecord::Migration[5.0]
  def change
    create_table :castingrequest do |t|
      t.integer :actor_id
      t.integer :producer_id
      t.integer :castingopportunity_id
      t.string :status
    end
  end
end
