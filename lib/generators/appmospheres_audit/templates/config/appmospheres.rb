AppmospheresAudit.configure do |config|
  # the parameters listed here will not be serialized in the event logs
  config.filter_parameters = [:password]
  # the actions listed here will not be recorded in the event logs
  #config.filter_actions = [:edit, :new]
end
