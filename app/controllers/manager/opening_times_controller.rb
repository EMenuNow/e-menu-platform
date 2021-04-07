class Manager::OpeningTimesController < Manager::BaseController
  before_action :authenticate_manager_restaurant_user!

  before_action :set_manager_opening_time, only: [:index, :show, :edit, :update, :destroy]
  before_action :set_time_settings, only: [:create, :edit, :update, :new]

  before_action :set_restaurant

  # GET /manager/opening_times
  # GET /manager/opening_times.json
  def index
    @manager_opening_times = OpeningTime.where(restaurant_id: @restaurant.id)
    @manager_busy_times = BusyTime.where(restaurant_id: @restaurant.id).in_future.order(:busy_time)
  end
  
  # GET /manager/opening_times/1
  # GET /manager/opening_times/1.json
  def show
    @manager_opening_time = OpeningTime.find_by(restaurant_id: @restaurant.id)
  end

  # GET /manager/opening_times/new
  def new
    @manager_opening_time = OpeningTime.new
    @manager_opening_time.restaurant_id = @restaurant.id
  end

  # GET /manager/opening_times/1/edit
  def edit
  end

  # POST /manager/opening_times
  # POST /manager/opening_times.json
  def create
    @manager_opening_time = OpeningTime.new(manager_opening_time_params)

    respond_to do |format|
      if @manager_opening_time.save
        format.html { redirect_to manager_restaurant_opening_times_path(@restaurant), notice: 'Opening time was successfully created.' }
        format.json { render :show, status: :created, location: @manager_opening_time }
      else
        format.html { render :new }
        format.json { render json: @manager_opening_time.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /manager/opening_times/1
  # PATCH/PUT /manager/opening_times/1.json
  def update
    respond_to do |format|
      if @manager_opening_time.update(manager_opening_time_params)
        format.html { redirect_to manager_restaurant_opening_times_path(@restaurant), notice: 'Opening time was successfully updated.' }
        format.json { render :show, status: :ok, location: @manager_opening_time }
      else
        format.html { render :edit }
        format.json { render json: @manager_opening_time.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manager/opening_times/1
  # DELETE /manager/opening_times/1.json
  def destroy
    @manager_opening_time.destroy
    respond_to do |format|
      format.html { redirect_to manager_opening_times_url, notice: 'Opening time was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_manager_opening_time
    if params[:id].present?
      @manager_opening_time = OpeningTime.find(params[:id])
    else
      @manager_opening_time = OpeningTime.find_by(restaurant_id: params[:restaurant_id])
    end
  end
  
  def set_time_settings
    @time_settings = [0,15,30,45,60]
    @cut_off_settings = [0,1,2,3,4,5,6]
    @advanced_order_settings = [1,2,3,4,5,6,7,8,9,10,11,12,13,14]
  end

  # Only allow a list of trusted parameters through.
  def manager_opening_time_params
    params.require(:opening_time).permit(:restaurant_id, :delay_time_minutes, :kitchen_delay_minutes, :cut_off_days, :advanced_order_days, times: {})
  end
end
