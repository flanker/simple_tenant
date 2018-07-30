require 'request_store'
require 'simple_tenant/version'
require 'simple_tenant/model_extensions'

module SimpleTenant

  def self.current_tenant
    RequestStore[:current_tenant]
  end

  def self.current_tenant= tenant
    RequestStore[:current_tenant] = tenant
  end

end
