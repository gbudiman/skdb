$('#search-input').on('focus', function() {
  $(this).select();
})

$('#search-input').on('keyup', function() {
  var query = $(this).val();

  if (query.length > 0) {
    $('.reveal-on-keyup').show();
    launch_search_hero(query);
    launch_search_skill(query);
    launch_search_atb(query);
  } else {
    $('.reveal-on-keyup').hide();
  }
});

$('#btn-execute-search').on('click', function() {
  $('#search-input').trigger('keyup');
});

$('#btn-restore-search').tooltip({
  container: 'body',
  placement: 'right'
}).on('click', function() {
  $.normalize_compare();
  $('#btn-restore-search').tooltip('hide');
  $('#search-input').focus();
})

function launch_search_hero(q) {
  $.ajax({
    url: '/heros/search/' + q
  }).done(function(res) {
    repopulate_hero_search_result(res);
    attach_add_to_compare($('#hero-result'), 'hero');
  })
}

function launch_search_skill(q) {
  $.ajax({
    url: '/skills/search/' + q
  }).done(function(res) {
    repopulate_skill_search_result(res);
    attach_add_to_compare($('#skill-result'), 'skill');
  })
}

function launch_search_atb(q) {
  $.ajax({
    url: '/attributes/search/' + q
  }).done(function(res) {
    repopulate_atb_search_result(res);
  })
}

function launch_search_hero_having_atb_effect(e, r, el) {
  $.ajax({
    url: '/heros/fetch/having/atb/effect/' + e + '/target/' + r
  }).done(function(res) {
    repopulate_hhae_search_result(res, e + '_' + r);
    el.attr('data-has-been-fetched', true);
  })
}

function repopulate_hero_search_result(d) {
  $('#hero-result-count').text(d.length);

  $('#hero-result').empty();
  $.each(d, function(i, v) {
    $('#hero-result')
      .append('<li class="list-group-item">'
            +   v.name.strip_hero_rank('mute_rank')
            +   '&nbsp;'
            +   '<span class="glyphicon glyphicon-star">'
            +   '</span>'
            +   '&nbsp;'
            +   v.rank
            +   '<a href="#" class="addable-to-compare pull-right" data-hero-id=' + v.id + '><span class="addable-to-compare"></span></a>'
            + '</li>');
  })
}

function repopulate_skill_search_result(d) {
  $('#skill-result-count').text(d.length);

  $('#skill-result').empty();
  $.each(d, function(i, v) {
    $('#skill-result')
      .append('<li class="list-group-item">'
            +   '<div class="row">'
            +     '<div class="col-xs-12">'
            +       v.skill_name
            +       '<span class="pull-right">' + $.prettify_skill(v.skill_category, v.skill_cooldown) + '</span>'
            +     '</div>'
            +   '</div>'
            +   '<div class="row">'
            +     '<div class="col-xs-12 small">'
            +       v.hero_name.strip_hero_rank()
            +       '&nbsp;'
            +       '<span class="glyphicon glyphicon-star"></span>'
            +       '&nbsp;'
            +       v.hero_rank
            +       '<a href="#" class="addable-to-compare pull-right" data-hero-id=' + v.hero_id + '><span class="addable-to-compare"></span></a>'
            +     '</div>'
            +   '</div>'
            + '</li>');
  })
}

function repopulate_atb_search_result(d) {
  $('#effect-result-count').text(d.length);

  $('#effect-result').empty();
  $.each(d, function(i, v) {
    var composite_attribute = v.effect + '_' + v.target;
    $('#effect-result')
      .append('<li class="list-group-item">'
            +   '<a data-toggle="collapse" '
            +      'data-query-effect="' + v.effect + '" '
            +      'data-query-target="' + v.target + '" '
            +      'data-target="#' + composite_attribute + '" href="#">'
            +     '<div class="row">'
            +       '<div class="col-xs-10">'
            +         $.render_effect(v.effect, v.target)
            +       '</div>'
            +       '<div class="col-xs-2 multi-line-vertical-centered">'
            +         '<span class="badge pull-right">' 
            +           v.count 
            +         '</span>'
            +       '</div>'
            +     '</div>'
            +     '<div class="row">'
            +       '<div class="col-xs-4">'
            +         $.prettify_target(v.target)
            +       '</div>'
            +       '<div class="col-xs-8">'
            +         '<span class="pull-right">'
            +           '<span class="expand-collapse"></span>'
            +         '</span>'
            +       '</div>'
            +     '</div>'
            +   '</a>'
            
            +   '<ul class="list-unstyled effect-hero-list collapse" id="' + composite_attribute + '">'
            +   '</ul>'
            + '</li>');
  })

  attach_atb_effect_search();
  attach_interactive_expand_button();
}

