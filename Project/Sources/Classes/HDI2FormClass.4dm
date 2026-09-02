

property data60 : Boolean
property data120 : Boolean


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
			
			Form:C1466.urlGetData60:="http://localhost/getContent?size=60"
			Form:C1466.urlGetData120:="http://localhost/getContent?size=120"
			
			
			Form:C1466.body:=Form:C1466.file_60.getText()
			Form:C1466.data60:=True:C214
			Form:C1466.data120:=False:C215
			
			manageTexts
			
			
		: ($formEventCode=On Page Change:K2:54)
			
			Case of 
				: (FORM Get current page:C276=2)
					
					If (Not:C34(WEB Server:C1674().isRunning))
						WEB Server:C1674().start({quotas: {inBytesPerMin: 350; outBytesPerMin: Null:C1517}})
						DELAY PROCESS:C323(Current process:C322; 60)
					Else 
						WEB Server:C1674().quotas.inBytesPerMin:=350
						WEB Server:C1674().quotas.outBytesPerMin:=Null:C1517
					End if 
					
					
				: (FORM Get current page:C276=3)
					If (Not:C34(WEB Server:C1674().isRunning))
						WEB Server:C1674().start({quotas: {outBytesPerMin: 130; inBytesPerMin: Null:C1517}})
						DELAY PROCESS:C323(Current process:C322; 60)
					Else 
						WEB Server:C1674().quotas.outBytesPerMin:=130
						WEB Server:C1674().quotas.inBytesPerMin:=Null:C1517
					End if 
					
					Form:C1466.attempts:=0
					
					
					
			End case 
			
			Form:C1466.quotas:=WEB Server:C1674().quotas
			
			
		: (Form event code:C388=On Close Box:K2:21)
			If (Is Windows:C1573 && Application info:C1599().SDIMode)
				QUIT 4D:C291
			Else 
				CANCEL:C270
			End if 
			
	End case 
	
	
Function sendDataToServer()
	
	Form:C1466.urlSendData:="http://localhost/demo"
	Form:C1466.verb:=HTTP POST method:K71:2
	
	
	Form:C1466.request:=_sendRequest(Form:C1466.urlSendData; Form:C1466.verb; Form:C1466.file_60.getText())
	
	
	Case of 
		: (Form:C1466.request.response.status=200)
			Form:C1466.response:=Form:C1466.request.response.body
			Form:C1466.retryAfter:=0
			
		: (Form:C1466.request.response.status=429)
			Form:C1466.response:={status: Form:C1466.request.response.status; statusText: Form:C1466.request.response.statusText; retryAfter: Form:C1466.request.response.headers["retry-after"]}
			Form:C1466.retryAfter:=Form:C1466.request.response.headers["retry-after"]
	End case 
	
	
	
Function requestDataToServer()
	
	Form:C1466.attempts+=1
	
	Form:C1466.verb:=HTTP GET method:K71:1
	
	Form:C1466.url:=Form:C1466.data60 ? Form:C1466.urlGetData60 : Form:C1466.urlGetData120
	
	Form:C1466.request:=_sendRequest(Form:C1466.url; Form:C1466.verb)
	
	Case of 
		: (Form:C1466.request.response.status=200)
			Form:C1466.response:=Form:C1466.request.response.body
			Form:C1466.retryAfter:=0
			
		: (Form:C1466.request.response.status=429)
			Form:C1466.response:={status: Form:C1466.request.response.status; statusText: Form:C1466.request.response.statusText; retryAfter: Form:C1466.request.response.headers["retry-after"]}
			Form:C1466.retryAfter:=Form:C1466.request.response.headers["retry-after"]
			Form:C1466.attempts:=0
	End case 
	