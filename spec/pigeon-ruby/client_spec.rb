require 'spec_helper'

module Pigeon
  RSpec.describe Client do
    let(:config) { Pigeon::Config.new }
    let(:client) { described_class.new(config) }

    describe '#process_delivery_attributes' do
      it 'raises error when Recipient is blank' do
        expect { client.send(:process_delivery_attributes, {}) }.to raise_error(ArgumentError, 'Recipient cannot be blank.')
      end

      context 'with valid params' do
        let(:attributes) { client.send(:process_delivery_attributes, to: 'User ID') }

        it 'sets the Recipient' do
          expect(attributes[:to]).to eq('User ID')
        end
      end
    end

    describe '#process_identify_attributes' do
      it 'generates anonymous_uid when both uid and anonymous_uid are not provided' do
        result = client.send(:process_identify_attributes, {})

        expect(result[:anonymous_uid]).not_to be_nil
      end

      it 'raises an error if extras is not a hash' do
        expect { client.send(:process_identify_attributes, extras: '') }.to raise_error(ArgumentError, 'Extras must be a Hash')
      end

      context 'with valid params' do
        let(:attributes) { client.send(:process_identify_attributes, uid: 'User ID', extras: { extra: 'extra' }) }

        it 'sets the User ID' do
          expect(attributes[:uid]).to eq('User ID')
        end

        it 'sets extras hash' do
          expect(attributes[:extras]).to eq(extra: 'extra')
        end
      end
    end
  end
end
