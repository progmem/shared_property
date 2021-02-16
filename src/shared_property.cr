module SharedProperty
  VERSION = "0.1.0"
  
  # A QρValue exists solely as a wrapper class for a given type.
  # Classes can be passed as references.
  private class QρValue(K)
    property value
    
    def initialize(@value : K)
    end
  end
  
  # Defines shared property methods for each of the given arguments.
  # This is a simpler version of the `property` macro, and requires explicit statements for:
  # * The name of the instance variable
  # * The type to be held in the instance variable
  # * The initial value
  macro shared_property(var, klass, content)
    @{{ var.name.id }} : QρValue({{ klass }}) = QρValue({{ klass }}).new({{ content }})
    
    # Get the value of our property.
    # This mimics standard method calls.
    def {{ var.name.id }}
      @{{ var.name.id }}.value
    end
    
    # Set the value of our property.
    # This mimics standard method calls.
    def {{ var.name.id }}=(val)
      @{{ var.name.id }}.value = val
    end
    
    # Get the reference to the property.
    def {{ var.name.id }}_reference
      @{{ var.name.id }}
    end
    
    # Replace the reference of one property from another class
    def references_{{ var.name.id }}_from(src)
      if src.responds_to?(:{{ var.name.id }}_reference)
        @{{ var.name.id }} = src.{{ var.name.id }}_reference
        return true
      end
      false
    end
  end
  
  # Sync all `shared_property`s from src
  def references(src)
    modified = [] of Symbol
    {% for var in @type.instance_vars %}
      if @{{ var.name.id }}.is_a? QρValue
        if src.responds_to?(:{{ var.name.id }}_reference)
          @{{ var.name.id }} = src.{{ var.name.id }}_reference
          modified << :{{var.name.id}}
        end
      end
    {% end %}
    modified
  end
end
