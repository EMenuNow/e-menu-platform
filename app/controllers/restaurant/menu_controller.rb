class Restaurant::MenuController < ApplicationController
  def index
  	name = params[:name] || params[:slug]
    @restaurant = Restaurant.where(path: name).or(Restaurant.where(slug: name)).first
  end
end
