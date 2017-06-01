module FlowNodePatron
  class FlowPromisedLandRest < Utils::LocalServiceRest
    class << self
      def basic_url
        Config::PROMISED_LAND_URL
      end

      def add_those_to_params
        {
          org_patron_token: Config::PROMISED_LAND_ORG_PATRON_TOKEN
        }
      end
    end
  end
end
