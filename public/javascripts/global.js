$(function() {
  
  $('button#get_random_name').click(function() {
    
    $.ajax({
        url: "/random_name",
        type: "GET",
        dataType : "json",
        success: function( json ) {
            $('h1#name').text( json.name );
        },
        error: function( xhr, status ) {
            alert( "Sorry, there was a problem!" );
        },
        complete: function( xhr, status ) {
            // alert( "The request is complete!" );
        }
    });
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