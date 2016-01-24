var modifier_translation = {
	attack_physical: 'Physical Damage',
	attack_magical: 'Magical Damage',
	inflict_stun: 'Stun',
	stat_damage_decrease: render_stat('down') + ' Damage Output',
	stat_defense_increase: render_stat('up') + ' Defense',
	stat_incoming_damage_decrease: render_stat('down') + ' Damage Received'
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
	  		case 'certain_rate':  return '50/50';         break;
	  		case 'permanent':     return '∞';             break;
	  		default:              return val;
	  	}
	  })(val);

	  s += '<div class="col-xs-6">'
	  	+    $.prettify_generic(glyph_mdf, s_val)
		  //+    '<span class="glyphicon glyphicon-' + glyph_mdf + '"></span>&nbsp;' + val
		  +  '</div>';
	});

	return s;
}

function render_stat(_x) {
	var color_class;

	switch(_x) {
		case 'up': color_class = 'text-success'; break;
		case 'down': color_class = 'text-danger'; break;
	}
	return '<span class="' + color_class + '">'
	     +   '<span class="glyphicon glyphicon-arrow-' + _x + '"></span>'
	     + '</span>';
}