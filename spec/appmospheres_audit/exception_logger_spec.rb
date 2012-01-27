require 'spec_helper'

describe AppmospheresAudit::SupportTrail do

  describe 'log_exception' do

    include AppmospheresAudit::SupportTrail

    it "should create an event log record" do
      expect { log_exception(Exception.new) }.to change(EventLog, :count).by(1)
    end

  end

end