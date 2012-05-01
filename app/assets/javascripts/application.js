// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
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
    var duraion       = 1 * 1000;
    var form          = $('#entry-form');
    var preview       = $('#preview');
    var body          = $('#body')
    var beforeBody    = body.val();
    var updatePreview = function() {
      $.post(
        preview.attr('data-url'),
        { body: body.val() },
        function(data) {
          preview.html(data);
        }
      );
    };

    body.keyup(function() {
      var afterBody = body.val();
      if (beforeBody == afterBody) { return }
      beforeBody = afterBody;
      clearTimeout(timeoutID);
      timeoutID = setTimeout(function() { updatePreview() }, duraion);
    });
  },
};

Hakolog.register('blogs_index', function() {
  this.focusFirstInput();
  this.bindAutoPreview();
});

Hakolog.register('entries_index', function() {
  this.focusFirstInput();
});

Hakolog.register('entries_new', function() {
  this.focusFirstInput();
  this.bindAutoPreview();
});

Hakolog.register('entries_search', function() {
  this.focusFirstInput();
});

$(function() {
  Hakolog.dispatch();
  $('a[original-title]').tipsy();
});
