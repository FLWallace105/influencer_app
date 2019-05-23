class OrderIntervalController < ApplicationController

  def index
    @order_interval = OrderInterval.all

  end
  
  def new
    OrderInterval.delete_all
    ActiveRecord::Base.connection.reset_pk_sequence!('order_intervals')
    @order_interval = OrderInterval.new


  end

  def edit
    
    @order_interval = OrderInterval.first

  end

  def update
    puts params.inspect
    my_id = params['order_interval']['id']

    @order_interval = OrderInterval.find(my_id)
    local_start_date = OrderInterval.new.create_date_from_string(params['order_interval']['start_date(1i)'], params['order_interval']['start_date(2i)'], params['order_interval']['start_date(3i)'])
    local_end_date = OrderInterval.new.create_date_from_string(params['order_interval']['end_date(1i)'], params['order_interval']['end_date(2i)'], params['order_interval']['end_date(3i)'])
    local_usage = OrderInterval.new.create_usage_from_integer(params['order_interval']['usage'])
    @order_interval.start_date = local_start_date
    @order_interval.end_date = local_end_date
    @order_interval.usage = local_usage

    if @order_interval.save
      redirect_to order_interval_index_path(@order_interval), notice: "Successfully updated start: #{@order_interval.start_date.strftime("%F")} end: #{@order_interval.end_date.strftime("%F")}."
    else
      render :edit
    end

  end

  def show
    @order_interval = OrderInterval.first

  end
  
  
  def create
    
    puts "*********"
    puts params.inspect
    puts params['order_interval'].inspect
    puts params['order_interval']['start_date(1i)'].inspect
    puts "----------------"
    local_start_date = OrderInterval.new.create_date_from_string(params['order_interval']['start_date(1i)'], params['order_interval']['start_date(2i)'], params['order_interval']['start_date(3i)'])
    puts local_start_date.inspect
    local_end_date = OrderInterval.new.create_date_from_string(params['order_interval']['end_date(1i)'], params['order_interval']['end_date(2i)'], params['order_interval']['end_date(3i)'])
    local_usage = OrderInterval.new.create_usage_from_integer(params['order_interval']['usage'])
    @new_interval = OrderInterval.create(start_date: local_start_date, end_date: local_end_date, usage: local_usage)


    
    puts "---"
    puts params.inspect
    puts "XXX"

    if @new_interval.save
      flash[:success] = "Created New Order Interval to check for duplicates"
      redirect_to order_interval_edit_path
    else
      flash.now[:danger] = "Uh oh. Something went wrong."
      #redirect_to_order_interval_create_path
    end
    

  end


  private
  def order_interval_params
    #params.require(:order_interval).permit(:start_date1, :start_date2, :start_date3, :end_date1, :end_date2, :end_date3, :usage)
  end

end
