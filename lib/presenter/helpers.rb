class Presenter
  module Helpers
    def present name, presenter
      define_method name do
        presenter.new @presented.public_send(name)
      end
    end

    def present_collection name, presenter
      define_method name do
        @presented.public_send(name).map do |elem|
          presenter.new elem
        end
      end
    end
  end
end
