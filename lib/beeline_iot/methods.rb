# frozen_string_literal: true

module BeelineIot
  module Methods
    def sim_list(dashboard_id, params = {})
      request(:post, "/api/v0/dashboards/#{dashboard_id}/sim_cards/list_all_sim", params)
    end

    def get_sims(dashboard_id, sim_id, params = {})
      request(:get, "/api/v0/dashboards/#{dashboard_id}/sim_cards/#{sim_id}", params)
    end

    def rate_plans(dashboard_id, params = {})
      request(:post, "/api/v0/dashboards/#{dashboard_id}/rate_plans", params)
    end

    def communication_plans(dashboard_id, params = {})
      request(:post, "/api/v0/dashboards/#{dashboard_id}/communication_plans", params)
    end
  end
end
