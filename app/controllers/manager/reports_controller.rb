# frozen_string_literal: true

module Manager
  class ReportsController < Manager::BaseController
    before_action :authenticate_manager_restaurant_user!
    before_action :set_restaurant

    def index
      after_created_at = params[:after_created_at]
      before_created_at = params[:before_created_at]

      @receipts = @restaurant.receipts.where.not(order: nil).includes(:order).order(created_at: :DESC)
      .where("created_at >= ?", after_created_at ? Date.parse(after_created_at) : 10.years.ago)
      .where("created_at <= ?", (before_created_at ? Date.parse(before_created_at) : Date.today)+1.days)
      .limit(500)

      @refunds = @receipts.map{|r| r.order.refunds}.flatten

      @total_value = (@receipts.sum(&:basket_total)/100.0)
      @refund_value = (@refunds.sum{|r| r[:stripe_data]['amount']}/100.0)
      @total_emenu_commission_value = (@receipts.sum(&:application_fee_amount)/100.0)
      @dates = @restaurant.receipts.select(:created_at).order(created_at: :asc).collect{|x|x.created_at.strftime("%d-%m-%Y")}.uniq.reverse
      @start_date = after_created_at || @dates.last
      @end_date = before_created_at || @dates.first

      segment = "-Daily" if params[:segment] == "%d-%m"
      segment = "-Weekly" if params[:segment] == "%W"
      segment = "-Monthly" if params[:segment] == "%m"
      date_range = @start_date.gsub("-", "") + @end_date.gsub("-", "")

      respond_to do |format|
        format.html
        format.xlsx {
          response.headers['Content-Disposition'] = "attachment; filename=EMenu-#{params[:view].humanize}#{segment}-#{@restaurant.id}#{date_range}.xlsx"
        }
        format.pdf do
          render pdf: "EMenu-Invoice-#{@restaurant.id}#{date_range}",
          layout: false,
          show_as_html: false
        end
      end
    end

    private

  end
end
