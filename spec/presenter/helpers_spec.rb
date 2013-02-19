require './lib/presenter'
require './lib/presenter/helpers'

describe Presenter::Helpers do
  describe "#present" do
    it "wraps the presented's method with the given given presenter" do
      bar = 'bar'
      bar_presenter = Class.new Presenter
      presented = Object.new
      presented.stub(:bar).and_return(bar)
      presenter_class = Class.new Presenter do
        extend Presenter::Helpers
        self.present :bar, bar_presenter
      end
      presenter = presenter_class.new presented

      presenter.bar.class.should == bar_presenter
    end
  end

  describe "#present_collection" do
    it "maps the presented's collection with the given presenter" do
      collection = %w[a b c]
      bar_presenter = Class.new Presenter
      presented = Object.new
      presented.stub(:bars).and_return(collection)
      presenter_class = Class.new Presenter do
        extend Presenter::Helpers
        self.present_collection :bars, bar_presenter
      end
      presenter = presenter_class.new presented
      presenter.bars.map(&:class).uniq.should == [bar_presenter]
    end
  end
end
