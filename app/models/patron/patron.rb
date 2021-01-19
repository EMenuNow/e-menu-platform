class Patron < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  attr_accessor :redirect_after_signup_to

  has_many :patron_orders, class_name: 'Patron::PatronOrder'
  has_many :patron_baskets, class_name: 'Patron::PatronBasket'
  has_many :orders, through: :patron_orders
  has_many :baskets, through: :patron_baskets
  has_many :patron_allergens
  has_many :patron_addresses
  has_one :patron_marketing_preference

  after_create :create_associations

  default_scope { includes(:orders) }

  def get_order_history
    orders
  end

  private

  def create_associations
    self.create_patron_marketing_preference
  end
end
