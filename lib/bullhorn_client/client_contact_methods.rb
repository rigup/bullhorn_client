module Bullhorn
  module ClientContactMethods

    # Return the Integer ID for the client contact or nil if not found
    def query_client_contact_by_email(email)
      query = { entity_name: 'ClientContact', max_results: 1, where: "email = '#{email}'" }
      message = { session: @session, query: query }
      soap_response = @client.call(:query, message: message)
      response = soap_response.body[:query_response][:return]
      response[:ids] ? response[:ids].to_i : nil
    end

    # Save the ClientContact and return the updated ClientContact object
    def save_client_contact(client_contact)
      message = client_contact.to_soap_message(@session)
      soap_response = @client.call(:save, message: message)
      response = soap_response.body[:save_response][:return]
      Bullhorn::ClientContact.from_soap_message(response[:dto])
    end

    # Return the ClientContact object for the specified ClientContact id
    def find_client_contact_by_id(id)
      message = { session: @session, entity_name: 'ClientContact', id: id, 
                  attributes!: { id: { 'xsi:type' => "xsd:int" } } }
      soap_response = @client.call(:find, message: message)
      response = soap_response.body[:find_response][:return]
      Bullhorn::ClientContact.from_soap_message(response[:dto])
    end

  end
end