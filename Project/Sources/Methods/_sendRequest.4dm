//%attributes = {}


#DECLARE($url : Text; $verb : Text; $body : Variant) : 4D:C1709.HTTPRequest


var $request : 4D:C1709.HTTPRequest
var $headers; $requestObj : Object


$headers:=_buildHeaders
$requestObj:={method: $verb; headers: $headers}

If ($body#Null:C1517)
	$requestObj.body:=$body
	$requestObj.headers["Content-Type"]:="text/plain"
End if 

$request:=4D:C1709.HTTPRequest.new($url; $requestObj).wait()
_handleSessionCookie($request)

return $request

