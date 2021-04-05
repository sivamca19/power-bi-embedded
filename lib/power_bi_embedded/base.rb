require 'base64'
require 'json'
require 'httparty'
require 'net/http'

module PowerBiEmbedded
  class Base

    def self.get(endpoint, query = nil, headers = nil)
      response = HTTParty.get(endpoint, headers: headers, query: query)
      parse_response(response)
    end

    def self.post(endpoint, body = nil, headers = nil)
      if(endpoint.include?('GenerateToken'))
        uri = URI.parse(endpoint)
        request = Net::HTTP::Post.new(uri)
        request.content_type = "application/json"
        request.body = body.to_json

        request["Authorization"] = headers[:Authorization]

        req_options = {
          use_ssl: uri.scheme == "https",
        }

        res = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
          http.request(request)
        end
        return JSON.parse(res.body)
      else
        response = HTTParty.post(endpoint, headers: headers, body: body)
        parse_response(response)
      end
    end

    def self.put(endpoint, body = nil, headers = nil)
      response = HTTParty.put(endpoint, headers: headers, body: body)
      parse_response(response)
    end

    def self.delete(endpoint, headers = nil)
      response = HTTParty.delete(endpoint, headers: headers)
      parse_response(response)
    end

    def self.parse_response(response)
      response.parsed_response&.deep_symbolize_keys
    end

  end
end
