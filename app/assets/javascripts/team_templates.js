// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

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