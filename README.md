# Welcome to Vines

Vines is a scalable XMPP chat server, using EventMachine for asynchronous IO.
This gem provides support for storing user data in SQL databases with Active
Record.

Additional documentation can be found at [getvines.org](http://www.getvines.org/).

## Usage

```
$ gem install vines vines-sql
$ vines init wonderland.lit
$ cd wonderland.lit && vines start
```

## Configuration

Add the following configuration block to a virtual host definition in
the server's `conf/config.rb` file.

```ruby
storage 'sql' do
  adapter 'postgresql'
  host 'localhost'
  port 5432
  database 'xmpp'
  username ''
  password ''
  pool 5
end
```

## Dependencies

Vines requires Ruby 1.9.3 or better. Instructions for installing the
needed OS packages, as well as Ruby itself, are available at
[getvines.org/ruby](http://www.getvines.org/ruby).

## Development

```
$ script/bootstrap
$ script/tests
```

## Contact

* David Graham <david@negativecode.com>

## License

Vines is released under the MIT license. Check the LICENSE file for details.
