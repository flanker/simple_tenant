RSpec.describe 'SimpleTenant::ModelExtensions with relation' do

  class Account
    include Mongoid::Document

    field :name, type: String
  end

  class Blog
    include Mongoid::Document
    include SimpleTenant::ModelExtensions

    tenanted_by :account

    field :title, type: String
    field :content, type: String
  end

  before do
    SimpleTenant.current_tenant = nil
    Account.unscoped.destroy_all
    Blog.unscoped.destroy_all
  end

  context 'document initialization' do

    it 'sets tenant as nil if current tenant is not set' do
      SimpleTenant.current_tenant = nil

      document = Blog.new

      expect(document.account_id).to be_nil
      expect(document.account).to be_nil
    end

    it 'sets tenant as current tenant if current tenant is set' do
      account = Account.create
      SimpleTenant.current_tenant = account.id

      document = Blog.new

      expect(document.account_id).to eq(account.id)
      expect(document.account).to eq(account)
    end

  end

  context 'document creation' do

    it 'fails to save document if current tenant is not set' do
      SimpleTenant.current_tenant = nil

      document = Blog.create

      expect(document.persisted?).to be_falsey
      expect(document.valid?).to be_falsey
    end

    it 'saves tenant as current tenant if current tenant is set' do
      account = Account.create
      SimpleTenant.current_tenant = account.id

      document = Blog.create

      expect(document.reload.account_id).to eq(account.id)
      expect(document.reload.account).to eq(account)
    end

  end

  context 'document query' do

    before do
      @account = Account.create
      @another_account = Account.create
      Blog.create title: 'blog with tenant', account_id: @account.id
      Blog.create title: 'blog with another tenant', account_id: @another_account.id
    end

    it 'searches document without tenant if current tenant is not set' do
      SimpleTenant.current_tenant = nil

      expect(Blog.count).to eq(0)
    end

    it 'searches document with given tenant if current tenant is set' do
      SimpleTenant.current_tenant = @account.id

      expect(Blog.count).to eq(1)
      expect(Blog.first.title).to eq('blog with tenant')
    end

  end

end
