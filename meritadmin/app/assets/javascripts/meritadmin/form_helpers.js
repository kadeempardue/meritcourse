var toggleSchedule = function(val) {
  // On Demand
   if (val == 0) {
     $("#events_calendar").attr("hidden", true);
     $("#instructor_host").attr("hidden", true);
   } else if (val == 1) {
     // Livestream
     $("#events_calendar").removeAttr("hidden");
     $("#instructor_host").removeAttr("hidden");
   }
}

$isScheduledInput = $('[name="lesson[is_scheduled]"]');

$isScheduledInput.on('change', function() {
  toggleSchedule($(this).val());
});

toggleSchedule($isScheduledInput.val());
