require 'pigeon-ruby/version'
require 'pigeon-ruby/config'
require 'pigeon-ruby/client'

module Pigeon
  @clients = Hash.new

  def self.configure(client_name = :default)
    yield config = Pigeon::Config.new

    @clients[client_name] = Pigeon::Client.new(config)
  end

  def self.deliver(message_identifier, attrs = {})
    @clients[:default].deliver(message_identifier, attrs)
  end

  def self.track(attrs = {})
    @clients[:default].track(event, data)
  end

  def self.identify(attrs = {})
    @clients[:default].identify(attrs)
  end

  def self.add_contact(uid, attrs = {})
    @clients[:default].add_contact(uid, attrs)
  end

  def self.generate_token(uid)
    @clients[:default].generate_token(uid)
  end
end
