require 'time'

module RspecProfiling
  module VCS
    class GitSvn
      # returns nil if using `git svn`
      def version_control
        `[ -d .git/svn  ] && [ x != x"$(ls -A .git/svn/)" ]`
        RspecProfiling::VCS::Svn unless $CHILD_STATUS.success?
      end

      def sha
        if version_control.nil?
          `git svn info | grep "Revision" | cut -f2 -d' '`
        else
          `svn info -r 'HEAD' | grep "Revision" | cut -f2 -d' '`
        end
      end

      def time
        if version_control.nil?
          Time.parse `git svn info | grep "Last Changed Date" | cut -f4,5,6 -d' '`
        else
          Time.parse `svn info -r 'HEAD' | grep "Last Changed Date" | cut -f4,5,6 -d' '`
        end
      end
    end
  end
end
