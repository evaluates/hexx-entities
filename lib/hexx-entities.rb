# encoding: utf-8

require "attestor"      # for validations
require "eigindir"      # for attributes
require "securerandom"  # for uuids

# Module Hexx provides the shared namespace for 'hexx' collection of gems
#
# @author Andrew Kozin <Andrew.Kozin@gmail.com>
module Hexx

  require_relative "hexx/entities" # for namespace
  require_relative "hexx/entities/uuid"
  require_relative "hexx/entities/uuids"

end # module Hexx
