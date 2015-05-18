# encoding: utf-8

module Hexx::Entities

  # Class Part provides a common interface for parts of aggregate entities
  #
  # @example
  #   require "hexx-entities"
  #
  #   class Item < Hexx::Entities::Part
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
  class Part
    include Attestor::Validations
    include Comparable
    include Eigindir

    # @!scope class
    # @!method new(attributes)
    # Creates the immutable object
    #
    # @param [Hash] attributes
    #
    # @return [Hexx::Entities::Part]

    # @private
    def initialize(**attributes)
      self.attributes = attributes
      freeze
    end

    # Recursively serializes the part to the hash
    #
    # Returns the hash of attributes, where every attribute
    # that responds to `serialize` is serialized in its turn.
    #
    # @return [Hash]
    def serialize
      attributes.map { |key, value| [key, serialize__(value)] }.to_h
    end

    private

    def serialize__(value)
      return value.serialize if value.respond_to? :serialize
      return value.map { |item| serialize__(item) } if value.is_a? Array
      value
    end

  end # class Part

end # module Hexx::Entities
