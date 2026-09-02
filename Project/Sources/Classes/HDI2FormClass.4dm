

Class constructor
	
	
	
Function formEventHandler($formEventCode : Integer)
	
	Case of 
			
		: ($formEventCode=On Load:K2:1)
			
			btnTrace:=False:C215
			
			InitInfo
			
			$files:=Folder:C1567("/RESOURCES/files/").files()
			
			//$file_1000:=$files.query("name = :1"; "file_1000_bytes").first()  // 1000 bytes gives
			//$file_500:=$files.query("name = :1"; "file_500_bytes").first()  // 500 bytes gives 
			Form:C1466.file_60:=$files.query("name = :1"; "file_60_bytes").first()  // 60 bytes gives 343 bytes sent to the server
			
			If (Not:C34(WEB Server:C1674().isRunning))
				WEB Server:C1674().start({quotas: {inBytesPerMin: 350}})
				DELAY PROCESS:C323(Current process:C322; 60)
			Else 
				WEB Server:C1674().quotas.inBytesPerMin:=350
			End if 
			
			Form:C1466.body:=Form:C1466.file_60.getText()
			
			Form:C1466.quotas:=WEB Server:C1674().quotas
			
			manageTexts
			
			
		: (Form event code:C388=On Close Box:K2:21)
			If (Is Windows:C1573 && Application info:C1599().SDIMode)
				QUIT 4D:C291
			Else 
				CANCEL:C270
			End if 
			
	End case 
	
	
Function sendDataToServer()
	
	Form:C1466.url:="http://localhost/demo"
	Form:C1466.verb:=HTTP POST method:K71:2
	
	
	Form:C1466.request:=_sendRequest(Form:C1466.url; Form:C1466.verb; Form:C1466.file_60.getText())
	
	
	Case of 
		: (Form:C1466.request.response.status=200)
			Form:C1466.response:=Form:C1466.request.response.body
			Form:C1466.retryAfter:=0
			
		: (Form:C1466.request.response.status=429)
			Form:C1466.response:={status: Form:C1466.request.response.status; statusText: Form:C1466.request.response.statusText; retryAfter: Form:C1466.request.response.headers["retry-after"]}
			Form:C1466.retryAfter:=Form:C1466.request.response.headers["retry-after"]
	End case 
	
	
	