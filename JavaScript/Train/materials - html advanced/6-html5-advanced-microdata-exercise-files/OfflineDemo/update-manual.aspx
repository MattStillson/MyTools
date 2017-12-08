<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="update-manual.aspx.cs" Inherits="OfflineDemo.update_manual" %>

<!doctype html>
<html manifest="manifest.aspx">
<head>
    <title>Manual Update</title>
    <link rel="Stylesheet" href="global-css.aspx"  type="text/css" />
</head>
<body>
    <div id="container">
        <h1>Manual Updates two</h1>
        <input type="button" id="updateButton" value="Update" />

        <div id="eventLogContainer">
            <h2>Event Log</h2>
            <ul id="log"></ul>
        </div>
    </div>
</body>
<script src="scripts/jquery-1.5.1.min.js" type="text/javascript"></script>
<script src="offline.js" type="text/javascript"></script>
<script>
    $(function () {
        window.applicationCache.onupdateready = function (e) {
            logEvent("Update Ready");
            logEvent("Swapping Cache");
            applicationCache.swapCache();
        }

        $("#updateButton").click(function () {
            location.reload();
        });
    });
</script>
</html>