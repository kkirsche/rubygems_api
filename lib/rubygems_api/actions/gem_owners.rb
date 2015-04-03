module Rubygems
  module API
    # Method relating to gem ownership
    module GemOwners
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
    end
  end
end