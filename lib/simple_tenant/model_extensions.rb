module SimpleTenant
  module ModelExtensions

    def self.included(base)
      base.extend ClassMethods

      base.class_eval do

        tenant_scope = lambda do
          if SimpleTenant.current_tenant.present?
            where(@tenant_field_name => SimpleTenant.current_tenant)
          else
            where(@tenant_field_name => nil)
          end
        end

        default_scope tenant_scope
        scope :tenanted, tenant_scope
      end
    end

    module ClassMethods

      def tenanted_by field_name, type: Integer
        if const_defined?(field_name.to_s.classify)
          belongs_to field_name
          @tenant_field_name = "#{field_name}_id"
        else
          field field_name, type: type
          @tenant_field_name = field_name
        end
      end

    end

  end
end
