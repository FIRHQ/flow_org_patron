require 'aasm'
require 'thread'
require_relative './flow_promised_land_service'
require_relative './server_thread'
STDOUT.sync

module FlowNodePatron
  class Server
    include AASM
    include ServerThread
    attr_accessor :current_box_id

    aasm do
      state :idle, initial: true
      state :running
      state :cleaning

      after_all_transitions :report_message

      event :run do
        transitions from: :idle, to: :running
      end

      event :clean do
        transitions from: :running, to: :cleaning
      end

      event :reset do
        transitions from: :cleaning, to: :idle
        after do
          self.current_box_id = nil
        end
      end

      event :force_reset do
        transitions to: :idle
        after do
          self.current_box_id = nil
          File.delete('/tmp/clean_success.txt') if File.file?('/tmp/clean_success.txt')
        end
      end
    end

    def report_message
      FlowPromisedLandService.update_report(aasm.to_state, current_box_id)
    end

    def run_box_check
      # 当有执行的时候  直接返回
      return false unless may_run?

      answer = FlowPromisedLandService.fetch_outqueue_box
      return false if answer.nil? || answer[:id].nil? # 没拿到值
      self.current_box_id = answer[:id]
      run
      if block_given?
        yield(answer)
      else
        puts "拿到了出队的 box 的值#{answer}"
        true
      end
    end

    def clean_box_check
      return false unless may_clean?
      box_info = FlowPromisedLandService.get_box_info(current_box_id)
      return false unless box_info[:status] == 'closed'
      clean
      if block_given?
        yield box_info
      else
        puts '检测到了 box 关闭，patron 开始运行打扫程序...'
        true
      end
    end

    def reset_check
      tmp_id = current_box_id
      return false unless may_reset?

      while !File.file?('/tmp/clean_success.txt') && ENV['DEBUG'].nil?
        puts '没找到 /tmp/clean_success.txt 代表清理脚本还没执行完， sleep 5'
        sleep 5
      end
      puts 'clean 脚本执行完毕'
      File.delete('/tmp/clean_success.txt') if File.file?('/tmp/clean_success.txt')
      reset
      self.current_box_id = nil
      if block_given?
        yield tmp_id
      else
        puts '检测到了reset 。。。。'
        true
      end
    end

    def report_server_state
      puts "#{Time.now}: #{aasm_read_state}, current_box_id = #{current_box_id}"
      FlowPromisedLandService.update_report(aasm_read_state, current_box_id)
    end
  end
end
