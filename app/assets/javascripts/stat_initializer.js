$('#stat-table').bootstrapTable({
  url: '/stat/fetch',
  showColumns: true,
  uniqueId: 'id',
  toolbar: '.tabular-toolbar',
  rowAttributes: 'format_row_stat',
  onPostBody: function() { 
    resize_once('#stat-table', false); 
    activate_links('#stat-table');
  },
  onSort: function() {
    resize_bst_area('#stat-table', false);
    activate_links('#stat-table');
  }
});

var slider_lv = $('input#lv').bootstrapSlider({
  min: 30,
  max: 40,
  step: 1,
  tooltip: 'hide'
});

var slider_plus = $('input#plus').bootstrapSlider({
  min: 0,
  max: 5,
  step: 1,
  tooltip: 'hide'
});

$('input#lv').parent().find('.slider-horizontal').css('width', '64px');
$('input#plus').parent().find('.slider-horizontal').css('width', '32px');

$('input#lv').on('change', function() {
  var parameter = get_growth_parameter();
  $('#lv-text').text(parameter.level);

  recalculate_stats();
});


$('input#plus').on('change', function() {
  var parameter = get_growth_parameter();
  $('#plus-text').text(parameter.plus);

  recalculate_stats();
})

$('input#lv').trigger('change');
$('input#plus').trigger('change');

function recalculate_stats() {
  var length = $('#stat-table').bootstrapTable('getData').length;
  var uids = new Array();

  $('#stat-table').bootstrapTable('updateByUniqueId', uids);
}

function recalculate(i) {
  return {
    index: i,
    field: 'hp_calc',
    value: 0,
    reinit: false
  };
}

function get_growth_parameter() {
  return {
    level: $('input#lv').bootstrapSlider('getValue'),
    plus: $('input#plus').bootstrapSlider('getValue')
  }
}

function format_row_stat(row) {
  var calc = {
    hp_calc: 0,
    atk_calc: 0,
    mag_calc: 0,
    def_calc: 0,
    spd_calc: 0
  }

  calc.hp_calc = formulate(row.hp);
  calc.atk_calc = formulate(row.atk);
  calc.mag_calc = formulate(row.mag);
  calc.def_calc = formulate(row.def);
  calc.spd_calc = formulate(row.spd);

  row.hp_calc = calc.hp_calc;
  row.atk_calc = calc.atk_calc;
  row.mag_calc = calc.mag_calc;
  row.def_calc = calc.def_calc;
  row.spd_calc = calc.spd_calc;

  //console.log(row);
  return {};
}

function formulate(stat) {
  var p = get_growth_parameter();
  if (stat == undefined) {
    return 0;
  } else if (stat.level_gradient && stat.plus_gradient) {
    //return stat.base + stat.level_gradient * 0 + stat.plus_gradient;
    return stat.base + stat.level_gradient * (p.level - 30) + stat.plus_gradient * p.plus;
  } else {
    return stat.base;
  }
}