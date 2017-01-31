require "rspec_profiling/vcs/git"

module RspecProfiling
  describe VCS::Git do
    describe "#branch" do
      it "calls Git to get the current branch" do
        expect(subject).to receive(:`).with("git rev-parse --abbrev-ref HEAD").and_return("master")
        expect(subject.branch).to eq "master"
      end
    end

    describe "#sha" do
      it "calls Git to get the current commit's SHA" do
        expect(subject).to receive(:`).with("git rev-parse HEAD").and_return("abc123")
        expect(subject.sha).to eq "abc123"
      end
    end

    describe "#time" do
      it "calls Git to get the current commit's datetime" do
        expect(subject).to receive(:`).with("git rev-parse HEAD").and_return("abc123")
        expect(subject).to receive(:`).with("git show -s --format=%ci abc123").and_return("2017-01-31")
        expect(subject.time).to eq Time.parse("2017-01-31")
      end
    end
  end
end
