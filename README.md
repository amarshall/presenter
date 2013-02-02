# Presenter

A simple presenter.

## Usage

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

## Contributing

Contributions are welcome. Please be sure that your pull requests are atomic so they can be considered and accepted separately.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Credits & License

Copyright © 2013 J. Andrew Marshall. License is available in the LICENSE file.
