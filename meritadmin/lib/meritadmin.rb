Gem.loaded_specs['meritadmin'].dependencies.each do |d|
 require d.name unless d.type == :development
end

require 'dotenv/load' unless Rails.env.production?
require "meritadmin/engine"

module Meritadmin
  PER_SCOPE_8 = 8
  PER_SCOPE = 5
  PER_PAGE = 1

  CLOUDINARY_CONFIG = {
    cloud_name: ENV['CLOUDINARY_API_CLOUD_NAME']
  }
end
