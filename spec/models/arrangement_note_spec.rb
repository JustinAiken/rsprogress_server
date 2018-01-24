require "spec_helper"

describe ArrangementNote do
  it { should belong_to :user }
  it { should belong_to :arrangement }
  it { should validate_presence_of :user }
  it { should validate_presence_of :arrangement }
  it { should validate_presence_of :body }
end
