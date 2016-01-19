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