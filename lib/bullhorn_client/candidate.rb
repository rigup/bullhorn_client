module Bullhorn
  
  class Candidate
    include ActiveAttr::Model

    DEFAULT_CATEGORY_ID = 45
    DEFAULT_OWNER_ID = 4
    DEFAULT_USER_TYPE_ID = 35
    
    VALID_EMPLOYEE_TYPES = ['W2', '1099']
    VALID_STATUSES = ['New Lead', 'Active', 'Offer Pending', 'Placed']
    VALID_VETERAN = ['Y', 'N']
    
    attribute :category_id, :type => Integer, :default => DEFAULT_CATEGORY_ID
    attribute :owner_id, :type => Integer, :default => DEFAULT_OWNER_ID
    attribute :user_type_id, :type => Integer, :default => DEFAULT_USER_TYPE_ID
    attribute :employee_type, :default => 'W2'
    attribute :status, :default => 'New Lead'
    
    attribute :user_id, :type => Integer
    attribute :external_id
    attribute :first_name
    attribute :last_name
    attribute :email
    attribute :will_relocate
    attribute :veteran
    attribute :salary_low, :type => Integer
    attribute :salary_low
    attribute :is_deleted

    validates :category_id, :presence => true
    validates :owner_id, :presence => true
    validates :user_type_id, :presence => true
    validates :employee_type, :presence => true, :inclusion => { :in => VALID_EMPLOYEE_TYPES }
    validates :status, :presence => true, :inclusion => { :in => VALID_STATUSES }
    validates :external_id, :presence => true
    validates :first_name, :presence => true
    validates :last_name, :presence => true
    validates :email, :presence => true
    validates :veteran,  :inclusion => { :in => VALID_VETERAN }
    
    def to_soap_message(session)
      raise "Invalid Candidate: #{errors.full_messages}" if not valid?

      attribute_data = {}
      candidate_data = { attributes!: attribute_data }
      message = { session: session, dto: candidate_data, 
                  attributes!: { dto: { 'xsi:type' => "ns4:candidateDto", 
                                      'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance', 
                                      'xmlns:ns4' => 'http://candidate.entity.bullhorn.com/' } } }
      
      candidate_data[:category_iD] = category_id
      attribute_data[:category_iD] = { 'xsi:type' => "xsd:int" }
      candidate_data[:owner_iD] = owner_id
      attribute_data[:owner_iD] = { 'xsi:type' => "xsd:int" }
      candidate_data[:user_type_iD] = user_type_id
      attribute_data[:user_type_iD] = { 'xsi:type' => "xsd:int" }
      candidate_data[:employee_type] = employee_type
      candidate_data[:status] = status
      candidate_data[:external_iD] = external_id if external_id
      candidate_data[:first_name] = first_name
      candidate_data[:last_name] = last_name
      if user_id
          candidate_data[:user_iD] = user_id
          attribute_data[:user_iD] = { 'xsi:type' => "xsd:int" }
      end
      candidate_data[:email] = email if email
      candidate_data[:will_relocate] = will_relocate ? 'true' : 'false'
      candidate_data[:veteran] = veteran if veteran
      if salary_low
          candidate_data[:salary_low] = salary_low
          attribute_data[:salary_low] = { 'xsi:type' => "xsd:decimal" }
      end
      candidate_data[:is_deleted] = is_deleted ? 'true' : 'false'

      # Auto-generated fields
      candidate_data[:name] = "#{first_name} #{last_name}"
      candidate_data[:username] = "#{first_name.downcase}#{last_name.downcase}"
      candidate_data[:password] = "password"

      message
    end

    def self.from_soap_message(dto)
      candidate = Bullhorn::Candidate.new
      candidate[:user_id] = dto[:user_id].to_i
      candidate[:external_id] = dto[:external_id]
      candidate[:first_name] = dto[:first_name]
      candidate[:last_name] = dto[:last_name]
      candidate[:email] = dto[:email]
      candidate[:will_relocate] = dto[:will_relocate]
      candidate[:veteran] = dto[:veteran]
      candidate[:salary_low] = dto[:salary_low]
      candidate[:is_deleted] = dto[:is_deleted]
      candidate
    end

  end
end

