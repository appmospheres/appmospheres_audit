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
    end

    describe "destroy" do
      it "should create an event log when a record is deleted" do
        expect { User.first.destroy }.to change(EventLog, :count).by(1)
      end
    end

  end

end