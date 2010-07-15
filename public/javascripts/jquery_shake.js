jQuery.fn.shake = function(intShakes /*Amount of shakes*/, intDistance /*Shake distance*/, intDuration /*Time duration*/) {
  this.each(function() {
      distLeft = $(this).offset().left;
      for (var x=1; x<=intShakes; x++) {
      $(this).animate({left:distLeft + (intDistance*-1)}, (((intDuration/intShakes)/4)))
      .animate({left:distLeft + intDistance}, ((intDuration/intShakes)/2))
      .animate({left:distLeft}, (((intDuration/intShakes)/4)));
      }
      });
  return this;
};

