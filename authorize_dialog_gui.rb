
# This class was automatically generated from XRC source. It is not
# recommended that this file is edited directly; instead, inherit from
# this class and extend its behaviour there.  
#
# Source file: authorize_dialog_gui.xrc 
# Generated at: 2011-05-09 20:24:55 +0200

class AuthorizeDialog < Wx::Dialog
	
	attr_reader :m_button1, :m_textctrl1, :m_button2
	
	def initialize(parent = nil)
		super()
		xml = Wx::XmlResource.get
		xml.flags = 2 # Wx::XRC_NO_SUBCLASSING
		xml.init_all_handlers
		xml.load("authorize_dialog_gui.xrc")
		xml.load_dialog_subclass(self, parent, "MyDialog3")

		finder = lambda do | x | 
			int_id = Wx::xrcid(x)
			begin
				Wx::Window.find_window_by_id(int_id, self) || int_id
			# Temporary hack to work around regression in 1.9.2; remove
			# begin/rescue clause in later versions
			rescue RuntimeError
				int_id
			end
		end
		
		@m_button1 = finder.call("m_button1")
		@m_textctrl1 = finder.call("m_textCtrl1")
		@m_button2 = finder.call("m_button2")
		if self.class.method_defined? "on_init"
			self.on_init()
		end
	end
end


