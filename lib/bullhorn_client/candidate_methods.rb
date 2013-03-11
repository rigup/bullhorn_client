module Bullhorn
  module CandidateMethods

    # Return the Integer ID for the candidate or nil if not found
    def query_candidate_by_email(email)
      query = { entity_name: 'Candidate', max_results: 1, where: "email = '#{email}'" }
      message = { session: @session, query: query }
      soap_response = @client.call(:query, message: message)
      response = soap_response.body[:query_response][:return]
      response[:ids] ? response[:ids].to_i : nil
    end

    # Save the Candidate and return the updated Candidate object
    def save_candidate(candidate)
      message = candidate.to_soap_message(@session)
      soap_response = @client.call(:save, message: message)
      response = soap_response.body[:save_response][:return]
      Bullhorn::Candidate.from_soap_message(response[:dto])
    end

    # Return the Candidate object for the specified candidate id
    def find_candidate_by_id(id)
      message = { session: @session, entity_name: 'Candidate', id: id, 
                  attributes!: { id: { 'xsi:type' => "xsd:int" } } }
      soap_response = @client.call(:find, message: message)
      response = soap_response.body[:find_response][:return]
      Bullhorn::Candidate.from_soap_message(response[:dto])
    end

    # Return the array of files stored for the specified candidate id
    def get_candidate_files(id)
      message = { session: @session, entity_name: 'Candidate', entity_id: id, 
                  attributes!: { entity_id: { 'xsi:type' => "xsd:int" } } }
      soap_response = @client.call(:get_entity_files, message: message)
      response = soap_response.body[:get_entity_files_response][:return]
      files_array = []
      if not response[:api_entity_metas].nil?
        if response[:api_entity_metas].is_a?(Hash)
          files_array << response[:api_entity_metas]
        else
          files_array = response[:api_entity_metas]
        end
      end
      files_array
    end

    # Add the input file to the specified candidate id
    def add_candidate_file(candidate_id, name, binary)
      message = { session: @session, entity_name: 'Candidate', entity_id: candidate_id, 
                  file_content: Base64.encode64(binary), 
                  file_meta_data: { name: name, type: 'Resume' },  
                  attributes!: { entity_id: { 'xsi:type' => "xsd:int" } } }
      soap_response = @client.call(:add_file, message: message)
      response = soap_response.body[:add_file_response][:return]
      response[:id].to_i
    end

    # Return the file data for the specified candidate and file ids
    def get_candidate_file(candidate_id, file_id)
      message = { session: @session, entity_name: 'Candidate', entity_id: candidate_id, file_id: file_id, 
                  attributes!: { entity_id: { 'xsi:type' => "xsd:int" }, file_id: { 'xsi:type' => "xsd:int" } } }
      soap_response = @client.call(:get_file, message: message)
      response = soap_response.body[:get_file_response][:return]
      file_data = nil
      file_data = Base64.decode64(response[:file_data]) if response[:file_data]
      return file_data
    end

    # Update the input file for the specified candidate id
    def update_candidate_file(candidate_id, file_id, name, binary)
      message = { session: @session, entity_name: 'Candidate', entity_id: candidate_id, file_id: file_id, 
                  file_content: Base64.encode64(binary), 
                  file_meta_data: { name: name, type: 'Resume' },  
                  attributes!: { entity_id: { 'xsi:type' => "xsd:int" }, file_id: { 'xsi:type' => "xsd:int" } } }
      soap_response = @client.call(:update_file, message: message)
      response = soap_response.body[:update_file_response][:return]
      response
    end

    # Delete the input file for the specified candidate id
    def delete_candidate_file(candidate_id, file_id)
      message = { session: @session, entity_name: 'Candidate', entity_id: candidate_id, file_id: file_id, 
                  attributes!: { entity_id: { 'xsi:type' => "xsd:int" }, file_id: { 'xsi:type' => "xsd:int" } } }
      soap_response = @client.call(:delete_file, message: message)
      response = soap_response.body[:delete_file_response][:return]
      response
    end

  end
end