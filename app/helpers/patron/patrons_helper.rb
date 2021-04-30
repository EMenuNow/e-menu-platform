module Patron::PatronsHelper

	def resource_name
		:patron
	end

	def resource
		@resource ||= Patron.new
	end

	def devise_mapping
		@devise_mapping ||= Devise.mappings[:patron]
	end

	def resource_class
		devise_mapping.to
	end

end
