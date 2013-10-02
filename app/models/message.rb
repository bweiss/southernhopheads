class Message
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :name, :email, :content

  validates :email, :presence => true,
                    :format => { :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i },
                    :length => { :maximum => 200 }
  validates :content, :presence => true, :length => { :maximum => 2000 }

  def self.attr_accessor(*vars)
    @attributes ||= []
    @attributes.concat( vars )
    super
  end

  def self.attributes
    @attributes
  end

  def initialize(attributes={})
    attributes && attributes.each do |name, value|
      send("#{name}=", value) if respond_to? name.to_sym 
    end
  end

  def persisted?
    false
  end

  def self.inspect
    "#<#{ self.to_s} #{ self.attributes.collect{ |e| ":#{ e }" }.join(', ') }>"
  end
end