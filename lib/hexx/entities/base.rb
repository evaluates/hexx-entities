# encoding: utf-8

module Hexx::Entities

  # Class Base provides a common interface for entities, that have identity
  #
  # @example
  #   require "hexx-entities"
  #
  #   class Item < Hexx::Entities::Base
  #
  #     # Defines attributes with their coercers
  #     attribute :foo, coerce: ->(value) { value.to_s }
  #
  #     # Defines validation for the entity
  #     validate { invalid :blank_foo unless foo }
  #
  #   end # class Item
  #
  # @author Andrew Kozin <Andrew.Kozin@gmail.com>
  #
  # @api public
  class Base < Part

    # @!scope class
    # @!method new(attributes)
    # Creates the entity and initializes its attributes
    #
    # @param [Hash] attributes
    #
    # @return [Hexx::Entities::Base]

    # @private
    def initialize(uuids: nil, **attributes)
      @uuids = UUIDs.build Array(uuids)
      super attributes
    end

    # @!attribute [rw] uuids
    #
    # @return [Array<String>] The list of UUIDs that identify the entity
    attribute_reader :uuids
    validate { uuids.each(&:validate!) }

    # Checks the equality of the entity to another object
    #
    # The entity is equal to any other entity that has at least one of its
    # own uuids.
    #
    # @param [Object] other
    #
    # @return [Boolean]
    def ==(other)
      return false unless other.is_a? Base
      (other.uuids & uuids).any?
    end

  end # class Base

end # module Hexx::Entities
