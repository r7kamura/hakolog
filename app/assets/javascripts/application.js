//= require jquery
//= require jquery_ujs
//= require external/google-code-prettify/prettify
//= require external/hatena-star
//= require external/keyString
//= require_tree .

var Hakolog = {
  dispatches: [],

  register: function(pageKey, callback) {
    this.dispatches.push({
      pageKey: pageKey,
      callback: callback
    });
  },

  dispatch: function() {
    var self = this;
    $.each(this.dispatches, function() {
      if (this.pageKey == self.pageKey()) {
        this.callback.apply(self);
      }
    });
  },

  pageKey: (function() {
    var pageKeyCache;
    return function() {
      return pageKeyCache || (pageKeyCache = $('body').attr('id'));
    };
  })(),

  focusFirstInput: function() {
    $('form input[type=text]').focus();
  },

  bindAutoPreview: function() {
    var timeoutID;
    var self          = this;
    var duration      = 1 * 1000;
    var form          = $('#form-preview');
    var preview       = $('#preview');
    var before        = form.serialize();
    var updatePreview = function() {
      $.post(
        preview.attr('data-url'),
        form.serialize(),
        function(data) {
          preview.html(data);
          $(window).trigger('update');
        }
      );
    };

    form.keyup(function() {
      var after = form.serialize();
      if (before == after) { return }
      before = after;
      clearTimeout(timeoutID);
      timeoutID = setTimeout(function() { updatePreview() }, duration);
    });
  },

  bindFinder: function() {
    var allEntries;
    var self         = this;
    var form         = $('#form-search');
    var entriesOuter = $('#entries-outer');
    var focusedClass = 'focused';
    var focusedEntry = function() {
      return entriesOuter.find('.' + focusedClass);
    };
    var focusFirst = function() {
      if (focusedEntry().length) return;
      entriesOuter.find('.entry').removeClass(focusedClass);
      entriesOuter.find('.entry:nth-child(1)').addClass(focusedClass);
    };
    var move = function(prevOrNext) {
      var before = focusedEntry();
      var after  = before[prevOrNext]();
      if (after.length) {
        before.removeClass(focusedClass);
        after.addClass(focusedClass);
        self.adjustScroll(after);
      }
    };
    var visitFocusedEntry = function(inBackground) {
      self.visitUrl(focusedEntry().find('a').attr('href'), inBackground);
    };

    focusFirst();
    form.keydown(function(e) {
      var key = keyString(e);
      if      (key == 'Up')       { move('prev'); e.preventDefault() }
      else if (key == 'Down')     { move('next'); e.preventDefault() }
      else if (key == 'Return')   { visitFocusedEntry() }
      else if (key == 'C-Return') { visitFocusedEntry(true) }

    }).keyup(function(e) {
      var key = keyString(e);
      if (
        key == 'Up'    ||
        key == 'Down'  ||
        key == 'Left'  ||
        key == 'Right' ||
        key == 'Return'
      ) return;
      allEntries ?
        $(this).trigger('update') :
        $(this).submit();

    }).on('ajax:success', function(event, data) {
      /* disable submit when once you submit */
      $(this).bind('ajax:before', function() { return false });
      allEntries = $(data);
      $(this).trigger('update');

    }).bind('update', function() {
      var input = $(this).find('input[type=text]').val();
      var hitEntries = allEntries.clone();
      hitEntries.find('.entry').each(function() {
        if (!$(this).find('.title').text().match(new RegExp(input, 'i'))) {
          $(this).remove();
        }
      });
      if (entriesOuter.find('.entry').length != hitEntries.find('.entry').length) {
        entriesOuter.html(hitEntries);
        focusFirst();
      }
    });
  },

  bindPrettifyCode: function() {
    $(window).bind('update', function() {
      $('pre').addClass('prettyprint');
      prettyPrint();
    });
  },

  /* private */

  visitUrl: function(url, inBackground) {
    if (inBackground) {
      var a          = document.createElement('a');
      var clickEvent = document.createEvent('MouseEvents');
      clickEvent.initMouseEvent(
        'click', true, true, window, 0, 0, 0, 0,
        false, false, false, false, 1, null
      );
      a.href = url;
      a.dispatchEvent(clickEvent);
    } else {
      location.href = url;
    }
  },

  adjustScroll: function(obj) {
    var objTop    = obj.offset().top;
    var objHeight = obj.height();
    var winTop    = $(window).scrollTop();
    var winHeight = $(window).height();
    if (objTop <= winTop) {
      $('html, body').scrollTop(objTop);
    } else if (winTop + winHeight <= objTop + objHeight) {
      $('html, body').scrollTop(objTop + objHeight - winHeight);
    }
  }
};

Hakolog.register('blogs_index', function() {
  this.focusFirstInput();
});

Hakolog.register('blogs_show', function() {
  this.focusFirstInput();
  this.bindFinder();
});

Hakolog.register('entries_new', function() {
  this.focusFirstInput();
  this.bindAutoPreview();
  this.bindPrettifyCode();
});

Hakolog.register('entries_show', function() {
  this.bindPrettifyCode();
  this.bindAutoPreview();
});

$(function() {
  Hakolog.dispatch();
  $('a[original-title]').tipsy();
  $(window).trigger('update');
});
