$('#search-input').on('keyup', function() {
  var query = $(this).val();

  if (query.length > 0) {
    launch_search_hero(query);
    launch_search_skill(query);
    launch_search_atb(query);
  }
});

function launch_search_hero(q) {
  $.ajax({
    url: '/heros/search/' + q
  }).done(function(res) {
    repopulate_hero_search_result(res);
  })
}

function launch_search_skill(q) {
  $.ajax({
    url: '/skills/search/' + q
  }).done(function(res) {
    repopulate_skill_search_result(res);
  })
}

function launch_search_atb(q) {
  $.ajax({
    url: '/attributes/search/' + q
  }).done(function(res) {
    repopulate_atb_search_result(res);
  })
}

function launch_search_hero_having_atb_effect(e, r) {
  $.ajax({
    url: '/heros/fetch/having/atb/effect/' + e + '/target/' + r
  }).done(function(res) {
    repopulate_hhae_search_result(res, e + '_' + r);
  })
}

function repopulate_hero_search_result(d) {
  $('#hero-result-count').text(d.length);

  $('#hero-result').empty();
  $.each(d, function(i, v) {
    $('#hero-result')
      .append('<li class="list-group-item">'
            +   v.name
            +   '&nbsp;'
            +   '<span class="glyphicon glyphicon-star">'
            +   '</span>'
            +   '&nbsp;'
            +   v.rank
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
            +       '<span class="pull-right">' + v.skill_category + '</span>'
            +     '</div>'
            +   '</div>'
            +   '<div class="row">'
            +     '<div class="col-xs-12 small">'
            +       v.hero_name
            +       '&nbsp;'
            +       '<span class="glyphicon glyphicon-star"></span>'
            +       '&nbsp;'
            +       v.hero_rank
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
            +     v.effect
            +     '&nbsp;'
            +     '<span class="glyphicon glyphicon-screenshot"></span>'
            +     '&nbsp;'
            +     v.target
            +   '</a>'
            +   '<span class="badge pull-right">' + v.count + '</span>'
            +   '<ul class="list-unstyled collapse" id="' + composite_attribute + '">'
            +   '</ul>'
            + '</li>');
  })

  attach_atb_effect_search();
}

function attach_atb_effect_search() {
  $('a[data-target]').on('click', function() {
    var effect = $(this).attr('data-query-effect');
    var target = $(this).attr('data-query-target');
    launch_search_hero_having_atb_effect(effect, target);
  })
}

function repopulate_hhae_search_result(d, element_target) {
  console.log(element_target);
  $('#' + element_target).empty();

  console.log(d);
  $.each(d, function(i, v) {
    $('#' + element_target)
      .append('<li class="list-group-item">'
            +   '<span class="effect-hero-item">'
            +   v.hero_name
            +   '</span>'
            + '</li>'); 
  });
}