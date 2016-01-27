(function() {
  if (window.preload === null) return false;

  $('#compare-table').show().bootstrapTable({});
  $.each(window.preload, function(i, x) {
    add_to_compare_table(x);
  });
})();