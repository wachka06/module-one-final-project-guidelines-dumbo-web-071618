class RenameCastingrequestTable < ActiveRecord::Migration[5.0]
  def change
    rename_table :castingrequest, :casting_requests
  end
end
