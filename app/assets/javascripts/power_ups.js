// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
var fodder_grade = {
  3: [25, 50, 100, 200, 400],
  4: [12, 25, 50, 100, 200],
  5: [7, 12, 25, 50, 100],
  6: [1, 7, 12, 25, 50]
};

var gold_cost = {
  3: 2750,
  4: 4500,
  5: 6750,
  6: 9500
};

var element_grade = {
  3: [50, 100],
  4: [25, 50, 100],
  5: [12.5, 25, 50, 100],
  6: [6.25, 12.5, 25, 50, 100]
};

jQuery.fn.extend({
  create_container: function(id) {
    var that = $(this);
    var s = '<div class="row">'
          +   '<div class="col-xs-4">'
          +     '<div class="btn-group small-pad">'
          +       '<button type="button" class="btn btn-primary btn-block dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">'
          +         'Calculate<br />Power Up '
          +         '&nbsp;'
          +         '<span class="caret"></span>'
          +       '</button>'
          +       '<ul class="dropdown-menu">'
          +         '<li><a href="#" data-init=3>From 3 <span class="glyphicon glyphicon-star"></span></a></li>'
          +         '<li><a href="#" data-init=4>From 4 <span class="glyphicon glyphicon-star"></span></a></li>'
          +         '<li><a href="#" data-init=5>From 5 <span class="glyphicon glyphicon-star"></span></a></li>'
          +       '</ul>'
          +     '</div>'
          +   '</div>'
          +   '<div class="col-xs-8">'
          +     '<div class="input-group small-pad">'
          +       '<span class="input-group-addon">Gold</span>'
          +       '<span class="input-group-addon cumulative-gold-cost">0</span>'
          +     '</div>'
          +     '<div class="input-group small-pad cumulative-fodders">'
          +       '<span class="input-group-addon">Fodders</span>'
          +       '<span class="input-group-addon cfc-1">0</span>'
          +       '<span class="input-group-addon cfc-2">0</span>'
          +       '<span class="input-group-addon cfc-3">0</span>'
          +       '<span class="input-group-addon cfc-4">0</span>'
          +       '<span class="input-group-addon cfc-5">0</span>'
          +     '</div>'
          +     '<div class="input-group cumulative-elementals">'
          +       '<span class="input-group-addon">Elementals</span>'
          +       '<span class="input-group-addon cec-2">0</span>'
          +       '<span class="input-group-addon cec-3">0</span>'
          +       '<span class="input-group-addon cec-4">0</span>'
          +       '<span class="input-group-addon cec-5">0</span>'
          +     '</div>'
          +   '</div>'
          + '</div>'

          + '</div>'
          + '<br />'
          + '<div id="' + id + '"></div>';

    $(this).append(s);

    for (var i = 3; i <= 6; i++) {
      that.find('#' + id).create_grade(id, i);
      $('#' + id + '-' + i).fadeOut();
    }

    $(this).find('a[data-init]').on('click', function() {
      var init = parseInt($(this).attr('data-init'));

      for (var i = 3; i < init; i++) {
        $('#' + id + '-' + i).fadeOut();
      }

      that.find('input[data-value]').trigger('change');
      $('#' + id + '-' + init).fadeIn();
    })
  },

  create_grade: function(id, grade) {
    var s = '<ul class="list-group" id="' + id + '-' + grade + '" data-grade=' + grade + '>'
          +   '<li class="list-group-item active"><strong>'
          +     'Power Up ' + grade + ' <span class="glyphicon glyphicon-star"></span>'
          +   '</strong></li>'
          +   '<li class="list-group-item">'
          +     this.create_power_up_bar('a' + '-' + grade)
          +   '</li>'
          +   '<li class="list-group-item">'
          +     '<div class="row">'
          +       '<div class="col-xs-8">'
          +         this.create_fodder_staging('c' + '-' + grade)
          +       '</div>'
          +       '<div class="col-xs-4">'
          +         this.create_gold_cost_tracker('d' + '-' + grade)
          +       '</div>'
          +     '</div>'
          +     '<div class="clearfix"></div>'
          +   '</li>';

    if (grade < 6) {
       s +=   '<li class="list-group-item list-group-item-info">'
          +     '<strong>Add Elementals</strong>'
          +   '</li>'
          +   '<li class="list-group-item">'
          +     this.create_element_bar('b' + '-' + grade)
          +   '</li>'
          +   '<li class="list-group-item">'
          +     this.create_element_staging('e' + '-' + grade, grade)
          +   '</li>'
    }

       s += '</ul>';
       
    $(this).append(s);

    $('#a-' + grade).activate_power_up_slider();
    $('#b-' + grade).activate_element_slider();
    $('#c-' + grade).activate_fodder_controls($('#a-' + grade), grade);

    if (grade < 6) {
      $('#e-' + grade).activate_element_controls($('#b-' + grade), grade);
    }
  },

  create_gold_cost_tracker: function(id) {
    return _create_gold_cost_tracker(id);
  },

  create_fodder_staging: function(id) {
    return _create_fodder_staging(id);
  },

  create_power_up_bar: function(id) {
    return _create_power_up_bar(id);
  },

  create_element_bar: function(id) {
    return _create_element_bar(id);
  },

  create_element_staging: function(id, grade) {
    return _create_element_staging(id, grade);
  },

  activate_fodder_controls: function(el, grade) {
    _activate_fodder_controls($(this), el, grade);
  },

  activate_element_controls: function(el, grade) {
    _activate_element_controls($(this), el, grade);
  },

  activate_element_slider: function() { 
    var text_id = $(this).selector;
    _activate_element_slider($(text_id), $(text_id + '-text'));
  },

  activate_power_up_slider: function(text_id, max_id) { 
    var text_id = $(this).selector;
    _activate_power_up_slider($(this), $(text_id + '-text'), $(text_id + '-max')); 
  },

  add: function(value) {
    return _add($(this), value);
  },

  subtract: function(value) {
    return _add($(this), -value);
  },

  set: function(value) {
    return _set($(this), value);
  }
})

