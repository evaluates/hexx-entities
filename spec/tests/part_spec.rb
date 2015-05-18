# encoding: utf-8

require "attestor/rspec"

describe Hexx::Entities::Part do
  include Attestor::RSpec # helpers and matchers for validations

  let(:klass) { Class.new(described_class) }

  subject(:entity) { klass.new }

  describe ".new" do

    it "creates validatable object" do
      expect(subject).to be_kind_of Attestor::Validations
    end

    it "creates attributable object" do
      expect(subject).to be_kind_of Eigindir
    end

    it "creates comparable object" do
      expect(subject).to be_kind_of Comparable
    end

    it "initializes attributes from hash" do
      klass.attribute :foo
      subject = klass.new foo: :bar
      expect(subject.foo).to eq :bar
    end

    it "creates immutable object" do
      expect(subject).to be_frozen
    end

  end # describe .new

  describe "#serialize" do

    before { klass.attribute :foo }
    before { klass.attribute :bar }

    let(:bar)   { double }
    let(:baz)   { double serialize: { baz: :baz } }
    let(:uuids) { [SecureRandom.uuid] }

    subject(:entity) { klass.new(foo: bar, bar: baz) }

    it "returns a nested hash" do
      expect(entity.serialize).to eq(foo: bar, bar: { baz: :baz })
    end

  end # describe #to_hash

end # describe Hexx::Entities::Part
