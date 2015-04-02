module Rubygems
  module API
    class Gems
      include Rubygems::API::Utilities
      attr_accessor :client
      def initialize(client)
        @client ||= client
      end

      def info(name, format = 'json')
        if validate_format(format)
          response = @client.get("gems/#{name}.#{format}")
          response = format_json_body(response) if format == 'json'
          response = format_yaml_body(response) if format == 'yaml'
        end

        response
      end

      def search(query, format = 'json', args = { page: 1 })
        if validate_format(format)
          response = @client.get("search.#{format}", query: query, page: args[:page])
          unless args[:skip_format]
            response = format_json_body(response) if format == 'json'
            response = format_yaml_body(response) if format == 'yaml'
          end
        end

        response
      end

      def mine(format = 'json', args = {})
        if validate_format(format)
          response = @client.get("gems.#{format}")
          unless args[:skip_format]
            response = format_json_body(response) if format == 'json'
            response = format_yaml_body(response) if format == 'yaml'
          end
        end

        response
      end

      def submit(gem_file)
        response = @client.post("gems",
          file: Hurley::UploadIO.new(gem_file.read, 'application/octet-stream'))

        response
      end

      def yank(gem_name, gem_version = nil, args = {})
        response = @client.delete("gems/yank", {}.tap do |hash|
          hash[:gem_name] = gem_name
          hash[:gem_version] = gem_version unless gem_version.nil?
          hash[:platform] = args[:platform] unless args[:platform].nil?
        end)

        response
      end

      def unyank(gem_name, gem_version = nil, args = {})
        response = @client.put("gems/unyank", {}.tap do |hash|
          hash[:gem_name] = gem_name
          hash[:gem_version] = gem_version unless gem_version.nil?
          hash[:platform] = args[:platform] unless args[:platform].nil?
        end)

        response
      end

      def versions(gem_name, format = 'json')
        if validate_format(format)
          response = @client.get("versions/#{gem_name}.#{format}")
          response = format_json_body(response) if format == 'json'
          response = format_yaml_body(response) if format == 'yaml'
        end

        response
      end

      def downloads(gem_name, gem_version, format = 'json')
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