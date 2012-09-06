class Issue
  attr_reader :comments

  def initialize(github, number)
    @github = github
    @number = number
    @issue = @github.issues.get(@github.user, @github.repo, number) or raise "Couldn't find issue for task #{number}"
    @comments = @github.issues.comments.all(@github.user, @github.repo, number)
  end
end
