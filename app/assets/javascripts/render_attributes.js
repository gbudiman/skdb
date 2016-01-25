var modifier_translation = {
	// attack_physical: 'Physical Damage',
	// attack_magical: 'Magical Damage',
	// inflict_stun: 'Stun',
	// stat_damage_decrease: render_stat('down') + ' Damage Output',
	// stat_defense_increase: render_stat('up') + ' Defense',
	// stat_incoming_damage_decrease: render_stat('down') + ' Damage Received'

	attack_magical: 'Physical Attack',
  attack_physical: 'Magical Attack',
  buff_duration_reduction: render_stat('down', 'inverse') + ' Buff Duration',
  cooldown_decrease: render_stat('down', 'inverse') + ' Cooldown',
  heal_magic_attack: 'Heal',
  heal_on_enemy_death: 'Heal on Enemy Death',
  immunity_to_all_damage: render_immunity('All Damage'),
  immunity_to_all_debuff: render_immunity('All Debuff'),
  immunity_to_death: render_immunity('Death'),
  immunity_to_electrify: render_immunity('Electrify'),
  immunity_to_magical_damage: render_immunity('Magical Attack'),
  immunity_to_physical_damage: render_immunity('Physical Attack'),
  immunity_to_silence: render_immunity('Silence'),
  immunity_to_stun: render_immunity('Stun'),
  inflict_blind: inflict('Blind'),
  inflict_burn: inflict('Burn'),
  inflict_chill: inflict('Chill'),
  inflict_death: inflict('Death'),
  inflict_electrify: inflict('Electrify'),
  inflict_paralyze: inflict('Paralyze'),
  inflict_silence: inflict('Silence'),
  inflict_stun: inflict('Stun'),
  leech_damage: 'Leech',
  reflect: 'Reflect',
  remove_buffs: 'Remove Buffs',
  remove_debuffs: 'Remove Debuffs',
  resurrect_hp: 'Resurrect',
  revive: 'Revive',
  skills_power_up: 'Power Up Skills',
  stat_block_rate_increase: render_stat('up') + ' Block Rate',
  stat_counter_attack_rate_decrease: render_stat('down') + ' Counter Rate',
  stat_counter_attack_rate_increase: render_stat('up') + ' Counter Rate',
  stat_critical_rate_decrease: render_stat('down') + ' Critical Rate',
  stat_critical_rate_increase: render_stat('up') + ' Critical Rate',
  stat_damage_output_decrease: render_stat('down') + ' Damage Output',
  stat_damage_output_increase: render_stat('up') + ' Damage Output',
  stat_defense_decrease: render_stat('up') + ' Defense',
  stat_defense_increase: render_stat('down') + ' Defense',
  stat_healing_potency_decrease: render_stat('down') + ' Healing Potency',
  stat_hp_increase: render_stat('up') + ' HP',
  stat_incoming_damage_decrease: render_stat('down', 'inverse') + ' Incoming Damage',
  stat_incoming_damage_increase: render_stat('up', 'inverse') + ' Incoming Damage',
  stat_incoming_physical_damage_decrease: render_stat('down', 'inverse') + ' Incoming Physical Damage',
  stat_lethal_rate_increase: render_stat('up') + ' Lethal Rate',
  stat_magical_attack_increase: render_stat('up') + ' Magical Attack',
  stat_magical_attack_increase_on_enemy_death: render_stat('up') + ' Magical Attack on Enemy Death',
  stat_physical_attack_decrease: render_stat('down') + ' Physical Attack',
  stat_physical_attack_increase: render_stat('up') + ' Physical Attack',
  taunt: 'Taunt',
  untargettable: 'Untargettable',
};

function render_attributes(a) {
	var s = '';

	$.each(a, function(effect, atb) {
		s += '<div class="panel panel-default condensed">'
			+    '<div class="panel-heading condensed">' 
			+      render_effect(effect)
			+    '</div>'
			+    '<div class="panel-body condensed">'
			+      '<div class="row">'
			+        '<div class="col-xs-6">'
			+          $.prettify_target(atb.target)
			+        '</div>'
			+			   render_modifier(atb.modifiers)
			+      '</div>'
			+    '</div>'
			+  '</div>';
	})

	return s;
}

function render_effect(x) {
	return modifier_translation[x] || x;
}

function render_modifier(mdfs) {
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
		  //+    '<span class="glyphicon glyphicon-' + glyph_mdf + '"></span>&nbsp;' + val
		  +  '</div>';
	});

	return s;
}

function render_stat(_x, _inverse = false) {
	var color_class;
	var inverse = _inverse == 'inverse' ? true : false

	switch(_x) {
		case 'up': color_class = inverse ? 'text-danger' : 'text-success'; break;
		case 'down': color_class = inverse ? 'text-success' : 'text-danger'; break;
	}
	return '<span class="' + color_class + '">'
	     +   '<span class="glyphicon glyphicon-arrow-' + _x + '"></span>'
	     + '</span>';
}

function render_immunity(_x) {
	return 'Immunity to ' + _x;
}

function inflict(_x) {
	return 'Inflict ' + _x;
}