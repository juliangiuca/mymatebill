function load_wood_bull_clip() {
  var canvas = document.getElementById("wood_bull_clip");
  var context = canvas.getContext("2d");

  var bull_clip = new Image();
  bull_clip.src = "/images/notes/bull_clip.png";
  bull_clip.onload = function() {
    context.drawImage(bull_clip, 0, 0);
  };
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
