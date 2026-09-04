

shared singleton Class constructor
	
	
Function handle($incoming : 4D:C1709.IncomingMessage) : 4D:C1709.OutgoingMessage
	
	//TRACE
	
	var $result:=4D:C1709.OutgoingMessage.new()
	
	Case of 
			
		: (($incoming.verb="GET") && ($incoming.urlQuery.size#Null:C1517))
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
			
		: ($incoming.urlQuery.authenticate#Null:C1517)
			If (JSON Parse:C1218($incoming.urlQuery.authenticate))
				Session:C1714.clearPrivileges()
				Session:C1714.setPrivileges("")
			End if 
			
		: ($incoming.urlQuery.getQuotas#Null:C1517)
			If (JSON Parse:C1218($incoming.urlQuery.getQuotas))
				$result.setBody(This:C1470.getQuotas())
				$result.setHeader("Content-Type"; "application/json")
			End if 
			
	End case 
	
	
	//If ($incoming.getText()#"")
	//$result.setBody("Well received your data! \n\nBody content-type: "+String($incoming.headers["content-type"])+"\n\n"+"Body content-length: "+String($incoming.headers["content-length"])\
		+"\n\n"+"Body: "+"\n\n"+$incoming.getText())
	
	//Else 
	//$result.setBody("You sent a request without body")
	//End if 
	
	return $result
	
	
Function getQuotas() : Object
	
	var $result:={}
	
	For each ($name; WEB Server:C1674().quotas)
		$result[$name]:=WEB Server:C1674().quotas[$name]
	End for each 
	
	return $result
	
	
	
	
Function buildContent($size : Integer) : Text
	
	var $result:=""
	
	For ($i; 1; $size)
		$result+="A"
	End for 
	
	return $result