module Rubygems
  module API
    class Gems_Versions
      include Rubygems::API::Utilities
      attr_accessor :client
      def initialize(client)
        @client ||= client
      end

      def info(gem_name, format = 'json')
        if validate_format(format)
          response = @client.get("gems/#{gem_name}.#{format}")
          response = format_json_body(response) if format == 'json'
          response = format_yaml_body(response) if format == 'yaml'
        end

        response
      end
    end
  end
end