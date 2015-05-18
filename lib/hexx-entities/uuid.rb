# encoding: utf-8

module Hexx::Entities

  # Class UUID provides validatable value object that describes UUID
  #
  # @example Creates a string
  #   uuid = UUID.new "12345678-90ab-cdef-1234-567890abcdef"
  #   # => "12345678-90ab-cdef-1234-567890abcdef"
  #
  # @example Validates the format of its own
  #   uuid = UUID.new "wrong format"
  #   uuid.validate.valid? # => false
  #
  # @example Generates a default value for nil
  #   uuid = UUID.new nil
  #   # => "97f340af-8157-5c3a-1571-743d208da957"
  #
  # @see https://www.ietf.org/rfc/rfc4122.txt
  #   the RFC 4220 standard for Universal Unique Identifiers (UUID)
  #
  # @author Andrew Kozin <Andrew.Kozin@gmail.com>
  #
  # @api public
  class UUID < String
    include Attestor::Validations

    # @private
    FORMAT = /^\h{8}(-\h{4}){3}-\h{12}$/

    # @private
    def initialize(value)
      super (value || SecureRandom.uuid).to_s
    end

    # @private
    validate { invalid :invalid unless self[FORMAT] }

  end # class UUID

end # module Hexx::Entities
