require 'base64'
require 'httparty'
require 'openssl'
require 'securerandom'

module Pigeon
  class Client
    include HTTParty

    def initialize(config)
      @config = config

      self.class.base_uri(config.base_uri || 'https://api.pigeonapp.io/v1')
      self.class.headers({
        'X-Public-Key' => config.public_key,
        'X-Private-Key' => config.private_key
      })
    end

    def deliver(message_identifier, attrs)
      send_request(:post, '/deliveries', {
        body: process_delivery_attributes(attrs).merge({
          message_identifier: message_identifier
        })
      })
    end

    def track(attrs = {})
      send_request(:post, '/event_logs', {
        body: process_track_attributes(attrs)
      })
    end

    def identify(attrs = {})
      send_request(:post, '/customers', {
        body: process_identify_attributes(attrs)
      })
    end

    def add_contact(customer_id, attrs = {})
      send_request(:post, '/contacts', {
        body: process_contact_attributes(customer_id, attrs)
      })
    end

    def generate_token(customer_id)
      cipher = OpenSSL::Cipher::AES256.new :CBC
      cipher.encrypt
      cipher.key = OpenSSL::Digest::SHA256.digest @config.private_key
      encrypted = cipher.update(customer_id.to_s) + cipher.final
      Base64.urlsafe_encode64(encrypted)
    end

    private

    def process_delivery_attributes(attrs)
      symbolize_keys! attrs

      check_presence!(attrs[:to], 'Recipient')

      (attrs[:attachments] || []).each { |attachment| prepare_attachment_content(attachment) }

      attrs
    end

    def prepare_attachment_content(attachment)
      attachment_file = attachment[:file]

      if File.file?(attachment_file)
        file = File.open(attachment_file)
        attachment[:content] = Base64.strict_encode64(file.read)
        attachment[:name] ||= File.basename(file, '.*')
      else
        attachment[:content] = attachment_file
      end

      attachment.delete(:file)
    end

    def process_track_attributes(attrs)
      symbolize_keys! attrs

      check_presence!(attrs[:event], 'Event')
      check_presence!(attrs[:customer_uid], 'Customer UID')

      data = attrs[:data] || {}
      raise ArgumentError, 'data must be a Hash' if !data.is_a? Hash

      attrs
    end

    def process_identify_attributes(attrs)
      symbolize_keys! attrs

      extras = attrs[:extras] || {}
      raise ArgumentError, 'Extras must be a Hash' if !extras.is_a? Hash

      if !attrs[:uid] && !attrs[:anonymous_uid]
        attrs[:anonymous_uid] = generate_anonymous_uid
      end

      attrs
    end

    def process_contact_attributes(uid, attrs)
      symbolize_keys! attrs

      check_presence!(attrs[:name], 'Name')
      check_presence!(attrs[:value], 'Value')
      check_presence!(attrs[:kind], 'Kind')

      attrs[:uid] = uid
      attrs
    end

    def generate_anonymous_uid
      SecureRandom.uuid
    end

    def symbolize_keys!(hash)
      new_hash = hash.each_with_object({}) do |(k, v), memo|
        memo[k.to_sym] = v
      end

      hash.replace(new_hash)
    end

    def check_presence!(obj, name = obj)
      raise ArgumentError, "#{name} cannot be blank." if obj.nil? || (obj.is_a?(String) && obj.empty?)
    end

    def send_request(method, route, options)
      if !!@config.stub
        HTTParty::Response 200, body: {}
      else
        self.class.send(method, route, options)
      end
    end
  end
end
