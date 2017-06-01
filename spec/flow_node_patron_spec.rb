require "spec_helper"

RSpec.describe FlowNodePatron do
  it "has a version number" do
    expect(FlowNodePatron::VERSION).not_to be nil
  end

  it "could write log correctly" do
    FlowNodePatron.logger.info "hello world"
    expect(File.size("flow_node_patron.log") > 0).to eq true
  end

  it "BYEBUG whole gem" do
    skip unless ENV["BYEBUG"]
  end
end
