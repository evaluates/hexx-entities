# encoding: utf-8

require "attestor/rspec"

describe Hexx::Entities::UUID do
  include Attestor::RSpec

  let(:value)    { SecureRandom.uuid.to_sym  }
  subject(:uuid) { described_class.new value }

  describe ".new" do

    context "with something" do

      it "creates a string" do
        expect(subject).to eq value.to_s
      end

    end # context

    context "with nil" do

      let(:format)   { /^\h{8}(-\h{4}){3}-\h{12}$/ }
      subject(:uuid) { described_class.new nil }

      it "creates uuid by default" do
        expect(subject).to match format
      end

    end # context

    context "with nothing" do

      subject(:uuid) { described_class.new }

      it "fails" do
        expect { subject }.to raise_error ArgumentError
      end

    end # context

  end # describe .new

  describe "#validate" do

    subject { uuid.validate }

    context "with valid uuid" do

      it { is_expected.to be_valid }

    end # context

    context "with invalid value" do

      let(:value) { "wrong" }
      it { is_expected.to be_invalid }

    end # context

  end # describe #validate

end # describe Hexx::Entities::UUID
