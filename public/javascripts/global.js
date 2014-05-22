$(function() {
  
  $.cookie.json = true;
  
  $('button#save_name').click(function() {
    save_name();
  });
  
  $('button#get_random_name').click(function() {
    show_random_name_data();
  });
  
  get_saved_names();
  show_random_name_data();
    
});

// ========================================================================== //
// ========================================================================== //
// ========================================================================== //

function save_name() {
  
  var saved_names = $.cookie("saved_names") || [];
  
  // Only insert if it doesn't exist in the list
  var current_name = $( "body" ).data( "current_name");
  if ($.inArray(current_name, saved_names) == -1) saved_names.push(current_name);

  $.cookie("saved_names", saved_names);
  
  // Refresh list
  get_saved_names();
  
}

function get_saved_names() {
  
  $('#saved_names').empty();
  $.each($.cookie("saved_names"), function(index, name_text) {
    $('<li></li>', {
      text: name_text
    }).appendTo($('#saved_names'));
  });  
  
}

function show_random_name_data() {
  
  $.ajax({
      url: "/random_name",
      type: "GET",
      dataType : "json",
      
      success: function( json ) {
        
        // Save current name for saving
        $( "body" ).data( "current_name", json.current_name );
        
        $('#name_data').empty();
        $.each(json.years, function(year) {
          var y = json.years[year];
          $('<li></li>', {
            text: [y.name, y.sex, y.year, json.years[year].yearly_score].join(' : ')
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
