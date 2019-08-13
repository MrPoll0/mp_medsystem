$(function() {
    window.addEventListener('message', function(event) {
        if (event.data.type == "on") {
             document.body.style.display = event.data.enable ? "block" : "none";
        }else if (event.data.type == "change") {
            if (event.data.type1 == "1") { 
                $('.' + event.data.part + '').css("fill", event.data.gravedad);
            }else if (event.data.type1 == "0") {
                $('.' + event.data.part + '').css("fill", event.data.gravedad);
            }
        }else if (event.data.type == "status") {
            $('.pulsaciones').html(event.data.health);
            //$('.bleeding').html(event.data.bleeding);
        } 
    });

    document.onkeyup = function (data) {
        if (data.which == 27) { // Escape key
            $.post('http://mp_medsystem/escape', JSON.stringify({}));
            document.body.style.display = "none";
        }
    };

    $("#aplicar2").submit(function(e) {
        e.preventDefault(); // Prevent form from submitting
        $.post('http://mp_medsystem/aplicar', JSON.stringify({
            part: $('.zone').html(),
            med: $('.med').html()
        }));
    });
});
