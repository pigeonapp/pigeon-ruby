require 'spec_helper'

Rspec.describe Pigeon::Client do
  let(:client) { Pigeon::Client.new(private_key: 'PRIVATE_KEY', public_key: 'PUBLIC_KEY') }

  describe '#process_identify_attributes' do
    it 'generates anonymous_uid when both uid and anonymous_uid are not provided' do
      result = client.process_identify_attributes({})

      expect(result.anonymous_uid).to be_present
    end
  end
end