module Rubygems
  module API
    # Method relating to gem ownership
    module Gems
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
        @client.post(
          'gems',
          file: Hurley::UploadIO.new(gem_file.read, 'application/octet-stream'))
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
