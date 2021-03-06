class OrdersController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:notify, :done, :show]
  
    def show
      if current_user.status == "free"
        order = current_user.orders.create(status: 0, name: "plan_pro", email: current_user.email, amount: 100)
        @form_info = Newebpay::Mpg.new(order).form_info    
      end
    end
        
    def create
    end
    
    def notify
        response = Newebpay::Mpgresponse.new(params[:TradeInfo])
        if response.success?
        order = Order.find_by(slug: response.order_no)
        order.update(status: 1)
        end

        head :ok
    end
    
    def done
        response = Newebpay::Mpgresponse.new(params[:TradeInfo])
        if response.success?
          redirect_to root_path
        else
          render html: "付款失敗"
        end
    end
    
    private
    # def set_user
    #   @user = User.find(params[:format])
    # end

end