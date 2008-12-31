(function($){

    $.fn.editable = function(options) {

        var defaults = {
            typex: "text",
            url: "remote_save.rb",
            actionx: "nothing",
            id: 0,
            style_class: "editable",
            width: "200px",
            focus_on_done: ''
        };

        var options = $.extend(defaults, options);

        return this.each(function() {

            var obj = $(this);
                        
            obj.addClass(options.style_class);

            var text_saved = obj.html();
            var namex = this.id + "editMode";
            var urlx = options.url + this.id;
            var items = "";

            obj.keypress(function(e){
                log(e);
                if(e.which==13) {
                    obj.trigger('click');
                }
            })


            obj.click(function() {                
                switch (options.typex) {
                    case "text": {
                        var inputx = "<input id='" + namex + "' type='text' style='width: " + options.width + "' value='" + text_saved + "' />&nbsp;&nbsp;";
                        var btnSend = "<input type='submit' id='btnSave" + this.id + "' value='Accept' tabindex='0' />";
                        var btnCancel = "<input type='button' id='btnCancel" + this.id + "' value='Cancel' tabindex='0' />";
                        items = inputx + btnSend + btnCancel;
                      
                        options.typex = 'edit';                        
                        
                        obj.html(items);

                        $("#" + namex).focus();
                     
                
                        $("#btnSave" + this.id, obj).click(function () {
                            $.ajax({
                                type: "POST",
                                data:
                                {
                                    text_string: $("#" + namex).val(),
                                    actionx: options.actionx,
                                    idx: options.id
                                },
                                url: urlx,
                                success: function(data) {
                                    if (options.focus_on_done!='') {
                                        $(options.focus_on_done).focus();
                                    }
                                    options.typex = 'text';
                                    if (data > '') {
                                        obj.html(data);                                        
                                    } else {
                                        obj.html('Pinchar para introducir un texto');
                                    }
                                    text_saved = data;                                    
                                },
                                error: function(objHttpRequest, error_str) {
                                    obj.html(error_str);
                                }
                            });
                        })

                        $("#btnCancel" + this.id, obj).click(function () {
                            options.typex = 'cancel';
                        })
                        break;
                    }
                    case "cancel":  {
                        options.typex = 'text';
                        obj.html(text_saved);
                        if (options.focus_on_done!='') {
                            $(options.focus_on_done).focus();
                            log(options.focus_on_done)
                        }
                        break;
                    }
                }                            
                    

                return false;
            });
        });
    };
})(jQuery);