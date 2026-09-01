//%attributes = {}


#DECLARE($url : Text; $verb : Text; $body : Variant; $cookie : Text) : 4D:C1709.HTTPRequest


var $request : 4D:C1709.HTTPRequest
var $requestObj : Object
var $headers:=New object:C1471()


$headers["Cookie"]:=$cookie

$requestObj:={method: $verb; headers: $headers}

If ($body#Null:C1517)
	$requestObj.body:=$body
	$requestObj.headers["Content-Type"]:="text/plain"
End if 

$request:=4D:C1709.HTTPRequest.new($url; $requestObj).wait()

return $request