function attach_atb_effect_search() {
  $('a[data-target]').on('mouseover', function() {
    var has_been_fetched = $(this).attr('data-has-been-fetched');

    if (!has_been_fetched) {
      var effect = $(this).attr('data-query-effect');
      var target = $(this).attr('data-query-target');
      launch_search_hero_having_atb_effect(effect, target, $(this));
    }
  })
}

function attach_interactive_expand_button() {
  $('a[data-target]').on('mouseover', function() {
    attach_expand_collapse_cosmetic($(this));
  }).on('mouseout', function() {
    $(this).find('.expand-collapse').text('');
    $(this).find('.compare-all').text('');
  });

  $('ul.effect-hero-list').on('hide.bs.collapse show.bs.collapse', function() {
    attach_expand_collapse_cosmetic($(this).parent().find('a[data-target]'));
  });
}

function attach_expand_collapse_cosmetic(el) {
  if (el.attr('aria-expanded') == "true") {
    el.find('.expand-collapse')
      .html('Collapse <span class="glyphicon glyphicon-chevron-up"></span>');
  } else {
    el.find('.expand-collapse')
      .html('Expand <span class="glyphicon glyphicon-chevron-down"></span>');
  }
}

function repopulate_hhae_search_result(d, element_target) {
  $('#' + element_target).empty();
  var effect_filter = $('#' + element_target).parent().find('a[data-query-effect]').attr('data-query-effect');
  var target_filter = $('#' + element_target).parent().find('a[data-query-target]').attr('data-query-target');

  var s = '';
  $.each(d, function(i, v) {
    s += '<li class="list-group-item">'
       +   '<span class="effect-hero-item">' + v.hero_name.strip_hero_rank() + '</span>&nbsp;'
       +   '<span class="glyphicon glyphicon-star"></span>&nbsp;' + v.hero_rank
       +   '<a href="#" class="addable-to-compare pull-right" data-hero-id=' + v.hero_id + '>'
       +     '<span class="addable-to-compare"></span>'
       +   '</a>';
    
    $.each(v.skills, function(k_skills, v_skills) {
      $.each(v_skills['attributes'], function(k_atbs, v_atbs) {
        if (effect_filter == v_atbs.effect && target_filter == v_atbs.target) {
          s += '<br />';
          s += '<span>' + v_skills.name + '</span>';
          s += '<span class="pull-right">'
          s +=   $.prettify_skill(v_skills.category, v_skills.cooldown);
          s += '</span>';
        }


      })
    });
    s += '</li>';
  });

  $('#' + element_target).append(s);
  attach_add_to_compare($('#' + element_target), 'effect');
}

function attach_add_to_compare(el, type) {
  el.find('span.addable-to-compare').each(function() {
    var placeholder = $(this);

    if (type == 'hero') {
      var target = $(this).parent().parent();
    } else if (type == 'skill') {
      var target = $(this).parent().parent().parent().parent();
    } else if (type == 'effect') {
      var target = $(this).parent().parent();
    }

    target.on('mouseover', function() {
      var target_hero_id = placeholder.parent().attr('data-hero-id');
      var in_compare_table = $('#compare-table').find('th[data-hero-id="' + target_hero_id + '"]');

      if (in_compare_table.length == 0) {
        placeholder
          .html('<span class="glyphicon glyphicon-plus"></span>&nbsp;Compare');

        placeholder.parent().attr('disabled', false);
      } else {
        placeholder
          .html('Already <span class="glyphicon glyphicon-chevron-right"></span>');

        placeholder.parent().attr('disabled', true);
      }
    }).on('mouseout', function() {
      placeholder.text('');
    });
  });

  $('a.addable-to-compare').off('click').on('click', function() {
    var placeholder = $(this);

    initialize_compare_table_bst();

    if (!placeholder.attr('disabled')) {
      add_to_compare_table($(this).attr('data-hero-id'), placeholder);
    }
  })
}

function add_to_compare_table(id, placeholder = null) {
  $.ajax({
    url: '/heros/fetch/' + id
  }).done(function(res) {
    if (placeholder != null) placeholder.children().empty();
    compare_table_add(res);
    stack_table_add(res);
    update_permalink();
  }); 
}