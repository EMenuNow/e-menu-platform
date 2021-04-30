# frozen_string_literal: true

module Manager

class DiscountCodesController < Manager::BaseController
  before_action :authenticate_manager_restaurant_user!
  before_action :set_restaurant
  before_action :set_discount_code, :only => [:show, :edit, :update, :destroy]

  def index
    @discount_codes = @restaurant.discount_codes.order(updated_at: :DESC)
  end

  def show
  end

  def new
    @discount_code = @restaurant.discount_codes.new
  end
  
  def edit
  end

  def create
    @discount_code = @restaurant.discount_codes.new(discount_code_params)

    respond_to do |format|
      if @discount_code.save
        format.html { redirect_to manager_discount_codes_path(@restaurant), notice: 'Discount code was successfully created.' }
        format.json { render :show, status: :created, location: @discount_code }
      else
        format.html { render :new }
        format.json { render json: @discount_code.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @discount_code.update(discount_code_params)
        format.html { redirect_to manager_discount_codes_path(@restaurant), notice: 'Discount code was successfully updated.' }
        format.json { render :show, status: :ok, location: @discount_code }
      else
        format.html { render :edit }
        format.json { render json: @discount_code.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @discount_code.update_attribute(:expires_on, 1.days.ago)
    respond_to do |format|
      format.html { redirect_to manager_discount_codes_path(@restaurant), notice: 'Discount code was successfully deactivated.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_discount_code
      @discount_code = @restaurant.discount_codes.where(:id => params[:id]).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def discount_code_params
      params.require(:discount_code).permit(:code, :amount, :type, :max_uses, :expires_on, :single_use_per_user)
    end
end

end
