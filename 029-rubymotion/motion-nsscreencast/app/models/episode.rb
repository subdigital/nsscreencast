class Episode
  attr_accessor :title

  def initialize(attrs)
    attrs.each_pair do |key, value|
      self.send("#{key}=", value)
    end
  end

  def self.from_json(json)
    new(:title => json["title"])
  end
end
