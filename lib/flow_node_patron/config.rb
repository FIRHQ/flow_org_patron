require 'socket'
require_relative './version'

module FlowNodePatron
  module Config
    PROMISED_LAND_ORG_PATRON_TOKEN = ENV['PROMISED_LAND_ORG_PATRON_TOKEN'] 

    HTTP_PROTOCOL = ENV['HTTP_PROTOCOL'] || 'http'
    PROMISED_LAND_URL = ENV['PROMISED_LAND_URL'] || "#{HTTP_PROTOCOL}://lyon.flow.ci:6690"

    # 获取patron 的名称, 以后严格的时候不给名称不让启动，或者不匹配成功不让启动
    PATRON_LOG_LEVEL = ENV['PATRON_LOG_LEVEL'] || 'INFO'
    PATRON_LOOP_RUN_CHECK_SECONDS = ENV['PATRON_LOOP_RUN_CHECK_SECONDS'].nil? ? 5 : ENV['PATRON_LOOP_RUN_CHECK_SECONDS'].to_i
    PATRON_AUTO_REPORT_SECONDS = ENV['PATRON_AUTO_REPORT_SECONDS'].nil? ? 60 : ENV['PATRON_AUTO_REPORT_SECONDS'].to_i

    PATRON_LOCAL_IP = ENV['PATRON_LOCAL_IP'] ||
                      Socket.ip_address_list.map(&:ip_address).find { |p| p.start_with?('192', '172') }
    PATRON_RUNNING_SCRIPT_FILE = ENV['PATRON_RUNNING_SCRIPT_URI'] || '~/patron_running_script.sh'
    PATRON_CLEAN_SCRIPT_FILE = ENV['PATRON_CLEAN_SCRIPT_URI'] || '~/patron_clean_script.sh'
    PATRON_RESET_SCRIPT_FILE = ENV['PATRON_RESET_SCRIPT_URI'] || '~/patron_reset_script.sh'
    PATRON_VERSION = ::FlowNodePatron::VERSION
  end
end
