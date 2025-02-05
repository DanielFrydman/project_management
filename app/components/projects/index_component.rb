module Projects
  class IndexComponent < ViewComponent::Base
    include StatusColorable

    def initialize(projects:)
      @projects = projects
    end

    private

    attr_reader :projects
  end
end
