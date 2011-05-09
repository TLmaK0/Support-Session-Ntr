#!/c/Ruby192/bin/ruby
require "wx"
require "oauth"
require "launchy"
include Wx

require_relative "support_session_gui.rb"
require_relative "authorize_dialog_gui.rb"

#Token: LvzPzoQpg5cE5AgzR5yE
#Secret: AQRMeHZVhkM0NUaoBPeehlwXx9GawhX5vxX47Bii  
  
class SupportSession < App
  def on_init
    @consumer=OAuth::Consumer.new( "oSvqWJxkgZ2J66LM9gqo","ZhJc8EkSN8k2hk0FcyKNIfCSIrx3lVcahBSQpLDJ", {
      :site=>"http://apifree.ntrglobal.com"
    })

    if (access_token)
      open_support_session_window
    else
      open_authorize_window
    end
  end
  
  def access_token
    if !@access_token
      begin
        File.open("data.txt") do |f|  
          @access_token = Marshal.load(f)  
        end
      rescue
        $stderr.puts "No exists access token"
      end
    end
    @access_token
  end
  
  def open_support_session_window
    @ss_win = SupportSessionGUI.new
    @ss_win.show() 
    @ss_win.m_button2.evt_left_down() { |event| generate_session_code }
  end
  
  def open_authorize_window
    @auth_win = AuthorizeDialog.new
    @auth_win.m_button1.evt_left_down() { |event| authorize }
    @auth_win.m_button2.evt_left_down() { |event| validate }
    
    @auth_win.show()    
  end
  
  def authorize
    @request_token = @consumer.get_request_token
    Launchy.open(@request_token.authorize_url)
  end

  def validate
    @access_token = @request_token.get_access_token(:oauth_verifier => @auth_win.m_textctrl1.get_value)

    File.open('data.txt', 'w+') do |f|  
      Marshal.dump(@access_token, f)  
    end  
  end
 
  
  
  def generate_session_code
    result = @access_token.post("/support_sessions.xml", "", {'Content-type' => 'application/xml' })
    puts result.body
    puts result.inspect
  end
end

SupportSession.new.main_loop
