require 'base64'

module Bullhorn
  class Client
    
    BULLHORN_WSDL = 'https://api.bullhornstaffing.com/webservices-2.5/?wsdl'

    include Bullhorn::ResumeParsing
    include Bullhorn::CandidateMethods
    include Bullhorn::ClientContactMethods
    include Bullhorn::ClientCorporationMethods
    include Bullhorn::JobOrderMethods

    # Login to Bullhorn system and store credentials
    def initialize(username, password, api_key)      
      @username = username
      @password = password
      @api_key = api_key
      @client = Savon.client(wsdl: BULLHORN_WSDL, log_level: :debug, pretty_print_xml: true)
      #@client = Savon.client(wsdl: BULLHORN_WSDL, log_level: :warn, pretty_print_xml: true)
    end

    def start_session
      message = { username: @username, password: @password, apiKey: @api_key }
      soap_response = @client.call(:start_session, message: message)
      response = soap_response.body[:start_session_response][:return]
      @session = response[:session]
      response
    end

  end
end