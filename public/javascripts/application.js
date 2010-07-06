// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//
function allow_editable(e) {
  alert("hai")
}

function calendar_click(e) {
  window.location = "http://www.google.com"
}

function draw_calendar() {
  var canvas = document.getElementById("calendar");
  var ctx = canvas.getContext("2d");

  ctx.save();
  ctx.fillStyle = "rgb(49, 76, 85)";
  ctx.globalAlpha = 1.0;
  ctx.beginPath();
  ctx.moveTo(0, 9);
  ctx.lineTo(103, 1);
  ctx.lineTo(107, 33);
  ctx.lineTo(3, 47);
  ctx.lineTo(0, 9);
  ctx.closePath();
  add_shadow(ctx)
  ctx.fill();
}

function draw_transaction() {
  var canvas = document.getElementById("transaction");
  var ctx = canvas.getContext("2d");

  ctx.save();
  ctx.fillStyle = "rgb(0, 153, 204)";
  ctx.globalAlpha = 1.0;
  ctx.beginPath();
  ctx.moveTo(0, 5);
  ctx.lineTo(149, 1);
  ctx.lineTo(147, 42);
  ctx.lineTo(10, 43);
  ctx.lineTo(0, 5);
  ctx.closePath();
  add_shadow(ctx);
  ctx.fill();
}

function draw_friend() {
  var canvas = document.getElementById("friend");
  var ctx = canvas.getContext("2d");

  ctx.save();
  ctx.fillStyle = "rgb(151, 153, 3)";
  ctx.globalAlpha = 1.0;
  ctx.beginPath();
  ctx.moveTo(6, 1);
  ctx.lineTo(99, 16);
  ctx.lineTo(100, 49);
  ctx.lineTo(2, 33);
  ctx.lineTo(6, 1);
  ctx.closePath();
  add_shadow(ctx);
  ctx.fill();
}

function draw_log_in() {
  var canvas = document.getElementById("log_in_blue");
  var ctx = canvas.getContext("2d");

  ctx.rotate(-2 * Math.PI / 180);
  ctx.globalAlpha = 1.0;
  ctx.save();
  ctx.fillStyle = "rgb(0, 153, 204)";
  ctx.beginPath();
  ctx.translate(0, 15)
  ctx.moveTo(1, 3);
  ctx.lineTo(148, 7);
  ctx.lineTo(155, 38);
  ctx.lineTo(1, 38);
  ctx.lineTo(1, 3);
  ctx.closePath();
  add_shadow(ctx)
  ctx.fill();
  ctx.restore();
  ctx.font = "14pt hobo_std";
  ctx.fillStyle = "White";
  ctx.fillText("LOG-IN", 15, 42);

}

function draw_sign_up() {
  var canvas = document.getElementById("sign_up_blue");
  var ctx = canvas.getContext("2d");

  ctx.rotate(2 * Math.PI / 180);
  ctx.globalAlpha = 1.0;
  ctx.save();
  ctx.fillStyle = "rgb(0, 153, 204)";
  ctx.beginPath();
  ctx.moveTo(0, 3);
  ctx.lineTo(161, 5);
  ctx.lineTo(156, 38);
  ctx.lineTo(0, 39);
  ctx.lineTo(0, 3);
  ctx.closePath();
  add_shadow(ctx);
  ctx.fill();
  ctx.restore();
  ctx.font = "14pt hobo_std";
  ctx.fillStyle = "White";
  ctx.fillText("NEW USER?", 15, 30);
}

function add_shadow(context) {
  context.save();
  context.shadowOffsetX = 5;
  context.shadowOffsetY = 5;
  context.shadowBlur = 10;
  context.shadowColor = "rgba(0, 0, 0, 0.5)";
  context.fill();
  context.restore();
}

function load_wood_bull_clip() {
  var canvas = document.getElementById("wood_bull_clip");
  var context = canvas.getContext("2d");

  var bull_clip = new Image();
  bull_clip.src = "/images/notes/bull_clip.png";
  bull_clip.onload = function() {
    context.drawImage(bull_clip, 0, 0);
  };
}

function load_note_bull_clip() {
  var canvas = document.getElementById("notes_bull_clip");
  var context = canvas.getContext("2d");

  var bull_clip = new Image();
  bull_clip.src = "/images/notes/bull_clip.png";
  bull_clip.onload = function() {
    context.rotate(-5 * Math.PI / 180);
    context.drawImage(bull_clip, 0, -22);
  };
}
function load_note(image_name) {
  $("#notes_" + image_name).attr("src", "/images/notes/" + image_name + ".png");
}

function load_notes() {
  load_note("first")
  load_note("second")
  load_note("third")
  load_note("fourth")
}

function draw_nav() {
  draw_calendar();
  draw_transaction();
  draw_friend();
  load_note_bull_clip();
  load_notes();
  load_wood_bull_clip();
  draw_log_in();
  draw_sign_up();

}
