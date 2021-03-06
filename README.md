# Presenter

[![Build Status](https://secure.travis-ci.org/amarshall/presenter.png)](http://travis-ci.org/amarshall/presenter)

A simple presenter.

## Why

Why not just use `SimpleDelegator` you ask? Because this was mostly an exercise. There are a few notable differences between Presenter & SimpleDelegator, though. Mostly it’s that Presenter is a bit more enthusiastic in some respects about masquerading as the presented object. For example: `o = Object.new; Presenter.new(o) == Presenter.new(o)  #=> true`, whereas SimpleDelegator would return `false`. SimpleDelegator goes a bit farther in some places than Presenter, e.g. `taint`, etc., will call `taint` on both the delegator and the delegated object, and a few other interesting extras that aren’t really useful for a presenter in the way they might be for a more general buisiness object.

## Usage

```ruby
require 'presenter'

User = Struct.new :first_name, :last_name

class UserPresenter < Presenter
  def full_name
    [first_name, last_name].join(' ')
  end
end

user = User.new 'John', 'Doe'
user_presenter = UserPresenter.new user
user_presenter.full_name  #=> "John Doe"
```

You can also easily wrap objects or collections returned by the presented object with a presenter:

```ruby
require 'presenter'

User = Struct.new :first_name, :last_name, :age, :favorite_numbers

class AgePresenter < Presenter
  def to_s
    "#{@presented} years"
  end
end

class NumberPresenter < Presenter
  def mod_3
    self % 3
  end
end

class UserPresenter < Presenter
  extend Presenter::Helpers
  present :age, AgePresenter
  present_collection :favorite_numbers, NumberPresenter
end

user = User.new 'John', 'Doe', 42, [4, 8, 15, 16, 23, 42]
user_presenter = UserPresenter.new user
user_presenter.age.to_s  #=> "42 years"
user_presenter.favorite_numbers.map(&:mod_3)  #=> [1, 2, 0, 1, 2, 0]
```

## Contributing

Contributions are welcome. Please be sure that your pull requests are atomic so they can be considered and accepted separately.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Credits & License

Copyright © 2013 J. Andrew Marshall. License is available in the LICENSE file.
