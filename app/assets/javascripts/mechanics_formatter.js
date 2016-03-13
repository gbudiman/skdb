function group(x) {
  var h = new Object();
  $.each(x, function(i, x) {
    if (h[x.hero_name] == undefined) {
      h[x.hero_name] = {
        hero_element: x.hero_element,
        skill_data: new Array()
      };
    }

    h[x.hero_name]['skill_data'].push(x);
  })

  return h;
}

function group_format(hero, data, alignment) {
  var s = ''
  var span_class = (alignment == 'left') ? 'pull-right' : 'pull-left';
  var span_invert = (alignment == 'left') ? 'pull-left' : 'pull-right';

  s += '<span class="' + span_class + '">'
    +    format_hero_element(data.hero_element, null, null)
    +    ' '
    +    '<strong>' + hero + '</strong>'
    +  '</span>'
    +  '<br />'
    +  '<ul class="list-unstyled">';

  $.each(data.skill_data, function(skill, sd) {
    var classifier = '';
    var help = '';
    var glyph = '';

    if (sd.turns != undefined) {
      classifier = sd.turns;
      help = 'Duration (turns)';
      glyph = 'refresh';
    }

    if (sd.fraction != undefined) {
      classifier = sd.fraction;
      help = 'Fraction (%)';
      glyph = 'signal';
    }

    s += '<li>'
      +    '<span class="' + span_class + '">' + sd.skill_name + '</span>'
      +    '<span class="' + span_invert + '">';

    if (alignment == 'right') {
      s += $.prettify_generic(glyph, classifier, help)
        +  ' '
        +  $.prettify_target(sd.skill_target)
        +  ' '
        +  $.prettify_skill(sd.skill_category, sd.skill_cooldown);
    } else {
      s += $.prettify_skill(sd.skill_category, sd.skill_cooldown)
        +  ' '
        +  $.prettify_target(sd.skill_target)
        +  ' '
        +  $.prettify_generic(glyph, classifier, help);
    }
      
    s += '</span>'
      +  '</li><br />';
  })

  s += '</ul>';

  return s;
}