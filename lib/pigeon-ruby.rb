require 'pigeon-ruby/version'
require 'pigeon-ruby/config'
require 'pigeon-ruby/client'

module Pigeon
  @clients = Hash.new

  def self.configure(client_name = :default)
    yield config = Pigeon::Config.new

    @clients[client_name] = Pigeon::Client.new(config)
  end

  def self.deliver(message_identifier, parcels = nil)
    @clients[:default].deliver(message_identifier, parcels)
  end

  def self.track(event, data)
    @clients[:default].track(event, data)
  end
end
