$(document).ready(function(){
    $("#form_pwd").validate({
            rules: {
                'user[password]': {
                    required: true,
                    minlength: 5
                },
                'password_confirm[]': {
                    required: true,
                    minlength: 5,
                    equalTo: "#user_password"
                }
            },
            messages: {
                'user[password]': {
                    required: "Provide a password",
                    rangelength: jQuery.format("Enter at least {0} characters")
                },
                'password_confirm[]': {
                    required: "Repeat your password",
                    minlength: jQuery.format("Enter at least {0} characters"),
                    equalTo: "Enter the same password as above"
                }
            },
          // the errorPlacement has to take the table layout into account
          errorPlacement: function(error, element) {
            if ( element.is(":radio") )
              error.appendTo( element.parent().next().next() );
            else if ( element.is(":checkbox") )
              error.appendTo ( element.next() );
            else
              error.appendTo( element.parent().next() );
          },
          success: function(label) {
            // set &nbsp; as text for IE
            label.html("&nbsp;").addClass("checked");
          },
          invalidHandler: function() {
            return false;
          }
        }).form();

    // Form validators for user form
     $("#form_user").validate({
            rules: {
                'user[name]': "required",
                'user[email]': {
                    required: true,
                    email: true,
                    remote: "/user/remote_handler"
                }
            },
            messages: {
                'user[name]': "Enter your firstname",
                'user[email]': {
                    required: "Please enter a valid email address",
                    minlength: "Please enter a valid email address",
                    remote: jQuery.format("{0} is already in use")
                }
            },
          // the errorPlacement has to take the table layout into account
          errorPlacement: function(error, element) {
            if ( element.is(":radio") )
              error.appendTo( element.parent().next().next() );
            else if ( element.is(":checkbox") )
              error.appendTo ( element.next() );
            else
              error.appendTo( element.parent().next() );
          },
          success: function(label) {
            // set &nbsp; as text for IE
            label.html("&nbsp;").addClass("checked");
          },
          invalidHandler: function() {
            return false;
          }
        }).form();

  });