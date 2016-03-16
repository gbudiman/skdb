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
}

jQuery.fn.extend({
  create_grade: function(id, grade) {
    var s = '<ul class="list-group">'
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
       s +=   '<li class="list-group-item">'
          +     this.create_element_bar('b' + '-' + grade)
          +   '</li>'
    }

       s += '</ul>';
       
    $(this).append(s);

    $('#a-' + grade).activate_power_up_slider();
    $('#b-' + grade).activate_element_slider();
    $('#c-' + grade).activate_fodder_controls($('#a-' + grade), grade);
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

  activate_fodder_controls: function(el, grade) {
    _activate_fodder_controls($(this), el, grade);
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

function _create_gold_cost_tracker(id) {
  var s = '';

  s += '<ul class="list-group">'
    +    '<li class="list-group-item text-center"><strong>Gold Cost</li>'
    +    '<li class="list-group-item list-group-item-warning text-center gold-cost-text">0</li>'
    +  '</ul>'
  return s;
}

function _create_fodder_staging(id) {
  var u = new Array();

  $.each([1,2,3,4,5], function(i, x) {
    u.push('<div class="btn-group small-pad">' + _create_fodder_button(x) + '</div>');
  });

  var s = u.join('<br />');

  return '<div id="' + id + '">' + s + '</div>';
}

function _create_fodder_button(grade) {
  var s = '<button type="button" class="btn" disabled><strong>' + grade + '</strong> <span class="glyphicon glyphicon-star"></span>' + '</button> '
        + '<button type="button" class="btn btn-success fodder-subtract"><span class="glyphicon glyphicon-minus"></button>'
        + '<button type="button" class="btn fodder-count" disabled>0</button>'
        + '<button type="button" class="btn btn-success fodder-add"><span class="glyphicon glyphicon-plus"></button>'
        + '<button type="button" class="btn fodder-cost" disabled>0</button>';

  return s;
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
  _slider_el.set(sum);
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
  } else {
    el.bootstrapSlider('setValue', parseFloat(value), false, true);
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
  return '<input id="' + id + '" type="text"/>'
       + '<ul class="pagination power-ups-group">'
       +   '<li>'
       +     '<span id="' + id + '-text"></span>'
       +   '</li>'
       + '</ul>';
}

function _create_power_up_bar(id) {
  return '<input id="' + id + '" type="text"/>'
       + '<ul class="pagination power-ups-group">'
       +   '<li>'
       +     '<span id="' + id + '-text"></span> '
       +   '</li>'
       +   '<li>'
       +     '<span id="' + id + '-max"></span> '
       +   '</li>'
       + '</ul>';
}

function _activate_element_slider(el, el_text) {
  $(el).bootstrapSlider({
    ticks: [0, 100],
    ticks_labels: [0, 100],
    value: 0
  })

  $(el).bootstrapSlider('disable');
  $(el).on('change', function(evt) {
    $(el_text).html(_element_string(evt.value.newValue));
  });

  $(el_text).html(_element_string($(el).bootstrapSlider('getValue')));
}

function _activate_power_up_slider(el, el_text, el_max) {
  $(el).bootstrapSlider({
    ticks: [0, 100, 200, 300, 400, 500],
    ticks_labels: [0, 1, 2, 3, 4, 5],
    value: [0, 0],
    range: true
  });

  $(el).bootstrapSlider('disable');
  $(el).on('change', function(evt) {
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