require 'rubygems_api/utilities'
require 'rubygems_api/actions/activities'
require 'rubygems_api/actions/gem_owners'
require 'rubygems_api/actions/gems'
require 'rubygems_api/actions/webhooks'
require 'hurley'
require 'json'
require 'yaml'
require 'cgi'

module Rubygems
  module API
    class Client
      include Rubygems::API::Utilities
      include Rubygems::API::Activities
      include Rubygems::API::GemOwners
      include Rubygems::API::Gems
      include Rubygems::API::Webhooks
      attr_accessor :client, :api_key

      def initialize(arguments = {})
        @api_key ||= arguments[:api_key] || \
                     nil

        @host = 'https://rubygems.org/'
        @api_endpoint = '/api/v1'

        @client = Hurley::Client.new 'https://rubygems.org/api/v1/'
        ssl(arguments)
        @client.request_options.redirection_limit = 10

        @client.header[:Authorization] = @api_key unless @api_key.nil?

        @client
      end

      def api_key(key = nil)
        @api_key = key unless key.nil?
        @client.header[:Authorization] = @api_key unless @api_key.nil?

        @api_key
      end

      def set_api_key(username, password, format = 'json', args = {})
        creds = CGI.escape(username) + ':' + CGI.escape(password)
        if validate_format(format)
          response = @client.get("https://#{creds}@rubygems.org/api/v1/api_key.#{format}") do |req|
            req.header[:Authorization] = req.url.basic_auth.gsub!(/(\n|\r|\t)+/, '')
          end

          if response.success?
            format_body response: response, skip_format: args[:skip_format],
                        format: format

            api_key(response.body['rubygems_api_key'])
          end
        end

        response
      end
    end
  end
end
