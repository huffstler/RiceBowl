<%
' Example of a server side script called by using the link redirect option
' Written in ASP (Active Server Pages)
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>

<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="content-language" content="en" />

<link href="jquery.zrssfeed.css" rel="stylesheet" type="text/css" />

<title>zRSSFeed - RSS Feed Link Redirection Example</title>

<style>
#test {
	width: 100%;
	height: 600px;
}
</style>

</head>
<body>

<h1>zRSSFeed - RSS Feed Link Redirected Page</h1>
<p>This is the result of the redirected link example showing the original article of the feed item that was clicked.</p>

<iframe id="test" src="<%=Request("link")%>"></iframe>

</body>
</html>