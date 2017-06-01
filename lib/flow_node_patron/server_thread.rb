module FlowNodePatron
  module ServerThread
    def init
      yield if block_given?
      threads = []
      threads << build_run_box_check_thread
      threads << build_clean_box_check_thread
      threads << build_report_thread

      begin
        threads.each(&:join)
      rescue Interrupt => _e
        FlowPromisedLandService.logout
        logger.warn 'user Interrupt, logout'
        puts '退出...'
      end
    end

    def logger
      ::FlowNodePatron.logger
    end

    private

    def build_report_thread
      Thread.new do
        loop_run(:report_server_state, ::FlowNodePatron::Config::PATRON_AUTO_REPORT_SECONDS)
      end
    end

    def build_clean_box_check_thread
      my_proc = proc do
        begin
          loop_run(:clean_box_check) do |box|
            puts '检测到了关闭box， 运行清道夫。。。。'
            logger.debug '检测到了关闭box， 运行清道夫。。。。'
            system("bash #{::FlowNodePatron::Config::PATRON_CLEAN_SCRIPT_FILE} \
             #{box[:id]} #{box[:job_id]} #{box[:job_hash]} #{box[:flow_id]} #{box[:project_id]} #{box[:org_id]} &")
            reset_check do
              system("bash #{::FlowNodePatron::Config::PATRON_RESET_SCRIPT_FILE} &")
            end
          end
        rescue => e
          puts "e #{e.message}"
          logger.error "e #{e.message}"
        end
      end
      if ENV['LOOP_RUN_DEBUG']
        my_proc.call
      else
        Thread.new(&my_proc)
      end
    end

    def build_run_box_check_thread
      my_proc = proc do
        loop_run(:run_box_check) do |box|
          puts "进来了一个 box ,box id = #{box[:id]}"
          logger.debug "进来了一个 box ,box id = #{box[:id]}"
          system("bash #{::FlowNodePatron::Config::PATRON_RUNNING_SCRIPT_FILE} \
          #{box[:id]} #{box[:job_id]} #{box[:job_hash]} #{box[:flow_id]} #{box[:project_id]} #{box[:org_id]} &")
        end
      end
      if ENV['LOOP_RUN_DEBUG']
        my_proc.call
      else
        Thread.new(&my_proc)
      end
    end

    def loop_run(method_name, sleep_time = ::FlowNodePatron::Config::PATRON_LOOP_RUN_CHECK_SECONDS, &hook)
      if sleep_time <= 0
        logger.warn "method #{method_name} wants to loop run less sleeping 0 second, cancel it."
        return
      end
      loop do
        begin
          send method_name, &hook
        rescue => e
          logger.error "e #{e.class} #{e.message}"
          logger.error e.backtrace.join("\n")
          raise e if ENV['DEBUG']
          STDERR.puts e.backtrace.join("\n")
        end
        sleep sleep_time
        break if ENV['LOOP_RUN_DEBUG']
      end
    end
  end
end