function _create_element_staging(id, grade) {
  var u = new Array();

  for (var i = 2; i <= grade; i++) {
    u.push('<div class="btn-group small-pad">' + _create_element_button(i) + '</div>');
  }

  var s = u.join('<br />');

  return '<div id="' + id + '">' + s + '</div>';
}

function _create_element_button(grade) {
  var s = '<button type="button" class="btn btn-default" disabled>'
        +   '<strong>' + grade + ' </strong>'
        +   '<span class="glyphicon glyphicon-star"></span>'
        + '</button>'
        + '<button type="button" class="btn btn-success element-subtract">'
        +   '<span class="glyphicon glyphicon-minus"></span>'
        + '</button>'
        + '<button type="button" class="btn element-count" data-grade=' + grade + ' disabled>0</button>'
        + '<button type="button" class="btn btn-success element-add">'
        +   '<span class="glyphicon glyphicon-plus"></span>'
        + '</button>';

  return s;
}

function _create_gold_cost_tracker(id) {
  var s = '';

  s += '<ul class="list-group">'
    +    '<li class="list-group-item text-center"><strong>Gold Cost</strong></li>'
    +    '<li class="list-group-item list-group-item-warning text-center gold-cost-text">0</li>'
    +  '</ul>'
  return s;
}

function _create_fodder_staging(id) {
  var u = new Array();

  $.each([1,2,3,4], function(i, x) {
    u.push('<div class="btn-group small-pad">' + _create_fodder_button(x) + '</div>');
  });

  var s = u.join('<br />');

  return '<div id="' + id + '">' + s + '</div>';
}

