<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="journal.aspx.cs" Inherits="OfflineDemo.journal" %>

<html manifest="journal-manifest.aspx">
<html>
<head>
    <title>Journal</title>
    <link rel="Stylesheet" href="global-css.aspx"  type="text/css" />
    <link rel="Stylesheet" href="journal-css.aspx"  type="text/css" />
    <script src="scripts/jquery-1.5.1.min.js" type="text/javascript"></script>
</head>
<body>
    <div id="container">
        <h1>Journal</h1>
        <a href="/home">Home</a>

        <div id="online">Online: <span id="onlineStatus"></span></div>
         
        <div id="controls">
            <textarea autofocus id="journalText"></textarea>
            <input type="button" id="sendButton" value="Send" />
        </div>

        <div id="eventLogContainer">
            <h2>Event Log</h2>
            <ul id="log"></ul>
        </div>

    </div>
</body>
<script src="offline.js" type="text/javascript"></script>
<script>

    var box;
    var messages = [];

    function isOnLine() {
        return navigator.onLine;
    }

    function reportOnlineStatus() {
        $("#onlineStatus").html((isOnLine()) ? "Yes" : "No");
    }

    function storeMessage() {
        var message = box.val();
        if (!isOnLine()) {
            storeMessageLocal(message);
        }
        else {
            storeMessageRemote(message);
        }
    }

    function storeMessageLocal(msg) {
        messages.push(msg);
        clearUI();
        logEvent("Message saved locally: '" + msg + "'");
    }

    function storeMessageRemote(msg) {
        messages.push(msg);
        sendMessagesToServer();
        clearUI();
    }

    function sendMessagesToServer() {
        messages.reverse();
        while (messages.length > 0) {
            var msg = messages.pop();
            $.post("/message/save", { "Message": msg }, function (e) {
                logEvent(e.Status);
            }, "json");
        }
    }

    function clearUI() {
        box.val("");
        box.focus();
    }

    $(function () {

        if (window.applicationCache) {
            box = $("#journalText");

            $("#sendButton").click(function (e) {
                storeMessage();
            });

            window.applicationCache.onupdateready = function (e) {
                logEvent("update ready");
                logEvent("swapping cache");
                applicationCache.swapCache();
            }

            window.addEventListener("online", function (e) {
                reportOnlineStatus();
                sendMessagesToServer();
            }, true);

            window.addEventListener("offline", function (e) {
                reportOnlineStatus();
            }, true);

            reportOnlineStatus();
        }
    });
</script>
</html>