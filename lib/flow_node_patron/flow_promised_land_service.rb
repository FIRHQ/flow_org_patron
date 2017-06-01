require_relative './flow_promised_land_rest'
require_relative './operations/flow_promised_land_box_operation'
require_relative './operations/flow_promised_land_patron_operation'
module FlowNodePatron
  class FlowPromisedLandService
    extend FlowPromisedLandBoxOperation
    extend FlowPromisedLandPatronOperation
  end
end
