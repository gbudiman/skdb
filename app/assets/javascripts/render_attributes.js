var modifier_translation = {
	attack_magical: 'Magical Attack',
  attack_physical: 'Physical Attack',
  berserk: 'Zombie',
  buff_duration_reduction: _render_stat('down', 'Buff Duration', 'inverse'),
  cooldown_decrease: _render_stat('down', 'Cooldown', 'inverse'),
  heal: 'Heal (Recover)',
  heal_fraction_hp: 'Heal Fractional',
  heal_magic_attack: 'Heal',
  heal_on_enemy_death: 'Heal on Enemy Death',
  heal_upto_hp_fraction: 'Heal Up To',
  immunity_to_5_target_aoe: _render_immunity('5-target AoE'),
  immunity_to_all_damage: _render_immunity('All Damage'),
  immunity_to_all_debuff: _render_immunity('All Debuff'),
  immunity_to_all_debuff_on_enemy_death: _render_immunity('All Debuff on Enemy Death'),
  immunity_to_burn: _render_immunity('Burn'),
  immunity_to_chill: _render_immunity('Chill'),
  immunity_to_death: _render_immunity('Death'),
  immunity_to_electrify: _render_immunity('Electrify'),
  immunity_to_magical_damage: _render_immunity('Magical Attack'),
  immunity_to_paralyze: _render_immunity('Paralyze'),
  immunity_to_petrify: _render_immunity('Petrify'),
  immunity_to_physical_damage: _render_immunity('Physical Attack'),
  immunity_to_silence: _render_immunity('Silence'),
  immunity_to_stat_attrition_debuffs: _render_immunity('Stat Attrition'),
  immunity_to_stun: _render_immunity('Stun'),
  inflict_bleed: _render_inflict('Bleed'),
  inflict_blind: _render_inflict('Blind'),
  inflict_burn: _render_inflict('Burn'),
  inflict_chill: _render_inflict('Chill'),
  inflict_death: _render_inflict('Death'),
  inflict_electrify: _render_inflict('Electrify'),
  inflict_paralyze: _render_inflict('Paralyze'),
  inflict_petrify: _render_inflict('Petrify'),
  inflict_piercing: _render_inflict('Piercing'),  
  inflict_poison: _render_inflict('Poison'),
  inflict_silence: _render_inflict('Silence'),
  inflict_stun: _render_inflict('Stun'),
  leech_damage: 'Leech',
  reflect: 'Reflect',
  remove_buffs: 'Remove Buffs',
  remove_debuffs: 'Remove Debuffs',
  revive: 'Resurrect',
  skills_power_up: 'Power Up Skills',
  stat_block_rate_decrease: _render_stat('down', 'Block Rate'),
  stat_block_rate_increase: _render_stat('up', 'Block Rate'),
  stat_counter_attack_rate_decrease: _render_stat('down', 'Counter Rate'),
  stat_counter_attack_rate_increase: _render_stat('up', 'Counter Rate'),
  stat_critical_rate_decrease: _render_stat('down', 'Critical Rate'),
  stat_critical_rate_increase: _render_stat('up', 'Critical Rate'),
  stat_damage_output_decrease: _render_stat('down', 'Damage Output'),
  stat_damage_output_increase: _render_stat('up', 'Damage Output'),
  stat_defense_decrease: _render_stat('down', 'Defense'),
  stat_defense_increase: _render_stat('up', 'Defense'),
  stat_healing_potency_decrease: _render_stat('down', 'Healing Potency', 'inverse'),
  stat_hp_increase: _render_stat('up', 'HP'),
  stat_incoming_damage_decrease: _render_stat('down', 'Damage Received', 'inverse'),
  stat_incoming_damage_increase: _render_stat('up', 'Damage Received', 'inverse'),
  stat_incoming_magical_damage_decrease: _render_stat('down', 'Magical Damage Received', 'inverse'),
  stat_incoming_physical_damage_decrease: _render_stat('down', 'Physical Damage Received', 'inverse'),
  stat_lethal_rate_increase: _render_stat('up', 'Lethal Rate'),
  stat_magical_attack_decrease: _render_stat('down', 'Magical Attack', 'inverse'),
  stat_magical_attack_increase: _render_stat('up', 'Magical Attack'),
  stat_magical_attack_increase_on_enemy_death: _render_stat('up', 'Magical Attack on Enemy Death'),
  stat_physical_attack_decrease: _render_stat('down', 'Physical Attack'),
  stat_physical_attack_increase: _render_stat('up', 'Physical Attack'),
  stat_speed_decrease: _render_stat('down', 'Speed'),
  summon_avatars: 'Summon Avatars',
  taunt: 'Taunt',
  untargettable: 'Untargettable',
  void_shield_attack_based: 'Void Shield Attack-Based',
  void_shield_hit_based: 'Void Shield Hit-Based'
};

