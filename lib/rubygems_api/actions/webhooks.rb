module Rubygems
  module API
    # Method relating to RubyGems Webhooks
    module Webhooks
      def view_webhooks(format = 'json', args = {})
        get("web_hooks.#{format}", format, nil, args)
      end

      def register_webhook(gem_name, url)
        @client.post('web_hooks', gem_name: gem_name,
                                  url: url)
      end

      def remove_webhook(gem_name, url)
        @client.delete('web_hooks/remove', gem_name: gem_name, url: url)
      end

      def fire_webhook(gem_name, url)
        @client.post('web_hooks/fire', gem_name: gem_name, url: url)
      end
    end
  end
end
