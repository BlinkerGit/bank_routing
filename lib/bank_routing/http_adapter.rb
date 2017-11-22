# frozen_string_literal: true

require 'typhoeus'

class RoutingNumber
  class HttpAdapter
    attr_reader :options

    def initialize(options)
      @options = options
    end

    def fetch_routing_directory
      response = Typhoeus::Request.post(
        options[:routing_data_agreement_url],
        body: 'agreementValue=Agree'
      )
      session_id = response.headers['Set-Cookie']&.match(/JSESSIONID=.*?;/)

      if session_id
        Typhoeus::Request.get(
          options[:routing_data_url],
          ssl_verifypeer: false,
          headers: { 'Cookie' => "abaDataCaptureCookie=abaDataCaptureCookie; #{session_id.to_s}" }
        ).body
      end
    end
  end
end
