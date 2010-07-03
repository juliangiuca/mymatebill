// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//
function allow_editable(e) {
  alert("hai")
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
  ctx.restore();
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
  add_shadow(ctx)
  ctx.fill();
  ctx.restore();
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
  add_shadow(ctx)
  ctx.fill();
  ctx.restore();
}

function add_shadow(context) {
  context.shadowOffsetX = 5;
  context.shadowOffsetY = 5;
  context.shadowBlur = 10;
  context.shadowColor = "#595959";
}
var note = new Array();
function load_note(ctx_name) {
  var canvas = document.getElementById("notes_" + ctx_name);
  var context = canvas.getContext("2d");

  position = note.push(new Image()) - 1;
  eval("var note_" + ctx_name + " = position;")
  note[position].src = "/images/notes/" + ctx_name + ".png";
  note[position].onload = function() {
    context.drawImage(note[eval("note_" + ctx_name)], 0, 0);
  };
}

function load_notes() {
  load_note("first")
  load_note("second")
  load_note("third")
  load_note("fourth")
  load_note("bull_clip")
}


function draw_nav() {
  draw_calendar();
  draw_transaction();
  load_notes();
  draw_friend();
}
