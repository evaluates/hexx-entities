# encoding: utf-8

module Hexx::Entities

  # Module UUIDs provides a builder utility to create a list of uuids
  #
  # @author Andrew Kozin <Andrew.Kozin@gmail.com>
  #
  module UUIDs

    # Builds an immutable list of uuids from given list of values
    #
    # @example
    #   value = "12345678-90ab-cdef-1234-567890abcdef"
    #   list  = Hexx::Entities::UUIDs.build value
    #
    #   list == [value]  # => true
    #   list.first.class # => Hexx::Entities::UUID
    #   list.frozen?     # => true
    #
    # @example Generates default uuid if no uuids given
    #   list = Hexx::Entities::UUIDs.build nil
    #   list # => ["2bcfaedf-5f62-4929-861a-f8248f2bea16"]
    #
    # @param [Array<String>] values
    #
    # @return [Array<Hexx::Entities::UUID>] immutable (frozen) array of uuids
    def self.build(values)
      (values.empty? ? [nil] : values.uniq).map(&UUID.method(:new)).freeze
    end

  end # module UUIDs

end # module Hexx::Entities
