//= require jquery
//= require jquery_ujs
//= require external/google-code-prettify/prettify
//= require external/hatena-star
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

  bindSmartSearch: function() {
    var allEntries;
    var hitEntries;
    var self;

    $('#form-search').keyup(function() {
      if (!allEntries) {
        $(this).submit();
      } else {
        $(this).trigger('fetch');
      }
    }).on('ajax:success', function(event, data) {
      allEntries = $(data);
      $(this).trigger('fetch');

    }).bind('fetch', function() {
      var input = $(this).find('input[type=text]').val();
      hitEntries = allEntries.clone();
      hitEntries.find('tr').each(function() {
        if (!$(this).find('.title').text().match(new RegExp(input, 'i'))) {
          $(this).remove();
        }
      });
      $('#entries-outer').html(hitEntries);
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
});

Hakolog.register('blogs_show', function() {
  this.focusFirstInput();
  this.bindSmartSearch();
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
  $(window).trigger('change');
});
