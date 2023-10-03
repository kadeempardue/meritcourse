$(document).ready(function() {
  ace.config.set('basePath', '/assets/src-noconflict')

  $('.form').parsley();

  $("#scope-filter").on("change", function(){
    var val = $(this).val();
    var href = new URL(window.location.href);
    href.searchParams.set('scope', val);
    window.location.href = href.toString();
  });

  $(document).ready(function(){

    $(document).on('click', '.copy_from', copy_handler);
    $(document).on('click', '.delete-button', modal_handler);
    $(document).on('click', '.badge-button', badge_modal_handler);
    $(document).on('click', '.deny-badge-button', deny_badge_modal_handler);
    $(document).on('click', '.confirm-button', confirm_action);
    $(document).on('click', '.schedule-confirm-button', addSchedule);
    $(document).on('click', '.schedule-delete-button', deleteSchedule);
    $(document).on('click', '.sendBadge', sendBadge);
    $(document).on('click', '.denyBadge', denyBadge);
    $scheduleCount = 0;

    $(document).on("click", "[data-day]", function(e) {
      try {
        UIkit.modal("#add-schedule-modal").show()
      } catch(e) {
        // console.error(e);
      }
    });

    function copy_handler(e) {
      $(".copy_to").val($(this).html());
    }

    function addSchedule(e) {
      $day = $(e.target).attr("data-day-ref");
      $startTime = $("#start_datetime").val();
      $endTime = $("#end_datetime").val();
      $lessonName = $("#lesson_name").val();

      $("<input>").attr("type", "hidden").attr("name", "lesson[schedules_attributes][" + $scheduleCount + "][start_datetime]").val($day + ' ' + $startTime).appendTo("#lesson-form");
      $("<input>").attr("type", "hidden").attr("name", "lesson[schedules_attributes][" + $scheduleCount + "][end_datetime]").val($day + ' ' + $endTime).appendTo("#lesson-form");

      $appender = $("[data-day='" + $day + "']").find("ul");

      $li = '<li>' +
        '<a class="uk-accordion-title button small soft-grey mb-0" href="#">' +
          $startTime + ' - ' + $endTime +
        '</a><div class="uk-accordion-content"></div>'
      '</li>';
      $appender.append($li);

      try {
        UIkit.modal("#add-schedule-modal").hide()
      } catch(e) {
        // console.error(e);
      }

      UIkit.notification({message: "Added Schedule! Please save your lesson in order for changes to take effect.", pos: 'top-center', status: 'success'})
      $scheduleCount++;

      return true;
    }

    function deleteSchedule(e) {
      modal_handler(e);
      $("[data-calendar-id='" + $fn_id + "']").fadeOut();
      confirm_action(e);
    }

    function sendBadge(e) {
      $.ajax({
        url: "/admin/courses/" + $fn_course_id + "/lessons/" + $fn_lesson_id + "/send_badge",
        method: "POST",
        dataType: "JSON",
        data: {
          lesson_name: $fn_lesson_name,
          badge_id: $('#badge-selector option:selected').val(),
          lesson_id: $('#lesson_id').val(),
          cc: $fn_cc,
          email: $fn_email,
        },
        success: function(data) {
          try {
            UIkit.modal("#modal-send-badge").hide()
          } catch(e) {
            console.error(e);
          }

          if (data && data.notice) {
            UIkit.notification({message: data.notice, pos: 'top-center', status: 'success'})
          } else {
            UIkit.notification({message: data.error, pos: 'top-center', status: 'danger'})
          }
        },
        error: function(data) {
          UIkit.notification({message: data.responseJSON.error, pos: 'top-center', status: 'danger'})
        }
      })
    }

    function denyBadge(e) {
      $.ajax({
        url: "/admin/courses/" + $fn_course_id + "/lessons/" + $fn_lesson_id + "/deny_badge",
        method: "POST",
        dataType: "JSON",
        data: {
          lesson_name: $fn_lesson_name,
          badge_id: $('#deny-badge-selector option:selected').val(),
          lesson_id: $('#lesson_id').val(),
          cc: $fn_cc,
          email: $fn_email,
        },
        success: function(data) {
          try {
            UIkit.modal("#modal-deny-badge").hide()
          } catch(e) {
            console.error(e);
          }

          if (data && data.notice) {
            UIkit.notification({message: data.notice, pos: 'top-center', status: 'success'})
          } else {
            UIkit.notification({message: data.error, pos: 'top-center', status: 'danger'})
          }
        },
        error: function(data) {
          UIkit.notification({message: data.responseJSON.error, pos: 'top-center', status: 'danger'})
        }
      })
    }

    function confirm_action(e) {
      $.ajax({
        url: $fn_action,
        method: "DELETE",
        dataType: "JSON",
        data: {
          authenticity_token: $fn_token
        },
        success: function(data) {
          try {
            UIkit.modal("#delete-modal").hide()
          } catch(e) {
            console.error(e);
          }

          UIkit.notification({message: data.notice, pos: 'top-center', status: 'success'})
          $("[data-row-id='" + data.id + "']").fadeOut();
          $elem_current_count = $(".current_count");
          $elem_total_count = $(".total_count");
          if ($elem_total_count) {
            $current_count = parseInt($elem_current_count.html()) - 1;
            $total_count   = parseInt($elem_total_count.html()) - 1;
            $elem_current_count.html($current_count);
            $elem_total_count.html($total_count);
          }
        },
        error: function(data) {
          UIkit.notification({message: data.responseJSON.error, pos: 'top-center', status: 'danger'})
        }
      })
    }

    function modal_handler(e) {
      $fn_id = $(e.target).data('id');
      $fn_token = $(e.target).data('token');
      $fn_name = $(e.target).data('name');
      $fn_action = $(e.target).data('action');
      $(".resource_name").html($fn_name);
      $(".btn-option, .uk-dropdown").removeClass("uk-open");
    }

    function badge_modal_handler(e) {
      $fn_course_id = $(e.target).data('course-id');
      $fn_lesson_id = $(e.target).data('lesson-id');
      $fn_name = $(e.target).data('name');
      $fn_email = $(e.target).data('email');
      $fn_cc = $(e.target).data('cc');
      $fn_lesson_name = $(e.target).data('lesson-name');
      $fn_action = $(e.target).data('action');
      $(".resource_name").html($fn_name);
      $(".btn-option, .uk-dropdown").removeClass("uk-open");
    }

    function deny_badge_modal_handler(e) {
      $fn_course_id = $(e.target).data('course-id');
      $fn_lesson_id = $(e.target).data('lesson-id');
      $fn_name = $(e.target).data('name');
      $fn_email = $(e.target).data('email');
      $fn_cc = $(e.target).data('cc');
      $fn_lesson_name = $(e.target).data('lesson-name');
      $fn_action = $(e.target).data('action');
      $(".resource_name").html($fn_name);
      $(".btn-option, .uk-dropdown").removeClass("uk-open");
    }

    function badgeChange_handler_init() {
      $('#badge-selector').change(function() {
        $(".badge-placeholder img")[0].src = $(this).find("option:selected").attr("data-image-url");
      });
    }
    badgeChange_handler_init();

    function denyBadgeChange_handler_init() {
      $('#deny-badge-selector').change(function() {
        $(".badge-placeholder img")[1].src = $(this).find("option:selected").attr("data-image-url");
      });
    }
    denyBadgeChange_handler_init();

    $(document).on("click", "[data-day]", function(e) {
      $day = $(this).attr("data-day");
      $(".schedule_name").html($day);
      $("[data-day-ref]").attr("data-day-ref", $day);
    });
  });
});
