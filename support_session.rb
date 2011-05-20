require "json"

class SupportSession
  attr_accessor :customer, :language
  
  def to_json
    {
      "support_session" => {
        "customer" => customer, 
        "language" => language
      }
    }.to_json
  end
  
  
end