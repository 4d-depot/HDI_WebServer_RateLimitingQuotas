//%attributes = {}


#DECLARE($request : 4D:C1709.HTTPRequest)


If ($request.response.status=200)
	
	If (Storage:C1525.session.cookie=Null:C1517)
		Use (Storage:C1525.session)
			Storage:C1525.session.cookie:=_getRequestSessionCookie($request)
		End use 
	End if 
	
End if 