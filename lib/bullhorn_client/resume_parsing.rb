module Bullhorn
  module ResumeParsing

    MAX_PARSE_ATTEMPTS = 20

    def parse_resume(binary)
      # Chunk data in 76 character blocks
      # http://supportforums.bullhorn.com/viewtopic.php?f=32&t=13952
      data = Base64.encode64(Base64.encode64(binary)).split("\n").join.scan(/.{76}/).join("\n")
      message = { session: @session, base64_chunked_resume: data }
      
      # Retry until the resume has been parsed or it has been attempted enough times
      attempts = 0
      success = false
      while true
        soap_response = @client.call(:parse_resume, message: message)
        response = soap_response.body[:parse_resume_response][:return]
        success = response[:success]
        attempts = attempts + 1
        return response if success
        return response if attempts > Bullhorn::ResumeParsing::MAX_PARSE_ATTEMPTS or not retry_diagnostic(response[:diagnostics])
      end
    end

    private

    # Check diagnostics messages and return true if we should retry
    # http://supportforums.bullhorn.com/viewtopic.php?f=32&t=11921&st=0&sk=t&sd=a&start=15
    def retry_diagnostic(diagnostics)
       diagnostics =~ /RexStatusStr=Rex has not been initialized/
    end

  end
end