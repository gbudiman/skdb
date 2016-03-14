Array.prototype.last = function() { return this[this.length-1]; }

String.prototype.strip_hero_rank = function(_mute_rank) { 
  // IE hax
  _mute_rank = _mute_rank || false;

  var arr_s = this.split(/\s/);
  var name = arr_s.pop();
  var rank = arr_s.join(' ');
  
  if (_mute_rank == 'mute_rank') {
    return '<span class="text-muted">' + rank + '</span> ' + name;
  } else {
    return name; 
  }
}

String.prototype.mute_hero_banner = function() {
  var arr_s = this.split(/\s/);
  var name = arr_s.pop();
  var banner = arr_s.join(' ');

  return '<span class="text-muted">' + banner + '</span> ' + name;
};


function getScrollBarWidth () {
    var $outer = $('<div>').css({visibility: 'hidden', width: 100, overflow: 'scroll'}).appendTo('body'),
        widthWithScroll = $('<div>').css({width: '100%'}).appendTo($outer).outerWidth();
    $outer.remove();
    return 100 - widthWithScroll;
};

jQuery.fn.extend({
  has_hero: function(hero_id) {
    var count = $(this).find('th[data-hero-id="' + hero_id + '"]').length;

    return (count > 0) ? true : false;
  },

  update_stack_cell: function() {
    update_stack_cell($(this));
  },

  add_column_to_bst: function(data) {
    var last_column_index = $(this).find('tbody').find('tr').first().find('td').length;

    $(this).find('tbody').find('tr').each(function(i, r) {
      $(this).append('<td data-column-index=' + last_column_index + '>' + data[i] || '-' + '</td>');
    });
  },

  add_header_column_to_bst: function(data, hero_id, hero_name_url_friendly) {
    var last_header_index = $(this).find('th').length;

    $(this).find('thead').find('tr')
      .append('<th class="compare-table-th" '
            +      'data-hero-id=' + hero_id + ' '
            +      'data-hero-name-url-friendly=' + hero_name_url_friendly + ' '
            +      'data-header-index=' + last_header_index + '>'
            +   '<div class="th-inner">'
            +     data
            +   '</div>'
            + '</th>');
  },

  remove_column_from_bst: function(ord) {
    $(this).find('thead').find('th').each(function(i, x) {
      var placeholder = $(this);
      if (i == ord) {
        placeholder.nextAll().each(function() {
          $(this).attr('data-header-index', $(this).attr('data-header-index'));
        });
        placeholder.remove();
      }
    })

    $(this).find('tbody').find('tr').each(function(ri, row) {
      $(this).find('td').each(function(ci, col) {
        var placeholder = $(this);
        if (ci == ord) {
          placeholder.nextAll().each(function() {
            $(this).attr('data-column-index', $(this).attr('data-column-index'));
          });
          placeholder.remove();
        }
      })
    })

    update_permalink();

    if ($(this).find('tbody').find('tr').first().find('td').length == 0) {
      $('#toolbar').hide();
      $('.stack-table').hide();
      $('#underlay').show();
      $('#compare-table').bootstrapTable('destroy');
    }
  },

  find_ord_by_hero_id: function(id) {
    var result;
    this.find('thead').find('th').each(function(i, x) {
      if ($(this).attr('data-hero-id') == id) {
        result = $(this).attr('data-header-index');
        return false;
      }
    })

    return result;
  },

  uncompare_hero_by_id: function(id) {
    var ord = this.find_ord_by_hero_id(id);
    this.remove_column_from_bst(ord);
  },

  displace_bst_column: function(_pivot, dir) {
    var placeholder = $(this);
    var pivot = parseInt(_pivot);
    var allow_displace = false;
    var max_header_index = placeholder.find('th[data-header-index]').length;
    var lei, rei; // left-element index, right-element index

    lei = (dir == 'left') ? pivot - 1 : pivot;
    rei = (dir == 'left') ? pivot     : pivot + 1;
    allow_displace = (dir == 'left') ? (pivot - 1 >= 0 ? true : false)
                                     : (pivot + 1 <= max_header_index)

    if (!allow_displace) return false;

    // update header
    var lh = placeholder.find('th[data-header-index=' + lei + ']');
    var rh = placeholder.find('th[data-header-index=' + rei + ']');

    rh.insertBefore(lh);
    rh.attr('data-header-index', lei);
    lh.attr('data-header-index', rei);

    // update body by iterating through rows
    placeholder.find('tbody').find('tr').each(function() {
      var r = $(this);

      var lc = r.find('td[data-column-index=' + lei + ']');
      var rc = r.find('td[data-column-index=' + rei + ']');

      rc.insertBefore(lc);
      rc.attr('data-column-index', lei);
      lc.attr('data-column-index', rei);
    });

    update_permalink();
  }
});

