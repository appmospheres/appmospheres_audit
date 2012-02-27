require "active_record"
require "action_controller"

require "appmospheres_audit/version"
require "appmospheres_audit/event_log"

module AppmospheresAudit

  def self.configure
    yield(self) if block_given?
  end

  class << self

    # stores a hash of options given to the +configure+ block.
    def options
      @options ||= {}
    end

    # set or get the configuration parameters
    def method_missing(symbol, *args)
      if (method = symbol.to_s).sub!(/\=$/, '')
        options[method.to_sym] = args.first
      else
        options[method.to_sym]
      end
    end

  end

  module SupportTrail

    def log_exception(ex)
      begin
        EventLog.create!(:event_type => ex.class.to_s, :action => "exception", :payload => ex.backtrace.to_yaml)
      rescue
        Rails.logger.warn "Could not log event 'exception' for #{ex.class.to_s}:#{ex.backtrace.inspect}" rescue nil
      end
    end

  end

  module RecordTrail

    extend ActiveSupport::Concern

    module ClassMethods

      def enable_record_tracking
        # set up after filters for create/update/destroy
        after_create :track_create
        after_update :track_update
        after_destroy :track_destroy
      end

    end

    def track_create
      begin
        EventLog.create!(:event_type => self.class.to_s, :action => "create", :payload => self.id.to_yaml)
      rescue
        Rails.logger.warn "Could not log event 'create' for #{self.class.to_s}:#{self.id}" rescue true
      end
    end

    def track_update
      begin
        filtered_params = Rails.application.config.filter_parameters + (AppmospheresAudit.filter_parameters || [])
        EventLog.create!(:event_type => self.class.to_s, :action => "update",
          :payload => self.changes.merge({:id => self.id}).except(*filtered_params).to_yaml)
      rescue
        Rails.logger.warn "Could not log event 'update' for #{self.class.to_s}:#{self.changes.inspect}" rescue true
      end
    end

    def track_destroy
      begin
        filtered_params = Rails.application.config.filter_parameters + (AppmospheresAudit.filter_parameters || [])
        EventLog.create!(:event_type => self.class.to_s, :action => "destroy", :payload => self.serializable_hash.except(*filtered_params.map(&:to_s)).to_yaml)
      rescue
        Rails.logger.warn "Could not log event 'destroy' for #{self.class.to_s}:#{self.inspect}" rescue true
      end
    end

  end

  module ControllerTrail

    def self.included(base)
      base.extend ClassMethods
      base.send :include, AppmospheresAudit::SupportTrail
    end

    module ClassMethods

      def enable_action_tracking
        around_filter do |controller, action|
          begin
            begin
              filtered_actions = AppmospheresAudit.filter_actions || []
              unless filtered_actions.include?(controller.action_name.to_sym) || filtered_actions.include?(controller.action_name)
                filtered_params = Rails.application.config.filter_parameters + (AppmospheresAudit.filter_parameters || [])
                EventLog.create!(:event_type => 'controller', :action => controller.request.parameters[:action],
                  :payload => controller.request.parameters.except(*filtered_params).to_yaml)
              end
            rescue
              Rails.logger.warn "tracked #{controller.request.parameters.inspect}" rescue nil
            end
            action.call
          rescue Exception => e
            log_exception(e)
            raise # again, so the execution continues as intended by the app
          end
        end
      end

    end

  end

end

ActiveRecord::Base.class_eval do
  include AppmospheresAudit::RecordTrail
end

ActionController::Base.class_eval do
  include AppmospheresAudit::ControllerTrail
end
