
# This class was automatically generated from XRC source. It is not
# recommended that this file is edited directly; instead, inherit from
# this class and extend its behaviour there.  
#
# Source file: authorize_dialog_gui.xrc 
# Generated at: 2011-04-29 23:45:59 +0200

class AuthorizeDialog < Wx::Dialog
	
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
		
		if self.class.method_defined? "on_init"
			self.on_init()
		end
	end
end


