module SimpleTenant
  module ModelExtensions

    def self.included(base)
      base.class_eval do
        tenant_scope = lambda do
          if SimpleTenant.current_tenant.present?
            where(tenant_id: SimpleTenant.current_tenant)
          else
            where(tenant_id: nil)
          end
        end

        default_scope tenant_scope
        scope :tenanted, tenant_scope
      end
    end

  end
end
