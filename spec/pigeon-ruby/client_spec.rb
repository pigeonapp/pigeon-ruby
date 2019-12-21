require 'spec_helper'

RSpec.describe Pigeon::Client do
  let(:config) { Pigeon::Config.new }
  let(:client) { Pigeon::Client.new(config) }

  describe '#process_identify_attributes' do
    it 'generates anonymous_uid when both uid and anonymous_uid are not provided' do
      result = client.send(:process_identify_attributes, {})

      expect(result[:anonymous_uid]).not_to be_nil
    end

    it 'returns hash an error if traits are not a hash' do
      expect { client.send(:process_identify_attributes, traits: '') }.to raise_error(ArgumentError)
    end

    it 'returns attributes with the correct values' do
      attributes = client.send(:process_identify_attributes, uid: 'User id', traits: { trait: 'trait' })

      expect(attributes[:uid]).to eq('User id')
      expect(attributes[:traits]).to eq(trait: 'trait')
    end
  end
end
