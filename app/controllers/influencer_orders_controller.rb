class InfluencerOrdersController < ApplicationController
  def upload
    orders = InfluencerOrder.where(uploaded_at: nil).order(:name)

    if orders.any?
      csv_file_name = InfluencerOrder.create_csv(orders)
      UploadInfluencerOrdersJob.perform_later(csv_file_name)
      flash[:success] = "#{orders.count} orders were sent to the warehouse."
      InfluencerOrder.where(id: orders.pluck(:id)).update_all(uploaded_at: Time.current)
    else
      flash[:success] = 'There were no orders waiting to be sent to the warehouse.'
    end
    redirect_back(fallback_location: root_path)
  end

  def index
  end
end
