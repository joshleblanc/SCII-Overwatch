$(function() {
    const $replayInput = $('#replayInput');
    const $replayForm = $('#replayForm');
    const $uploadStatus = $('#uploadStatus');

    function connect(id) {
        const host = 'ws://' + window.location.host + '/submit/status/';
        try {
            const socket = new WebSocket(host + id);

            socket.onmessage = function(msg) {
                const data = JSON.parse(msg.data);
                if(data['error'] !== undefined) {
                    $uploadStatus.text(data['error']);
                    socket.close();
                } else if(data['replay_id'] !== undefined) {
                    $uploadStatus.text("Redirecting...");
                    window.location = 'http://' + window.location.host + '/submit/' + data['replay_id']
                } else {
                    $uploadStatus.text(data['message'])
                }

            };

            socket.onopen = function() {
                console.log("open");
            };

            socket.onclose = function() {
                console.log("close");
            };
        } catch(exception) {
            console.log(exception);
        }
    }

    function onReplaySelected() {
        var formData = new FormData($replayForm[0]);
        $.ajax('/submit', {
            method: 'post',
            processData: false,
            contentType: false,
            data: formData
        }).done(function(data) {
            connect(data);
            $uploadStatus.text("Uploading...");
        });
    }
    $replayInput.on('change', onReplaySelected);
});