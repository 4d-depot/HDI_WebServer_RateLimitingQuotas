

shared singleton Class constructor
	
	
Function handle($incoming : 4D:C1709.IncomingMessage) : 4D:C1709.OutgoingMessage
	
	TRACE:C157
	
	var $result:=4D:C1709.OutgoingMessage.new()
	
	If ($incoming.verb="GET")
		$files:=Folder:C1567("/RESOURCES/files/").files()
		
		$result.setBody(This:C1470.buildContent(Num:C11($incoming.urlQuery.size)))
		$result.setHeader("Content-Type"; "text/plain")
		
		//Case of 
		//: (Num($incoming.urlQuery.size)=60)
		//$file_60:=$files.query("name = :1"; "file_60_bytes").first()
		//$result.setBody($file_60.getText())
		//$result.setHeader("Content-Type"; "text/plain")
		
		//: (Num($incoming.urlQuery.size)=120)
		//$file_120:=$files.query("name = :1"; "file_120_bytes").first()
		//$result.setBody($file_120.getText())
		//$result.setHeader("Content-Type"; "text/plain")
		//End case 
		
	End if 
	
	
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