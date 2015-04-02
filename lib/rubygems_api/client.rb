require 'rubygems_api/utilities'
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

      def rubygems_total_downloads(format = 'json')
        if validate_format(format)
          response = @client.get("downloads.#{format}")
          response = format_json_body(response) if format == 'json'
          response = format_yaml_body(response) if format == 'yaml'
        end

        response
      end

      def gem_info(name, format = 'json')
        if validate_format(format)
          response = @client.get("gems/#{name}.#{format}")
          response = format_json_body(response) if format == 'json'
          response = format_yaml_body(response) if format == 'yaml'
        end

        response
      end

      def gem_search(query, format = 'json', args = { page: 1 })
        if validate_format(format)
          response = @client.get("search.#{format}", query: query, page: args[:page])
          unless args[:skip_format]
            response = format_json_body(response) if format == 'json'
            response = format_yaml_body(response) if format == 'yaml'
          end
        end

        response
      end

      def my_gems(format = 'json', args = {})
        if validate_format(format)
          response = @client.get("gems.#{format}")
          unless args[:skip_format]
            response = format_json_body(response) if format == 'json'
            response = format_yaml_body(response) if format == 'yaml'
          end
        end

        response
      end

      def submit_gem(gem_file)
        response = @client.post("gems",
          file: Hurley::UploadIO.new(gem_file.read, 'application/octet-stream'))

        response
      end

      def yank_gem(gem_name, gem_version = nil, args = {})
        response = @client.delete("gems/yank", {}.tap do |hash|
          hash[:gem_name] = gem_name
          hash[:gem_version] = gem_version unless gem_version.nil?
          hash[:platform] = args[:platform] unless args[:platform].nil?
        end)

        response
      end

      def unyank_gem(gem_name, gem_version = nil, args = {})
        response = @client.put("gems/unyank", {}.tap do |hash|
          hash[:gem_name] = gem_name
          hash[:gem_version] = gem_version unless gem_version.nil?
          hash[:platform] = args[:platform] unless args[:platform].nil?
        end)

        response
      end

      def gem_versions(gem_name, format = 'json')
        if validate_format(format)
          response = @client.get("versions/#{gem_name}.#{format}")
          response = format_json_body(response) if format == 'json'
          response = format_yaml_body(response) if format == 'yaml'
        end

        response
      end

      def gem_downloads(gem_name, gem_version, format = 'json')
        if validate_format(format)
          response = @client.get("downloads/#{gem_name}-#{gem_version}.#{format}")
          response = format_json_body(response) if format == 'json'
          response = format_yaml_body(response) if format == 'yaml'
        end

        response
      end
    end
  end
end
