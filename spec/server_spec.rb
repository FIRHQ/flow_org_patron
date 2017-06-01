require 'spec_helper'

module FlowNodePatron
  RSpec.describe Server do
    before(:each) do
      # 清除测试队列的影响
      FlowPromisedLandService.queue_list.map do |info|
        FlowPromisedLandService.delete_box(info[:id]) if info[:name] == 'patrontestdata'
      end
      expect(FlowPromisedLandService.queue_list.count).to eq 0
      @server = Server.new
      File.delete('/tmp/clean_success.txt') if File.file?('/tmp/clean_success.txt')
    end

    it 'could puts state' do
      string_io = StringIO.new
      $stdout = string_io
      @server.report_server_state
      expect($stdout.string.length > 0).to eq true
      $stdout = STDOUT
    end


    it 'could run box check correctly (IN DEBUG MODE)' do
      skip unless ENV['DEBUG']

      expect(@server.run_box_check).to eq false

      FlowPromisedLandService.push_a_test_box
      expect(FlowPromisedLandService.queue_list.count).to eq 1

      # 在有数据的时候拿数据，此时应该可以拿到限制
      box_check_answer = @server.run_box_check do |_box|
        'test answer'
      end
      expect(box_check_answer).to eq 'test answer'

      # 且此时的状态应该是 running
      expect(@server.aasm_read_state).to eq :running

      # 再次拿状态的时候，会因为状态 为running 而直接返回false
      expect(FlowPromisedLandService.queue_list.count).to eq 0
      FlowPromisedLandService.push_a_test_box
      expect(@server.run_box_check).to eq false
      expect(FlowPromisedLandService.queue_list.count).to eq 1

      # 当清空 state 后，则可以继续执行
      @server.clean
      @server.reset
      expect(@server.run_box_check).to eq true
      expect(FlowPromisedLandService.queue_list.count).to eq 0
    end

    it 'could clean workspace  (IN DEBUG MODE)' do
      skip unless ENV['DEBUG']

      FlowPromisedLandService.push_a_test_box

      expect(@server.clean_box_check). to eq false

      info = @server.run_box_check do |box|
        box
      end
      expect(@server.aasm_read_state).to eq :running
      expect(@server.clean_box_check).to eq false

      FlowPromisedLandService.delete_box(info[:id])
      clean_box = nil
      @server.clean_box_check do |box|
        clean_box = box
      end
      expect(clean_box[:id]).to eq info[:id]
    end

    it 'could reset server state (IN DEBUG MODE)' do
      skip unless ENV['DEBUG']

      FlowPromisedLandService.push_a_test_box
      info = @server.run_box_check do |box|
        box
      end
      FlowPromisedLandService.delete_box(info[:id])

      @server.clean_box_check
      @server.reset_check
      expect(@server.aasm_read_state).to eq :idle

      FlowPromisedLandService.push_a_test_box
      info = @server.run_box_check do |box|
        box
      end
      FlowPromisedLandService.delete_box(info[:id])

      @server.clean_box_check

      @server.reset_check {}
      expect(@server.aasm_read_state).to eq :idle
    end

    it 'could report info correctly(IN DEBUG MODE)' do

      skip unless ENV['DEBUG']
      FlowPromisedLandService.push_a_test_box
      info = @server.run_box_check do |box|
        box
      end
      patron_info = FlowPromisedLandService.show_patron_info
      expect(patron_info[:patron_running_status]).to eq "running"
      FlowPromisedLandService.delete_box(info[:id])

      @server.clean_box_check
      @server.reset_check {}
      patron_info = FlowPromisedLandService.show_patron_info
      expect(patron_info[:patron_running_status]).to eq "idle"
    end
  end
end
