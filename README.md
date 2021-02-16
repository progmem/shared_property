# SharedProperty

Short explanation: share a `Value` between two objects! Keep this `Value` in sync between two objects!

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     shared_property:
       github: progmem/shared_property
   ```

2. Run `shards install`

## Usage

```crystal
require "shared_property"
```

In a class you would like to share values with, include the following:

```crystal
class MyClass
  include SharedProperty

  ...
end
```

Properties can be declared with the following, explcitly declaring the **instance variable name**, the **class**, and the **initial value**. For example:

```crystal
class MyClass
  include SharedProperty

  shared_property my_value, Int32, 0

  ...
end
```

Instances can then be asked to share properties with the same name. This can be done across all shared properties like so:

```crystal
# Two new instances...
m1 = MyClass.new #=> #<MyClass:0x1056afb80 ... >
m2 = MyClass.new #=> #<MyClass:0x1056af6c0 ... >

# Assign some values
m1.my_value = 20 #=> 20 : Int32
m2.my_value = 40 #=> 40 : Int32

# Tell the first to reference the second
m1.references m2 #=> [:my_value] : Array(Symbol)

# Read the value from m1, which references m2...
m1.my_value      #=> 20 : Int32
# ...and even modify m1 and read the change from m2!
m1.my_value *= 40
m2.my_value      # => 1600 : Int32
```

Alternatively, references can be shared individually by using `references_{{name}}_from`, replacing `{{name}}` with the name of the instance variable:

```crystal
m1 = MyClass.new #=> #<MyClass:0x1056afb80 ... >
m2 = MyClass.new #=> #<MyClass:0x1056af6c0 ... >

...

# Tell the first to reference only a specific shared property
m1.references_my_value_from m2 #=> true : Bool
```

If you wish to assign a value as part of `initialize`, you will need to assign to a temporary variable for the time being:

```crystal
def initialize(value : Int32)
  @my_value.value = value
end
```