function _create_fodder_button(grade) {
  var s = '<button type="button" class="btn btn-default" disabled><strong>' + grade + '</strong> <span class="glyphicon glyphicon-star"></span></button> '
        + '<button type="button" class="btn btn-success fodder-subtract"><span class="glyphicon glyphicon-minus"></span></button>'
        + '<button type="button" class="btn fodder-count" data-grade=' + grade + ' disabled>0</button>'
        + '<button type="button" class="btn btn-success fodder-add"><span class="glyphicon glyphicon-plus"></span></button>'
        + '<button type="button" class="btn fodder-cost" disabled>0</button>';

  return s;
}

function _activate_element_controls(el, _slider_el, grade) {
  el.find('.element-subtract').on('click', function() {
    _update_element_count($(this), -1, grade, _slider_el);
    _update_element_meter(el, _slider_el, grade);
  });

  el.find('.element-add').on('click', function() {
    _update_element_count($(this), 1, grade, _slider_el);
    _update_element_meter(el, _slider_el, grade);
  });

  _update_element_meter(el, _slider_el, grade);
}

function _activate_fodder_controls(el, _slider_el, grade) {
  el.find('.fodder-subtract').on('click', function() {
    _update_fodder_count($(this), -1, grade, _slider_el);
    _update_fodder_meter(el, _slider_el, grade);
  });

  el.find('.fodder-add').on('click', function() {
    _update_fodder_count($(this), 1, grade, _slider_el);
    _update_fodder_meter(el, _slider_el, grade);
  })

  _update_fodder_meter(el, _slider_el, grade);
}

function _evaluate_dependency(el) {
  var list_group = el.parent().parent();
  var fodder_progress = parseInt(list_group.find('input.fodder-bar').bootstrapSlider('getValue')[1]);
  var element_progress = parseInt(list_group.find('input.element-bar').bootstrapSlider('getValue'));

  console.log('evaluating ' + fodder_progress + ': ' + element_progress);

  if (fodder_progress >= 500 && element_progress >= 100) {
    console.log('unhiding ');
    console.log(list_group.next());
    list_group.next().fadeIn();
  } else {
    list_group.nextAll().fadeOut();
  }
}

function _update_element_meter(el, _slider_el, grade) {
  var sum = 0;
  var cost = 0;

  el.find('.element-count').each(function(i, x) {
    sum += parseInt($(this).text()) * element_grade[grade][i];
  });

  _slider_el.set(sum);

  if (sum >= 100) {
    $.each(el.find('.element-add'), function() {
      $(this).prop('disabled', true);
    });

    $.each(el.find('.element-subtract'), function() {
      var that = $(this);

      if (parseInt(that.parent().find('.element-count').text()) == 0) {
        that.prop('disabled', true);
      } else {
        that.prop('disabled', false);
      }
    });
  } else if (sum <= 0) {
    $.each(el.find('.element-subtract'), function() {
      $(this).prop('disabled', true);
    });

    $.each(el.find('.element-add'), function() {
      $(this).prop('disabled', false);
    })
  } else {
    $.each(el.find('.element-add'), function() {
      $(this).prop('disabled', false);
    });

    $.each(el.find('.element-subtract'), function() {
      var that = $(this);

      if (parseInt(that.parent().find('.element-count').text()) == 0) {
        that.prop('disabled', true);
      } else {
        that.prop('disabled', false);
      }
    });
  }

  _update_cumulatives(el);
}

