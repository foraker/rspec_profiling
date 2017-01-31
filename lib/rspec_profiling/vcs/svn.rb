require 'time'

module RspecProfiling
  module VCS
    class Svn
      def branch
        nil
      end

      def sha
        `svn info -r 'HEAD' | grep "Revision" | cut -f2 -d' '`
      end

      def time
        Time.parse `svn info -r 'HEAD' | grep "Last Changed Date" | cut -f4,5,6 -d' '`
      end
    end
  end
end
