require "rails_helper"

RSpec.describe Resources::CastlesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/castles").to route_to("resources/castles#index")
    end

    it "routes to #show" do
      expect(:get => "/castles/1").to route_to("resources/castles#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/castles").to route_to("resources/castles#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/castles/1").to route_to("resources/castles#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/castles/1").to route_to("resources/castles#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/castles/1").to route_to("resources/castles#destroy", :id => "1")
    end
  end
end
