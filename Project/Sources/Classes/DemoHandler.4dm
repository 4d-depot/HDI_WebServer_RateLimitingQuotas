

shared singleton Class constructor
	
	
Function handle($incoming : 4D:C1709.IncomingMessage) : 4D:C1709.OutgoingMessage
	
	//TRACE
	
	var $result:=4D:C1709.OutgoingMessage.new()
	
	
	If ($incoming.getText()#"")
		$result.setBody("Well received your data! \n\nBody content-type: "+String:C10($incoming.headers["content-type"])+"\n\n"+"Body content-length: "+String:C10($incoming.headers["content-length"])\
			+"\n\n"+"Body: "+"\n\n"+$incoming.getText())
		
	Else 
		$result.setBody("You sent a request without body")
	End if 
	return $result
	
	
	
Function buildContent($incoming : 4D:C1709.IncomingMessage) : 4D:C1709.OutgoingMessage
	
	var $file_60; $file_120 : 4D:C1709.File
	var $files : Collection
	
	
	var $result:=4D:C1709.OutgoingMessage.new()
	
	$files:=Folder:C1567("/RESOURCES/files/").files()
	
	Case of 
		: (Num:C11($incoming.urlQuery.size)=60)
			$file_60:=$files.query("name = :1"; "file_60_bytes").first()
			$result.setBody($file_60.getText())
			$result.setHeader("Content-Type"; "text/plain")
			
		: (Num:C11($incoming.urlQuery.size)=120)
			$file_120:=$files.query("name = :1"; "file_120_bytes").first()
			$result.setBody($file_120.getText())
			$result.setHeader("Content-Type"; "text/plain")
			
	End case 
	
	return $result