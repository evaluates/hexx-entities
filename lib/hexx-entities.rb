# encoding: utf-8

require "attestor"      # for validations
require "eigindir"      # for attributes
require "securerandom"  # for uuids

# Shared namespace for the hexx collection of modules
#
module Hexx

  # Module Entities provides a base class for domain entities
  #
  module Entities

    require_relative "hexx-entities/part"
    require_relative "hexx-entities/uuid"
    require_relative "hexx-entities/uuids"
    require_relative "hexx-entities/base"

  end # module Entities

end # module Hexx
