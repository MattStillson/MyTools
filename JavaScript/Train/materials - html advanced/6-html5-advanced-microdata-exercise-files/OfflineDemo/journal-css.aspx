textarea
{
    padding:10px;
    width:100%;
    height:250px;
    -moz-border-radius: 5px;
    -webkit-border-radius: 5px;
    -khtml-border-radius: 5px;
    border-radius: 5px;
    border:1px solid #999;
}

#controls
{
    width:450px;
}

#sendButton
{
    display:block;
}

#online
{
    position:absolute;
    top:0px;
    right:0px;
    padding:4px;
    background-color:#36c;
    color:#fff;
    font-size:.8em;
    
}

#eventLogContainer
{
    position:absolute;
    top:300px;
    right:0px;
    width:250px;
    border:1px solid #ccc;
    padding:4px;
    background-color:#eee;
    font-size:.7em;
}

#eventLogContainer h2
{
    margin:0px;
}

#log li
{
    margin-top:6px;
    margin-bottom:6px;
}


<%@ Page
    ContentType="text/css"
    Language="C#" AutoEventWireup="true" CodeBehind="journal-css.aspx.cs" Inherits="OfflineDemo.journal_css" %>