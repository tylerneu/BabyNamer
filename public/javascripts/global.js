$(function() {
  
  $('button#save_name').click(function() {
    
    $.ajax({
        url: "/save_name",
        type: "POST",
        success: function( json ) {
          console.log(json);
        },
        error: function( xhr, status ) {
            alert( "Sorry, there was a problem!" );
        },
        complete: function( xhr, status ) {
          get_saved_names();
        }
    });
  });
  
  $('button#get_random_name').click(function() {
    show_random_name_data();
  });
  
  $('button#get_random_name_count').click(function() {
    
    $.ajax({
        url: "/random_name_count",
        type: "GET",
        dataType : "json",
        success: function( json ) {
          console.log(json);
        },
        error: function( xhr, status ) {
            alert( "Sorry, there was a problem!" );
        },
        complete: function( xhr, status ) {
            // alert( "The request is complete!" );
        }
    });
  });
  
  get_saved_names();
    
});

function get_saved_names() {
  $.ajax({
      url: "/saved_names",
      type: "GET",
      dataType : "json",
      success: function( json ) {
        $('#saved_names').empty();
        $.each(json.saved_names, function(index, name_text) {
          $('<li></li>', {
            text: name_text
          }).appendTo($('#saved_names'));
        });  
      },
      error: function( xhr, status ) {
          alert( "Sorry, there was a problem!" );
      },
      complete: function( xhr, status ) {
          // alert( "The request is complete!" );
      }
  });
}

function show_random_name_data() {
  $.ajax({
      url: "/random_name",
      type: "GET",
      dataType : "json",
      success: function( json ) {
        $('#name_data').empty();
        $.each(json, function(year) {
          $('<li></li>', {
            text: [json[year].name, json[year].sex, json[year].year, json[year].yearly_score].join(' : ')
          }).appendTo($('#name_data'));
        });
      },
      error: function( xhr, status ) {
          alert( "Sorry, there was a problem!" );
      },
      complete: function( xhr, status ) {
          // alert( "The request is complete!" );
      }
  });
}