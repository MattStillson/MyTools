<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="debug.aspx.cs" Inherits="OfflineDemo.debug" %>
<!doctype html>
<html manifest="debug-manifest.aspx">
<head>
    <title>Debug</title>
    <link rel="Stylesheet" href="global-css.aspx" type="text/css" />
</head>
<body>
    <div id="container">
        <h1>Manifest Error</h1>

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
            logEvent("update ready");
            logEvent("swapping cache");
            applicationCache.swapCache();
        }
    });
</script>
</html>