require 'spec_helper'

describe AppmospheresAudit::ControllerTrail do

  describe "enable_action_tracking", :type => :request do

    it "should record every controller action when enabled" do
      expect { get '/users' }.to change(EventLog, :count).by(1)
    end

    it "should not track filtered actions" do
      AppmospheresAudit.filter_actions = [:index]
      expect { get '/users' }.not_to change(EventLog, :count)
    end

  end

end