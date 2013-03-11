module Bullhorn
  module JobOrderMethods

    # Return the Integer ID for the JobOrder or nil if not found
    def query_job_order_by_external_id(external_id)
      query = { entity_name: 'JobOrder', max_results: 1, where: "externalID = '#{external_id}'" }
      message = { session: @session, query: query }
      soap_response = @client.call(:query, message: message)
      response = soap_response.body[:query_response][:return]
      response[:ids] ? response[:ids].to_i : nil
    end

    # Save the JobOrder and return the updated JobOrder object
    def save_job_order(job_order)
      message = job_order.to_soap_message(@session)
      soap_response = @client.call(:save, message: message)
      response = soap_response.body[:save_response][:return]
      Bullhorn::JobOrder.from_soap_message(response[:dto])
    end

    # Return the JobOrder object for the specified JobOrder id
    def find_job_order_by_id(id)
      message = { session: @session, entity_name: 'JobOrder', id: id, 
                  attributes!: { id: { 'xsi:type' => "xsd:int" } } }
      soap_response = @client.call(:find, message: message)
      response = soap_response.body[:find_response][:return]
      Bullhorn::JobOrder.from_soap_message(response[:dto])
    end

  end
end