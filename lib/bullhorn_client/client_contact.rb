module Bullhorn
  
  class ClientContact
    include ActiveAttr::Model

    DEFAULT_CATEGORY_ID = 45
    DEFAULT_OWNER_ID = 4
    DEFAULT_USER_TYPE_ID = 35

    attribute :category_id, :type => Integer, :default => DEFAULT_CATEGORY_ID
    attribute :owner_id, :type => Integer, :default => DEFAULT_OWNER_ID
    attribute :user_type_id, :type => Integer, :default => DEFAULT_USER_TYPE_ID

    attribute :user_id, :type => Integer
    attribute :external_id
    attribute :first_name
    attribute :last_name
    attribute :email
    attribute :client_corporation_id, :type => Integer
    attribute :is_deleted

    validates :category_id, :presence => true
    validates :owner_id, :presence => true
    validates :user_type_id, :presence => true
    validates :external_id, :presence => true
    validates :first_name, :presence => true
    validates :last_name, :presence => true
    validates :email, :presence => true
    validates :client_corporation_id, :presence => true

    def to_soap_message(session)
      raise "Invalid ClientContact: #{errors.full_messages}" if not valid?

      attribute_data = {}
      contact_data = { attributes!: attribute_data }
      message = { session: session, dto: contact_data, 
                  attributes!: { dto: { 'xsi:type' => "ns4:clientContactDto", 
                                      'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance', 
                                      'xmlns:ns4' => 'http://client.entity.bullhorn.com/' } } }
      contact_data[:category_iD] = category_id
      attribute_data[:category_iD] = { 'xsi:type' => "xsd:int" }
      contact_data[:owner_iD] = owner_id
      attribute_data[:owner_iD] = { 'xsi:type' => "xsd:int" }
      contact_data[:user_type_iD] = user_type_id
      attribute_data[:user_type_iD] = { 'xsi:type' => "xsd:int" }

      contact_data[:external_id] = external_id
      contact_data[:first_name] = first_name
      contact_data[:last_name] = last_name
      if user_id
          contact_data[:user_iD] = user_id
          attribute_data[:user_iD] = { 'xsi:type' => "xsd:int" }
      end
      contact_data[:email] = email if email
      if client_corporation_id
          contact_data[:client_corporation_iD] = client_corporation_id
          attribute_data[:client_corporation_iD] = { 'xsi:type' => "xsd:int" }
      end
      contact_data[:is_deleted] = is_deleted ? 'true' : 'false'

      # Auto-generated fields
      contact_data[:name] = "#{first_name} #{last_name}"
      contact_data[:username] = "#{first_name.downcase}#{last_name.downcase}"
      contact_data[:password] = "password"

      message
    end

    def self.from_soap_message(dto)
      contact = Bullhorn::ClientContact.new
      contact[:user_id] = dto[:user_id].to_i
      contact[:external_id] = dto[:external_id]
      contact[:first_name] = dto[:first_name]
      contact[:last_name] = dto[:last_name]
      contact[:email] = dto[:email]
      contact[:client_corporation_id] = dto[:client_corporation_id].to_i if dto[:client_corporation_id]
      contact[:is_deleted] = dto[:is_deleted]
      contact
    end

  end
end

