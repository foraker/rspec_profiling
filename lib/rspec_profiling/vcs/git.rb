require 'time'

module RspecProfiling
  module VCS
    class Git
      def branch
        `git rev-parse --abbrev-ref HEAD`.strip
      end

      def sha
        `git rev-parse HEAD`.strip
      end

      def time
        Time.parse `git show -s --format=%ci #{sha}`.strip
      end
    end
  end
end
