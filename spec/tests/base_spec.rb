# encoding: utf-8

require "attestor/rspec"

describe Hexx::Entities::Base do
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

  end # describe .new

  describe "#uuids" do

    let(:uuid) { SecureRandom.uuid }

    it "is an attribute" do
      expect(subject.attributes.keys).to include :uuids
    end

    it "returns an array" do
      expect(subject.uuids).to be_kind_of Array
    end

    it "has a default value" do
      expect(subject.uuids.count).to eq 1
      expect(subject.uuids.first).to be_kind_of Hexx::Entities::UUID
    end

    it "can be initialized" do
      subject = klass.new(uuids: uuid)
      expect(subject.uuids).to eq [uuid]
      expect(subject.uuids.first).to be_kind_of Hexx::Entities::UUID
    end

    it "is immutable" do
      expect(subject.uuids).to be_frozen
    end

  end # describe #uuids

  describe "#==" do

    let(:subclass) { Class.new(klass)  }
    let(:uuid)     { SecureRandom.uuid }
    let(:entity)   { klass.new uuids: [uuid, SecureRandom.uuid] }
    subject        { entity == other }

    context "to entity with the same uuid" do

      let(:other) { subclass.new uuids: [SecureRandom.uuid, uuid] }
      it { is_expected.to be true }

    end # context

    context "to entity with different uuids" do

      let(:other) { subclass.new }
      it { is_expected.to be false }

    end # context

    context "to non-entity" do

      let(:other) { double }
      it { is_expected.to be false }

    end # context

  end # describe #==

  describe "#serialize" do

    before { klass.attribute :foo }
    before { klass.attribute :bar }

    let(:bar)   { double }
    let(:baz)   { double serialize: { baz: :baz } }
    let(:uuids) { [SecureRandom.uuid] }

    subject(:entity) { klass.new(uuids: uuids, foo: bar, bar: baz) }

    it "returns a nested hash" do
      expect(entity.serialize).to eq(uuids: uuids, foo: bar, bar: { baz: :baz })
    end

  end # describe #to_hash

  describe "#validate" do

    subject { entity.validate }

    context "when every uuid is valid" do

      let(:entity) { described_class.new }

      it { is_expected.to be_valid }

    end # context

    context "when any uuid is invalid" do

      let(:entity) { described_class.new uuids: [SecureRandom.uuid, "wrong"] }

      it { is_expected.to be_invalid }

    end # context

  end # describe #validate

end # describe Hexx::Entities::Base
