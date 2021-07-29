# Simple Tenant

[![Build Status](https://www.travis-ci.com/flanker/simple_tenant.svg?branch=master)](https://www.travis-ci.com/flanker/simple_tenant)

A very simple multi-tenant library for ruby with __mongodb (based on mongoid)__.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simple_tenant'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_tenant

## Usage

Model definition:

```ruby
  class TestModel
    include Mongoid::Document
    include SimpleTenant::ModelExtensions

    field :name, type: String
    field :number, type: Integer
    field :text, type: String
    field :deleted_at, type: Time
    field :tenant_id, type: Integer

    tenanted_by :tenant_id

    default_scope { where(deleted_at: nil) }
  end
```

and:

```ruby
TestModel.create name: 'document with tenant', tenant_id: 828
TestModel.create name: 'document with another tenant', tenant_id: 1113
TestModel.create name: 'document without tenant'

SimpleTenant.current_tenant = 828

TestModel.count    # => 1
TestModel.first.name    # ==> document with tenant
```

See more usage example in specs:

1. [SimpleTenant::ModelExtensions](https://github.com/flanker/simple_tenant/blob/master/spec/simple_tenant/model_extensions_spec.rb)
2. [SimpleTenant::ModelExtensions for relation](https://github.com/flanker/simple_tenant/blob/master/spec/simple_tenant/model_extensions_with_relation_spec.rb)
3. [SimpleTenant::ModelExtensions for inheritance](https://github.com/flanker/simple_tenant/blob/master/spec/simple_tenant/model_extensions_with_inheritance_spec.rb)
 
