class InfluencerOrdersController < ApplicationController
  def new
    @influencer_order_creator = InfluencerOrder::Creator.new
  end

  def create
    @influencer_order_creator = InfluencerOrder::Creator.new

    if InfluencerOrder.where("created_at >= ?", Time.zone.now.beginning_of_month).any?
      flash[:danger] = 'Influencer orders were already created this month.'
      redirect_to new_influencer_order_path
    elsif @influencer_order_creator.save
      flash[:success] =
        "#{@influencer_order_creator.created_count}
        #{'product'.pluralize(@influencer_order_creator.created_count)} queued to ship."
      redirect_to new_influencer_order_path
    else
      flash.now[:danger] =
        "Uh oh. Something went wrong. #{@influencer_order_creator.created_count}
        #{'product'.pluralize(@influencer_order_creator.created_count)} queued to ship."
      render new_influencer_order_path
    end
  end

  def upload
    orders = InfluencerOrder.where(uploaded_at: nil).order(:name)

    if orders.any?
      csv_file_name = InfluencerOrder.create_csv(orders)
      UploadInfluencerOrdersJob.perform_later(csv_file_name)

      flash[:success] = "#{orders.pluck(:name).uniq.count} orders were sent to the warehouse."
      InfluencerOrder.where(id: orders.pluck(:id)).update_all(uploaded_at: Time.current)
    else
      flash[:success] = 'There were no orders waiting to be sent to the warehouse.'
    end
    redirect_to root_path
  end

  def index
  end
end
