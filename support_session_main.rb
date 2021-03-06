#!/c/Ruby192/bin/ruby
require "wx"
require "oauth"
require "launchy"
require "json"

include Wx

require_relative "support_session_gui.rb"
require_relative "authorize_dialog_gui.rb"

class SupportSessionMain < App
  URL_BASE_RC = "http://free.ntrglobal.com/main2/ntradmin.web.services/remotecontrol/downloadoperatorexe/?lang=en&code="

  def on_init
    @consumer=OAuth::Consumer.new( "moG9ePnMKDt6m4CmtmuH","lKhGVemDACIDY45F5xs8m8XYBRrgpFaHfgeStXUG", {
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
    @ss_win.m_button21.evt_left_down() { |event| send_email }
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

    open_support_session_window
  end
 
  def send_email
    @support_session ={
      "support_session" => {
        "customer_mail" => @ss_win.m_textctrl21.get_value
      }
    }
    
    result = @access_token.put(@support_session_url, @support_session.to_json, {'Content-type' => 'application/json' })
  end
  
  def generate_session_code
    @support_session =  {
      "support_session" => {
        "customer" => "test", 
        "language" => "en"
      }
    }.to_json
    
    result = @access_token.post("/support_sessions.json", @support_session, {'Content-type' => 'application/json' })
$stderr.puts result
    @support_session_url = "#{result["Location"]}"
    result = @access_token.get("#{@support_session_url}.json")
    
    @support_session = JSON.parse(result.body)
    
    code = @support_session["support_session"]["code"]
    @ss_win.m_textctrl2.value = code
    @ss_win.m_hyperlink1.url = "#{URL_BASE_RC}#{code}"
  end
end

SupportSessionMain.new.main_loop
