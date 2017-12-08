<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="events.aspx.cs" Inherits="OfflineDemo.events" %>

<!doctype html>
<html manifest="manifest.aspx">
<head>
    <title>Log</title> 
    <link rel="Stylesheet" href="global-css.aspx"  type="text/css" />
</head>
<body>
    <div id="container">
        <h1>Caching Events three</h1>

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
    });
</script>
</html>