require 'rubygems_api/utilities'
require 'hurley'
require 'json'
require 'yaml'
require 'cgi'

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
        @client.request_options.redirection_limit = 10

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

      def get(url, format, hash, args = {})
        if validate_format format
          response = @client.get(url, hash)

          format_body response: response, skip_format: args[:skip_format],
                      format: format if response.success?
        end

        response
      end

      def yank_api(url, method_symbol, gem_name, gem_version, args = {})
        response = @client.method(method_symbol).call(url, {}.tap do |hash|
          hash[:gem_name] = gem_name
          hash[:gem_version] = gem_version unless gem_version.nil?
          hash[:platform] = args[:platform] unless args[:platform].nil?
        end)

        response
      end

      def rubygems_total_downloads(format = 'json', args = {})
        get("downloads.#{format}", format, nil, args)
      end

      def gem_info(name, format = 'json', args = {})
        get("gems/#{name}.#{format}", format, nil, args)
      end

      def gem_search(query, format = 'json', args = { page: 1 })
        get("search.#{format}", format, { query: query, page: args[:page] }, args)
      end

      def my_gems(format = 'json', args = {})
        get("gems.#{format}", format, nil, args)
      end

      def submit_gem(gem_file)
        response = @client.post("gems",
          file: Hurley::UploadIO.new(gem_file.read, 'application/octet-stream'))

        response
      end

      def yank_gem(gem_name, gem_version = nil, args = {})
        yank_api('gems/yank', :delete, gem_name, gem_version, args)
      end

      def unyank_gem(gem_name, gem_version = nil, args = {})
        yank_api('gems/unyank', :put, gem_name, gem_version, args)
      end

      def gem_versions(gem_name, format = 'json', args = {})
        get("versions/#{gem_name}.#{format}", format, nil, args)
      end

      def gem_downloads(gem_name, gem_version, format = 'json', args = {})
        get("downloads/#{gem_name}-#{gem_version}.#{format}", format, nil, args)
      end

      def gems_by_owner(username, format = 'json', args = {})
        get("owners/#{username}/gems.#{format}", format, nil, args)
      end

      def gem_owners(gem_name, format = 'json', args = {})
        get("gems/#{gem_name}/owners.#{format}", format, nil, args)
      end

      def add_gem_owner(gem_name, email, args = {})
        @client.post("gems/#{gem_name}/owners", email: email)
      end

      def remove_gem_owner(gem_name, email, args = {})
        @client.delete("gems/#{gem_name}/owners", email: email)
      end

      def view_webhooks(format = 'json', args = {})
        get("web_hooks.#{format}", format, nil, args)
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
        get("activity/latest.#{format}", format, nil, args)
      end

      def just_updated(format = 'json', args = {})
        get("activity/just_updated.#{format}", format, nil, args)
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

      def gem_dependencies(args = [])
        response = @client.get('dependencies', {}.tap do |hash|
          args = Array.new(1, args) if args.is_a? String
          hash[:gems] = args.join(',')
        end)

        response.body = Marshal.load(response.body)

        response
      end
    end
  end
end
