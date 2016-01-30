module HerosHelper
	def stack_tables
		return \
			[['Blind'				, 'Block Rate Up'							, :top				, :top		],
			 ['Electrify'		, 'Lethal Rate Up'						, nil					, nil   	],
			 ['Paralyze'		, 'Critical Rate Up'					, nil					, :bottom	],
			 ['Petrify'			, nil                         , nil					, nil 		],
			 ['Silence'			, 'Debuff Immunity'						, nil					, :top		],
			 ['Stun'				, 'Damage Immunity'						, :bottom			, nil  		],
			 [nil						, 'Physical Immunity'         , nil					, nil			],
			 ['Bleed'				, 'Magical Immunity'					, :top				, :bottom	],
			 ['Burn'				, nil													, nil					, nil   	],
			 ['Chill'				, 'Buff Removal'							, nil 				, :top		],
			 ['Death'				, 'Buff Duration Reduction'		, nil					, nil  		],
			 ['Poison'			, 'Debuff Removal'						, :bottom			, :bottom	]]
	end

	def derive_id _name, _stat = nil
		name = _name.downcase.gsub(/\s+/, '_')

		if _stat
			return "#{name}_#{_stat.downcase}"
		else
			return name
		end
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
								 id: derive_id(_h[:name], _h[:stat]) do
					haml_concat _h[:stat]
				end
			end
		end
	end

	def generate_ss_stack _h
		return capture_haml do
			haml_tag :button, 
							 class: "btn btn-default disabled btn-block synergy-#{_h[:side] || 'mid'}",
							 id: derive_id(_h[:name]) do
				haml_concat _h[:name]
			end
		end
	end
end
