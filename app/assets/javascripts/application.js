// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery3
//= require popper
//= require bootstrap
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require jquery-ui
//= require ckeditor/init
//= require cocoon
//= require jquery.raty
//= require ratyrate
//= require gmaps/google
//= require social-share-button
//= require owl.carousel
//= require lightbox.min
//= require Chart.bundle
//= require chartkick
//= require_tree .

$(document).on("turbolinks:load", function () {
  $(".input-file").change(function () {
    $(this).next().text(this.files[0].name);
  });
  $('.setting-area li a').on('click', function () {
    $(this).next().toggleClass('show');
  });

  // Images location slider
  $('.show-slider').owlCarousel({
    loop: true,
    margin: 10,
    dots: true,
    autoplay: true,
    autoplayTimeout: 3000,
    autoplayHoverPause: true,
    responsive: {
      0: {
        items: 1
      },
      600: {
        items: 4
      },
    }
  })

  // Auotocomplete location status
  $autocomplete = function () {
    $auto = $(".checkin-location").autocomplete({
      source: function (request, response) {
        $.getJSON("/locations.json?s=" + request.term, function (data) {
          response($.map(data.locations, function (value, key) {
            return {
              label: value.name,
              value: value.id,
              image: value.thumbnail
            };
          }));
        });
      },
      minLength: 2,
      delay: 100,
      focus: function (event, ui) {
        $(this).val(ui.item.label);
        return false;
      },
      select: function (event, ui) {
        $(this).parent().find(".location_value").val(ui.item.value);
        return false;
      }
    })
    if ($auto.data("ui-autocomplete")) {
      $auto.data("ui-autocomplete")._renderItem = function (ul, item) {
        if (!item.image) {
          var thumb = "https://via.placeholder.com/50";
        }
        else {
          var thumb = item.image;
        }
        var markup = [
          "<span><img src='" + thumb + "' width='50'/></span>",
          "<span><b>" + item.label + "</b></span>",
        ]
        return $("<li>")
          .data("item.autocomplete", item)
          .append(markup.join(''))
          .appendTo(ul);
      };
    }
  }
  $autocomplete();

  // Autocomplete header
  $('#search').autocomplete({
    source: function (request, response) {
      $.getJSON("/locations.json?q=" + request.term, function (data) {
        response($.map(data.locations, function (value, key) {
          return {
            value: value.name,
          };
        }));
      });
    },
    minLength: 2,
    delay: 100
  });

  $(".buttons a.edit").on("click", function () {
    var status_id = $(this).attr('data-status-id');
    $.ajax({
      type: "GET",
      data: {
        id_status: status_id
      },
      dataType: "script",
    })
  });

  handler = Gmaps.build('Google');
  if (handler) {
    handler.buildMap({ provider: {}, internal: { id: 'map' } }, function () {
      markers = handler.addMarkers([
        {
          "lat": $("#map").data("latitude"),
          "lng": $("#map").data("longitude"),
          "picture": {
            "width": 32,
            "height": 32
          },
          "infowindow": "SJSU"
        }
      ]);
      handler.bounds.extendWith(markers);
      handler.fitMapToBounds();
    });
  }
});
