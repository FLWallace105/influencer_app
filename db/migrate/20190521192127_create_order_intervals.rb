class CreateOrderIntervals < ActiveRecord::Migration[5.2]
  def change
    create_table :order_intervals do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.boolean :usage, default: true

      t.timestamps 
    end

  end
end
