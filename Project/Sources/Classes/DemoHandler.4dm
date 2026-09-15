

shared singleton Class constructor
	
	
Function handle($incoming : 4D:C1709.IncomingMessage) : 4D:C1709.OutgoingMessage
	
	//TRACE
	
	var $result:=4D:C1709.OutgoingMessage.new()
	
	Case of 
			
		: (($incoming.verb="GET") && ($incoming.urlQuery.size#Null:C1517))
			$files:=Folder:C1567("/RESOURCES/files/").files()
			
			$result.setBody(This:C1470.buildContent(Num:C11($incoming.urlQuery.size)))
			$result.setHeader("Content-Type"; "text/plain")
			
		: (($incoming.verb="POST") && ($incoming.urlQuery.authenticate#Null:C1517))
			
			If (Bool:C1537($incoming.urlQuery.authenticate="true"))
				Session:C1714.setPrivileges("")
			End if 
			
			
	End case 
	
	
	//If ($incoming.getText()#"")
	//$result.setBody("Well received your data! \n\nBody content-type: "+String($incoming.headers["content-type"])+"\n\n"+"Body content-length: "+String($incoming.headers["content-length"])\
		+"\n\n"+"Body: "+"\n\n"+$incoming.getText())
	
	//Else 
	//$result.setBody("You sent a request without body")
	//End if 
	
	return $result
	
	
	
	
	
	
Function buildContent($size : Integer) : Text
	
	var $result:=""
	
	For ($i; 1; $size)
		$result+="A"
	End for 
	
	return $result