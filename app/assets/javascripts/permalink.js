function update_permalink() {
  var ids = new Array();
  var permalink = window.location.protocol
                + '//'
                + window.location.hostname
                + (window.location.port ? ':' + window.location.port : '')
                + '/compare/';

  $('#compare-table').find('th[data-hero-id]').each(function() {
    ids.push($(this).attr('data-hero-id'));
  })

  permalink += ids.join('/');

  $('#permalink').val(permalink);
}