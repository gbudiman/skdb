function stack_table_add(d) {
  $.each(d, function(i, e) {
  	// e.hero_id
  	$.each(e.skills, function(i, s) {
  		// s.name
  		// s.cooldown
  		$.each(s.attributes, function(atb, a) {
        if (a.name.match(/with_piercing/)) {
          populate_stack_table('piercing_damage', a, e, s);
        }

  			if ($('#stack_' + atb).length == 1) {
          populate_stack_table(atb, a, e, s);
      //     var overwrite;
  				// that = $('#stack_' + atb).attr('data-contributor');

  				// if (that == undefined) {
  				// 	overwrite = {};
  				// } else {
      //       overwrite = $.parseJSON(that);
      //     }
  					
  				// overwrite[e.hero_id] = {}
  				// overwrite[e.hero_id][s.name] = { hero_name: e.hero_name,
      //                                      hero_rank: e.hero_rank,
      //                                      skill_cooldown: s.cooldown, 
      //                                      skill_category: s.category,
      //                                      atb_target: a.target }


  				// $('#stack_' + atb).attr('data-contributor', JSON.stringify(overwrite));
      //     $('#stack_' + atb).update_stack_cell();
  				// $('#stack_' + atb)
  				// 	.removeClass('disabled btn-default')
						// .addClass('btn-success');

					// $.parseJSON($('#stack_' + atb).attr('data-contributor'));

  			}
  		})
  	})
  })
}

function populate_stack_table(atb, a, e, s) {
  var overwrite;
  var maybe_vs_attack_based;
  var maybe_vs_hit_based;
  that = $('#stack_' + atb).attr('data-contributor');

  if (that == undefined) {
    overwrite = {};
  } else {
    overwrite = $.parseJSON(that);
  }

  if (a.name.match(/void_shield_attack_based/)) {
    maybe_vs_attack_based = a.modifiers.attack_count;
  }

  if (a.name.match(/void_shield_hit_based/)) {
    maybe_vs_hit_based = a.modifiers.hit_count;
  }
    
  overwrite[e.hero_id] = {}
  overwrite[e.hero_id][s.name] = { hero_name: e.hero_name,
                                   hero_rank: e.hero_rank,
                                   skill_cooldown: s.cooldown, 
                                   skill_category: s.category,
                                   atb_target: a.target,
                                   maybe_amount: a.modifiers.amount || a.modifiers.on_regular_attack_amount,
                                   maybe_fraction: a.modifiers.fraction,
                                   maybe_turn: a.modifiers.turns,
                                   maybe_vs_attack_based: maybe_vs_attack_based, 
                                   maybe_vs_hit_based: maybe_vs_hit_based,
                                   maybe_vs_attack: a.modifiers }


  $('#stack_' + atb).attr('data-contributor', JSON.stringify(overwrite));
  $('#stack_' + atb).update_stack_cell();
  $('#stack_' + atb)
    .removeClass('disabled btn-default')
    .addClass('btn-success');
}

function stack_table_remove(id) {
  $('button[data-contributor]').each(function() {
    var target = $(this);
    var that = $.parseJSON(target.attr('data-contributor'));

    //console.log('cycling through ' + target.text() + ' hunting for ' + id);

    if (that[id]) {
      delete that[id];

      var overwrite = JSON.stringify(that);
      
      target.attr('data-contributor', overwrite);
      target.update_stack_cell();

      //console.log('eliminated and updated');
      //console.log($.parseJSON(target.attr('data-contributor')));

      if (overwrite == '{}') {
        target
          .removeClass('btn-success')
          .addClass('disabled btn-default');
      }
    }
  });
}

function update_stack_cell(el) {
  var expand = { count: 0 };

  if (el.attr('data-contributor') != '{}') {
    el.popover({
      container: 'body',
      //content: _expand_stack_cell_content(el),
      html: true,
      placement: 'top',
      trigger: 'hover'
    });

    expand = _expand_stack_cell_content(el)
    el.attr('data-content', expand.content);
  }

  mark_stacking_attributes(el, expand);
}

function mark_stacking_attributes(_el, _expand) {
  _el.find('.glyphicon-exclamation-sign').remove();
  if (_expand.count > 1) {
    _el.append('<span class="glyphicon glyphicon-exclamation-sign"></span>');
  }
}

function _expand_stack_cell_content(d) {
  var content = $.parseJSON(d.attr('data-contributor'));
  var s_content = '<div class="list-group">';
  var count = 0;

  $.each(content, function(i, x) {
    count++;
    $.each(x, function(skill_name, skill_data) {
      var extra = new Array();

      if (skill_data.maybe_fraction != undefined) {
        extra.push($.prettify_generic('filter', skill_data.maybe_fraction, 'DPS (%)'));
      }

      if (skill_data.maybe_turn != undefined) {
        extra.push($.prettify_generic('refresh', skill_data.maybe_turn, 'Duration (Turns)'));
      }

      if (skill_data.maybe_vs_attack_based != undefined) {
        extra.push($.prettify_generic('scissors', skill_data.maybe_vs_attack_based));
      }

      if (skill_data.maybe_vs_hit_based != undefined) {
        extra.push($.prettify_generic('scissors', skill_data.maybe_vs_hit_based));
      }

      if (skill_data.maybe_amount != undefined) {
        extra.push($.prettify_generic('filter', skill_data.maybe_amount));
      }

      s_content += '<a href="#" class="list-group-item">'
                +    '<div class="row">'
                +      '<div class="col-xs-12">'
                +        skill_data.hero_name.strip_hero_rank()
                +        '<span class="pull-right">'
                +          $.prettify_target(skill_data.atb_target)
                +          '&nbsp;'
                +          extra.join('&nbsp;')
                +        '</span>'
                +      '</div>'
                +      '<div class="col-xs-12">'
                +        '<strong>' + skill_name + '</strong>'
                +        '<span class="pull-right">'
                +          $.prettify_skill(skill_data.skill_category, skill_data.skill_cooldown)
                +        '</span>'
                +      '</div>'
                +    '</div>'
                +  '</a>';
    })
  })

  s_content += '</div>';

  return { count: count, content: s_content }
}