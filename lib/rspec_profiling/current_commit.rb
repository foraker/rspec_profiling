require "time"

module RspecProfiling
  module CurrentCommit
    extend self

    def version_control
      `[ -d .git/svn  ] && [ x != x"$(ls -A .git/svn/)" ]`
      return :git_svn if $CHILD_STATUS.success?

      `git rev-parse 2>&1`
      return :git if $CHILD_STATUS.success?

      :svn
    end

    def sha
      case version_control
      when :git
        `git rev-parse HEAD`
      when :svn
        `svn info -r 'HEAD' | grep "Revision" | cut -f2 -d' '`
      when :git_svn
        `git svn info | grep "Revision" | cut -f2 -d' '`
      end
    end

    def time
      case version_control
      when :git
        Time.parse `git show -s --format=%ci #{sha}`
      when :svn
        Time.parse `svn info -r 'HEAD' | grep "Last Changed Date" | cut -f4,5,6 -d' '`
      when :git_svn
        Time.parse `git svn info | grep "Last Changed Date" | cut -f4,5,6 -d' '`
      end
    end
  end
end
