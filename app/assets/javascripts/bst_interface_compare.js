function initialize_compare_table_bst() {
  $('#mismatched-preloads').parent().parent().hide();
  
  $('#compare-table').show().bootstrapTable({
  });

  $('#toolbar').show();
  $('.stack-table').show();

  $('#permalink').on('click', function() {
    $(this).select();
  })

  $('#permalink-addon').tooltip({
    container: 'body',
    placement: 'bottom'
  });

  $('#btn-maximize-compare').on('click', function() { $.maximize_compare(); });
  $('#btn-remove-all-compare').on('click', function() { $.remove_all_compare(); });
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
    $('#compare-table').add_column_to_bst(expand_skills(d.skills));
    $('#compare-table').add_header_column_to_bst(stylify_hero(d), d.hero_id, d.url_friendly);
  })

  attach_column_remove();
  attach_column_displace_left();
  attach_column_displace_right();
  attach_column_activator();
  attach_modifier_tooltip();
}

function expand_skills(d) {
  return [stylify_flair(undefined, 'Flair Not Available'),
          stylify_skill(d.active_0),
          stylify_skill(d.active_1),
          stylify_skill(d.passive, 'No Passive Aura'),
          stylify_skill(d.awakening, 'Not Awakened Hero')];
}

function stylify_hero(d) {
  return '<a href="#" hidden class="displace-left">'
       +   '<span class="glyphicon glyphicon-arrow-left"></span>'
       + '</a>'
       + '&nbsp;'
       + d.hero_name.strip_hero_rank()
       + '&nbsp;'
       + '<span class="glyphicon glyphicon-star"></span>&nbsp;'
       + d.hero_rank
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

function remove_bst_column(el) {
  var hero_id = el.attr('data-hero-id');

  $('#compare-table').find('th').each(function(i, x) {
    if (hero_id == $(this).attr('data-hero-id')) {
      $('#compare-table').remove_column_from_bst(i);
    }
  });

  stack_table_remove(hero_id);
}