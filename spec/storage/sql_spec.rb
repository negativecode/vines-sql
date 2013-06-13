require 'spec_helper'

describe Vines::Storage::Sql do
  include StorageSpecs

  DB_FILE = "./xmpp_testcase.db"
  ActiveRecord::Migration.verbose = false

  before do
    storage.create_schema(force: true)
    Vines::Storage::Sql::User.new(jid: 'empty@wonderland.lit', name: '', password: '').save
    Vines::Storage::Sql::User.new(jid: 'no_password@wonderland.lit', name: '', password: '').save
    Vines::Storage::Sql::User.new(jid: 'clear_password@wonderland.lit', name: '', password: 'secret').save
    Vines::Storage::Sql::User.new(jid: 'bcrypt_password@wonderland.lit', name: '',
      password: BCrypt::Password.create('secret')).save
    groups = %w[Group1 Group2 Group3 Group4].map do |name|
      Vines::Storage::Sql::Group.find_or_create_by_name(name)
    end
    full = Vines::Storage::Sql::User.new(
      jid: 'full@wonderland.lit',
      name: 'Tester',
      password: BCrypt::Password.create('secret'),
      vcard: vcard.to_xml)
    full.contacts << Vines::Storage::Sql::Contact.new(
      jid: 'contact1@wonderland.lit',
      name: 'Contact1',
      groups: groups[0, 2],
      subscription: 'both')
    full.contacts << Vines::Storage::Sql::Contact.new(
      jid: 'contact2@wonderland.lit',
      name: 'Contact2',
      groups: groups[2, 2],
      subscription: 'both')
    full.save

    partial = Vines::Storage::Sql::Fragment.new(
      user: full,
      root: 'characters',
      namespace: 'urn:wonderland',
      xml: fragment.to_xml)
    partial.save
  end

  after do
    File.delete(DB_FILE) if File.exist?(DB_FILE)
  end

  def storage
    Vines::Storage::Sql.new { adapter 'sqlite3'; database DB_FILE }
  end

  describe 'creating a new instance' do
    it 'raises with no arguments' do
      -> { Vines::Storage::Sql.new {} }.must_raise RuntimeError
    end

    it 'raises with no database' do
      -> { Vines::Storage::Sql.new { adapter 'postgresql' } }.must_raise RuntimeError
    end

    it 'does not raise with adapter and database' do
      obj = Vines::Storage::Sql.new { adapter 'sqlite3'; database ':memory:' }
      obj.wont_be_nil
    end
  end
end
