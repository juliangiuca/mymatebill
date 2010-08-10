function draw_user_welcome(username) {
  var canvas = document.getElementById("username");
  var ctx = canvas.getContext("2d");

  ctx.rotate(-1 * Math.PI / 180);
  ctx.globalAlpha = 1.0;
  ctx.save();
  ctx.fillStyle = "#2e2925";
  ctx.beginPath();
  ctx.moveTo(12, 8);
  ctx.lineTo(171, 7);
  ctx.lineTo(177, 38);
  ctx.lineTo(8, 42);
  ctx.lineTo(12, 8);
  ctx.closePath();
  add_shadow(ctx)
  ctx.fill();
  ctx.restore();
  ctx.font = "12pt hobo_std";
  ctx.save()
  ctx.fillStyle = "White";
  ctx.fillText("WELCOME", 15, 30);
  ctx.fillStyle = "#0099CC";
  ctx.fillText(username, 98, 30);
}

function draw_title(thing_to_say) {
  var canvas = document.getElementById("main_title");
  var ctx = canvas.getContext("2d");

  ctx.rotate(1 * Math.PI / 180);
  ctx.globalAlpha = 1.0;
  ctx.save();
  ctx.fillStyle = "#0099cc";
  ctx.beginPath();
  ctx.moveTo(5, 12);
  ctx.lineTo(231, 6);
  ctx.lineTo(230, 46);
  ctx.lineTo(12, 51);
  ctx.lineTo(5, 12);
  ctx.closePath();
  add_shadow(ctx)
  ctx.fill();
  ctx.restore();
  ctx.rotate(-2 * Math.PI / 180);
  ctx.font = "16pt hobo_std";
  ctx.fillStyle = "White";
  ctx.fillText(thing_to_say, 20, 40);
}

function load_bull_clip_title() {
  var canvas = document.getElementById("bull_clip_main");
  var context = canvas.getContext("2d");

  var bull_clip = new Image();
  bull_clip.src = "/images/notes/bull_clip.png";
  bull_clip.onload = function() {
    context.drawImage(bull_clip, 0, 0);
  };
}

function draw_left_panel(thing_to_say) {
  var canvas = document.getElementById("add_transaction");
  var ctx = canvas.getContext("2d");

  ctx.rotate(-1 * Math.PI / 180);
  ctx.globalAlpha = 1.0;
  ctx.save();
  ctx.fillStyle = "#2e2925";
  ctx.beginPath();
  ctx.moveTo(5, 8);
  ctx.lineTo(181, 7);
  ctx.lineTo(177, 38);
  ctx.lineTo(3, 42);
  ctx.lineTo(5, 8);
  ctx.closePath();
  add_shadow(ctx)
  ctx.fill();
  ctx.restore();
  ctx.font = "12pt hobo_std";
  ctx.save()
  ctx.fillStyle = "White";
  ctx.fillText(thing_to_say, 10, 30);
}

