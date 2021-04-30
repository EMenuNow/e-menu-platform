module Api
	module V1
    class ReceiptsController < ApiController
      def update
        receipt = Receipt.find(params[:id])

        if receipt.update(receipt_params)
          render json: { status: "success" }, status: :ok
        else
          render json: { status: "failure" }, status: :unprocessable_entity
        end
      end

      private

      def receipt_params
        params.require(:receipt).permit(:first_print_status)
      end
    end  
	end
end
