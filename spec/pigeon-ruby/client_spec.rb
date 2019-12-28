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

    describe '#process_track_attributes' do
      it 'raises an error if event is blank' do
        expect { client.send(:process_track_attributes, {}) }.to raise_error(ArgumentError, 'Event cannot be blank.')
      end

      it 'raises an error if event is present but customer_uid is blank' do
        expect { client.send(:process_track_attributes, event: 'test') }.to raise_error(ArgumentError, 'Customer UID cannot be blank.')
      end

      it 'raises an error if event and customer_uid is present but data is not a hash' do
        expect { client.send(:process_track_attributes, event: 'event', customer_uid: 'uid', data: '') }.to raise_error(ArgumentError, 'data must be a Hash')
      end

      context 'with valid params' do
        let(:attributes) { client.send(:process_track_attributes, event: 'event', customer_uid: 'uid', data: { name: 'Name' }) }

        it 'sets event' do
          expect(attributes[:event]).to eq('event')
        end

        it 'sets customer_uid' do
          expect(attributes[:customer_uid]).to eq('uid')
        end

        it 'sets data hash' do
          expect(attributes[:data]).to eq(name: 'Name')
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

    describe '#process_contact_attributes' do
      it 'raises an error if uid is blank' do
        expect { client.send(:process_contact_attributes, nil, {}) }.to raise_error(ArgumentError, 'UID cannot be blank.')
      end

      it 'raises an error if uid is present but contact value is blank' do
        expect { client.send(:process_contact_attributes, 'uid', {}) }.to raise_error(ArgumentError, 'Contact value cannot be blank.')
      end

      it 'raises an error if uid and contact value is present but contact kind is blank' do
        expect { client.send(:process_contact_attributes, 'uid', value: 'Contact Value') }.to raise_error(ArgumentError, 'Contact kind cannot be blank.')
      end

      context 'with valid params' do
        let(:attributes) { client.send(:process_contact_attributes, 'uid', value: 'Contact Value', kind: 'Contact Kind') }

        it 'sets the uid' do
          expect(attributes[:uid]).to eq('uid')
        end

        it 'sets contact value' do
          expect(attributes[:value]).to eq('Contact Value')
        end

        it 'sets contact kind' do
          expect(attributes[:kind]).to eq('Contact Kind')
        end
      end
    end
  end
end
