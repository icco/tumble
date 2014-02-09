$(document).ready(function() {
  // Adds letter counter to text area.
  $('.wordcount').each(function(i, el) {
    var dad = $(el).parent().children('textarea')[0];
    $(dad).bind('keypress', function() {
      var text = $(this)[0].value;
      $(el).text(text.split(" ").length);
    });
  });
});
