require 'spec_helper'

describe AppmospheresAudit::RecordTrail do

  describe "enable_record_tracking" do

    before(:each) { User.create! }

    describe "create" do
      it "should create an event log when a new record is created" do
        expect { User.create! }.to change(EventLog, :count).by(1)
      end
    end

    describe "update" do

      it "should create an event log when a record is updated" do
        expect { User.first.update_attribute(:name, "") }.to change(EventLog, :count).by(1)
      end

      it "should not include filtered parameters in the event log payload" do
        AppmospheresAudit.filter_parameters = [:name]
        User.first.update_attribute(:name, "changed")
        changes = YAML::load(EventLog.where(:event_type => 'User', :action => 'update').last.payload)
        changes.should_not include(:name)
      end

    end

    describe "destroy" do

      it "should create an event log when a record is deleted" do
        expect { User.first.destroy }.to change(EventLog, :count).by(1)
      end

      it "should not include filtered parameters in the event log payload" do
        AppmospheresAudit.filter_parameters = [:name]
        User.first.destroy
        record = YAML::load(EventLog.where(:event_type => 'User', :action => 'destroy').last.payload)
        record.should_not include(:name)
      end

    end

  end

end