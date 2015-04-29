# encoding: utf-8

describe Hexx::Entities::UUIDs do

  describe ".build" do

    subject { described_class.build values }

    shared_examples "building immutable array of uuids" do

      it "[returns an array]" do
        expect(subject).to be_kind_of Array
      end

      it "[returns uuids]" do
        subject.each { |item| expect(item).to be_kind_of Hexx::Entities::UUID }
      end

      it "[freezes the array]" do
        expect(subject).to be_frozen
      end

    end # context

    context "with non-empty uniq array" do

      let(:values) { 2.times.map { SecureRandom.uuid } }

      it_behaves_like "building immutable array of uuids"

      it "uses given values" do
        expect(subject).to match_array values
      end

    end # context

    context "with non-empty non-uniq array" do

      let(:values) { [SecureRandom.uuid] * 2 }

      it_behaves_like "building immutable array of uuids"

      it "removes duplications" do
        expect(subject).to match_array values.uniq
      end

    end # context

    context "with empty array" do

      let(:values) { [] }

      it_behaves_like "building immutable array of uuids"

      it "creates one uuid" do
        expect(subject.count).to eq 1
      end

      it "creates valid uuid" do
        expect(subject.first.validate).to be_valid
      end

    end # context

  end # describe .build

end # describe Hexx::Entities::UUIDs
