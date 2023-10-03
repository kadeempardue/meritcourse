$(document).ready(function() {
  // initialize Tagify on the above input node reference
  if ($("[data-tagify]").length > 0) {
    $("[data-tagify]").each(function(i, elem) {
      new Tagify(elem);
    });
  }

  var clipboard = new ClipboardJS('.copy-elem', {
    text: function text(_ref) {
      var clipboardTarget = _ref.dataset.clipboardTarget;

      var _document$querySelect = document.querySelector(clipboardTarget);

      var value = _document$querySelect.value;
      var innerHTML = _document$querySelect.innerHTML;

      return value || innerHTML;
    }
  });

  clipboard.on('success', function(e) {
    UIkit.notification({message: 'Successfully copied media url to clipboard.', pos: 'top-center', status: 'success'})
    e.clearSelection();
  });
  clipboard.on('error', function(e) {
    UIkit.notification({message: 'Something went wrong when trying to copy media url.', pos: 'top-center', status: 'danger'})
    e.clearSelection();
  });

  $('#mediaLibraryFile').on("change", function(e){
    if ($(this).val()) {
      $('#mediaLibraryUploadBtn').removeAttr('disabled');
    } else {
      $('#mediaLibraryUploadBtn').attr('disabled', true);
    }
  });

  $('.colorPicker').minicolors({ format: 'hex', swatches: ['#f44336','#2196f3','#4caf50','#ffeb3b','#ff9800','#795548','#9e9e9e'] })

  $('.timepicker.start').wickedpicker({
    now: "8:00",
    title: "Select A Time",
    minutesInterval: 15,
    secondsInterval: 0
  });

  $('.timepicker.end').wickedpicker({
    now: "12:00",
    title: "Select A Time",
    minutesInterval: 15,
    secondsInterval: 0
  });
});
