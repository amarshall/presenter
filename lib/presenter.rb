require 'presenter/version'

class Presenter
  def self.present name, presenter
    define_method name do
      presenter.new @presented.public_send(name)
    end
  end

  def self.present_collection name, presenter
    define_method name do
      @presented.public_send(name).map do |elem|
        presenter.new elem
      end
    end
  end

  def initialize presented
    @presented = presented
  end

  def method_missing name, *args, &block
    super unless respond_to_missing? name
    @presented.public_send name, *args, &block
  end

  def respond_to_missing? name, include_private = false
    @presented.respond_to? name, include_private
  end

  def public_methods
    super | @presented.public_methods
  end

  def == other
    @presented == other || super
  end

  def === other
    @presented == other || super
  end

  def instance_of? klass
    @presented.instance_of?(klass) || super
  end

  def is_a? klass
    @presented.is_a?(klass) || super
  end
  alias kind_of? is_a?

  undef to_param if instance_methods.include? :to_param
  undef to_s
end
