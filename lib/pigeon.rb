require 'pigeon/version'
require 'pigeon/config'
require 'pigeon/client'

module Pigeon
  @clients = Hash.new

  def self.configure(client_name = :default)
    yield config = Pigeon::Config.new

    @clients[client_name] = Pigeon::Client.new(config)
  end

  def self.deliver(message_identifier)
    @clients[:default].deliver(message_identifier)
  end
end
