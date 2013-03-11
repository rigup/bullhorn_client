module Bullhorn
  
  class ClientCorporation
    include ActiveAttr::Model

    DEFAULT_DEPARTMENT_ID = 17139

    attribute :client_corporation_id, :type => Integer
    attribute :department_id, :type => Integer, :default => DEFAULT_DEPARTMENT_ID
    attribute :external_id
    attribute :name
    attribute :company_description
    attribute :company_url
    attribute :num_employees
    attribute :num_offices
    attribute :phone

    validates :department_id, :presence => true
    validates :external_id, :presence => true
    validates :name, :presence => true
    
    def to_soap_message(session)
      raise "Invalid ClientCorporation: #{errors.full_messages}" if not valid?

      attribute_data = {}
      company_data = { attributes!: attribute_data }
      message = { session: session, dto: company_data, 
                  attributes!: { dto: { 'xsi:type' => "ns4:clientCorporationDto", 
                                      'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance', 
                                      'xmlns:ns4' => 'http://client.entity.bullhorn.com/' } } }
      company_data[:department_iD] = department_id
      attribute_data[:department_iD] = { 'xsi:type' => "xsd:int" }
      
      if client_corporation_id
          company_data[:client_corporation_iD] = client_corporation_id
          attribute_data[:client_corporation_iD] = { 'xsi:type' => "xsd:int" }
      end
      company_data[:external_iD] = external_id if external_id
      company_data[:name] = name if name
      company_data[:company_description] = company_description if company_description
      company_data[:company_uRL] = company_url if company_url
      if num_employees
          company_data[:num_employees] = num_employees
          attribute_data[:num_employees] = { 'xsi:type' => "xsd:int" }
      end
      if num_offices
          company_data[:num_offices] = num_offices
          attribute_data[:num_offices] = { 'xsi:type' => "xsd:int" }
      end
      company_data[:phone] = phone if phone

      message
    end

    def self.from_soap_message(dto)
      company = Bullhorn::ClientCorporation.new
      company[:client_corporation_id] = dto[:client_corporation_id].to_i
      company[:external_id] = dto[:external_id]
      company[:name] = dto[:name]
      company[:company_description] = dto[:company_description]
      company[:company_url] = dto[:company_url]
      company[:num_employees] = dto[:num_employees].to_i
      company[:num_offices] = dto[:num_offices].to_i
      company[:phone] = dto[:phone]
      company
    end

  end
end

