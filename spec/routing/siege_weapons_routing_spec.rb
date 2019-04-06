require "rails_helper"

RSpec.describe Resources::SiegeWeaponsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/siege_weapons").to route_to("resources/siege_weapons#index")
    end

    it "routes to #show" do
      expect(:get => "/siege_weapons/1").to route_to("resources/siege_weapons#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/siege_weapons").to route_to("resources/siege_weapons#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/siege_weapons/1").to route_to("resources/siege_weapons#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/siege_weapons/1").to route_to("resources/siege_weapons#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/siege_weapons/1").to route_to("resources/siege_weapons#destroy", :id => "1")
    end
  end
end
