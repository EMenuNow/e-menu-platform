# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')
Rails.application.config.assets.paths << Rails.root.join('assets/files')
Rails.application.config.assets.precompile +=
 %w[
  home_mobile.scss
  patron_application.css
  emenu_overwrite.css
  pdf.scss
  home_mobile.js
  cable.js
  cable_food.js
  cable_drinks.js
  color_picker.js
  live_order_loader.js
  pdf.js
 ]

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )
