class CreateFlights < ActiveRecord::Migration[5.2]
  def change
    create_table :flights do |t|
      t.string :mission_number
      t.decimal :duration
      t.string :mission_type
    end
  end
end
