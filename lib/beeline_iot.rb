# frozen_string_literal: true

require "active_support"
require "active_support/core_ext"
require "active_support/json"
require "active_support/hash_with_indifferent_access"

require_relative "beeline_iot/version"

require "beeline_iot/client"
require "beeline_iot/error"
require "beeline_iot/methods"

module BeelineIot
  mattr_accessor :username,
                 :password,
                 :client_id,
                 :client_secret,
                 :grant_type,
                 :token_type,
                 :expires_in,
                 :access_token,
                 :refresh_token,
                 :log_requests
end
