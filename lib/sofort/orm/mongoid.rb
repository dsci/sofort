require 'orm_adapter/adapters/mongoid'

Mongoid::Document::ClassMethods.send :include, Sofort::Models::Mongoid