function _update_cumulatives(el) {
  var target_eles = el.parent().parent().parent().parent().find('.cumulative-elementals');
  var target_gold = el.parent().parent().parent().parent().parent().parent().find('.cumulative-gold-cost');
  var target_fodders = el.parent().parent().parent().parent().parent().parent().find('.cumulative-fodders');
  var source_eles = el.parent().parent().parent().parent().parent().find('.element-count:visible');
  var source_gold = el.parent().parent().parent().parent().parent().find('.gold-cost-text:visible');
  var source_fodders = el.parent().parent().parent().parent().parent().find('.fodder-count:visible');

  var result_eles = {
    2: 0, 3: 0, 4: 0, 5: 0
  };

  var result_fodders = {
    1: 0, 2: 0, 3: 0, 4: 0, 5: 0
  };

  var result_gold = 0;

  source_eles.each(function() {
    var grade = parseInt($(this).attr('data-grade'));
    var count = parseInt($(this).text());

    result_eles[grade] += count;
  });

  source_gold.each(function() {
    result_gold += parseInt($(this).attr('data-value'));
  });

  source_fodders.each(function() {
    var grade = parseInt($(this).attr('data-grade'));
    var count = parseInt($(this).text());

    result_fodders[grade] += count;
  });

  $.each(result_eles, function(i, x) {
    target_eles.find('.cec-' + i).text(result_eles[i]);
  })

  target_gold.text(result_gold.toLocaleString());

  $.each(result_fodders, function(i, x) {
    target_fodders.find('.cfc-' + i).text(result_fodders[i]);
  })

}

function _update_fodder_meter(el, _slider_el, grade) {
  var sum = 0;
  var cost = 0;

  el.find('.fodder-count').each(function(i, x) {
    sum += parseInt($(this).text()) * fodder_grade[grade][i];
  });

  el.find('.fodder-cost').each(function(i, x) {
    var val = parseInt($(this).attr('data-value'));

    if (isNaN(val)) {
      return true;
    }

    cost += val;
  })

  el.parent().parent().find('.gold-cost-text').text(cost.toLocaleString());
  el.parent().parent().find('.gold-cost-text').attr('data-value', cost);
  _slider_el.set(sum);

  if (sum >= 500) {
    $.each(el.find('.fodder-add'), function() {
      $(this).prop('disabled', true);
    });

    $.each(el.find('.fodder-subtract'), function() {
      var that = $(this);

      if (parseInt(that.parent().find('.fodder-count').text()) == 0) {
        that.prop('disabled', true);
      } else {
        that.prop('disabled', false);
      }
    });
  } else if (sum <= 0) {
    $.each(el.find('.fodder-subtract'), function() {
      $(this).prop('disabled', true);
    });

    $.each(el.find('.fodder-add'), function() {
      $(this).prop('disabled', false);
    })
  } else {
    $.each(el.find('.fodder-add'), function() {
      $(this).prop('disabled', false);
    });

    $.each(el.find('.fodder-subtract'), function() {
      var that = $(this);

      if (parseInt(that.parent().find('.fodder-count').text()) == 0) {
        that.prop('disabled', true);
      } else {
        that.prop('disabled', false);
      }
    });
  }

  _update_cumulatives(el);
}

function _update_element_count(el, x, grade, _slider_el) {
  var target = el.parent().find('.element-count');
  var value = parseInt(target.text());
  var is_exceeded = _slider_el.bootstrapSlider('getValue') >= 100 ? true : false;

  target.text((value == 0 && x < 0) || (is_exceeded && x > 0) ? value : value + x);
}

function _update_fodder_count(el, x, grade, _slider_el) {
  var target = el.parent().find('.fodder-count');
  var cost = el.parent().find('.fodder-cost');
  var value = parseInt(target.text());
  var is_exceeded = _slider_el.bootstrapSlider('getValue')[0] >= 500 ? true : false;

  target.text((value == 0 && x < 0) || (is_exceeded && x > 0) ? value : value + x);
  cost.text((parseInt(target.text()) * gold_cost[grade]).toLocaleString());
  cost.attr('data-value', parseInt(target.text()) * gold_cost[grade])
}

function _set(el, value) {
  if (el.bootstrapSlider('getAttribute', 'range')) {
    el.bootstrapSlider('setValue', [parseFloat(value), 
                                    parseFloat(value) * 1.5]
                                 , false
                                 , true);
    _alert_exceeding(el.parent().parent().find('.power-ups-group').first().find('.exceed-warning').first(), parseFloat(value) > 500);
    _alert_exceeding(el.parent().parent().find('.power-ups-group').first().find('.exceed-warning').last(), parseFloat(value) * 1.5 > 500);
  } else {
    el.bootstrapSlider('setValue', parseFloat(value), false, true);
    _alert_exceeding(el, value > 100);
  }

}

