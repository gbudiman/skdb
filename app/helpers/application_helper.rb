module ApplicationHelper
  CLIENT = 'GA 1.0.46'
  VERSION = '0.3.8'

  def self.set_active s, _x
  	return s.current_page?(_x) ? 'active' : ''
  end

end
