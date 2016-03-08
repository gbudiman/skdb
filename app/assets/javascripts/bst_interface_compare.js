function initialize_compare_table_bst() {
  $('#mismatched-preloads').parent().parent().hide();
  
  $('#compare-table').show().bootstrapTable({
    onPostBody: function() {
      $('#compare-table').parent().css('height', '64vh');
    }
  });

  $('#toolbar').show();
  $('.stack-table').show();

  $('#permalink').off('click').on('click', function() {
    $(this).select();
  })

  $('#permalink-addon').tooltip({
    container: 'body',
    placement: 'bottom'
  });

  $('#btn-maximize-compare').off('click').on('click', function() { $.maximize_compare(); });
  $('#btn-remove-all-compare').off('click').on('click', function() { $.remove_all_compare(); });
}

function attach_column_remove() {
  $('a.compare-remove').each(function() {
    var placeholder = $(this);

    placeholder.attr('title', 'Remove').off('click').on('click', function() {
      remove_bst_column(placeholder);
    });
  });
}

function attach_column_displace_left() {
  $('a.displace-left').attr('title', 'Move Left').off('click').on('click', function() {
    $(this).tooltip('hide');
    $(this).parent().parent().find('a').hide();
    $('#compare-table').displace_bst_column($(this).parent().parent().attr('data-header-index'), 'left');
  });
}

function attach_column_displace_right() {
  $('a.displace-right').attr('title', 'Move Right').off('click').on('click', function() {
    $(this).tooltip('hide');
    $(this).parent().parent().find('a').hide();
    $('#compare-table').displace_bst_column($(this).parent().parent().attr('data-header-index'), 'right');
  });
}

function attach_column_activator() {
  $('#compare-table').find('thead').find('tr').find('th').each(function(i, e) {
    var placeholder = $(this);

    placeholder.on('mouseover', function() {
      var current_position = $(this).attr('data-header-index');
      var last_column_index = $('#compare-table').find('th[data-header-index]').length - 1;

      if (current_position != 0) {
        placeholder.find('a.displace-left').show();
      }

      if (current_position != last_column_index) {
        placeholder.find('a.displace-right').show();
      }

      placeholder.find('a.compare-remove').show();
    }).on('mouseout', function() {
      placeholder.find('a').hide();
    })
  })
}

function compare_table_add(d) {
  $.each(d, function(index, d) {
    $('#compare-table').add_column_to_bst(expand_stats_and_skills(d));
    $('#compare-table').add_header_column_to_bst(stylify_hero(d), d.hero_id, d.url_friendly);
  })

  attach_column_remove();
  attach_column_displace_left();
  attach_column_displace_right();
  attach_column_activator();
  attach_modifier_tooltip();
  activate_growth_control();
  recalculate_team_speed();
  recalculate_team_members();
}

function recalculate_team_speed() {
  var total = 0;
  $('span.label-group[data-original-title="spd"]').each(function() {
    total += parseInt($(this).children().last().text());
  });

  $('#compare-cumulative-spd').text(total); 
}

function recalculate_team_members() {
  var members_s = $('.compare-table-th').length;
  var members = parseInt(members_s);

  if (members > 5) {
    $('#compare-team-members-count').parent().children().each(function() {
      $(this).removeClass('label-primary');
      $(this).addClass('label-danger');
    })

    members_s += ' <span class="glyphicon glyphicon-exclamation-sign"></span>';
  } else {
    $('#compare-team-members-count').parent().children().each(function() {
      $(this).removeClass('label-danger');
      $(this).addClass('label-primary');
    })
  }

  $('#compare-team-members-count').html(members_s);
}

function activate_growth_control() {
  $('.level-decr').off('click').on('click', function() {
    var that = $(this);
    adjust_growth_level(that.parent().find('.level-text'), -1);
  });

  $('.level-incr').off('click').on('click', function() {
    var that = $(this);
    adjust_growth_level(that.parent().find('.level-text'), 1);
  })

  $('.plus-decr').off('click').on('click', function() {
    var that = $(this);
    adjust_growth_plus(that.parent().find('.plus-text'), -1);
  })

  $('.plus-incr').off('click').on('click', function() {
    var that = $(this);
    adjust_growth_plus(that.parent().find('.plus-text'), 1);
  })
}

function adjust_growth_level(el, val) {
  var current_value = parseInt(el.text());
  if (current_value + val < 30 || current_value + val > 40) {
    return;
  } else {
    el.text(current_value + val);
  }

  adjust_stats(el.parent());
}

function adjust_growth_plus(el, val) {
  var current_value = parseInt(el.text());
  if (current_value + val < 0 || current_value + val > 5) {
    return;
  } else {
    el.text(current_value + val);
  }

  adjust_stats(el.parent());
}