function _alert_exceeding(el, _bool) {
  if (_bool) {
    el.parent().find('.exceed-warning').html('<span class="glyphicon glyphicon-exclamation-sign"></span>');
  } else {
    el.parent().find('.exceed-warning').html('');
  }
}

function _add(el, value) {
  if (el.bootstrapSlider('getAttribute', 'range')) {
    var current_value = el.bootstrapSlider('getValue')[0];

    el.bootstrapSlider('setValue', [parseFloat(current_value + value), 
                                    parseFloat(current_value + value) * 1.5]
                                 , false
                                 , true);
  } else {
    var current_value = el.bootstrapSlider('getValue');

    el.bootstrapSlider('setValue', parseFloat(current_value + value), false, true);
  }

  return el.bootstrapSlider('getValue');
}

function _create_element_bar(id) {
  return '<input id="' + id + '" type="text" class="element-bar" />'
       + '<ul class="pagination power-ups-group">'
       +   '<li>'
       +     '<span id="' + id + '-text"> '
       +       '<span class="value"></span>'
       +       '<span class="exceed-warning"></span>'
       +   '</li>'
       + '</ul>';
}

function _create_power_up_bar(id) {
  return '<input id="' + id + '" type="text" class="fodder-bar" />'
       + '<ul class="pagination power-ups-group">'
       +   '<li>'
       +     '<span id="' + id + '-text"> '
       +       '<span class="value"></span>'
       +       '<span class="exceed-warning"></span>'
       +     '</span>'
       +   '</li>'
       +   '<li>'
       +     '<span id="' + id + '-max"> '
       +       '<span class="value"></span>'
       +       '<span class="exceed-warning"></span>'
       +     '</span>'
       +   '</li>'
       + '</ul>';
}

function _activate_element_slider(el, _el_text) {
  $(el).bootstrapSlider({
    ticks: [0, 100],
    ticks_labels: [0, 100],
    value: 0
  });

  var el_text = $(_el_text).find('.value');

  $(el).bootstrapSlider('disable');
  $(el).on('change', function(evt) {
    if (evt.value == undefined) {
    } else {
      $(el_text).html(_element_string(evt.value.newValue));

      _evaluate_dependency($(el));
    }
  });

  $(el_text).html(_element_string($(el).bootstrapSlider('getValue')));
}

function _activate_power_up_slider(el, _el_text, _el_max) {
  $(el).bootstrapSlider({
    ticks: [0, 100, 200, 300, 400, 500],
    ticks_labels: [0, 1, 2, 3, 4, 5],
    value: [0, 0],
    range: true
  });

  var el_text = $(_el_text).find('.value');
  var el_max = $(_el_max).find('.value');

  $(el).bootstrapSlider('disable');
  $(el).on('change', function(evt) {
    if (evt.value == undefined) {
    } else {
      $(el_text).html(_power_up_string(evt.value.newValue[0]));
      $(el_max).html(_power_up_string(evt.value.newValue[1]));

      if (evt.value.newValue[0] >= 500) {
        $(el_text).parent().addClass('active');
      } else {
        $(el_text).parent().removeClass('active');
      }

      if (evt.value.newValue[1] >= 500) {
        $(el_max).parent().addClass('active');
      } else {
        $(el_max).parent().removeClass('active');
      }
    }

    _evaluate_dependency($(el));
  });

  $(el_text).html(_power_up_string($(el).bootstrapSlider('getValue')[0]));
  $(el_max).html(_power_up_string($(el).bootstrapSlider('getValue')[1]));
}

function _power_up_string(value) {
  var power = parseInt(value / 100);
  var progress = value % 100;

  return '<strong>+' + power + '</strong> ' + progress + '%';
}

function _element_string(value) {
  return '<strong>' + value + '</strong> %';
}