module Bullhorn
  
  class JobOrder
    include ActiveAttr::Model

    DEFAULT_OWNER_ID = 4

    VALID_SALARY_UNIT = ['per hour', 'yearly']

    attribute :owner_id, :type => Integer, :default => DEFAULT_OWNER_ID
    attribute :job_order_id, :type => Integer
    attribute :external_id
    attribute :client_contact_id, :type => Integer
    attribute :client_corporation_id, :type => Integer

    attribute :title
    attribute :description
    attribute :salary
    attribute :salary_unit
    attribute :start_date
    attribute :is_deleted

    validates :owner_id, :presence => true
    validates :client_contact_id, :presence => true
    validates :client_corporation_id, :presence => true
    validates :external_id, :presence => true
    validates :title, :presence => true
    validates :description, :presence => true
    validates :salary, :presence => true
    validates :salary_unit, :presence => true, :inclusion => { :in => VALID_SALARY_UNIT }
    validates :start_date, :presence => true
    
    def to_soap_message(session)
      raise "Invalid JobOrder: #{errors.full_messages}" if not valid?

      attribute_data = {}
      job_data = { attributes!: attribute_data }
      message = { session: session, dto: job_data, 
                  attributes!: { dto: { 'xsi:type' => "ns4:jobOrderDto", 
                                      'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance', 
                                      'xmlns:ns4' => 'http://job.entity.bullhorn.com/' } } }

      job_data[:owner_iD] = owner_id
      attribute_data[:owner_iD] = { 'xsi:type' => "xsd:int" }
      
      if job_order_id
          job_data[:job_order_iD] = job_order_id
          attribute_data[:job_order_iD] = { 'xsi:type' => "xsd:int" }
      end
      job_data[:external_iD] = external_id if external_id
      if client_contact_id
          job_data[:client_contact_iD] = client_contact_id
          attribute_data[:job_order_iD] = { 'xsi:type' => "xsd:int" }
      end
      if client_corporation_id
          job_data[:client_corporation_iD] = client_corporation_id
          attribute_data[:client_corporation_iD] = { 'xsi:type' => "xsd:int" }
      end
      job_data[:title] = title
      job_data[:description] = description
      if salary
          job_data[:salary] = salary
          attribute_data[:salary] = { 'xsi:type' => "xsd:decimal" }
      end
      job_data[:salary_unit] = salary_unit
      if start_date
          job_data[:start_date] = start_date
          attribute_data[:start_date] = { 'xsi:type' => "xsd:dateTime" }
      end
      job_data[:is_deleted] = is_deleted ? 'true' : 'false'
      

      message
    end

    def self.from_soap_message(dto)
      job = Bullhorn::JobOrder.new
      job[:job_order_id] = dto[:job_order_id].to_i
      job[:external_id] = dto[:external_id]
      job[:client_corporation_id] = dto[:client_corporation_id].to_i
      job[:client_contact_id] = dto[:client_contact_id].to_i
      job[:title] = dto[:title]
      job[:description] = dto[:description]
      job[:salary] = dto[:salary]
      job[:salary_unit] = dto[:salary_unit]
      job[:start_date] = dto[:start_date]
      job[:is_deleted] = dto[:is_deleted]
      job
    end

  end
end

