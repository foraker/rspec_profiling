require 'time'

module RspecProfiling
  module VCS
    class Git
      def branch
        `git rev-parse --abbrev-ref HEAD`.chomp
      end

      def sha
        `git rev-parse HEAD`.chomp
      end

      def time
        Time.parse `git show -s --format=%ci #{sha}`.chomp
      end
    end
  end
end
