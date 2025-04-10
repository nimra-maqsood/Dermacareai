$(document).ready(function() {
    $("#show-login").click(function() {
        $("#login-form").show();
        $("#register-form").hide();
        $("#forgot-form").hide();
    });

    $("#show-register").click(function() {
        $("#register-form").show();
        $("#login-form").hide();
        $("#forgot-form").hide();
    });

    $("#show-forgot").click(function() {
        $("#forgot-form").show();
        $("#login-form").hide();
        $("#register-form").hide();
    });

    $("#show-login-forgot").click(function() {
        $("#forgot-form").hide();
        $("#register-form").hide();
        $("#login-form").show();
    });

    //  image upload handler
$('#imageUpload').on('change', function () {
    const file = this.files[0];
    const reader = new FileReader();

    if (file) {
        const filenameHTML = `<p><strong>Selected file:</strong> ${file.name}</p>`;
        reader.onload = function (e) {
            const imgHTML = `<img src="${e.target.result}" alt="Image Preview" style="max-width: 100px; 
            border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.2);">`;
            $('#imagePreview').html(filenameHTML + imgHTML);
            $('.image-section').show();
        };
        reader.readAsDataURL(file); 
    } else {
        $('#imagePreview').html('');
        $('.image-section').hide();
    }
});
    // ajax form submission (prediction)
     $('#upload-file').submit(function(event) {
        event.preventDefault();
        var formData = new FormData(this);
        $('#result').html("");  
        $("#prediction-loader").show();   

        $.ajax({
            type: 'POST',
            url: '/predict',
            data: formData,
            contentType: false,
            processData: false,
            success: function(response) {
                $("#prediction-loader").hide(); 
                $('#result').html(response.prediction);
                $("#feedback-container").fadeIn();
            },
            error: function() {
                $("#prediction-loader").hide(); 
                $('#result').html("Error in predicting disease. Please try again.");
            }
        });
    });

    $("form").on("submit", function(event) {
        var isValid = true;
        $(this).find("input").each(function() {
            if ($(this).val().trim() === "") {
                isValid = false;
                $(this).css("border", "2px solid red");
            } else {
                $(this).css("border", "1px solid #ccc");
            }
        });
        if (!isValid) {
            event.preventDefault();
            alert("Please fill in all fields.");
        }
    });

    // ======= SHOW/HIDE PASSWORD (Multiple Eye Icons) =======
    $(".toggle-password").click(function() {
        var inputID = $(this).attr("data-target");
        var passwordField = $("#" + inputID);
        var type = passwordField.attr("type") === "password" ? "text" : "password";
        passwordField.attr("type", type);
        $(this).toggleClass("fa-eye fa-eye-slash");
    });

    // ======= FEEDBACK FORM SUBMISSION =======
    $("#feedback-form").submit(function(event) {
        event.preventDefault();
        var formData = $(this).serialize();
        $.ajax({
            type: "POST",
            url: "/feedback",
            data: formData,
            success: function(response) {
                alert(response.message);
                $("#feedback-form")[0].reset();
            },
            error: function() {
                alert("Error submitting feedback. Please try again.");
            }
        });
    });

});
