module FlowNodePatron
  module FlowPromisedLandPatronOperation
    def checkin
      logger.info 'checkin ... '
      FlowPromisedLandRest.post '/org_patrons/checkin',
                                org_patron_token: ::FlowNodePatron::Config::PROMISED_LAND_ORG_PATRON_TOKEN,
                                version: ::FlowNodePatron::Config::PATRON_VERSION
    end

    def logout
      logger.info 'logout ...'
      FlowPromisedLandRest.post "/org_patrons/#{::FlowNodePatron::Config::PROMISED_LAND_ORG_PATRON_TOKEN}/logout", {}
    end

    def update_report(patron_running_status, service_box_id = nil)
      logger.info "report patron_running_status #{patron_running_status} run box #{service_box_id}"
      FlowPromisedLandRest.post "/org_patrons/#{::FlowNodePatron::Config::PROMISED_LAND_ORG_PATRON_TOKEN}/update_report",
                                patron_running_status: patron_running_status,
                                service_box_id:       service_box_id
    end

    def show
      FlowPromisedLandRest.get "/org_patrons/#{::FlowNodePatron::Config::PROMISED_LAND_ORG_PATRON_TOKEN}"
    end

    alias show_patron_info show

    # DEBUG USE
    def list
      FlowPromisedLandRest.get '/org_patrons'
    end

    private

    def logger
      FlowNodePatron.logger
    end
  end
end