// Use http://localhost:2000/compare/52/61/157/55/166 to test
var modifier_title = {
  as_invincible_magical_damage_increase_fraction: '',
  as_invincible_physical_damage_increase_fraction: '',
  as_invincible_turns: '',
  proportional_increase_fraction: '',
  proportional_limit_fraction: '',
  continuous_physical_damage_fraction: '',
  continuous_magical_damage_fraction: '',
  aftershock_physical_damage_fraction: '',
  aftershock_magical_damage_fraction: '',
  add_damage_target_max_hp_fraction: '',
  with_ignore_defense_probability: '',
  with_critical_hit_probability: '',
  with_piercing_probability: '',
  on_counter_attack_amount: '',
  on_regular_attack_probability: '',
  on_regular_attack_amount: '',
  on_regular_attack_turns: '',
  on_speed_attack_amount: '',
  extra_damage_fraction: '',
  extra_damage_probability: '',
  fraction_of_defense: 'Fraction of DEF',
  on_hp_below_threshold_fraction: 'When HP drops below %',
  on_hp_below_threshold: 'Restores up to % of Max HP',
  hp_fraction: 'Fraction of Max HP',
  from_5_target_aoe_fraction: '',
  stat_original_fraction: '',
  fraction: 'Fraction of Stat',
  amount: 'Amount',
  turns: 'Turn Duration',
  probability: 'Probability',
  attack_count: 'Attack Count',
  hit_count: 'Hit Count',
  before_dying_invincible_turns: 'Turns of Invincibility',
  before_dying_critical_rate_increase_fraction: 'Critical Rate Increase',
  before_dying_counter_rate_increase_fraction: 'Counter Rate Increase'
}

function _render_modifier_title (x) {
  return modifier_title[x] || x;
}

function _render_attributes(a) {
	var s = '';

	$.each(a, function(effect, atb) {
		s += '<div class="panel panel-default condensed">'
			+    '<div class="panel-heading condensed" data-raw-effect="' + effect + '">' 
			+      _render_effect(effect, atb.target)
			+    '</div>'
			+    '<div class="panel-body condensed">'
			+      '<div class="row">'
			+        '<div class="col-xs-6">'
			+          $.prettify_target(atb.target)
			+        '</div>'
			+			   _render_modifier(atb.modifiers)
			+      '</div>'
			+    '</div>'
			+  '</div>';
	})

	return s;
}

function _render_effect(x, target) {
	var raw_render_wrap = modifier_translation[x] || x;

	if (raw_render_wrap.match(/text-danger/) && target.match(/^enemy/)) {
		if (raw_render_wrap.match(/text-danger/)) {
			raw_render_wrap = raw_render_wrap.replace(/text-danger/, 'text-success');
		} else if (raw_render_wrap.match(/text-success/)) {
			raw_render_wrap = raw_render_wrap.replace(/text-success/, 'text-danger');
		}
	}

	return raw_render_wrap;
}

function _render_modifier(mdfs) {
	var s = '';

	$.each(mdfs, function(mdf, val) {
    var s_mdf = _render_modifier_title(mdf);

	  var glyph_mdf = (function(mdf) {
	    switch(mdf) {
	      case 'fraction':      return 'filter';        break;
	      case 'turns':         return 'refresh';       break;
	      case 'probability':   return 'equalizer';     break;
        case 'attack_count':
	      case 'hit_count':     return 'scissors';      break;
	      case 'amount':        return 'superscript';   break;
	      default:              return 'question-sign';  
	    }
	  })(mdf);

	  var s_val = (function(val) {
	  	switch(val) {
	  		case 'guaranteed':    return '100%';          break;
	  		case 'massively':     return '~99%';					break;
	  		case 'very_high':     return '>90%';          break;
	  		case 'certain_rate':  return '50/50';         break;
	  		case 'permanent':     return '∞';             break;
	  		default:              return val;
	  	}
	  })(val);

	  s += '<div class="col-xs-6">'
	  	+    $.prettify_generic(glyph_mdf, s_val, s_mdf)
		  +  '</div>';
	});

	return s;
}

function _render_stat(_x, _stat, _inverse) {
  // IE hax
  _inverse = _inverse || false;

	var color_class;
	var inverse = _inverse == 'inverse' ? true : false

	switch(_x) {
		case 'up': color_class = inverse ? 'text-danger' : 'text-success'; break;
		case 'down': color_class = inverse ? 'text-success' : 'text-danger'; break;
	}
	return '<span class="' + color_class + ' realignable-arrow">'
	     +   '<span class="glyphicon glyphicon-arrow-' + _x + '"></span>'
       +   '&nbsp;'
       +   _stat
	     + '</span>';
}

function _render_immunity(_x) {
	return 'Immune: ' + _x;
}

function _render_inflict(_x) {
	return 'Inflict ' + _x;
}