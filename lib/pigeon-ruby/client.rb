require 'httparty'

module Pigeon
  class Client
    include HTTParty

    def initialize(config)
      @config = config

      self.class.base_uri(@config.base_uri || 'https://api.pigeonapp.io/v1')
    end

    def deliver(message_identifier, parcels = nil)
      self.class.post('/deliveries', {
        headers: {
          'X-Public-Key' => @config.public_key,
          'X-Private-Key' => @config.private_key
        },
        body: {
          message_identifier: message_identifier,
          parcels: process_attachments(parcels)
        }
      })
    end

    private

    def process_attachments(parcels)
      parcels = [parcels] if parcels.is_a? Hash

      parcels.each do |parcel|
        (parcel[:attachments] || []).map do |attachment|
          file = attachment[:file]
          next unless File.file?(file)

          file = File.open(file) if file.is_a? String
          attachment[:content] = Base64.strict_encode64(file.read)
          attachment[:name] ||= File.basename(file, '.*')
          attachment.delete(:file)
        end
      end
    end
  end
end
