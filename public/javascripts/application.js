$(function () {
    $("#fileupload").fileupload({
        dataType: "json",
        add: function(event, data) {
            var file, types;

            file = data.files[0];

            data.context = $($.trim(tmpl("template-upload", file)));

            $("#uploads").append(data.context);

            return data.submit();
        },
        progress: function(event, data) {
            var progress;

            if (data.context) {
                progress = parseInt(data.loaded / data.total * 100, 10);

                data.context.find(".progress-bar").css("width", progress + "%").attr("aria-valuenow", progress.toString());
            }
        },
        done: function(event, data) {
            if (data.context) {
                data.context.find(".progress-bar").css("width", "100%").attr("aria-valuenow", "100");

                setTimeout(function() {
                    data.context.find(".progress").removeClass("active").find(".progress-bar").removeClass("progress-bar-info").delay(500).addClass("progress-bar-success").closest(".upload").fadeOut(4000);
                }, 500);
            }
        },
        fail: function(event, data) {
            if (data.context) {
                data.context.find(".progress").removeClass("active").find(".progress-bar").removeClass("progress-bar-info").delay(500).addClass("progress-bar-danger");
            }
        }
    });
});
