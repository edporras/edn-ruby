# edn-ruby

**edn-ruby** is a Ruby library to read and write [edn][edn] (extensible data notation), a subset of Clojure used for transferring data between applications, much like JSON, YAML, or XML.

## Installation

Add this line to your application's Gemfile:

    gem 'edn'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install edn

## Usage

To read a string of **edn**:

```ruby
EDN.read("[1 2 {:foo \"bar\"}]")
```

To convert a data structure to an **edn** string:

```ruby
data.to_edn
```

By default, this will work for strings, symbols, numbers, arrays, hashes, sets, nil, Time, and boolean values.

### Tagged Values

The interesting part of **edn** is the _extensible_ part. Data can be be _tagged_ to coerce interpretation of it to a particular data type. An example of a tagged data element:

```
#wolf/pack {:alpha "Greybeard" :betas ["Frostpaw" "Blackwind" "Bloodjaw"]}
```

The tag (`#wolf/pack`) will tell any consumers of this data to use a data type registered to handle `wolf/pack` to represent this data.

The rules for tags from the [**edn** README][README] should be followed. In short, custom tags should have a prefix (the part before the `/`) designating the user that created them or context they are used in. Non-prefixed tags are reserved for built-in tags.

There are two tags built in by default: `#uuid`, used for UUIDs, and `#inst`, used for an instant in time. In `edn-ruby`, `#inst` is converted to a Time, and Time values are tagged as `#inst`. There is not a UUID data type built into Ruby, so `#uuid` is converted to a string, but if you require `edn/uuid`, `#uuid` values are converted to an instance of `EDN::UUID`.

Tags that are not registered are converted as their base data type and a warning will be shown.

### Registering a New Tag For Reading

To register a tag for reading, call the method `EDN.register` with a tag and one of the following:

- A block that accepts data and returns a value.
- A lambda that accepts data and returns a value.
- A class that has an `initialize` method that accepts data.

Examples:

```ruby
EDN.register("clinton/uri") do |uri|
  URI(uri)
end

EDN.register("clinton/date", lambda { |date_array| Date.new(*date_array) }

class Dog
  def initialize(name)
    @name = name
  end
end

EDN.register("clinton/dog", Dog)
```

### Writing Tags

Writing tags should be done as part of the class's `.to_edn` method, like so:

```ruby
class Dog
  def to_edn
    ["#clinton/dog", @name.to_edn].join(" ")
  end
end
```

`EDN` provides a helper method, `EDN.tagout`:

```ruby
class Dog
  def to_edn
    EDN.tagout("clinton/dog", @name)
  end
end
```

This method calls `.to_edn` on the second argument and joins the arguments appropriately.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


[edn]: https://github.com/richhickey/edn
[README]: https://github.com/richhickey/edn/blob/master/README.md