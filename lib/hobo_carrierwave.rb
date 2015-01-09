require 'hobo_fields'

module HoboCarrierwave
  class DefaultUploader < CarrerWave::Uploader::Base
    storage :file
    def store_dir
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end
  end
end

# The main work here is to monkey-patch HoboFields::Types
# Adding a new field type for :carrierwave_attachment to HoboFields::Types
module HoboFields
  module Types
    class CarrierwaveAttachment < String
      COLUMN_TYPE = :string
      def self.declared(model,name,options)
        mount_options = options.clone
        uploader = mount_options.delete(:uploader) || HoboCarrierwave::DefaultUploader
        model.mount_uploader(name, uploader, mount_options)
      end
      HoboFields.register_type(:carrierwave_attachment,self)
    end
  end
end