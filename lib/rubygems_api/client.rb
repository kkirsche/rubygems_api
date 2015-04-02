require 'rubygems_api/utilities'
require 'rubygems_api/actions/gems'
require 'hurley'
require 'json'
require 'yaml'

module Rubygems
  module API
    class Client
      include Rubygems::API::Utilities
      attr_accessor :client, :api_key

      def initialize(arguments = {})
        @api_key ||= arguments[:api_key] || \
                     nil

        @host = 'https://rubygems.org/'
        @api_endpoint = '/api/v1'

        @client = Hurley::Client.new 'https://rubygems.org/api/v1/'
        ssl(arguments)

        @client.header[:Authorization] = @api_key unless @api_key.nil?

        @client
      end

      def ssl(arguments)
        @skip_verification = arguments[:skip_verification] || \
                      true

        @ca_path = arguments[:ca_path]  || \
                   `openssl version -d`.split(/"/)[1] + '/certs'

        @ssl_version = arguments[:ssl_version]  || \
                       'SSLv23'

        @client.ssl_options.skip_verification = @skip_verification
        @client.ssl_options.ca_path = @ca_path
        @client.ssl_options.version = @ssl_version
      end

      def api_key(key = nil)
        @api_key = key unless key.nil?
        @client.header[:Authorization] = @api_key unless @api_key.nil?

        @api_key
      end

      def total_downloads(format = 'json')
        if validate_format(format)
          response = @client.get("downloads.#{format}")
          response = format_json_body(response) if format == 'json'
          response = format_yaml_body(response) if format == 'yaml'
        end

        response
      end

      def gems
        @gems ||= Rubygems::API::Gems.new @client
      end

      def gem_versions
        @gem_versions ||= Rubygems::API::Gems_Versions.new @client
      end
    end
  end
end
