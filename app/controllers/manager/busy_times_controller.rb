class Manager::BusyTimesController < Manager::BaseController
  before_action :authenticate_manager_restaurant_user!

  before_action :set_manager_busy_time, only: [:index, :show, :destroy]

  before_action :set_restaurant

  def index
    @manager_busy_times = BusyTime.where(restaurant_id: @restaurant.id).in_future.order(:busy_time)
  end
  
  def show
    @manager_busy_times = BusyTime.where(restaurant_id: @restaurant.id).in_future.order(:busy_time)
  end
  
  def new
    @manager_busy_times = BusyTime.where(restaurant_id: @restaurant.id).in_future.order(:busy_time)
    @busy_day_options = @restaurant.available_days
    @restaurant_availability = @restaurant.availability
    @restaurant_availability[0][:times] = @restaurant_availability[0][:times].reject { |obj| obj[:value] == "ASAP" }
    @busy_time_options = @restaurant_availability[0][:times]

    @manager_opening_time = @restaurant.opening_time
    @manager_busy_time = BusyTime.new
    @manager_busy_time.restaurant_id = @restaurant.id
  end

  def create
    t = Time.new
    offset = params[:busy_time][:date_offset].to_i
    busy_time = params[:busy_time][:busy_time]
    bt = t + offset.day
    busy_params = manager_busy_time_params.except(:date_offset)
    busy_params[:busy_time] = Time.parse("#{bt.year}-#{bt.month}-#{bt.day} #{busy_time}:00").in_time_zone(@restaurant.time_zone) + t.utc_offset - t.in_time_zone(@restaurant.time_zone).utc_offset
    @manager_busy_time = BusyTime.new(busy_params)

    respond_to do |format|
      if @manager_busy_time.save
        format.html { redirect_to new_manager_restaurant_busy_time_path(@restaurant), notice: 'Busy time was successfully created.' }
        format.json { render :show, status: :created, location: @manager_busy_time }
      else
        format.html { render :new }
        format.json { render json: @manager_busy_time.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    session[:return_to] ||= request.referer

    @manager_busy_time.destroy
    respond_to do |format|
      format.html { redirect_to session.delete(:return_to), notice: 'Busy time was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_manager_busy_time
    if params[:id].present?
      @manager_busy_time = BusyTime.find(params[:id])
    else
      @manager_busy_time = BusyTime.find_by(restaurant_id: params[:restaurant_id])
    end
  end

  def manager_busy_time_params
    params.require(:busy_time).permit(:restaurant_id, :busy_time, :date_offset)
  end
end
