var modifier_translation = {
	attack_magical: 'Magical Attack',
  attack_physical: 'Physical Attack',
  buff_duration_reduction: _render_stat('down', 'Buff Duration', 'inverse'),
  cooldown_decrease: _render_stat('down', 'Cooldown', 'inverse'),
  heal: 'Heal (Recover)',
  heal_magic_attack: 'Heal',
  heal_on_enemy_death: 'Heal on Enemy Death',
  immunity_to_all_damage: _render_immunity('All Damage'),
  immunity_to_all_debuff: _render_immunity('All Debuff'),
  immunity_to_death: _render_immunity('Death'),
  immunity_to_electrify: _render_immunity('Electrify'),
  immunity_to_magical_damage: _render_immunity('Magical Attack'),
  immunity_to_physical_damage: _render_immunity('Physical Attack'),
  immunity_to_silence: _render_immunity('Silence'),
  immunity_to_stun: _render_immunity('Stun'),
  inflict_blind: _render_inflict('Blind'),
  inflict_burn: _render_inflict('Burn'),
  inflict_chill: _render_inflict('Chill'),
  inflict_death: _render_inflict('Death'),
  inflict_electrify: _render_inflict('Electrify'),
  inflict_paralyze: _render_inflict('Paralyze'),
  inflict_silence: _render_inflict('Silence'),
  inflict_stun: _render_inflict('Stun'),
  leech_damage: 'Leech',
  reflect: 'Reflect',
  remove_buffs: 'Remove Buffs',
  remove_debuffs: 'Remove Debuffs',
  revive: 'Resurrect',
  skills_power_up: 'Power Up Skills',
  stat_block_rate_increase: _render_stat('up'),
  stat_counter_attack_rate_decrease: _render_stat('down', 'Counter Rate', 'inverse'),
  stat_counter_attack_rate_increase: _render_stat('up', 'Counter Rate', 'inverse'),
  stat_critical_rate_decrease: _render_stat('down', 'Critical Rate'),
  stat_critical_rate_increase: _render_stat('up', 'Critical Rate'),
  stat_damage_output_decrease: _render_stat('down', 'Damage Output'),
  stat_damage_output_increase: _render_stat('up', 'Damage Output'),
  stat_defense_decrease: _render_stat('up', 'Defense', 'inverse'),
  stat_defense_increase: _render_stat('down', 'Defense', 'inverse'),
  stat_healing_potency_decrease: _render_stat('down', 'Healing Potency', 'inverse'),
  stat_hp_increase: _render_stat('up', 'HP'),
  stat_incoming_damage_decrease: _render_stat('down', 'Damage Received'),
  stat_incoming_damage_increase: _render_stat('up', 'Damage Received'),
  stat_incoming_physical_damage_decrease: _render_stat('down', 'Physical Damage Received'),
  stat_lethal_rate_increase: _render_stat('up', 'Lethal Rate'),
  stat_magical_attack_increase: _render_stat('up', 'Magical Attack'),
  stat_magical_attack_increase_on_enemy_death: _render_stat('up', 'Magical Attack on Enemy Death'),
  stat_physical_attack_decrease: _render_stat('down', 'Physical Attack'),
  stat_physical_attack_increase: _render_stat('up', 'Physical Attack'),
  taunt: 'Taunt',
  untargettable: 'Untargettable',
};

function _render_attributes(a) {
	var s = '';

	$.each(a, function(effect, atb) {
		s += '<div class="panel panel-default condensed">'
			+    '<div class="panel-heading condensed" data-raw-effect="' + effect + '">' 
			+      _render_effect(effect)
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

function _render_effect(x) {
	return modifier_translation[x] || x;
}

function _render_modifier(mdfs) {
	var s = '';

	$.each(mdfs, function(mdf, val) {
	  var glyph_mdf = (function(mdf) {
	    switch(mdf) {
	      case 'fraction':      return 'filter';        break;
	      case 'turns':         return 'refresh';       break;
	      case 'probability':   return 'equalizer';     break;
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
	  	+    $.prettify_generic(glyph_mdf, s_val, mdf)
		  +  '</div>';
	});

	return s;
}

function _render_stat(_x, _stat, _inverse = false) {
	var color_class;
	var inverse = _inverse == 'inverse' ? true : false

	switch(_x) {
		case 'up': color_class = inverse ? 'text-danger' : 'text-success'; break;
		case 'down': color_class = inverse ? 'text-success' : 'text-danger'; break;
	}
	return '<span class="' + color_class + '">'
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