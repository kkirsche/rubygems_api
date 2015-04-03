module Rubygems
  module API
    # The Utilities module allows us to use the same functions throughout
    module Utilities
      def validate_format(format)
        return true if format == 'json' || format == 'yaml'

        fail RuntimeError,
             'Invalid format requested. Please select either json or yaml.'
      end

      def format_body(args = {})
        if args[:skip_format].nil?
          response = format_json_body(args[:response]) if args[:format] == 'json'
          response = format_yaml_body(args[:response]) if args[:format] == 'yaml'
        end

        response
      end

      def format_json_body(response)
        response.body = JSON.parse(response.body)

        response
      end

      def format_yaml_body(response)
        response.body = YAML.load(response.body)

        response
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
    end
  end
end
