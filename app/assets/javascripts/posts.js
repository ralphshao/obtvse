$(function() {
	$('.post').fitVids();

  var printGist = function(gist) {
      console.log(gist.repo, ' (' + gist.description + ') :');
      console.log(gist.div);
  };

  var displayGist = function(selector, gistResponse) {
    $(selector).html(gistResponse.div);
  };

  // TODO: bad, don't add functions to jQuery
  $.getGist = function(id, success) {
    $.ajax({
          url: 'https://gist.github.com/' + id + '.json',
          dataType: 'jsonp',
          success: function(gist) {
            success("#" + id, gist);
          }
      });
  };

  // fetch the gists
  $('.gist').each(function() {
    $.getGist(this.id, displayGist);
  });

  // viewport rotation fix
  (function(doc) {
    var addEvent = 'addEventListener',
        type = 'gesturestart',
        qsa = 'querySelectorAll',
        scales = [1, 1],
        meta = qsa in doc ? doc[qsa]('meta[name=viewport]') : [];
    function fix() {
      meta.content = 'width=device-width,minimum-scale=' + scales[0] + ',maximum-scale=' + scales[1];
      doc.removeEventListener(type, fix, true);
    }
    if ((meta = meta[meta.length - 1]) && addEvent in doc) {
      fix();
      scales = [.25, 1.6];
      doc[addEvent](type, fix, true);
    }
  }(document));

});