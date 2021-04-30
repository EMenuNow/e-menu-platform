# frozen_string_literal: true

class RestaurantUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :restaurant
  has_one :onboard

  def display_name
    email
  end

  def role?(role)
          
 # binding.pry
    roles.include? role.to_s
  end

  
end
