RSpec.describe SimpleTenant::ModelExtensions do

  class TestModel
    include Mongoid::Document
    include SimpleTenant::ModelExtensions

    field :name, type: String
    field :number, type: Integer
    field :text, type: String

    tenanted_by :tenant_id
  end

  before do
    SimpleTenant.current_tenant = nil
    TestModel.unscoped.destroy_all
  end

  context 'document initialization' do

    it 'sets tenant as nil if current tenant is not set' do
      SimpleTenant.current_tenant = nil

      document = TestModel.new

      expect(document.tenant_id).to be_nil
    end

    it 'sets tenant as current tenant if current tenant is set' do
      SimpleTenant.current_tenant = 828

      document = TestModel.new

      expect(document.tenant_id).to equal(828)
    end

  end

  context 'document creation' do

    it 'saves tenant as nil if current tenant is not set' do
      SimpleTenant.current_tenant = nil

      document = TestModel.create

      expect(document.reload.tenant_id).to be_nil
    end

    it 'saves tenant as current tenant if current tenant is set' do
      SimpleTenant.current_tenant = 828

      document = TestModel.create

      expect(document.reload.tenant_id).to eq(828)
    end

  end

  context 'document query' do

    before do
      TestModel.create name: 'document with tenant', tenant_id: 828
      TestModel.create name: 'document with another tenant', tenant_id: 1113
      TestModel.create name: 'document without tenant'
    end

    it 'searches document without tenant if current tenant is not set' do
      SimpleTenant.current_tenant = nil

      expect(TestModel.count).to eq(1)
      expect(TestModel.first.name).to eq('document without tenant')
    end

    it 'searches document with given tenant if current tenant is set' do
      SimpleTenant.current_tenant = 828

      expect(TestModel.count).to eq(1)
      expect(TestModel.first.name).to eq('document with tenant')
    end

  end

end
