Hexx::Entities
==============

[![Gem Version](https://img.shields.io/gem/v/hexx-entities.svg?style=flat)][gem]
[![Build Status](https://img.shields.io/travis/nepalez/hexx-entities/master.svg?style=flat)][travis]
[![Dependency Status](https://img.shields.io/gemnasium/nepalez/hexx-entities.svg?style=flat)][gemnasium]
[![Code Climate](https://img.shields.io/codeclimate/github/nepalez/hexx-entities.svg?style=flat)][codeclimate]
[![Coverage](https://img.shields.io/coveralls/nepalez/hexx-entities.svg?style=flat)][coveralls]
[![Inline docs](http://inch-ci.org/github/nepalez/hexx-entities.svg)][inch]
[![Documentation Status](https://readthedocs.org/projects/hexx-entities/badge/?version=latest)][readthedocs]

[codeclimate]: https://codeclimate.com/github/nepalez/hexx-entities
[coveralls]: https://coveralls.io/r/nepalez/hexx-entities
[gem]: https://rubygems.org/gems/hexx-entities
[gemnasium]: https://gemnasium.com/nepalez/hexx-entities
[inch]: https://inch-ci.org/github/nepalez/hexx-entities
[readthedocs]: https://hexx-entities.readthedocs.org
[travis]: https://travis-ci.org/nepalez/hexx-entities

Base class for domain entities:

* [synopsis](#synopsis)
* [istallation](#istallation)
* [usage](#usage)
* [compatibility](#compatibility)
* [contributing](#contributing)
* [license](#license)

Check the documentation at [Read the Docs]

Synopsis
--------

The [entity] describes (immutable) domain objects that have identity.

When descibing an entity you are expected to declare its attributes and
validations in the following way:

```ruby
require "hexx-entities"

class Item < Hexx::Entities::Base

  # Defines attributes with their coercers
  attribute :foo, coerce: ->(value) { value.to_s }
  attribute :bar

  # Defines validation for the entity
  validate { invalid :blank_foo unless foo }
  validate { invalid :blank_bar unless bar }

end # class Item

item = Item.new foo: 1

item.frozen?
# => true
item.attributes
# => { uuids: ["31a840f4-71e2-4de1-3a6f-04d2103aa2e8"], foo: "1", bar: nil }
item.validate!
# <Attestor::InvalidError> because bar is nil
```

To model parts of aggregate entities, that have no identity by themselves,
use `Hexx::Entitites::Part`. The part is just the entity without `uuids`.

Installation
------------

Add this line to your application's Gemfile:

```ruby
# Gemfile
gem "hexx-entities"
```

Then execute:

```
bundle
```

Or add it manually:

```
gem install hexx-entities
```

Usage
-----

* [entity declaration](#declaration)
* [identity and equality](#identity-and-equality)
* [attributes and their initializer](#attributes-and-their-initializer)
* [validation](#validation)
* [serialization](#serialization)

### Entity Declaration

Define the entity as a subclass of `Hexx::Entities::Base`:

```ruby
class Item < Hexx::Entities::Base
end
```

### Identity and Equality

An entity is identified by its [uuids]. Uuids are either initialized,
or assigned by default:

[uuid]: https://en.wikipedia.org/wiki/Universally_unique_identifier

```ruby
entity = Item.new
entity.uuids # => ["31a840f4-71e2-4de1-3a6f-04d2103aa2e8"]
```

The entity is equal to any entity that responds to `uuids` and 
has at least one uuid, that is equal to its own:

```ruby
a = Item.new uuids: [
  "31a840f4-71e2-4de1-3a6f-04d2103aa2e8", # this value...
  "78340523-8928-1ab0-0a3f-fa9eb07a7986"
]

b = Hexx::Entities::Base.new uuids: [
  "9875023e-f483-cef9-ae09-27384015de79",
  "31a840f4-71e2-4de1-3a6f-04d2103aa2e8"  # ...is equal to this one
]

a == b # => true
```

Any uuid in the list is an instance of `Hexx::Entities::UUID` (kind of string).
The instance is validatable:

```ruby
uuid = Hexx::Entities::UUID.new "9875023e-f483-cef9-ae09-27384015de79"
# => "9875023e-f483-cef9-ae09-27384015de79"
uuid.validate! # passes

uuid = Hexx::Entities::UUID.new "not a valid uuid"
# => "not a valid uuid"
uuid.validate! # <Attestor::InvalidError>
```

### Attributes and their Initializer

The gem uses the [eigindir] library for attributes definition and coersion.
The `uuids` attribute is added by default.

All attributes can be initialized from hash:

```ruby
class Foo < Hexx::Entities::Base

  attribute :bar
  attribute :baz, coerce: ->(value) { value.to_s }

end

foo = Foo.new bar: :bar, "baz" => :baz
foo.attributes
# => { uuids: ["9875023e-f483-cef9-ae09-27384015de79"], bar: :bar, baz: "baz" }
```

[eigindir]: https://github.com/nepalez/eigindir

### Validation

The gem uses the [attestor] library for validation. Any entity is
a validatable object and responds to `#validate` and `#validate!` instance
methods.

Validation rules should be defined on class level with `.validate` helper,
or with the help of externam policy objects by `.validates` (with s) method:

```ruby
class Foo < Hexx::Entities::Base

  attribute :bar
  attribute :baz, coerce: ->(value) { Baz.new value }

  validate { invalid :blank_bar unless bar }
  # providing Baz responds to #validate! delegates validations:
  validates :baz

end
```

Any enitiy is invalid when any of its uuids is invalid:

```ruby
Foo = Class.new Hexx::Entities::Base
foo = Foo.new uuids: ["invalid uuid"]
foo.validate! # <Attestor::InvalidError>
```

This is the only validation rule that is added to entity by default.

### Serialization

Entities can be converted to nested hash by the `serialize` method.
Any attribute is serialized recursively if it responds to `serialize` without
arguments:

```ruby
class Foo < Hexx::Entities::Base

  attribute :bar, coerce: ->(value) { value.to_f }
  attribute :baz, coerce: ->(value) { value.to_s }

end

class Qux < Hexx::Entities::Base

  attribute :foo, coerce: ->(value) { Foo.new value }
  attribute :qux

end

foo = Foo.new bar: 1, baz: 1
qux = Qux.new foo: foo

qux.serialize
# {
#   uuids: ["78340523-8928-1ab0-0a3f-fa9eb07a7986"],
#   foo:   {
#     uuids: ["31a840f4-71e2-4de1-3a6f-04d2103aa2e8"],
#     bar:   1.0,
#     baz:   "1"
#   }
# }
```

**Notice** the method is not protected against looping. In cases the later is
possible, you'd better to redefine the `serialize` method by itself with
custom protection.

Compatibility
-------------

Tested under [MRI rubies 2.1+](.travis.yml).
The module heavily uses [refinements], not yet supported by Rubinius and JRuby.

Backed on libraries:
* [eigindir] for defining attributes
* [attestor] for validations

Uses [RSpec] 3.0+ for testing and [hexx-suit] for dev/test tools collection.

[refinements]: http://ruby-doc.org/core-2.1.1/doc/syntax/refinements_rdoc.html
[attestor]:    http://github.com/nepalez/attestor
[eigindir]:    http://github.com/nepalez/eigindir
[RSpec]:       http://rspec.org
[hexx-suit]:   https://github.com/nepalez/hexx-suit

Contributing
------------

* Read the [STYLEGUIDE](config/metrics/STYLEGUIDE)
* [Fork the project](https://github.com/nepalez/hexx-entities)
* Create your feature branch (`git checkout -b my-new-feature`)
* Add tests for it
* Commit your changes (`git commit -am '[UPDATE] Add some feature'`)
* Push to the branch (`git push origin my-new-feature`)
* Create a new Pull Request

License
-------

See the [MIT LICENSE](LICENSE).
