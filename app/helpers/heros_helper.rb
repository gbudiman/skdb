module HerosHelper
	def stack_tables
		return \
			[['Blind'				, 'Block Rate'	   						, :top				, :top		, :inflict_blind, :stat_block_rate, :bidir],
			 ['Electrify'		, 'Lethal Rate'		   		  		, nil					, nil   	, :inflict_electrify, :stat_lethal_rate, :bidir],
			 ['Paralyze'		, 'Critical Rate'		     			, nil					, :bottom	, :inflict_paralyze, :stat_critical_rate, :bidir],
			 ['Petrify'			, nil                         , nil					, nil 		, :inflict_petrify],
			 ['Silence'			, 'Debuff Immunity'						, nil					, :top		, :inflict_silence, :immunity_to_all_debuff],
			 ['Stun'				, 'Damage Immunity'						, :bottom			, nil  		, :inflict_stun, :immunity_to_all_damage],
			 [nil						, 'Physical Immunity'         , nil					, nil			, nil, :immunity_to_physical_damage],
			 ['Bleed'				, 'Magical Immunity'					, :top				, :bottom	, :inflict_bleed, :immunity_to_magical_damage],
			 ['Burn'				, nil													, nil					, nil   	, :inflict_burn],
			 ['Chill'				, 'Buff Removal'							, nil 				, :top		, :inflict_chill, :remove_buffs],
			 ['Death'				, 'Buff Duration Reduction'		, nil					, nil  		, :inflict_death, :buff_duration_reduction],
			 ['Poison'			, 'Debuff Removal'						, :bottom			, :bottom	, :inflict_poison, :remove_debuffs]]
	end

	def generate_ii_stack _h
		return capture_haml do
			haml_tag :div, class: "col-xs-2 synergy-#{_h[:side]}" do
				r = case _h[:position]
				when :top then "synergy-#{_h[:side]}-top"
				when :bottom then "synergy-#{_h[:side]}-bottom"
				else 'synergy-mid'
				end

				haml_tag :button, 
								 class: "btn btn-default disabled btn-block #{r}", 
								 id: "stack_#{_h[:name_id]}" do
					haml_concat _h[:stat]
				end
			end
		end
	end

	def generate_ss_stack _h
		return capture_haml do
			if _h[:bidir]
				haml_tag :div, class: 'col-xs-1 synergy-leading' do
					synergy_class = _h[:side] ? "synergy-leading-#{_h[:side]}" : 'synergy-mid'
					haml_tag :button,
									 class: "btn btn-default disabled btn-block #{synergy_class}",
									 id: "#{_h[:name_id]}_increase" do
						haml_tag :span, class: 'glyphicon glyphicon-arrow-up'
					end
				end

				haml_tag :div, class: 'col-xs-2 synergy-mid' do
					haml_tag :button,
									 class: 'btn btn-default disabled btn-block synergy-mid' do
						haml_concat _h[:name]
					end
				end

				haml_tag :div, class: 'col-xs-1 synergy-closing' do
					synergy_class = _h[:side] ? "synergy-closing-#{_h[:side]}" : 'synergy-mid'
					haml_tag :button,
									 class: "btn btn-default disabled btn-block #{synergy_class}",
									 id: "#{_h[:name_id]}_decrease" do
						haml_tag :span, class: 'glyphicon glyphicon-arrow-down'
					end
				end
			else
				haml_tag :div, class: 'col-xs-4' do
					haml_tag :button, 
									 class: "btn btn-default disabled btn-block synergy-#{_h[:side] || 'mid'}",
									 id: "stack_#{_h[:name_id]}" do
						haml_concat _h[:name]
					end
				end
			end
		end
	end
end
