module Rubygems
  module API
    module Utilities
      def validate_format(format)
        return true if format == 'json' || format == 'yaml'

        raise 'Invalid format requested. Please select either json or yaml.'
      end

      def format_body(args = {})
        unless args[:skip_format]
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

      def validate_api_key(client)
        return true unless client.api_key.nil?

        raise 'No API Key set. This request requires a valid key to function.'
      end
    end
  end
end
