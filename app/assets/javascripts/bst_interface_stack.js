function stack_table_add(d) {
  $.each(d, function(i, e) {
  	// e.hero_id
  	$.each(e.skills, function(i, s) {
  		// s.name
  		// s.cooldown
  		$.each(s.attributes, function(atb, a) {
  			if ($('#stack_' + atb).length == 1) {
          var overwrite;
  				that = $('#stack_' + atb).attr('data-contributor');

  				if (that == undefined) {
  					overwrite = {};
  				} else {
            overwrite = $.parseJSON(that);
          }
  					
  				overwrite[e.hero_id] = {}
  				overwrite[e.hero_id][s.name] = { hero_name: e.hero_name,
                                           hero_rank: e.hero_rank,
                                           skill_cooldown: s.cooldown, 
                                           skill_category: s.category,
                                           atb_target: a.target }


  				$('#stack_' + atb).attr('data-contributor', JSON.stringify(overwrite));
          $('#stack_' + atb).update_stack_cell();
  				$('#stack_' + atb)
  					.removeClass('disabled btn-default')
						.addClass('btn-success');

					// $.parseJSON($('#stack_' + atb).attr('data-contributor'));

  			}
  		})
  	})
  })
}

function stack_table_remove(id) {
  $('button[data-contributor]').each(function() {
    var target = $(this);
    var that = $.parseJSON(target.attr('data-contributor'));

    //console.log('cycling through ' + target.text() + ' hunting for ' + id);

    if (that[id]) {
      delete that[id];

      var overwrite = JSON.stringify(that);
      
      target.attr('data-contributor', overwrite);
      target.update_stack_cell();

      //console.log('eliminated and updated');
      //console.log($.parseJSON(target.attr('data-contributor')));

      if (overwrite == '{}') {
        target
          .removeClass('btn-success')
          .addClass('disabled btn-default');
      }
    }
  });
}

function update_stack_cell(el) {
  var expand = { count: 0 };

  if (el.attr('data-contributor') != '{}') {
    el.popover({
      container: 'body',
      //content: _expand_stack_cell_content(el),
      html: true,
      placement: 'top',
      trigger: 'hover'
    });

    expand = _expand_stack_cell_content(el)
    el.attr('data-content', expand.content);
  }

  if (expand.count > 1) {
    //console.log('appended to ' + el);
    el.append('<span class="glyphicon glyphicon-exclamation-sign"></span>');
  } else {
    el.find('.glyphicon-exclamation-sign').remove();
  }
}

function _expand_stack_cell_content(d) {
  var content = $.parseJSON(d.attr('data-contributor'));
  var s_content = '<div class="list-group">';
  var count = 0;

  $.each(content, function(i, x) {
    count++;
    $.each(x, function(skill_name, skill_data) {
      s_content += '<a href="#" class="list-group-item">'
                +    '<div class="row">'
                +      '<div class="col-xs-12">'
                +        skill_data.hero_name.strip_hero_rank()
                +        '<span class="pull-right">'
                +          $.prettify_target(skill_data.atb_target)
                +        '</span>'
                +      '</div>'
                +      '<div class="col-xs-12">'
                +        '<strong>' + skill_name + '</strong>'
                +        '<span class="pull-right">'
                +          $.prettify_skill(skill_data.skill_category, skill_data.skill_cooldown)
                +        '</span>'
                +      '</div>'
                +    '</div>'
                +  '</a>';
    })
  })

  s_content += '</div>';

  return { count: count, content: s_content }
}