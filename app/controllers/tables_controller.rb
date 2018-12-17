# frozen_string_literal: true

class TablesController < ApplicationController
  before_action :set_table, only: %i[show edit update destroy]
  before_action :authenticate_manager_restaurant_user!, except: %i[show pay stripe finish add_item]
  skip_before_action :verify_authenticity_token, only: %i[pay stripe]
  # GET /tables
  # GET /tables.json
  def index
    @tables = Table.all
  end

  # GET /tables/1
  # GET /tables/1.json
  def show
    table_id = cookies[:table_id]
    redirect_to home_index_path, alert: 'The table session has expired. Please re-join table.' unless @table.id == table_id.to_i
  end

  # GET /tables/new
  def new
    @table = Table.new
  end

  # GET /tables/1/edit
  def edit; end

  def add_item
    table = Table.find(params[:table_id])
    menu = Menu.find(params[:menu_id])
    for_person = params[:for]

    TableItem.create(
      table_id: table.id,
      menu_id: menu.id,
      for: for_person
    )

    respond_to do |format|
      format.html { redirect_to table_path(table), notice: "#{menu.name} was added to your order successfully." }
      format.js
    end
  end

  def pay
    @table = Table.find(params[:table_id])
  end

  def stripe
    error = nil
    @table = Table.find(params[:table_id])

    Stripe.api_key = 'sk_test_hOj5WqYB26UV1v5uuqXsADSG'
    token = params[:token]
    price = params[:price].to_i

    Rails.logger.debug("Payment Token: #{token}")
    Rails.logger.debug("Payment Price: #{price}")
    begin
      Stripe::Charge.create(
        amount: price,
        currency: 'gbp',
        description: 'e-me.nu charge',
        source: token
      )
      table_items = TableItem.where(id: params[:items].split(','))
      table_items.update_all(paid: true, token: token)
    rescue Exception => e
      error = e
    end

    respond_to do |format|
      if error.present?
        format.json { render json: { error: 'true', url: table_pay_path(@table), message: "There has been an error: #{e.message}" } }
        format.html { redirect_to table_pay_path(@table), alert: "There has been an error: #{e.message}" }
      else
        format.json { render json: { error: 'false', url: table_pay_path(@table), message: 'Thank You, your payment was successful.' } }
        format.html { redirect_to table_pay_path(@table), notice: 'Thank You, your payment was successful.' }
      end
    end
  end

  def finish
    @table = Table.find(params[:table_id])
    price = @table.table_items.reject(&:paid).map(&:price_a).inject(:+) || 0

    respond_to do |format|
      if price.zero?
        @table.finish
        @table.save
        format.html { redirect_to root_path(@table), notice: 'Thank You' }
      else
        format.html { redirect_to table_pay_path(@table), notice: 'You cannot close the table if the bill is not settled' }
      end
    end
  end

  # POST /tables
  # POST /tables.json
  def create
    @table = Table.new(table_params)

    respond_to do |format|
      if @table.save
        format.html { redirect_to @table, notice: 'Table was successfully created.' }
        format.json { render :show, status: :created, location: @table }
      else
        format.html { render :new }
        format.json { render json: @table.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tables/1
  # PATCH/PUT /tables/1.json
  def update
    respond_to do |format|
      if @table.update(table_params)
        format.html { redirect_to @table, notice: 'Table was successfully updated.' }
        format.json { render :show, status: :ok, location: @table }
      else
        format.html { render :edit }
        format.json { render json: @table.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tables/1
  # DELETE /tables/1.json
  def destroy
    @table.destroy
    respond_to do |format|
      format.html { redirect_to tables_url, notice: 'Table was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_table
    @table = Table.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def table_params
    params.require(:table).permit(:restaurant_table_id, :password, :aasm_state)
  end
end
