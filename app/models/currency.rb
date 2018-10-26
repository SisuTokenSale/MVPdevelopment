class Currency
  DEFAULT_ISO = 'USD'.freeze

  include ActiveModel::Model
  include ActiveModel::Serialization

  attr_accessor :id, :iso, :symbol

  class << self
    def all
      @all ||= Settings.currencies.map { |c| new c }
    end

    def default
      @default ||= all.detect { |c| c.iso == DEFAULT_ISO }
    end

    def by_iso(iso)
      raise ArgumentError, 'iso should be defined in argument' unless iso

      all.detect { |c| c.iso == iso.upcase }
    end

    def symbol_by_iso(iso)
      raise ArgumentError, 'iso should be defined in argument' unless iso

      by_iso(iso)&.symbol
    end
  end

  def attributes
    {
      'id' => iso,
      'iso' => iso,
      'symbol' => symbol
    }
  end
end
