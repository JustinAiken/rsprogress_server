# frozen_string_literal: true
require "spec_helper"

describe Filters do

  class FiltersTester
    include Filters
  end

  let(:tester) { FiltersTester.new }

  describe "#filter_arrangement" do
    subject(:result) { tester.filter_arrangement.call :column, search_string }

    context "when empty" do
      let(:search_string) { "" }
      it { should be_nil }
    end

    context "when not empty" do
      subject { result.right.map &:val }

      context "when one key requested" do
        let(:search_string) { "Lead" }
        it { should match_array [0] }
      end

      context "when 'Any Guitar' requested" do
        let(:search_string) { "Any Guitar" }
        it { should match_array [0, 1, 3, 4, 6, 7] }
      end
    end
  end

  describe "#filter_type" do
    subject(:result)    { tester.filter_type.call :column, search_string }

    context "when empty" do
      let(:search_string) { "" }
      it { should be_nil }
    end

    context "when not empty" do
      subject { result.right.map &:val }

      context "when one key requested" do
        let(:search_string) { "cdlc" }
        it { should match_array %w{cdlc} }
      end

      context "when multiple keys requested" do
        let(:search_string) { "cdlc,dlc,disc" }
        it { should match_array %w{cdlc dlc disc} }
      end
    end
  end

  describe "#filter_flag" do
    subject(:result) { tester.filter_flag.call :column, search_string }

    context "when empty" do
      let(:search_string) { "" }
      it { should be_nil }
    end

    context "when not empty" do
      pending
    end
  end
end
