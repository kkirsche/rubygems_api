module Rubygems
  module API
    # The Utilities module allows us to use the same functions throughout
    module Utilities
      def validate_format(format)
        return true if format == 'json' || format == 'yaml'

        raise 'Invalid format requested. Please select either json or yaml.'
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
    end
  end
end
