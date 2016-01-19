Array.prototype.last = function() { return this[this.length-1]; }

String.prototype.strip_hero_rank = function() { return this.split(/\s/).last(); }

jQuery.fn.extend({
  add_column_to_bst: function(data) {
    var last_column_index = $(this).find('tbody').find('tr').first().find('td').length - 1;

    console.log(last_column_index);
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
    console.log(placeholder.find('th[data-header-index]').length);

    switch (dir) {
      case 'left':  var left = $(this).find('th[data-header-index=' + (pivot - 1) + ']');
                    var right = $(this).find('th[data-header-index=' + pivot + ']');

                    right.insertBefore(left);
                    if (pivot - 1 >= 0) {
                      allow_displace = true;
                      right.attr('data-header-index', pivot - 1);
                      left.attr('data-header-index', pivot);
                    }

                    break;
      case 'right': var left = $(this).find('th[data-header-index=' + pivot + ']');
                    var right = $(this).find('th[data-header-index=' + (pivot + 1) + ']');

                    right.insertBefore(left);
                    if (pivot + 1 <= placeholder.find('th[data-header-index]').length - 1) {
                      allow_displace = true;
                      right.attr('data-header-index', pivot);
                      left.attr('data-header-index', pivot + 1);
                    }

                    break;
    }

    if (allow_displace) {
      placeholder.find('tbody').find('tr').each(function() {
        var r = $(this);

        switch (dir) {
          case 'left':  var left = r.find('td[data-column-index=' + (pivot - 1) + ']');
                        var right = r.find('td[data-column-index=' + pivot + ']');

                        right.insertBefore(left);
                        right.attr('data-column-index', pivot - 1);
                        left.attr('data-column-index', pivot);
                        break;
          case 'right': var left = r.find('td[data-column-index=' + pivot + ']');
                        var right = r.find('td[data-column-index=' + (pivot + 1) + ']');

                        right.insertBefore(left);
                        right.attr('data-column-index', pivot);
                        left.attr('data-column-index', pivot + 1);
                        break;
        }
      });

      allow_displace = false;
    }
  }
});