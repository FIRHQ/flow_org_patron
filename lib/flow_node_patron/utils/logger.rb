module FlowNodePatron
  module Utils
    module Logger
      extend ActiveSupport::Concern
      class_methods do
        def logger
          return @log unless @log.nil?
          create_log
        end

        def create_log(param = nil)
          @log = case param
                 when 'stdout'
                   ::Logger.new IO::STDOUT
                 when 'stderr'
                   ::Logger.new IO::STDERR
                 else
                   file = File.new('flow_node_patron.log', 'a')
                   file.sync = true
                   logger = ::Logger.new file
                   logger
                 end
        end
      end
    end
  end
end
