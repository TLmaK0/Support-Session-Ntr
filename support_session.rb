require "wx"
require "oauth"
require "launchy"
#!/c/Ruby192/bin/ruby
include Wx

require_relative "support_session_gui.rb"
require_relative "authorize_dialog_gui.rb"

#Token: LvzPzoQpg5cE5AgzR5yE
#Secret: AQRMeHZVhkM0NUaoBPeehlwXx9GawhX5vxX47Bii  
  
class SupportSession < App
  def on_init
@token = "LvzPzoQpg5cE5AgzR5yE"
@secret = "AQRMeHZVhkM0NUaoBPeehlwXx9GawhX5vxX47Bii"


    @gui = AuthorizeDialog.new
    @gui.show()

    @consumer=OAuth::Consumer.new( "oSvqWJxkgZ2J66LM9gqo","ZhJc8EkSN8k2hk0FcyKNIfCSIrx3lVcahBSQpLDJ", {
      :site=>"http://apifree.ntrglobal.com"
    })


    
    # @request_token = @consumer.get_request_token
    
    @gui.m_button2.evt_left_down() { | event | click(event) }
    
    # Launchy.open(@request_token.authorize_url)
    
  end

  def generate_code
    
  end

  def click(e)
    #@access_token = @request_token.get_access_token(:oauth_verifier => @gui.m_textctrl2.get_value)
    File.open('data.txt') do |f|  
      @access_token = Marshal.load(f)  
    end
    
    if !@access_token
      puts "storing new token"
      @access_token = OAuth::AccessToken.new(@consumer, @token, @secret)

      File.open('data.txt', 'w+') do |f|  
        Marshal.dump(@access_token, f)  
      end  
    end
    
    puts @access_token.get("/users.xml")
    
  end
  
  def store_consumer
  end
end
SupportSession.new.main_loop
