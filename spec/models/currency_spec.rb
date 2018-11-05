require 'rails_helper'

describe Currency, type: :model do
  context 'constants' do
    describe 'DEFAULT_ISO' do
      specify 'exist' do
        expect(Currency::DEFAULT_ISO).to eq('USD')
      end
    end
  end

  context 'Class methods' do
    describe '.all' do
      specify 'return list on object' do
        expect(Currency.all.map(&:attributes)).to match_array(Settings.currencies.map { |c| Currency.new c }.map(&:attributes))
      end
    end

    describe '.default' do
      specify 'return default currency' do
        expect(Currency.default).to eq(Currency.all.detect { |c| c.iso == Currency::DEFAULT_ISO })
      end
    end

    describe '.symbol_by_iso' do
      specify 'return currency symbol by ISO code' do
        expect(Currency.symbol_by_iso('USD')).to eq('$')
        expect(Currency.symbol_by_iso('EUR')).to eq('€')
        expect(Currency.symbol_by_iso('GBP')).to eq('£')
      end
    end
  end
end
