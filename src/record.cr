require "./record/errors"
require "./record/connection"
require "./record/finders"
require "./record/persistence"
require "./record/validation"
require "./support/core_ext/time"

module Trail
  # TODO: associations (has_many :children, belongs_to :parent)
  # TODO: dirty attributes
  class Record
    extend Finders
    include Persistence
    include Validation

    def self.table_name
      @@table_name ||= name.tableize
    end

    def self.primary_key
      @@primary_key
    end

    # :nodoc:
    def self.primary_key_type
      @@primary_key_type
    end

    def self.attribute_names
      @@attribute_names
    end

    def self.build(attributes : Hash)
      new.tap do |record|
        record.attributes = attributes
      end
    end

    #def to_hash
    #  Hash.zip(self.class.attribute_names.to_a, to_tuple.to_a)
    #end

    def to_param
      id.to_s
    end

    abstract def to_tuple

    macro generate_attributes
      {{ run "./record/attributes.cr", @type.name.stringify }}
    end

    macro inherited
      generate_attributes
    end
  end
end
