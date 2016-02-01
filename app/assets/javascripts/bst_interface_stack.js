function stack_table_add(d) {
  $.each(d, function(i, e) {
  	// e.hero_id
  	$.each(e.skills, function(i, s) {
  		// s.name
  		// s.cooldown
  		$.each(s.attributes, function(atb, a) {
  			if ($('#stack_' + atb).length == 1) {
  				that = $('#stack_' + atb).attr('data-contributor');

  				if (that == undefined) {
  					overwrite = {};
  				}
  					
  				overwrite[e.hero_id] = {}
  				overwrite[e.hero_id][s.name] = { cooldown: s.cooldown, target: a.target }


  				$('#stack_' + atb).attr('data-contributor', JSON.stringify(overwrite));
  				$('#stack_' + atb)
  					.removeClass('disabled btn-default')
						.addClass('btn-success');

					// $.parseJSON($('#stack_' + atb).attr('data-contributor'));

  			}
  		})
  	})
  })
}