jQuery.extend({
  prettify_skill: function(_type, _cooldown) {
    switch (_type) {
      case 'active_0'  :
      case 'active_1'  : return $.label_group(['Active', _cooldown + 's'], 'primary');
      case 'passive'   : return $.label_group(['Passive'], 'default');
      case 'awakening' : return $.label_group(['Awakening'], 'danger');
    }
  },

  prettify_target: function(_text) {
    var label_class, count, help;

    switch(_text) {
      case 'self'        : label_class = 'success'; count = 'Self';     help = 'Self'; break;
      case 'ally_single' : label_class = 'primary'; count = '1';        help = 'One Ally'; break;
      case 'ally_all'    : label_class = 'primary'; count = 'All';      help = 'All Allies';break;
      case 'enemy_one'   : label_class = 'danger';  count = '1';        help = '1 Enemy'; break;
      case 'enemy_two'   : label_class = 'danger';  count = '2';        help = '2 Enemies'; break;
      case 'enemy_three' : label_class = 'danger';  count = '3';        help = '3 Enemies'; break;
      case 'enemy_four'  : label_class = 'danger';  count = '4';        help = '4 Enemies'; break;
      case 'enemy_all'   : label_class = 'danger';  count = 'All';      help = 'All Enemies'; break;
      case 'attacker'    : label_class = 'danger';  count = 'Attacker'; help = 'Attacker'; break;
    }

    var glyph_sym = '<span class="glyphicon glyphicon-screenshot"></span>';
    return $.label_group([glyph_sym, count], label_class, 'Targets ' + help);
  },

  prettify_generic: function(_glyph, _text, _title) {
    // IE hax
    _title = _title || '';

    var glyph_sym = '<span class="glyphicon glyphicon-' + _glyph + '"></span>';
    return $.label_group([glyph_sym, _text], 'default', _title);
  },

  label_group: function(_data, _class, _title) {
    // IE hax
    _title = _title || '';

    if (_data.constructor === Array && _data.length > 1) {
      var s = '';

      s += '<span class="label-group" title="' + _title + '">';
      $.each(_data, function(i, x) {
        s += '<span class="label label-' + _class + '">'
          +     x
          +  '</span>';
      });
      s += '</span>';

      return s;
    } else {
      var d = (_data.constructor === Array ? _data[0] : _data);
      return '<span class="label label-' + _class + '" title="' + _title + '">' 
           +   d 
           + '</span>';
    }
  },

  maximize_compare: function() {
    $('#left-bar').removeClass('col-md-4').addClass('col-md-1');
    $('#left-bar').find('.minimizable').fadeOut();
    $('#left-bar').find('.minimized').fadeIn();
    $('#right-bar').removeClass('col-md-8').addClass('col-md-11');
    $('#btn-maximize-compare').fadeOut();
  },

  remove_all_compare: function() {
    $('a.compare-remove').trigger('click');
  },

  normalize_compare: function() {
    $('#left-bar').removeClass('col-md-1').addClass('col-md-4');
    $('#left-bar').find('.minimizable').show();
    $('#left-bar').find('.minimized').hide();
    $('#right-bar').removeClass('col-md-11').addClass('col-md-8');
    $('#btn-maximize-compare').show();
  },  

  render_attributes:      function(x)   { return _render_attributes(x); },
  render_effect:          function(x,y) { return _render_effect(x,y); },
  render_modifier:        function(x)   { return _render_modifier(x); },
  render_stat:            function(x)   { return _render_stat(x); },
  render_immunity:        function(x)   { return _render_immunity(x); },
  render_inflict:         function(x)   { return _render_inflict(x); }
});

function attach_modifier_tooltip() {
  $('.label-group[title][title!=""]')
    .hover(function() { $(this).css('cursor', 'help') })
    .tooltip({
      container: 'body'
  });
}