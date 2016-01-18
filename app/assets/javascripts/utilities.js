Array.prototype.last = function() { return this[this.length-1]; }

String.prototype.strip_hero_rank = function() { return this.split(/\s/).last(); }

jQuery.fn.extend({
  add_column_to_bst: function(data) {
    $(this).find('tbody').find('tr').each(function(i, r) {
      $(this).append('<td>' + data[i] || '-' + '</td>');
    });
  },

  add_header_column_to_bst: function(data, hero_id) {
    $(this).find('thead').find('tr')
      .append('<th class="compare-table-th" data-hero-id=' + hero_id + '>'
            +   '<div class="th-inner">'
            +     data
            +   '</div>'
            + '</th>');
  },

  remove_column_from_bst: function(ord) {
    $(this).find('thead').find('th').each(function(i, x) {
      if (i == ord) {
        $(this).remove();
      }
    })

    $(this).find('tbody').find('tr').each(function(ri, row) {
      $(this).find('td').each(function(ci, col) {
        if (ci == ord) {
          $(this).remove();
        }
      })
    })
  }
});