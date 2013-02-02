require './lib/presenter'

describe Presenter do
  it "delegates methods to the presented object when they don't exist on the presenter" do
    presented = Object.new
    def presented.foo arg
      yield arg
    end
    presenter = Presenter.new presented

    presenter.foo('bar', &->(o) { o.upcase }).should == 'BAR'
  end

  it "responds to methods on the presented" do
    presented = Object.new
    def presented.foo; end
    presenter = Presenter.new presented

    presenter.respond_to?(:foo).should be_true
  end

  it "does not respond to private methods on the presenter" do
    presented = Object.new
    def presented.foo; end
    presented.singleton_class.send :private, :foo
    presenter = Presenter.new presented

    presenter.respond_to?(:foo).should be_false
  end

  it "does not delegate methods defined in the presenter which are defined on presented" do
    presented = Object.new
    def presented.foo; end
    presenter = Presenter.new presented
    def presenter.foo; end

    presented.should_not_receive :foo

    presenter.foo
  end

  it "does not delegate methods to the presented when they are not defined anywhere" do
    presented = Object.new
    presenter = Presenter.new presented

    presented.should_not_receive :foo
    def presented.respond_to? name, _ = false
      return false if name.to_sym == :foo
      super
    end

    presenter.foo
  end

  it "delegates to_s" do
    presented = Object.new
    presenter = Presenter.new presented

    presented.should_receive :to_s
    presenter.to_s
  end

  it "masquerades as an instance of the presented class" do
    presented_class = Class.new
    presented = presented_class.new
    presenter = Presenter.new presented

    presenter.instance_of?(presented_class).should be_true
    presenter.is_a?(presented_class).should be_true
    presenter.kind_of?(presented_class).should be_true
  end

  it "is equal (==) to the object it presents" do
    presented = Object.new
    presenter = Presenter.new presented

    (presenter == presented).should be_true
  end

  it "subsumps what it presents" do
    presented = Object.new
    presenter = Presenter.new presented

    (presenter === presented).should be_true
    (presenter === presenter).should be_true
    (presenter === Object.new).should be_false
  end

  describe ".present" do
    it "wraps the presented's method with the given given presenter" do
      bar = 'bar'
      bar_presenter = Class.new Presenter
      presented = Object.new
      presented.stub(:bar).and_return(bar)
      presenter_class = Class.new Presenter do
        self.present :bar, bar_presenter
      end
      presenter = presenter_class.new presented

      presenter.bar.class.should == bar_presenter
    end
  end
end
