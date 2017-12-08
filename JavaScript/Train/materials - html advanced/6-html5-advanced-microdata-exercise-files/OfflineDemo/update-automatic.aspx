<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="update-automatic.aspx.cs" Inherits="OfflineDemo.update_automatic" %>

<!doctype html>
<html manifest="manifest.aspx">
<head>
    <title></title>
    <link rel="Stylesheet" href="global-css.aspx"  type="text/css" />
</head>
<body>
    <div id="container">
        <h1>Automatic Updates two</h1>
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
            // once the cache is updated
            // then you can automatically reload the page
            location.reload();
        }
    });
</script>
</html>