require 'hashman/version'
require 'active_support'

module HashMan
  module Inclusion
    extend ActiveSupport::Concern

    def hash_id
      self.class.generate_hash_id(id)
    end

    # extend methods for class
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      # generate the hash_id using the @magic_number declared in class
      # id class === String || UUIDTools::UUID || Fixnum

      def hash_length(number)
        @magic_number = number
      end

      def generate_hash_id(id)
        hasher.encode(rinse_id(id))
      end

      # reverse the has to get the original id
      # if UUID, parse it and return the UUID object

      def reverse_hash(hash)
        id = hasher.decode(hash).try(:first)
        (self.include? Dynamoid::Document) || (self.columns_hash["id"].type == :uuid) ? UUIDTools::UUID.parse_int(id) : id
      end

      private

      def hasher
        Hashman::Hasher.new("#{Rails.application.secrets.magic_number}", @magic_number || 4)
      end

      # standardize the id integer
      # we do not specify UUIDTools since comparisons break!
      # String (activeUUID tables), FixNum (normal ids), UUID (dynamoid/VideoClips)

      def rinse_id(id)
        case
          when id.class == String
            return UUIDTools::UUID.parse(id).to_i
          when id.class == Fixnum
            return id
          else
            return id.to_i
        end
      end

    end

  end
end
