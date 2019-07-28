require 'httparty'

module Pigeon
  class Client
    include HTTParty

    def initialize(config)
      self.class.base_uri(config.base_uri || 'https://api.pigeonapp.io/v1')
      self.class.headers({
        'X-Public-Key' => config.public_key,
        'X-Private-Key' => config.private_key
      })
    end

    def deliver(message_identifier, parcels = nil)
      self.class.post('/deliveries', {
        body: {
          message_identifier: message_identifier,
          parcels: process_parcels(parcels)
        }
      })
    end

    def track(event, data = {})
      self.class.post('/event_logs', {
        body: {
          event: event,
          data: data
        }
      })
    end

    private

    def process_parcels(parcels)
      parcels = [parcels] if parcels.is_a? Hash

      parcels.each do |parcel|
        (parcel[:attachments] || []).each do |attachment|
          next unless File.file?(attachment[:file])

          prepare_attachment_content(attachment)
        end
      end
    end

    def prepare_attachment_content(attachment)
      file = attachment[:file]
      file = File.open(file) if file.is_a? String
      attachment[:content] = Base64.strict_encode64(file.read)
      attachment[:name] ||= File.basename(file, '.*')
      attachment.delete(:file)
    end
  end
end
