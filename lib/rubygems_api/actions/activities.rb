module Rubygems
  module API
    # Method relating to RubyGems Activity
    module Activities
      def rubygems_total_downloads(format = 'json', args = {})
        get("downloads.#{format}", format, nil, args)
      end

      def latest_activity(format = 'json', args = {})
        get("activity/latest.#{format}", format, nil, args)
      end

      def just_updated(format = 'json', args = {})
        get("activity/just_updated.#{format}", format, nil, args)
      end
    end
  end
end
