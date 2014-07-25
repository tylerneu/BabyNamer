function debug() {
  
  var recent_names = JSON.parse(localStorage.getItem('recent_names')) || {};
  var buffer_index = $.cookie("buffer_index") || 0;

  console.group('Debug');

  var names_string = '[';
  var buffer_string = '[';
  $.each(recent_names, function(index, name) {
    names_string += 'X'
    buffer_string +=  (buffer_index == index) ? '^' : ' ';
  });
  names_string += ']';
  buffer_string += ']';
  console.log(names_string);
  console.log(buffer_string);
  console.groupEnd('Debug');
  
}

function display_previous_name() {

  // Decrease buffer index  
  var buffer_index = $.cookie("buffer_index") || 0;
  buffer_index--;
  $.cookie("buffer_index", buffer_index, { expires: 365 }); 
  
  display_name();
  
}

function display_next_name() {
  

  var buffer_index = $.cookie("buffer_index") || 0;
  buffer_index++;
  $.cookie("buffer_index", buffer_index, { expires: 365 }); 
  
  display_name()
  
}

function display_name() {
  
  //debug();

  var buffer_index = $.cookie("buffer_index") || 0;
  var recent_names = JSON.parse(localStorage.getItem('recent_names')) || {};
  var json = recent_names[buffer_index];

  if (json == null || buffer_index >= recent_names.length) {
    retrieve_random_names();
  } else if (buffer_index == 0) {
    retrieve_random_names(1);
  } else {
    render_name();
  }
  

}

function render_name() {
  
  //debug();
  
  var json = current_name();
    
  $('#name').text(json[Object.keys(json)[0]].name);
  $('#name_sex').text(json[Object.keys(json)[0]].sex);
  $('#name_data').empty();
    
  $.each(json, function(year) {
    var y = json[year];
    $('<li></li>', {
      text: [y.year, json[year].yearly_score].join(' : ')
    }).appendTo($('#name_data'));  
  });
  
}


function retrieve_random_names(pre_flag) {
  
  pre_flag = pre_flag != null ? pre_flag : 0;
  
	$.ajax({
      url:      "/random_name",
      type:     "GET",
      dataType: "json",
      data:     { sex: $('#sex').val(), popular_names: $('#popular_names').prop('checked') },
      beforeSend: function() {
        save_controls();
        $('#name').empty().spin('large');
        $('#name_sex').empty();
        $('#name_data').empty();
      },
      success: function( json ) {
        
        // Buffer        
        var recent_names = JSON.parse(localStorage.getItem('recent_names')) || [];

        $.each(json, function(id) {
          if (pre_flag) {
            recent_names.unshift(json[id]);  
          } else {
            recent_names.push(json[id]);  
          }
          
        });
        localStorage.setItem('recent_names', JSON.stringify(recent_names));
        
        if (pre_flag) {
          // The buffer is at 0 and will soon be moved to -1
          // The buffer needs to be set to `buffer + NUM_OF_NEW_NAMES`
          // TODO: This number should not be hard coded
          var buffer_index = $.cookie("buffer_index") || 0;;
          $.cookie("buffer_index", buffer_index + 5, { expires: 365 });           
        }

      
      },
      error: function( xhr, status ) {
          alert( "Sorry, there was a problem!" );
      },
      complete: function( xhr, status ) {
        render_name();
      }
  });
}
