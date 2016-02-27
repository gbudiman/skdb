class SkillAtb < ActiveRecord::Base
  enum target: [ :self,
                 :ally_single, :ally_all,
                 :enemy_one, :enemy_two, :enemy_three, :enemy_four, :enemy_all,
                 :attacker ]

  validates :value, :target, presence: true, strict: ActiveRecord::StatementInvalid

  belongs_to :skill
  validates :skill, presence: true, strict: ActiveRecord::StatementInvalid

  belongs_to :atb
  validates :atb, presence: true, strict: ActiveRecord::StatementInvalid
end
