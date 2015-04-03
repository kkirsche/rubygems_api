require 'rubygems_api/utilities'
require 'hurley'
require 'json'
require 'yaml'
require 'CGI'

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

      def rubygems_total_downloads(format = 'json', args = {})
        if validate_format(format)
          response = @client.get("downloads.#{format}")
          format_body response: response, skip_format: args[:skip_format],
                      format: format
        end

        response
      end

      def gem_info(name, format = 'json', args = {})
        if validate_format(format)
          response = @client.get("gems/#{name}.#{format}")
          format_body response: response, skip_format: args[:skip_format],
                      format: format
        end

        response
      end

      def gem_search(query, format = 'json', args = { page: 1 })
        if validate_format(format)
          response = @client.get("search.#{format}", query: query, page: args[:page])
          format_body response: response, skip_format: args[:skip_format],
                      format: format
        end

        response
      end

      def my_gems(format = 'json', args = {})
        if validate_format(format)
          response = @client.get("gems.#{format}")
          format_body response: response, skip_format: args[:skip_format],
                      format: format
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

      def gem_versions(gem_name, format = 'json', args = {})
        if validate_format(format)
          response = @client.get("versions/#{gem_name}.#{format}")
          format_body response: response, skip_format: args[:skip_format],
                      format: format
        end

        response
      end

      def gem_downloads(gem_name, gem_version, format = 'json', args = {})
        if validate_format(format)
          response = @client.get("downloads/#{gem_name}-#{gem_version}.#{format}")
          format_body response: response, skip_format: args[:skip_format],
                      format: format
        end

        response
      end

      def gems_by_owner(username, format = 'json', args = {})
        if validate_format(format)
          response = @client.get("owners/#{username}/gems.#{format}")
          format_body response: response, skip_format: args[:skip_format],
                      format: format
        end

        response
      end

      def gem_owners(gem_name, format = 'json', args = {})
        if validate_format(format)
          response = @client.get("gems/#{gem_name}/owners.#{format}")
          format_body response: response, skip_format: args[:skip_format],
                      format: format
        end

        response
      end

      def add_gem_owner(gem_name, email, args = {})
        response = @client.post("gems/#{gem_name}/owners",
                               email: email)
      end

      def remove_gem_owner(gem_name, email, args = {})
        response = @client.delete("gems/#{gem_name}/owners",
                               email: email)
      end

      def view_webhooks(format = 'json', args = {})
        if validate_format(format)
          response = @client.get("web_hooks.#{format}")
          format_body response: response, skip_format: args[:skip_format],
                      format: format
        end

        response
      end

      def register_webhook(gem_name, url, args = {})
        response = @client.post("web_hooks", gem_name: gem_name,
                                             url: url)
      end

      def remove_webhook(gem_name, url, args = {})
        response = @client.delete("web_hooks/remove",
                                  gem_name: gem_name, url: url)
      end

      def fire_webhook(gem_name, url, args = {})
        response = @client.post("web_hooks/fire",
                                  gem_name: gem_name, url: url)
      end

      def latest_activity(format = 'json', args = {})
        if validate_format(format)
          response = @client.get("activity/latest.#{format}")
          format_body response: response, skip_format: args[:skip_format],
                      format: format
        end

        response
      end

      def just_updated(format = 'json', args = {})
        if validate_format(format)
          response = @client.get("activity/just_updated.#{format}")
          format_body response: response, skip_format: args[:skip_format],
                      format: format
        end

        response
      end

      def set_api_key(username, password, format = 'json', args = {})
        if validate_format(format)
          auth = CGI.escape(username + ':' + password)
          response = @client.get("https://kev.kirsche%40gmail.com:843.cBYcaAWFtZ.%3EAxscU79P%2FLF7*%3Ejtw%3FaJ.o969CH%3B%259CAyF@rubygems.org/api/v1/api_key.#{format}") do |req|
            puts 'Username: ' + req.url.user + "\n"
            puts 'Password: ' + req.url.password + "\n"
            puts 'URL: '
            puts req.url.basic_auth
          end

          format_body response: response, skip_format: args[:skip_format],
                      format: format
        end

        api_key(response.body[:rubygems_api_key])

        response
      end
    end
  end
end
