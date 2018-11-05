module Serializable
  extend ActiveSupport::Concern
  def initialize(json)
    return unless json

    json = JSON.parse(json) if json.is_a?(String)
    # Will only set the properties that have an accessor,
    # such as those provided to an attr_accessor call.
    json.to_hash.each { |k, v| public_send("#{k}=", v) }
  end

  class_methods do
    def load(json)
      return if json.blank?

      new(json)
    end

    def dump(obj)
      # Make sure the type is right.
      raise StandardError, "Expected #{self}, got #{obj.class}" unless obj.is_a?(self)

      obj.to_json
    end
  end
end
