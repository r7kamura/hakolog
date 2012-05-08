//= require jquery
//= require jquery_ujs
//= require external/google-code-prettify/prettify
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
    var duraition     = 1 * 1000;
    var form          = $('#form-preview');
    var preview       = $('#preview');
    var before        = form.serialize();
    var updatePreview = function() {
      $.post(
        preview.attr('data-url'),
        form.serialize(),
        function(data) {
          preview.html(data);
          $(window).trigger('change');
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

  bindIncrementalSearch: function() {
    $('#form-search').keyup(function() {
      $(this).submit();
    }).on('ajax:success', function(event, data) {
      $('#entries-outer').html(data);
    });
  },

  bindPrettifyCode: function() {
    $(window).bind('change', function() {
      $('pre').addClass('prettyprint');
      prettyPrint();
    });
  }
};

Hakolog.register('blogs_index', function() {
  this.focusFirstInput();
  this.bindAutoPreview();
});

Hakolog.register('blogs_show', function() {
  this.bindIncrementalSearch();
});

Hakolog.register('entries_new', function() {
  this.focusFirstInput();
  this.bindAutoPreview();
  this.bindPrettifyCode();
});

Hakolog.register('entries_show', function() {
  this.bindPrettifyCode();
});

$(function() {
  Hakolog.dispatch();
  $('a[original-title]').tipsy();
  $(window).trigger('change');
});
