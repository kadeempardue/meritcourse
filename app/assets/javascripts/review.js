function star(r, c) {
  var rating = r;
  var clickable = c;
  var modulo = Number((rating % 1).toFixed(2));
  var modulo_flag = false;
  var html = '';
  var clickable_class = '';

  if (clickable) {
    clickable_class = 'clickable ';
  } else {
    clickable_class = ' ';
  }

  for (var step = 1; step <= 5; step++) {
    var extra_class = 'empty';

    if (rating >= step) {
      extra_class = '';
    } else if (!modulo_flag) {
      if (modulo > 0.0) {
        extra_class = 'quarter';
      }

      if (modulo >= 0.5) {
        extra_class = 'half';
      }

      if (modulo >= 0.75) {
        extra_class = 'three_quarter';
      }

      modulo_flag = true;
    } else {
      extra_class = 'empty';
    }

    html += "<span class='star " + clickable_class + extra_class + "' star-value='" + step + "'></span>";
  }

  return html;
}

$(document).on('mouseenter', '.star.clickable', function () {
  var val = $(this).attr('star-value');

  for (var step = 1; step <= val; step++) {
    $(".star.clickable[star-value='" + step + "']").removeClass('empty');
  }
  $(this).removeClass('empty');

}).on('mouseleave', '.star.clickable', function () {
  $(".star.clickable[star-value]").addClass('empty');
}).on('click', '.star.clickable', function () {
  var val = $(this).attr('star-value');
  $("#review_rating").val(val);
  
  $(".star.clickable[star-value]").addClass('empty');

  for (var step = 1; step <= val; step++) {
    $(".star.clickable[star-value='" + step + "']").removeClass('empty');
  }
  $(this).removeClass('empty');

  $(document).off('mouseenter mouseleave', '.star.clickable');
});
