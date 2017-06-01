require "spec_helper"

module FlowNodePatron
RSpec.describe FlowNodePatron::FlowPromisedLandService do
  before(:each) do
    # 清除测试队列的影响
    FlowPromisedLandService.queue_list.map do |info|
      FlowPromisedLandService.delete_box(info[:id]) 
    end
    expect(FlowPromisedLandService.queue_list.count).to eq 0
  end

  it "could outqueue" do
    skip "no test unless debug mode" unless ENV["DEBUG"]
    queue_list = FlowPromisedLandService.queue_list
    raise "队列初始值大于0 了，是不是有东西在跑？如果不必要的数据，可以先在BYEBUG=1 下清除队列" if queue_list.count > 0

    FlowPromisedLandService.push_a_test_box
    answer = FlowPromisedLandService.fetch_outqueue_box
    # 一般情况下，在测试环境中，这个的队列应该是空，但是要看这里连的promised_land 的具体情况
    expect(answer[:provider]).to eq "org_custom_machine"
    FlowPromisedLandService.delete_box(answer[:id])
    answer = FlowPromisedLandService.get_box_info(answer[:id])
    expect(answer[:status]).to eq "closed"
  end

  it "could receive service box closed status" do
    skip "no test unless debug mode" unless ENV["DEBUG"]
    FlowPromisedLandService.push_a_test_box
    answer = FlowPromisedLandService.fetch_outqueue_box

    FlowPromisedLandService.delete_box(answer[:id])
    answer = FlowPromisedLandService.get_box_info(answer[:id])
    expect(answer[:status]).to eq "closed"
    expect(FlowPromisedLandService.closed_box?(answer[:id])).to eq true
  end

  describe "when checkin" do
    it "could checkin and checkout" do
      a = FlowPromisedLandService.checkin
      expect(a[:status]).to eq "running"

      info = FlowPromisedLandService.show_patron_info
      expect(info[:status]).to eq "running"

      FlowPromisedLandService.update_report("idle")
      expect(FlowPromisedLandService.show_patron_info[:patron_running_status]).to eq "idle"

      FlowPromisedLandService.update_report("running")
      expect(FlowPromisedLandService.show_patron_info[:patron_running_status]).to eq "running"

      FlowPromisedLandService.logout
      expect(FlowPromisedLandService.show_patron_info[:status]).to eq "closed"
    end

  end


  it "BYEBUG whole gem" do
    skip "no test unless BYEBUG " unless ENV["BYEBUG"]
    byebug
  end


end
end
