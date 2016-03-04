function format_mute_name(value, row, index) {
	return value.mute_hero_banner();
}

function format_compact_name_with_dynamic_buttons(value, row, index) {
  var s = row.rank
        + ' <span class="glyphicon glyphicon-star"></span> '
        + row.stripped_name;

  s += '<span class="pull-right dynamic-add" data-hero-id=' + row['id'] + ' hidden>'
    +    '<a href="#">'
    +      '<span class="glyphicon glyphicon-plus"></span>'
    +    '</a>'
    +  '</span>'

  return s;
}

function activate_links(id) {
  $(id).find('.dynamic-add').each(function() {
    var o = $(this).parent().parent();
    var that = $(this);

    o.off('mousover').on('mouseover', function() {
      //that.show();
      render_contextual_control(that);
      that.show();
    }).off('mouseout').on('mouseout', function() {
      that.hide();
    });

    that.off('click').on('click', function() {
      initialize_compare_table_bst();

      if ($('#compare-table').has_hero(that.attr('data-hero-id'))) {
        $('#compare-table').uncompare_hero_by_id(that.attr('data-hero-id'));
      } else {
        add_to_compare_table(that.attr('data-hero-id'));
      }
      that.fadeOut();
      resize_bst_area('#stat-table');
    })
  });
}

function render_contextual_control(el) {
  var hero_id = el.attr('data-hero-id');
  var in_compare_table = $('#compare-table').find('th[data-hero-id="' + hero_id + '"]');
  var glyph = el.find('span.glyphicon');

  if (!$('#compare-table').has_hero(hero_id)) {
    glyph.removeClass('glyphicon-remove').addClass('glyphicon-add');
  } else {
    glyph.removeClass('glyphicon-add').addClass('glyphicon-remove');
  }

}

function resize_bst_area(id) {
  resize_once(id);
	$(id).bootstrapTable('resetWidth');
}

function resize_once(id) {
  $(id).parent().css('height', '70vh');
  $(id).parent().parent().css('padding-bottom', 0);
}

function get_extrapolation_parameters(obj) {
  if (obj.thirty == undefined && obj.forty == undefined && obj.forty_5 == undefined) {
    throw 'Extrapolation requires object with .thirty, .forty, and .forty_5 attribute';
  } else {
    return {
      level_gradient: (obj.forty - obj.thirty) / 10,
      plus_gradient: (obj.forty_5 - obj.forty) / 5
    };
  }
};

$(window).on('resize', function() {
  resize_bst_area('#stat-table');
});