require_relative '../flow_promised_land_rest'

module FlowNodePatron
  module FlowPromisedLandBoxOperation
    # 去promised_land 拿出队的box info
    def fetch_outqueue_box
      answer = FlowPromisedLandRest.get "/#{specific_org_patrons_url}/fetch_outqueue_box", {}
      return nil if answer.dig(:json, :queue) == 'empty'
      answer
    end

    def get_box_info(box_id)
      FlowPromisedLandRest.get "/#{specific_org_patrons_url}/get_box_info", box_id: box_id
    end

    def closed_box?(box_id)
      answer = get_box_info(box_id)
      answer[:status] == 'closed'
    end

    def delete_box(id)
      FlowPromisedLandRest.post("/#{specific_org_patrons_url}/delete_box", box_id: id)
    end

    # 主要给测试用的函数，平时不要乱用
    def push_a_test_box
      FlowPromisedLandRest.post("/#{specific_org_patrons_url}/push_a_test_box", {})
    end

    def queue_list
      FlowPromisedLandRest.get("/#{specific_org_patrons_url}/queue_box_list")
    end

    private

    def specific_org_patrons_url
      "org_patrons/#{::FlowNodePatron::Config::PROMISED_LAND_ORG_PATRON_TOKEN}"
    end
  end
end
