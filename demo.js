$(document).ready(function() {

  // page loads
  $('#role_panel').css("opacity","0.5");
  $( "#role-range" ).slider({ disabled: true });
  $('#role-btn').prop("disabled",true);
  $('#submit').prop("disabled",true);
  $( "#student-range" ).slider({
    range: "max",
    min: 1,
    max: 10,
    value: 4,
    animate: true,
    slide: function( event, ui ) {
      $( "#students" ).val( ui.value );
    }
  });
  $( "#students" ).val( $( "#student-range" ).slider( "value" ) );

  // first button is clicked
  $('#button').click(function(){
      $(this).prop("disabled",true);
      $('#role-btn').prop("disabled",false);
      $('#student_panel').css("opacity","0.5");
      $( "#student-range" ).slider({ disabled: true });
      $('#role_panel').css("opacity","1.0");
      $( "#role-range" ).fadeIn(500).slider({
        disabled: false,
        range: "max",
        min: $( "#student-range" ).slider( "value" )+1,
        max: 15,
        value: $( "#student-range" ).slider( "value" )+2,
        slide: function( event, ui ) {
          $( "#roles" ).val( ui.value );
        }
      });
      $( "#roles" ).val( $( "#role-range" ).slider( "value" ) );
  });

  // second button is clicked
  $('#role-btn').click(function(){
      $('#submit').prop("disabled",false);
      $(this).prop("disabled",true);
      $('#role_panel').css("opacity","0.5");
      $( "#role-range" ).slider({ disabled: true });
      $('#submit').fadeIn(500);
      
  });

});