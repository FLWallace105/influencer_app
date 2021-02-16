class InfluencerOrdersController < ApplicationController
  def create
    @influencer_order_creator = InfluencerOrder::Creator.new(check_box_params)
    @influencers = @influencer_order_creator.influencers.page(params[:page]).per(100)

    if @influencer_order_creator.save
      flash[:success] =
        "#{@influencer_order_creator.created_count}
        #{'product'.pluralize(@influencer_order_creator.created_count)} queued to ship."
      redirect_to influencers_path
    else
      flash.now[:danger] =
        "Uh oh. Something went wrong. #{@influencer_order_creator.created_count}
        #{'product'.pluralize(@influencer_order_creator.created_count)} queued to ship."
      render :create
    end
  end

  def create_once_a_month
    @influencer_order_creator = InfluencerOrder::Creator.new(check_box_params)
    @influencers = @influencer_order_creator.influencers.page(params[:page]).per(100)

    my_order_interval = OrderInterval.first
    if InfluencerOrder.where("created_at >= ?", my_order_interval.start_date).any?
    #if InfluencerOrder.where("created_at >= ?", '2019-10-31').any?
    #if InfluencerOrder.where("created_at > 	 ?", Time.zone.now.end_of_month).any?
    #if InfluencerOrder.where("created_at >= ?", Time.zone.now.beginning_of_month).any?
      flash[:danger] = 'Influencer orders were already created this month.'
      redirect_to influencers_path
    elsif @influencer_order_creator.save
	#if @influencer_order_creator.save
      flash[:success] =
        "#{@influencer_order_creator.created_count}
        #{'product'.pluralize(@influencer_order_creator.created_count)} queued to ship."
      redirect_to influencers_path
    else
      flash.now[:danger] =
        "Uh oh. Something went wrong. #{@influencer_order_creator.created_count}
        #{'product'.pluralize(@influencer_order_creator.created_count)} queued to ship."
      render :create
    end
  end

  def upload
    orders = InfluencerOrder.where(uploaded_at: nil).order(:name)

    if orders.any?
      csv_file_name = InfluencerOrder.create_csv(orders)
      EllieFTP.new.upload_orders_csv(csv_file_name)

      flash[:success] = "#{orders.pluck(:name).uniq.count} orders were sent to the warehouse."
      InfluencerOrder.where(id: orders.pluck(:id)).update_all(uploaded_at: Time.current)
    else
      flash[:success] = 'There were no orders waiting to be sent to the warehouse.'
    end
    redirect_to root_path
  end

  def index
    ids = InfluencerOrder.pluck(:name, :id).uniq(&:first).map(&:last)
    @influencer_orders = InfluencerOrder.where(id: ids).includes(:tracking).page(params[:page]).per(100)
  end

  def delete
    partial_orders = InfluencerOrder.where(id: delete_params[:influencer_orders])
    count = partial_orders.count
    complete_orders = partial_orders.flat_map { |order| InfluencerOrder.where(name: order.name) }

    complete_orders.each(&:delete)
    flash[:success] = "#{count} #{'order'.pluralize(count)} deleted."

    redirect_to influencer_orders_path
  end

  private

  def check_box_params
    if params[:create_once_a_month]
      :create_once_a_month
    elsif params[:influencers]
      params.permit(influencers: [])
    else
      params
    end
  end

  def delete_params
    params.permit(influencer_orders: [])
  end
end
