module ApplicationHelper
  CLIENT = 'GA 1.0.51'
  VERSION = '0.3.14'

  def self.set_active s, _x
  	return s.current_page?(_x) ? 'active' : ''
  end

  def self.cumulative_unique_visit_to_date
    return Visitor.cumulative_unique_visit_to_date
  end

end
