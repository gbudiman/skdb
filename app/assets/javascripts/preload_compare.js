(function() {
  var count = 0;
  if (window.preload === null) return false;

  initialize_compare_table_bst();

  $.each(window.preload, function(i, x) {
    add_to_compare_table(parseInt(x));
    count++;
  });

  update_permalink();
  if (count == 0) {
    $('.stack-table').hide();
  }
})();