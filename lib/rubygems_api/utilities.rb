module Rubygems
  module API
    module Utilities
      def validate_format(format)
        return true if format == 'json' || format == 'yaml'

        raise 'Invalid format requested. Please select either json or yaml.'
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
