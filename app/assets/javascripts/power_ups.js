// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

jQuery.fn.extend({
  create_power_up_bar: function(id) {
    $(this).append(_create_power_up_bar(id));
    $('#' + id).activate_power_up_slider('#' + id + '-text', '#' + id + '-max');
  },

  create_element_bar: function(id) {
    $(this).append(_create_element_bar(id));
    $('#' + id).activate_element_slider('#' + id + '-text');
  },

  activate_element_slider: function(text_id) { 
    _activate_element_slider($(this), $(text_id)); 
  },

  activate_power_up_slider: function(text_id, max_id) { 
    _activate_power_up_slider($(this), $(text_id), $(max_id)); 
  },

  add: function(value) {
    return _add($(this), value);
  },

  subtract: function(value) {
    return _add($(this), -value);
  }
})

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
     + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'
     + '<span id="' + id + '-text"></span>';
}

function _create_power_up_bar(id) {
  return '<input id="' + id + '" type="text"/>'
       + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'
       + '<span id="' + id + '-text"></span> '
       + ' ~ '
       + '<span id="' + id + '-max"></span> ';
}

function _activate_element_slider(el, el_text) {
  $(el).bootstrapSlider({
    min: 0,
    max: 100,
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