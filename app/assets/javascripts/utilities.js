Array.prototype.last = function() { return this[this.length-1]; }

String.prototype.strip_hero_rank = function() { return this.split(/\s/).last(); }

function getScrollBarWidth () {
    var $outer = $('<div>').css({visibility: 'hidden', width: 100, overflow: 'scroll'}).appendTo('body'),
        widthWithScroll = $('<div>').css({width: '100%'}).appendTo($outer).outerWidth();
    $outer.remove();
    return 100 - widthWithScroll;
};

jQuery.fn.extend({
  add_column_to_bst: function(data) {
    var last_column_index = $(this).find('tbody').find('tr').first().find('td').length - 1;

    $(this).find('tbody').find('tr').each(function(i, r) {
      $(this).append('<td data-column-index=' + last_column_index + '>' + data[i] || '-' + '</td>');
    });
  },

  add_header_column_to_bst: function(data, hero_id) {
    var last_header_index = $(this).find('th').length - 1;

    $(this).find('thead').find('tr')
      .append('<th class="compare-table-th" '
            +      'data-hero-id=' + hero_id + ' '
            +      'data-header-index=' + last_header_index + '>'
            +   '<div class="th-inner">'
            +     data
            +   '</div>'
            + '</th>');

    // var target_width = $(this).find('td[data-column-index]').width();
    // var leading_width = $(this).find('tr[data-index]').first().find('td').first().width();
    // var scrollbar_width = getScrollBarWidth();

    // $(this).parent().parent().find('.fixed-table-header').find('tr')
    //   .append('<th class="compare-table-th" '
    //         +      'data-hero-id=' + hero_id + ' '
    //         +      'data-header-index=' + last_header_index + '>'
    //         +   '<div class="th-inner">'
    //         +     data
    //         +   '</div>'
    //         + '</th>');

    // $('.fht-cell').remove();
    // $('.fixed-table-header').find('tr').find('th[data-header-index]').css('width', target_width + 'px');
    // $('.fixed-table-header').find('tr').find('th').first().css('width', leading_width + scrollbar_width + 'px');
  },

  remove_column_from_bst: function(ord) {
    $(this).find('thead').find('th').each(function(i, x) {
      var placeholder = $(this);
      if (i == ord) {
        placeholder.nextAll().each(function() {
          $(this).attr('data-header-index', $(this).attr('data-header-index') - 1);
        });
        placeholder.remove();
      }
    })

    $(this).find('tbody').find('tr').each(function(ri, row) {
      $(this).find('td').each(function(ci, col) {
        var placeholder = $(this);
        if (ci == ord) {
          placeholder.nextAll().each(function() {
            $(this).attr('data-column-index', $(this).attr('data-column-index') - 1);
          });
          placeholder.remove();
        }
      })
    })
  },

  displace_bst_column: function(_pivot, dir) {
    var placeholder = $(this);
    var pivot = parseInt(_pivot);
    var allow_displace = false;
    var max_header_index = placeholder.find('th[data-header-index]').length - 1;
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
    })
  }
});

jQuery.extend({
  prettify_skill: function(_type, _cooldown) {
    var type;
    var cooldown = '<span class="label label-primary">'
                 +   (_cooldown || '') + 's'
                 + '</span>';

    switch (_type) {
      case 'active_0'  :
      case 'active_1'  : type = '<span class="label label-lg label-primary">Active</span>';
                         return '<span class="label-group">' + type + cooldown + '</span>'
      case 'passive'   : type = '<span class="label label-default">Passive</span>'; 
                         return type;
      case 'awakening' : type = '<span class="label label-danger">Awakening</span>';
                         return '<span class="label-group">' + type + cooldown + '</span>';
    }
  },

  prettify_target: function(_text) {
    var label_class, count;

    switch(_text) {
      case 'self'        : label_class = 'label-success'; count = 'Self';     break;
      case 'ally_single' : label_class = 'label-primary'; count = '1';        break;
      case 'ally_all'    : label_class = 'label-primary'; count = 'All';      break;
      case 'enemy_one'   : label_class = 'label-danger';  count = '1';        break;
      case 'enemy_two'   : label_class = 'label-danger';  count = '2';        break;
      case 'enemy_three' : label_class = 'label-danger';  count = '3';        break;
      case 'enemy_four'  : label_class = 'label-danger';  count = '4';        break;
      case 'enemy_all'   : label_class = 'label-danger';  count = 'All';        break;
      case 'attacker'    : label_class = 'label-danger';  count = 'Attacker'; break;
    }

    return '<span class="label-group">'
         +   '<span class="label ' + label_class + '">'
         +     '<span class="glyphicon glyphicon-screenshot"></span>'
         +   '</span>'
         +   '<span class="label ' + label_class + '">'
         +     count
         +   '</span>'
         + '</span>';
  },

  prettify_generic: function(_glyph, _text) {
    return '<span class="label-group">'
         +   '<span class="label label-default">'
         +     '<span class="glyphicon glyphicon-' + _glyph + '"></span>'
         +   '</span>'
         +   '<span class="label label-default">'
         +     _text
         +   '</span>'
         + '</span>';
  }
});