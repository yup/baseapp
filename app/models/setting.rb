class Setting < ActiveRecord::Base
  validates_presence_of :label
  validates_uniqueness_of :label
  validates_uniqueness_of :identifier
  
  # Story any kind of object in the value field.
  # This is nice, but you should also make it editable through admin/settings
  serialize :value
  
  def self.load(identifier)
    identifier = identifier.to_s if identifier.is_a?(Symbol)
    
    setting = find_by_identifier(identifier)
    if setting.nil?
      Setting.new(:identifier => identifier, :value => configatron.send(identifier.to_sym))
    else
      setting
    end
  end
  
  # Return the value for a setting
  def self.get(identifier)
    identifier = identifier.to_s if identifier.is_a?(Symbol)
    
    begin
      setting = find_by_identifier(identifier)
    rescue
      setting = nil
    end
    
    setting.nil? ? configatron.send(identifier.to_sym) : setting.value
  end
end
