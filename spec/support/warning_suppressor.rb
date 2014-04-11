# Suppresses certain warnings from Webkit output.
# Webkit is kind of a "hack": it uses webkit to simulate a browser in the back}
# in a fast and reliable way. It works very well, but it tends to generate an awful
# quantity of warnings that cannot be controlled.
# 
# This classes filters those warnings that do not add value and cannot be fixed. 
# 
# If you want to add or remove warnings to be filtered look into "write" method.
# 
# @author [despada]
# 
class WarningSuppressor
  class << self
    def write(message)
    	return 0 unless message.index("QFont::setPixelSize: Pixel size <= 0").nil?
    	return 0 unless message.index("GConf-WARNING **: Client failed to connect to the D-BUS daemon").nil?
    	return 0 unless message.index("WARNING **: Unable to create Ubuntu Menu Proxy:").nil?
    	return 0 unless message.index("Rack::File headers parameter").nil?
      return 0 unless message.index("QGtkStyle was unable to detect the current GTK+ theme").nil?

      puts(message)
      0
    end
  end
end

Capybara.register_driver :webkit_warning_filtered do |app|
	Capybara::Webkit::Driver.new(app, stderr: WarningSuppressor)
end