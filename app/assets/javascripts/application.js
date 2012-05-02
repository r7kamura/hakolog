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
    var duraition     = 1 * 1000;
    var form          = $('#form-preview');
    var preview       = $('#preview');
    var before        = form.serialize();
    var updatePreview = function() {
      $.post(
        preview.attr('data-url'),
        form.serialize(),
        function(data) {
          preview.hide().html(data).fadeIn();
        }
      );
    };

    form.find(':input').keyup(function() {
      var after = form.serialize();
      if (before == after) { return }
      before = after;
      clearTimeout(timeoutID);
      timeoutID = setTimeout(function() { updatePreview() }, duraition);
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
