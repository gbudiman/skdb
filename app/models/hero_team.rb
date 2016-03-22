class HeroTeam < ActiveRecord::Base
  belongs_to :hero
  validates :hero, presence: true

  belongs_to :team_template
  validates :team_template, presence: true

  validate :has_at_most_five_heroes

private
  def has_at_most_five_heroes
    s = HeroTeam.where team_template_id: self.team_template_id
    raise ActiveRecord::StatementInvalid, "At most 5 heroes may be assigned to a template" if s.length > 5
  end
end
