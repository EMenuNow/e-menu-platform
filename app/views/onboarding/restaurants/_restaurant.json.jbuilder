# frozen_string_literal: true

json.extract! restaurant, :id, :name, :address, :postcode, :telephone, :email, :twitter, :facebook, :opening_times, :is_chain, :cuisine_id, :created_at, :updated_at
json.url restaurant_url(restaurant, format: :json)
