module HerosHelper
	def stack_tables
		return \
			[['Blind'				, 'Block Rate'	   						, :top				, :top		, :blind, :stat_block_rate, :bidir],
			 ['Electrify'		, 'Lethal Rate'		   		  		, nil					, nil   	, :electrify, :stat_lethal_rate, :bidir],
			 ['Paralyze'		, 'Critical Rate'		     			, nil					, nil   	, :paralyze, :stat_critical_rate, :bidir],
			 ['Petrify'			, 'Skill Cooldown'            , nil					, :bottom	, :petrify, :cooldown, :bidir_reverse],
			 ['Silence'			, nil             						, nil					, nil	  	, :silence],
			 ['Stun'				, 'Debuff Immunity'						, :bottom			, :top  	, :stun, :immunity_to_all_debuff],
			 [nil						, 'Damage Immunity'           , nil					, nil			, nil, :immunity_to_all_damage],
			 ['Bleed'				, 'Physical Immunity'					, :top				, nil   	, :bleed, :immunity_to_physical_damage],
			 ['Burn'				, 'Magical Immunity'          , nil					, nil   	, :burn, :immunity_to_magical_damage],
			 ['Chill'				, '5-target AOE Immunity'			, nil 				, nil 		, :chill, :immunity_to_5_target_aoe],
			 ['Death'				, 'Buff Removal'		          , nil					, nil  		, :death, :remove_buffs],
			 ['Poison'			, 'Buff Duration Reduction'		, :bottom			, nil   	, :poison, :buff_duration_reduction],
			 [nil           , 'Debuff Removal'            , nil         , nil     , nil, :remove_debuffs],
			 [nil           , 'Piercing Damage'           , nil         , nil     , nil, :piercing_damage],
			 [nil           , 'Void Shield: Attack-Based' , nil         , nil     , nil, :void_shield_attack_based],
			 [nil           , 'Void Shield: Hit-Based'    , nil         , :bottom , nil, :void_shield_hit_based],
			]
	end

	def generate_ii_stack _h
		stat = { immunity_to: 'Immunity', inflict: 'Inflict'}
		return capture_haml do
			haml_tag :div, class: "col-xs-2 synergy-#{_h[:side]}" do
				r = case _h[:position]
				when :top then "synergy-#{_h[:side]}-top"
				when :bottom then "synergy-#{_h[:side]}-bottom"
				else 'synergy-mid'
				end

				haml_tag :button, 
								 class: "btn btn-default disabled btn-block #{r}", 
								 id: "stack_#{_h[:stat]}_#{_h[:name_id]}" do
					haml_concat stat[_h[:stat].to_sym]
				end
			end
		end
	end

	def generate_ss_stack _h
		return capture_haml do
			if _h[:bidir]
				left_id = "stack_#{_h[:name_id]}_" + (_h[:bidir] == :bidir ? 'increase' : 'decrease')
				right_id = "stack_#{_h[:name_id]}_" + (_h[:bidir] == :bidir ? 'decrease' : 'increase')
				left_arrow = 'glyphicon glyphicon-arrow-' + (_h[:bidir] == :bidir ? 'up' : 'down')
				right_arrow = 'glyphicon glyphicon-arrow-' + (_h[:bidir] == :bidir ? 'down' : 'up') 

				haml_tag :div, class: 'col-xs-1 synergy-leading' do
					synergy_class = _h[:side] ? "synergy-leading-#{_h[:side]}" : 'synergy-mid'
					haml_tag :button,
									 class: "btn btn-default disabled btn-block #{synergy_class}",
									 id: left_id do
						haml_tag :span, class: left_arrow
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
									 id: right_id do
						haml_tag :span, class: right_arrow
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
