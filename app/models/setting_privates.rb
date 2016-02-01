class SettingPrivates < Settingslogic
  source "#{Rails.root}/config/setting_privates.yml"
  namespace Rails.env
end
