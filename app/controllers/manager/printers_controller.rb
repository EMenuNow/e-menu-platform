class Manager::PrintersController < Manager::BaseController
  before_action :set_printer, only: [:show, :edit, :update, :destroy]
  before_action :set_restaurant, except: [:print, :print_item, :print_items]
  before_action :set_pi_interface, except: [:print, :print_item, :print_items]
  
  # GET /manager/printers
  # GET /manager/printers.json
  def index
    @printers = Printer.all
  end

  # GET /manager/printers/1
  # GET /manager/printers/1.json
  def show
  end

  # GET /manager/printers/new
  def new
    @printer = Printer.new
    @printer.pi_interface_id = @pi_interface.id
    @printer.restaurant_id = @restaurant.id
  end

  # GET /manager/printers/1/edit
  def edit
  end

  # POST /manager/printers
  # POST /manager/printers.json
  def create
    @printer = Printer.new(printer_params)

    respond_to do |format|
      if @printer.save
        format.html { redirect_to manager_restaurant_pi_interface_path(@restaurant, @pi_interface), notice: 'Printer was successfully created.' }
        format.json { render :show, status: :created, location: @printer }
      else
        format.html { render :new }
        format.json { render json: @printer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /manager/printers/1
  # PATCH/PUT /manager/printers/1.json
  def update
    respond_to do |format|
      if @printer.update(printer_params)
        format.html { redirect_to manager_restaurant_pi_interface_path(@restaurant, @pi_interface), notice: 'Printer was successfully updated.' }
        format.json { render :show, status: :ok, location: @printer }
      else
        format.html { render :edit }
        format.json { render json: @printer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manager/printers/1
  # DELETE /manager/printers/1.json
  def destroy
    @printer.destroy
    respond_to do |format|
      format.html { redirect_to manager_restaurant_pi_interface_path(@restaurant, @pi_interface), notice: 'Printer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def print
    @printer = Printer.find(params[:printer_id])    
    @receipt = Receipt.find(params[:receipt_id]) 
    @receipt.print_receipt(@printer)
  end
  
  def print_item
    @printer = Printer.find(params[:printer_id])    
    @screen_item = ScreenItem.find_by(uuid: params[:uuid]) 
    @screen_item.print_receipt(@printer)
  end

  def print_items
    @printer = Printer.find(params[:printer_id])    
    @receipt = Receipt.find(params[:receipt_id]) 
    @receipt.print_receipt_grouped(@printer, params[:item_screen_type_key], action='print')
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_printer
      @printer = Printer.find(params[:id])
    end
    def set_pi_interface
      @pi_interface = PiInterface.find(params[:pi_interface_id])
   end
    # Only allow a list of trusted parameters through.
    def printer_params
      params.require(:printer).permit(:name, :pi_interface_id, :vendor, :product, :print_type, :restaurant_id)
    end
end
