$(function() {
  
  $.cookie.json = true;
  
  $('button#save_name').click(function() {
    save_name();
  });
  
  $('button#get_random_name').click(function() {
    show_random_name_data();
  });
  
  $('#sex').change(function() {
    show_random_name_data();
  });
  
  $('#popular_names').click(function() {
    show_random_name_data();
  });
  
  // Set controls based on last selections
  var saved_controls = $.cookie("saved_controls");
  $('#sex').val(saved_controls.sex);
  $('#popular_names').prop('checked', saved_controls.popularity);
  
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

  $.cookie("saved_names", saved_names, { expires: 365 });
  
  // Refresh list
  get_saved_names();
  
}

function remove_name(name) {
	
	var saved_names = $.cookie("saved_names") || [];
	
	saved_names = $.grep(saved_names, function(n,i) {
	  return n != name;
	});
	
	$.cookie("saved_names", saved_names, { expires: 365 });
	
    // Refresh list
    get_saved_names();

}

function get_saved_names() {
  
  $('#saved_names').empty();
  $.each($.cookie("saved_names"), function(index, name_text) {
    $('<li></li>', {
      text: name_text,
	  click: function() {
		  remove_name(name_text);
	  }
    }).appendTo($('#saved_names'));
  });  
  
}

function show_random_name_data() {
  
  save_controls();

  $('#name').empty().spin('large');
  $('#name_sex').empty();
  $('#name_data').empty();
  
  $.ajax({
      url: "/random_name",
      type: "GET",
      dataType : "json",
      data: { sex: $('#sex').val(), popular_names: $('#popular_names').prop('checked') },
      success: function( json ) {
        
        // Save current name for saving
        $( "body" ).data( "current_name", json.name );
        
        $('#name').empty();
        $('#name').text(json.name);
        $('#name_sex').text(json.sex);
        
        $.each(json.years, function(year) {
          var y = json.years[year];
          $('<li></li>', {
            text: [y.year, json.years[year].yearly_score].join(' : ')
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

function save_controls() {
 $.cookie("saved_controls", { sex: $('#sex').val(), popularity: $('#popular_names').prop('checked') }, { expires: 365 }); 
}