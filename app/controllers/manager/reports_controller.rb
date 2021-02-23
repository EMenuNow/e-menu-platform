# frozen_string_literal: true

module Manager
  class ReportsController < Manager::BaseController
    before_action :authenticate_manager_restaurant_user!
    before_action :set_restaurant

    def index
      after_created_at = params[:after_created_at]
      before_created_at = params[:before_created_at]

      @receipts = @restaurant.receipts.includes(:order).order(created_at: :DESC)
      .where("created_at >= ?", after_created_at ? Date.parse(after_created_at) : 10.years.ago)
      .where("created_at <= ?", (before_created_at ? Date.parse(before_created_at) : Date.today)+1.days)
      .limit(500)

      respond_to do |format|
        format.html
        format.xlsx
        format.pdf do
          render pdf: "emenu-invoice-download", :layout => false, show_as_html: false
        end
      end
    end

    private

  end
end
