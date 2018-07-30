RSpec.describe SimpleTenant::ModelExtensions do

  class TestModel
    include Mongoid::Document
    include SimpleTenant::ModelExtensions

    field :name, type: String
    field :number, type: Integer
    field :text, type: String
    field :deleted_at, type: Time

    tenanted_by :tenant_id

    default_scope { where(deleted_at: nil) }
  end

  before do
    SimpleTenant.current_tenant = nil
    TestModel.unscoped_all.destroy_all
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

  context '#unscoped' do

    before do
      TestModel.create name: 'document with tenant', tenant_id: 828
      TestModel.create name: 'document with another tenant', tenant_id: 1113
      TestModel.create name: 'document with tenant but deleted', tenant_id: 828, deleted_at: Time.now
      TestModel.create name: 'document without tenant'
    end

    it 'respects other scope' do
      SimpleTenant.current_tenant = 828

      expect(TestModel.count).to eq(1)
      expect(TestModel.first.name).to eq('document with tenant')
    end

    it 'unscoped will unscope other scopes but still keep tenant scope' do
      SimpleTenant.current_tenant = 828

      expect(TestModel.unscoped.count).to eq(2)
      expect(TestModel.unscoped.map(&:name)).to match_array(['document with tenant', 'document with tenant but deleted'])
    end

    it 'unscoped_all will unscope all scopes including tenant scope' do
      SimpleTenant.current_tenant = 828

      expect(TestModel.unscoped_all.count).to eq(4)
    end

  end

end
