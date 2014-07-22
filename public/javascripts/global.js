$(function() {
  
  $.cookie.json = true;
  
  $('button#save_name').click(function() {
    save_name();
  });
  
  $('button#get_random_name').click(function() {
    display_next_name();
  })
  
  $('#sex').change(function() {
    // TODO, clear buffer
    display_next_name();
  });
  
  $('#popular_names').click(function() {
    // TODO, clear buffer
    display_next_name();
  });
  
  // Keyboard shortucts
  $(document).keypress(function(e){
    switch(e.which) {
      case 106: display_previous_name(); break; // "j"
      case 107: display_next_name(); break; // "k"
    }
  });
  
  // Set controls based on last selections
  var saved_controls = $.cookie("saved_controls");

  if (saved_controls) {
    $('#sex').val(saved_controls.sex);
    $('#popular_names').prop('checked', saved_controls.popularity);
  }
  
  get_saved_names();
  display_name();
    
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
  $.each($.cookie("saved_names") || [], function(index, name_text) {
    $('<li></li>', {
      text: name_text,
      click: function() {
		    remove_name(name_text);
	    }
    }).appendTo($('#saved_names'));
  });   
}

function save_controls() {
  $.cookie("saved_controls", { sex: $('#sex').val(), popularity: $('#popular_names').prop('checked') }, { expires: 365 }); 
}
