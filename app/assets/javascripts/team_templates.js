// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

window.templateSearchTimeout;

$('.team-template[data-hero-id]').each(function() {
  var heros = $.parseJSON($(this).attr('data-hero-id'));

  $(this).off('click').on('click', function() {
    $('.team-template[data-hero-id]').removeClass('active');

    $(this).addClass('active');

    $('#btn-remove-all-compare').trigger('click');
    initialize_compare_table_bst();
    
    $('#underlay').hide();

    $.each(heros, function(i, x) {
      add_to_compare_table(x, null);
    })
  });
})

$('#template-search').on('focus', function() {
  $(this).select();
})

$('#template-search').on('keyup', function() {
  var query = $(this).val().trim();
  var top = $('#team-template');

  window.clearTimeout(window.templateSearchTimeout);
  
  window.templateSearchTimeout = window.setTimeout(function() {
    delayed_search(top, query);  
  }, 250);  
})

function delayed_search(top, query) {
  if (query.length == 0) {
    top.find('a[data-hero-id]').fadeIn();
  } else {
    top.find('a[data-hero-id]:notContainsInsensitive(' + query + ')').fadeOut();
    top.find('a[data-hero-id]:containsInsensitive(' + query + ')').fadeIn();
  }
}