//CATEGORY.JS - Javascript for all category views


$('document').ready(function(){

    $(document).ajaxSend(function(event, request, settings) {
        if (typeof(window.AUTH_TOKEN) == "undefined") return;
        settings.data = settings.data || "";
        settings.data += (settings.data ? "&" : "") + "authenticity_token=" + encodeURIComponent(window.AUTH_TOKEN);
    });


    $(".edit_title").editable({
        // Php that receive the parameter $_POST['text_string']
        url: "/category/update_remote/",
        width: "100px",
        focus_on_done: '#category_title'
    })


})