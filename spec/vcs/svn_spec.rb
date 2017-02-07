require "rspec_profiling/vcs/svn"

module RspecProfiling
  describe VCS::Svn do
    describe "#branch" do
      it "calls Git to get the current branch" do
        expect(subject.branch).to be_nil
      end
    end

    describe "#sha" do
      it "calls Git to get the current commit's SHA" do
        expect(subject).to receive(:`).with("svn info -r 'HEAD' | grep \"Revision\" | cut -f2 -d' '").and_return("abc123")
        expect(subject.sha).to eq "abc123"
      end
    end

    describe "#time" do
      it "calls Git to get the current commit's datetime" do
        expect(subject).to receive(:`).with("svn info -r 'HEAD' | grep \"Last Changed Date\" | cut -f4,5,6 -d' '").and_return("2017-01-31")
        expect(subject.time).to eq Time.parse("2017-01-31")
      end
    end
  end
end
