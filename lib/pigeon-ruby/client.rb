require 'httparty'

module Pigeon
  class Client
    include HTTParty
    include Pigeon::Utils

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

    def identify(attrs = {})
      self.class.post('/customers', {
        body: process_identify_attributes(attrs)
      })
    end

    def add_contact(customer_id, attrs = {})
      self.class.post('/contacts', {
        body: process_contact_attributes(customer_id, attrs)
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

    def process_identify_attributes(attrs)
      symbolize_keys! attrs
      traits = attrs[:traits] || {}

      raise ArgumentError, 'Traits must be a Hash' if !traits.is_a? Hash

      if !attrs[:uid] && !attrs[:anonymous_uid]
        raise ArgumentError, 'You must supply either uid or anonymous_uid.'
      end

      attrs
    end

    def process_contact_attributes(uid, attrs)
      symbolize_keys! attrs

      check_presence!(uid, 'Customer ID')
      check_presence!(attrs[:platforrm], 'Platform')
      check_presence!(attrs[:token], 'Token')

      attrs[:uid] = uid
    end
  end
end
