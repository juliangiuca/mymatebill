function popover() {
  $("#observe_me").val("I owe steve $50 for vuvuzela lessons");
  $("#observe_me").addClass("light_gray")
  $("#greybox").fadeIn("slow");
  $("#quick_add").fadeIn("slow");
  $("#quick_add").center();
  $("#quick_add_submit").show();
}

function close_pop_over() {
  $("#greybox").fadeOut("slow");
  $("#quick_add").fadeOut("slow");
  $("#tick").hide();
  $("#hot_tip").hide();
  $("#big_spinner").hide();
}

function show_tick_and_fade_out() {
  $("#big_spinner").hide();
  $("#tick").fadeIn("slow");
  setTimeout('close_pop_over()', 2000)
}

function shake() {
  $("#big_spinner").hide();
  $("#block_icon").show();
  $("#quick_add").shake(2, 10, 400);
  $("#hot_tip").show();
  setTimeout('reset_buttons()', 1000)
}

function reset_buttons() {
  $("#block_icon").hide();
  $("#quick_add_submit").fadeIn("slow");
}

function hide_submit() {
  $("#quick_add_submit").hide();
  $("#big_spinner").show();
}

