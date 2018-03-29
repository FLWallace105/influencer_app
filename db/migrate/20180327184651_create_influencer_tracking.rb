class CreateInfluencerTracking < ActiveRecord::Migration[5.1]
  def change
    create_table :influencer_tracking do |t|
      t.string :order_name, null: false, default: nil 
      t.string :carrier
      t.string :tracking_number
      t.timestamp :email_sent_at

      t.timestamps
    end
  end
end
