require 'rails_helper'

RSpec.describe TeamTemplate, type: :model do
  context "execution" do
    before :all do
      XlsxInterface.rebuild_database!
      TeamTemplate.destroy_all
      HeroTeam.destroy_all
    end

    describe "creation" do
      before :each do
        @team_name = 'test_123'
        @heros = ['karin_6', 'leo_6', 'jupy_6', 'bane_6', 'cleo_6']
        @heros_2 = ['karin_6', 'leo_6', 'shane_6', 'bane_6', 'cleo_6']
        @description = 'argh'
      end

      it "should be recorded properly" do
        TeamTemplate.rebuild name: @team_name, heros: @heros, description: @description

        expect(TeamTemplate.count).to eq(1)
        expect(HeroTeam.count).to eq(5)

        expect(TeamTemplate.first.name).to eq(@team_name)
        expect(TeamTemplate.first.description).to eq(@description)
      end

      it "should update existing team properly" do
        [@heros, @heros_2].each do |x|
          TeamTemplate.rebuild name: @team_name, heros: x, description: @description
        end

        expect(TeamTemplate.first.list_heros('heros.static_name').sort).to eq(@heros_2.sort)

        TeamTemplate.rebuild name: @team_name, heros: @heros_2
        expect(TeamTemplate.first.list_heros('heros.static_name').sort).to eq(@heros_2.sort)
      end

      it "should reject more a team with more than 5 heros" do
        team_exceed = @heros_2.dup
        team_exceed.push('lina_6')

        expect { TeamTemplate.rebuild name: @team_name, heros: team_exceed }.to raise_error(ArgumentError, /\Aat most only/i)
      end

      it "should reject when any one hero does not exist" do
        team = ['wtf_6']

        expect { TeamTemplate.rebuild name: 'fail', heros: team }.to raise_error(ActiveRecord::RecordNotFound, /\Ahero.+not found\z/i)
      end

      it "should be able to build with less than 5 teams" do
        team = ['karin_6', 'evan_6']

        TeamTemplate.rebuild name: 'duo', heros: team
        expect(HeroTeam.count).to eq(team.count)
      end

      context "data integrity" do
        before :each do
          TeamTemplate.rebuild name: @team_name, heros: @heros
        end

        it "should cascade hero destruction" do
          no_jupy = @heros.dup
          no_jupy.delete('jupy_6')
          expect(HeroTeam.count).to eq(5)

          Hero.find_by(static_name: 'jupy_6').destroy
          expect(TeamTemplate.first.list_heros('heros.static_name').sort).to eq(no_jupy.sort)
        end

        it "should cascade template destruction" do
          TeamTemplate.first.destroy

          expect(HeroTeam.count).to eq(0)
        end
      end
    end
  end
end
