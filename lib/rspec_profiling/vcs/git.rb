require 'time'

module RspecProfiling
  module VCS
    class Git
      def branch
        `git rev-parse --abbrev-ref HEAD`
      end

      def sha
        `git rev-parse HEAD`
      end

      def time
        Time.parse `git show -s --format=%ci #{sha}`
      end
    end
  end
end
