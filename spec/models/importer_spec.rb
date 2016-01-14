require 'rails_helper'

RSpec.describe Importer, type: :model do
  before :each do
    @data_with_hero_error = [
      { static_data: 'rudy_4_0',
        hero_name: 'Guardian Rudy',
        skill_name: 'Rush',
        cooldown: 80,
        attributes: [
          { name: :attack_physical_fraction, target: :enemy_one, value: 180 },
          { name: :inflict_stun_turns, target: :enemy_one, value: 2 },
          { name: :inflict_stun_probability, target: :enemy_one, value: :certain_rate },
          { name: :buff_duration_reduction_turns, target: :enemy_one, value: 2 },
        ]
      },
      { static_data: 'rudy_5_0',
        hero_name: 'Guardian Rudy',
        skill_name: 'Rush',
        cooldown: 80,
        attributes: [
          { name: :attack_physical_fraction, target: :enemy_one, value: 200 },
          { name: :inflict_stun_turns, target: :enemy_one, value: 2 },
          { name: :inflict_stun_probability, target: :enemy_one, value: :certain_rate },
          { name: :buff_duration_reduction_turns, target: :enemy_one, value: 2 },
        ]
      },
    ]

    @data_with_duplicate_attribute = [
      { static_data: 'rudy_4_0',
        hero_name: 'Guardian Rudy',
        skill_name: 'Rush',
        cooldown: 80,
        attributes: [
          { name: :attack_physical_fraction, target: :enemy_one, value: 180 },
          { name: :inflict_stun_turns, target: :enemy_one, value: 2 },
          { name: :inflict_stun_probability, target: :enemy_one, value: :certain_rate },
          { name: :buff_duration_reduction_turns, target: :enemy_one, value: 2 },
          { name: :attack_physical_fraction, target: :enemy_one, value: 220 },
        ]
      },
    ]

    @data_with_skill_error = [
      { static_data: 'rudy_4_0',
        hero_name: 'Guardian Rudy',
        skill_name: 'Rush',
        cooldown: 80,
        attributes: [
          { name: :attack_physical_fraction, target: :enemy_one, value: 180 },
          { name: :inflict_stun_turns, target: :enemy_one, value: 2 },
          { name: :inflict_stun_probability, target: :enemy_one, value: :certain_rate },
          { name: :buff_duration_reduction_turns, target: :enemy_one, value: 2 },
        ]
      },
      { static_data: 'rudy_4_0',
        hero_name: 'Light Guardian Rudy',
        skill_name: 'Defense Preparation',
        cooldown: 74,
        attributes: [
          { name: :stat_incoming_damage_decrease_fraction, target: :self, value: 60 },
          { name: :immunity_to_all_debuff_turns, target: :self, value: 2 },
        ]
      },
    ]

    @data_with_non_uniform_skill_error = [
      { static_data: 'rudy_4_0',
        hero_name: 'Guardian Rudy',
        skill_name: 'Rush',
        cooldown: 80,
        attributes: [
          { name: :attack_physical_fraction, target: :enemy_one, value: 180 },
          { name: :inflict_stun_turns, target: :enemy_one, value: 2 },
          { name: :inflict_stun_probability, target: :enemy_one, value: :certain_rate },
          { name: :buff_duration_reduction_turns, target: :enemy_one, value: 2 },
        ]
      },
      { static_data: 'rudy_5_0',
        hero_name: 'Light Guardian Rudy',
        skill_name: 'Super Rush',
        cooldown: 80,
        attributes: [
          { name: :attack_physical_fraction, target: :enemy_one, value: 200 },
          { name: :inflict_stun_turns, target: :enemy_one, value: 2 },
          { name: :inflict_stun_probability, target: :enemy_one, value: :certain_rate },
          { name: :buff_duration_reduction_turns, target: :enemy_one, value: 2 },
        ]
      },
    ]

    @data = [
              { static_data: 'rudy_4_0',
                hero_name: 'Guardian Rudy',
                skill_name: 'Rush',
                cooldown: 80,
                attributes: [
                  { name: :attack_physical_fraction, target: :enemy_one, value: 180 },
                  { name: :inflict_stun_turns, target: :enemy_one, value: 2 },
                  { name: :inflict_stun_probability, target: :enemy_one, value: :certain_rate },
                  { name: :buff_duration_reduction_turns, target: :enemy_one, value: 2 },
                ]
              },
              { static_data: 'rudy_4_1',
                hero_name: 'Guardian Rudy',
                skill_name: 'Defense Preparation',
                cooldown: 74,
                attributes: [
                  { name: :stat_incoming_damage_decrease_fraction, target: :self, value: 60 },
                  { name: :immunity_to_all_debuff_turns, target: :self, value: 2 },
                ]
              },
              { static_data: 'rudy_4_2',
                hero_name: 'Guardian Rudy',
                skill_name: 'Sturdy Shield',
                cooldown: nil,
                attributes: [
                  { name: :stat_defense_increase_fraction, target: :ally_all, value: 40 },
                  { name: :stat_defense_increase_turns, target: :ally_all, value: :permanent }
                ]
              },
              { static_data: 'rudy_5_0',
                hero_name: 'Light Guardian Rudy',
                skill_name: 'Rush',
                cooldown: 80,
                attributes: [
                  { name: :attack_physical_fraction, target: :enemy_one, value: 200 },
                  { name: :inflict_stun_turns, target: :enemy_one, value: 2 },
                  { name: :inflict_stun_probability, target: :enemy_one, value: :certain_rate },
                  { name: :buff_duration_reduction_turns, target: :enemy_one, value: 2 },
                ]
              },
              { static_data: 'rudy_5_1',
                hero_name: 'Light Guardian Rudy',
                skill_name: 'Defense Preparation',
                cooldown: 74,
                attributes: [
                  { name: :stat_incoming_damage_decrease_fraction, target: :self, value: 70 },
                  { name: :immunity_to_all_debuff_turns, target: :self, value: 2 },
                ]
              },
              { static_data: 'rudy_5_2',
                hero_name: 'Light Guardian Rudy',
                skill_name: 'Sturdy Shield',
                cooldown: nil,
                attributes: [
                  { name: :stat_defense_increase_fraction, target: :ally_all, value: 50 },
                  { name: :stat_defense_increase_turns, target: :ally_all, value: :permanent }
                ]
              },
              { static_data: 'rudy_6_0',
                hero_name: 'Absolute Guardian Rudy',
                skill_name: 'Rush',
                cooldown: 80,
                attributes: [
                  { name: :attack_physical_fraction, target: :enemy_one, value: 230 },
                  { name: :inflict_stun_turns, target: :enemy_one, value: 2 },
                  { name: :inflict_stun_probability, target: :enemy_one, value: :certain_rate },
                  { name: :buff_duration_reduction_turns, target: :enemy_one, value: 2},
                ]
              },
              { static_data: 'rudy_6_1',
                hero_name: 'Absolute Guardian Rudy',
                skill_name: 'Defense Preparation',
                cooldown: 74,
                attributes: [
                  { name: :stat_incoming_damage_decrease_fraction, target: :self, value: 80 },
                  { name: :immunity_to_all_debuff_turns, target: :self, value: 2 },
                ]
              },
              { static_data: 'rudy_6_2',
                hero_name: 'Absolute Guardian Rudy',
                skill_name: 'Sturdy Shield',
                cooldown: nil,
                attributes: [
                  { name: :stat_defense_increase_fraction, target: :ally_all, value: 60 },
                  { name: :stat_defense_increase_turns, target: :ally_all, value: :permanent }
                ]
              },
            ]
  end

  context "validation" do
    it "should expect IndexError when same hero of different rank has identical name" do
      expect { Importer.new @data_with_hero_error }.to raise_error(IndexError)
    end

    it "should expect NameError when multiple skill name exists for one the same category" do
      expect { Importer.new @data_with_skill_error }.to raise_error(NameError)
    end

    it "should expect NameError when hero's skill of the same category has non-uniform name" do
      expect { Importer.new @data_with_non_uniform_skill_error}.to raise_error(NameError)
    end

    it "should expect IndexError when one attribute appears multiple time in a particular skill" do
      expect { Importer.new @data_with_duplicate_attribute}.to raise_error(IndexError)
    end
  end

  context "execution" do
    before :each do
      @imported_data = Importer.new @data
    end

    context "statistics" do
      it "should correctly reflect inserted heros" do
        expect { @imported_data.commit! }.to change{Hero.count}.by(@imported_data.stat[:heros].keys.count)
      end

      it "should correctly reflect inserted skills" do
        expect { @imported_data.commit! }.to change{Skill.count}.by(@imported_data.stat[:skills].keys.count)
      end

      it "should correctly reflect inserted attributes" do
        expect { @imported_data.commit! }.to change{Atb.count}.by(@imported_data.stat[:attributes].keys.count)
      end

      it "should correctly reflect inserted skill_attributes" do
        expect { @imported_data.commit! }.to change{SkillAtb.count}.by(@imported_data.stat[:skill_attribute_count])
      end
    end

    context "overwriting" do
      before :each do
        @imported_data.commit!
      end

      it "must be able to update hero" do
        new_data = [
          { static_data: 'rudy_4_0',
            hero_name: 'Haxxed Guardian Rudy',
            skill_name: 'Rush',
            cooldown: 80,
            attributes: [
              { name: :attack_physical_fraction, target: :enemy_one, value: 180 },
              { name: :inflict_stun_turns, target: :enemy_one, value: 2 },
              { name: :inflict_stun_probability, target: :enemy_one, value: :certain_rate },
              { name: :buff_duration_reduction_turns, target: :enemy_one, value: 2 },
            ]
          },
        ]

        old_row = Hero.find_by(static_name: 'rudy_4')
        Importer.new(new_data).commit!
        expect([old_row.name, Hero.find_by(static_name: 'rudy_4').name]).to eq [@imported_data.stat[:heros]['rudy_4'], 'Haxxed Guardian Rudy']
      end

      it "must be able to update skill" do
        new_data = [
          { static_data: 'rudy_4_0',
            hero_name: 'Guardian Rudy',
            skill_name: 'Mega Rush',
            cooldown: 80,
            attributes: [
              { name: :attack_physical_fraction, target: :enemy_one, value: 180 },
              { name: :inflict_stun_turns, target: :enemy_one, value: 2 },
              { name: :inflict_stun_probability, target: :enemy_one, value: :certain_rate },
              { name: :buff_duration_reduction_turns, target: :enemy_one, value: 2 },
            ]
          },
        ]

        old_row = Skill.find_by(static_name: 'rudy_4_0')
        Importer.new(new_data).commit!
        expect([old_row.name, Skill.find_by(static_name: 'rudy_4_0').name]).to eq [@imported_data.stat[:skills]['rudy_4_0'], 'Mega Rush']
      end

      it "must be able to clean-slate-update skill attributes" do
        new_data = [
          { static_data: 'rudy_4_0',
            hero_name: 'Guardian Rudy',
            skill_name: 'Rush',
            cooldown: 80,
            attributes: [
              { name: :inflict_burn_turns, target: :enemy_one, value: 2 },
              { name: :inflict_burn_probability, target: :enemy_one, value: :certain_rate },
            ]
          },
        ]

        Importer.new(new_data).commit!
        sab_ids = SkillAtb.where(skill_id: Skill.find_by(static_name: 'rudy_4_0')).pluck(:atb_id)
        atbs = Atb.where(id: sab_ids).pluck(:name)

        expect(atbs.sort).to eq(%w(inflict_burn_turns inflict_burn_probability).sort)
      end
    end
  end
end
