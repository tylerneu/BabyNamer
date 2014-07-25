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


function current_name() {
  
  var buffer_index = $.cookie("buffer_index") || 0;  
  recent_names = JSON.parse(localStorage.getItem('recent_names')) || {};
  json = recent_names[buffer_index];
  return json;
  
}

function save_name() {
  
  var saved_names = JSON.parse(localStorage.getItem("saved_names")) || {};
  
  var name = current_name();
  
  // Only insert if it doesn't exist in the list
  //if ($.inArray(current_name, saved_names) == -1) 
  
  saved_names[name[Object.keys(name)[0]].id] = name;
  //  saved_names[name[0].id] = name;
  //json[Object.keys(json)[0]].name
  
  localStorage.setItem("saved_names", JSON.stringify(saved_names));
  
  // Refresh list
  get_saved_names();
  
}

function remove_name(id) {
	
	var saved_names = JSON.parse(localStorage.getItem("saved_names")) || {};
  
  delete saved_names[id];

	localStorage.setItem("saved_names", JSON.stringify(saved_names));
	
  // Refresh list
  get_saved_names();

}

function get_saved_names() {
  
  var saved_names = JSON.parse(localStorage.getItem("saved_names")) || [];
  
  $('#saved_names').empty();
  $.each(saved_names, function(id, name_data) {
    
    name_data = name_data[Object.keys(name_data)[0]];
    
    $('<li></li>', {
      text: name_data.name + ', ' + name_data.sex,
      click: function() {
		    remove_name(name_data.id);
	    }
    }).appendTo($('#saved_names'));
  });   
}

function save_controls() {
  $.cookie("saved_controls", { sex: $('#sex').val(), popularity: $('#popular_names').prop('checked') }, { expires: 365 }); 
}
