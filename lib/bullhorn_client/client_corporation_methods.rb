module Bullhorn
  module ClientCorporationMethods

    # Return the Integer ID for the client corporation or nil if not found
    def query_client_corporation_by_external_id(external_id)
      query = { entity_name: 'ClientCorporation', max_results: 1, where: "externalID = '#{external_id}'" }
      message = { session: @session, query: query }
      soap_response = @client.call(:query, message: message)
      response = soap_response.body[:query_response][:return]
      response[:ids] ? response[:ids].to_i : nil
    end

    # Save the ClientCorporation and return the updated ClientCorporation object
    def save_client_corporation(client_corporation)
      message = client_corporation.to_soap_message(@session)
      soap_response = @client.call(:save, message: message)
      response = soap_response.body[:save_response][:return]
      Bullhorn::ClientCorporation.from_soap_message(response[:dto])
    end

    # Return the ClientCorporation object for the specified ClientCorporation id
    def find_client_corporation_by_id(id)
      message = { session: @session, entity_name: 'ClientCorporation', id: id, 
                  attributes!: { id: { 'xsi:type' => "xsd:int" } } }
      soap_response = @client.call(:find, message: message)
      response = soap_response.body[:find_response][:return]
      Bullhorn::ClientCorporation.from_soap_message(response[:dto])
    end

  end
end