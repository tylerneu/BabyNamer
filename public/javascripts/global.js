$(function() {
  
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
    
});

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