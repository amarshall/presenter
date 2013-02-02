require './lib/presenter'

describe Presenter do
  describe "delegating" do
    it "delegates methods to the presented object when they don't exist on the presenter" do
      presented = Object.new
      def presented.foo arg
        yield arg
      end
      presenter = Presenter.new presented

      presenter.foo('bar', &->(o) { o.upcase }).should == 'BAR'
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
  end

  describe "responding" do
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

  it "subsumps what it presents, and itself" do
    presented = Object.new
    presenter = Presenter.new presented

    (presenter === presented).should be_true
    (presenter === presenter).should be_true
    (presenter === Object.new).should be_false
  end

  describe "#public_methods" do
    it "includes all public methods of the presented object" do
      presented = Object.new
      def presented.foo; end
      presenter = Presenter.new presented

      presenter.public_methods.should include :foo
    end
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

  describe ".present_collection" do
    it "maps the presented's collection with the given presenter" do
      collection = %w[a b c]
      collection_presenter = Class.new Presenter
      presented = Object.new
      presented.stub(:bars).and_return(collection)
      presenter_class = Class.new Presenter do
        self.present_collection :bars, collection_presenter
      end
      presenter = presenter_class.new presented

      presenter.bars.map(&:class).uniq.should == [collection_presenter]
    end
  end

  describe "basic example in the readme" do
    after do
      Object.send :remove_const, :User
      Object.send :remove_const, :UserPresenter
    end

    it "works" do
      User = Struct.new :first_name, :last_name

      class UserPresenter < Presenter
        def full_name
          [first_name, last_name].join(' ')
        end
      end

      user = User.new 'John', 'Doe'
      user_presenter = UserPresenter.new user
      user_presenter.full_name.should == "John Doe"
    end
  end
end
