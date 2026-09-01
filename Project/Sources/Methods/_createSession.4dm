//%attributes = {}


#DECLARE() : Text

var $url : Text
var $request : 4D:C1709.HTTPRequest
var $requestObj : Object

var $headers:=New object:C1471()

$url:="http://localhost/acceptance"

$requestObj:={method: HTTP GET method:K71:1; headers: $headers}
$request:=4D:C1709.HTTPRequest.new($url; $requestObj).wait()

If ($request.response.status=200)
	return _getRequestSessionCookie($request)
Else 
	return "429 - Too many requests"
End if 
