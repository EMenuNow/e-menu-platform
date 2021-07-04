class CustomList < ApplicationRecord
  belongs_to :restaurant
  has_many :custom_list_items
  validates_presence_of :name, :on => [:update,:create], :message => "can't be blank"
  acts_as_list scope: :restaurant
  default_scope { order(position: :asc) }


  def input_type
  	if constraint == '1'
  		'radio'
  	else
  		'checkbox'
  	end
  end

  def clone!(cl_id, restaurant_id)
    custom_list = CustomList.find(cl_id)
    new_restaurant = Restaurant.find(restaurant_id)

    new_custom_list = custom_list.dup
    new_custom_list.restaurant_id = new_restaurant.id
    new_custom_list.save
    new_custom_list
  end

end
