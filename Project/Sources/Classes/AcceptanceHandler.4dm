

shared singleton Class constructor
	
	
Function handle($incoming : 4D:C1709.IncomingMessage) : 4D:C1709.OutgoingMessage
	
	//TRACE
	
	var $result:=4D:C1709.OutgoingMessage.new()
	
	
	If ($incoming.urlQuery.privilege#Null:C1517)
		Session:C1714.clearPrivileges()
		Session:C1714.setPrivileges($incoming.urlQuery.privilege)
	End if 
	
	If ($incoming.getText()#"")
		$result.setBody("Content-type: "+String:C10($incoming.headers["content-type"])+" Content-length "+String:C10($incoming.headers["content-length"]))
	Else 
		$result.setBody("Without body")
	End if 
	return $result
	
	
	
Function buildContent($incoming : 4D:C1709.IncomingMessage) : 4D:C1709.OutgoingMessage
	
	var $file_50; $file_1000; $file_500 : 4D:C1709.File
	var $files : Collection
	
	
	var $result:=4D:C1709.OutgoingMessage.new()
	
	$files:=Folder:C1567("/RESOURCES/files/").files()
	
	Case of 
		: (Num:C11($incoming.urlQuery.size)=50)
			$file_50:=$files.query("name = :1"; "file_50_bytes").first()
			$result.setBody($file_50.getText())
			
		: (Num:C11($incoming.urlQuery.size)=500)
			$file_500:=$files.query("name = :1"; "file_500_bytes").first()
			$result.setBody($file_500.getText())
			
		: (Num:C11($incoming.urlQuery.size)=1000)
			$file_1000:=$files.query("name = :1"; "file_1000_bytes").first()
			$result.setBody($file_1000.getText())
	End case 
	
	return $result