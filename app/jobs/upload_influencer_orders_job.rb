class UploadInfluencerOrdersJob < ApplicationJob
  queue_as :default

  def perform(csv_file_name)
    EllieFTP.new.upload_orders_csv(csv_file_name)
  end
end
