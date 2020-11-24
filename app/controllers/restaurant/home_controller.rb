class Restaurant::HomeController < ApplicationController
  def index

    redirect_to root_path
  	# @restaurants = Restaurant.all



  end
  def show


  	name = params[:name]
  	@restaurant = Restaurant.find(name)



  end
end
