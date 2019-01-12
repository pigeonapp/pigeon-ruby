require 'httparty'

module Pigeon
  class Client
    include HTTParty

    def initialize(config)
      @config = config

      self.class.base_uri(@config.base_uri || 'https://api.pigeonapp.io')
    end

    def deliver(message_identifier, parcels = nil)
      self.class.post('/deliveries', {
        headers: {
          'X-Public-Key' => @config.public_key,
          'X-Private-Key' => @config.private_key
        },
        body: {
          message_identifier: message_identifier,
          parcels: parcels
        }
      })
    end
  end
end
