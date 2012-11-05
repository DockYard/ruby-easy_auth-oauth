require 'easy_auth'
require 'easy_auth/oauth/engine'
require 'easy_auth/oauth/version'

module EasyAuth

  module Oauth
    extend ActiveSupport::Autoload
    autoload :Controllers
    autoload :Models
    autoload :Routes
  end

  module Models
    module Account
      include EasyAuth::Oauth::Models::Account
    end

    module Identities
      autoload :Oauth
    end
  end

  module Controllers::Sessions
    include EasyAuth::Oauth::Controllers::Sessions
  end

  def self.oauth_identity_model(params)
    method_name = "oauth_#{params[:provider]}_identity_model"
    camelcased_provider_name = params[:provider].to_s.camelcase
    if respond_to?(method_name)
      send(method_name, params)
    elsif eval("defined?(Identities::Oauth::#{camelcased_provider_name})")
      eval("Identities::Oauth::#{camelcased_provider_name}")
    else
      camelcased_provider_name.constantize
    end
  end

  class << self
    attr_accessor :oauth
  end

  self.oauth = {}

  def self.oauth_client(provider, client_id, secret, scope = '')
    oauth[provider] = OpenStruct.new :client_id => client_id, :secret => secret, :scope => scope || ''
  end
end

ActionDispatch::Routing::Mapper.send(:include, EasyAuth::Oauth::Routes)