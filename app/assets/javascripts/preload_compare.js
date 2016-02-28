(function() {
  if (window.preload === null) return false;

  initialize_compare_table_bst();

  $.each(window.preload, function(i, x) {
    add_to_compare_table(parseInt(x));
  });
})();