module WarrantyCheck

  class Warranty
    attr_accessor :description, :expired, :expire_date, :warrantydetails,
    :warranty_type, :status, :service_level, :deliverables, :product_id, :serial_number,
    :location, :service_type, :type_model, :start_date, :end_date, :details, 
    :provider, :days_left, :expiration_date

    def warrantydetails
      # this method is just a summary of the details as the individual details can be accessed by themselves
      if @warrantydetails.nil?
        @warrantydetails = {
          "warranty_type" => @warranty_type,
          "service_type" => @service_type,
          "start_date" => @start_date,
          "end_date" => @end_date,
          "status" => @status,
          "service_level" => @service_level,
          "deliverables" => @deliverables,
        }
      end
      return @warrantydetails

    end
    
  end
  
end