function adjust_stats(el) {
  var level = parseInt(el.find('.level-text').text());
  var plus = parseInt(el.find('.plus-text').text());

  $.each(['hp', 'atk', 'mag', 'def'], function(i, x) {
    var formula = el.find('.formula-' + x);
    var target = el.find('.label-group[data-original-title="' + x + '"]');
    var level_gradient = parseInt(formula.attr('data-level-gradient'));
    var plus_gradient = parseInt(formula.attr('data-plus-gradient'));
    var base = parseInt(formula.attr('data-base'));

    var result = base + level_gradient * (level - 30) + plus_gradient * plus;
    target.children().last().text(result);
  });
}

function expand_stats_and_skills(s) {
  return [stylify_flair(undefined, 'Flair Not Available'),
          stylify_stats(s.stats, s.level, s.plus),
          stylify_skill(s.skills.active_0),
          stylify_skill(s.skills.active_1),
          stylify_skill(s.skills.passive, 'No Passive Aura'),
          stylify_skill(s.skills.awakening, 'Not Awakened Hero')];
}

function stylify_hero(d) {
  return '<a href="#" hidden class="displace-left">'
       +   '<span class="glyphicon glyphicon-arrow-left"></span>'
       + '</a>'
       + '&nbsp;'
       + '<img src="/assets/element_' + d.hero_element + '.png" style="margin-top: -0.4em">'
       + '&nbsp;'
       + d.hero_rank
       + '&nbsp;'
       + '<span class="glyphicon glyphicon-star"></span>'
       + '&nbsp;'
       + d.hero_name.strip_hero_rank()
       + '&nbsp;'
       + '<a href="#" hidden class="compare-remove" data-hero-id=' + d.hero_id + '>'
       +   '<span class="glyphicon glyphicon-remove"></span>'
       + '</a>'
       + '&nbsp;'
       + '<a href="#" hidden class="displace-right">'
       +   '<span class="glyphicon glyphicon-arrow-right"></span>'
       + '</a>';
}

function stylify_skill(d, err_na) {
  // IE hax
  err_na = err_na || 'Not Available';

  if (!d) {
    return $.label_group(err_na, 'default');
  };

  return '<strong>' + d['name'] + '</strong>'
       + '<br />' 
       + $.prettify_skill(d.category, d.cooldown)
       + _render_attributes(d.attributes);
}

function stylify_flair(d, err_na) {
  if (!d) {
    return $.label_group(err_na, 'default');
  }
}

function stylify_stats(d, _level, _plus) {
  var s = attach_growth_control(_level, _plus);

  $.each(d, function(stat, ds) {
    var g = derive_gradients(ds);
    var value = extrapolate(g, ds);
    s += $.label_group([stat.toUpperCase(), value], 'default', stat);
    s += '</br >';
    if (g) {
      s += '<span class="formula-' + stat + '" '
        +  '  data-level-gradient=' + g.level_gradient + ' '
        +  '  data-plus-gradient=' + g.plus_gradient + ' '
        +  '  data-base=' + g.base + '></span>';
    }
  });

  return s;
}

function attach_growth_control(_level, _plus) {
  var s;

  s = '<a class="level-decr" href="#"><span class="glyphicon glyphicon-minus"></span></a> '
    + '<span class="level-text">' + _level + '</span>'
    + ' <a class="level-incr" href="#"><span class="glyphicon glyphicon-plus"></span></a> '
    + ' | '
    + '<a class="plus-decr" href="#"><span class="glyphicon glyphicon-minus"></span></a> '
    + '+<span class="plus-text">' + _plus + '</span>'
    + ' <a class="plus-incr" href="#"><span class="glyphicon glyphicon-plus"></span></a> '
    + '<br />';

  return s;
}

function derive_gradients(ds) {
  if (ds.forty === undefined) {
    return undefined;
  } else {
    return {
      level_gradient: parseInt((ds.forty - ds.thirty) / 10),
      plus_gradient: parseInt((ds.forty_5 - ds.forty) / 5),
      base: ds.thirty
    }
  }
}

function extrapolate(g, ds) {
  if (ds.forty === undefined) {
    return ds.thirty;
  } else {
    var p = get_growth_parameter();
    // return ds.thirty + parseInt((ds.forty - ds.thirty) / 10) * (p.level - 30)
    //                  + parseInt((ds.forty_5 - ds.forty) / 5) * (p.plus);

    return ds.thirty + g.level_gradient * (p.level - 30)
                     + g.plus_gradient * p.plus;
    // TODO: Write extrapolation fuction here
  }
}

function remove_bst_column(el) {
  var hero_id = el.attr('data-hero-id');

  $('#compare-table').find('th').each(function(i, x) {
    if (hero_id == $(this).attr('data-hero-id')) {
      $('#compare-table').remove_column_from_bst(i);
    }
  });

  stack_table_remove(hero_id);
  recalculate_team_speed();
  recalculate_team_members();
}