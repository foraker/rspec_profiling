require "time"

module RspecProfiling
  module CurrentCommit
    extend self

    def git?
      `git rev-parse 2>&1`
      $?.success?
    end

    def sha
      if git?
        `git rev-parse HEAD`
      else
        `svn info -r 'HEAD' | grep "Revision" | cut -f2 -d' '`
      end
    end

    def time
      if git?
        Time.parse `git show -s --format=%ci #{sha}`
      else
        Time.parse `svn info -r 'HEAD' | grep "Last Changed Date" | cut -f4,5,6 -d' '`
      end
    end
  end
end
