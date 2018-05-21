class AddDateColumnToFlights < ActiveRecord::Migration[5.2]
  def change
    add_column :flights, :flight_date, :date
  end
end
