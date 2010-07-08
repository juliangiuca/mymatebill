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

