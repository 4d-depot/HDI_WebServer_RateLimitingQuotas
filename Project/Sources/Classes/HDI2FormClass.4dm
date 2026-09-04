

property data60 : Boolean
property data120 : Boolean

property quotaNames : Collection


Class constructor
	
	This:C1470.quotaNames:=New collection:C1472()
	
	This:C1470.quotaNames.push("inBytesPerMin")
	This:C1470.quotaNames.push("outBytesPerMin")
	
	This:C1470.quotaNames.push("inBytesPerHour")
	This:C1470.quotaNames.push("outBytesPerHour")
	
	This:C1470.quotaNames.push("nbRequestPerMin")
	This:C1470.quotaNames.push("nbRequestPerHour")
	
	This:C1470.quotaNames.push("inBytesPerMinPerSession")
	This:C1470.quotaNames.push("outBytesPerMinPerSession")
	
	This:C1470.quotaNames.push("inBytesPerHourPerSession")
	This:C1470.quotaNames.push("outBytesPerHourPerSession")
	
	This:C1470.quotaNames.push("nbRequestPerMinPerSession")
	This:C1470.quotaNames.push("nbRequestPerHourPerSession")
	
	This:C1470.quotaNames.push("nbSessions")
	This:C1470.quotaNames.push("nbGuestSessions")
	
	This:C1470.quotaNames.push("nbEntitySetsPerSession")
	
	
Function formEventHandler($formEventCode : Integer)
	
	Case of 
			
		: ($formEventCode=On Load:K2:1)
			
			btnTrace:=False:C215
			
			InitInfo
			
			
			Form:C1466.proposedQuotas:={inBytesPerMin: 3000}
			
			If (Not:C34(WEB Server:C1674().isRunning))
				WEB Server:C1674().start()
				DELAY PROCESS:C323(Current process:C322; 60)
			End if 
			
			This:C1470.resetQuotas()
			
			Form:C1466.quotas:=This:C1470.getQuotas()
			
			//$files:=Folder("/RESOURCES/files/").files()
			
			//$file_1000:=$files.query("name = :1"; "file_1000_bytes").first()  // 1000 bytes gives
			//$file_500:=$files.query("name = :1"; "file_500_bytes").first()  // 500 bytes gives 
			//Form.file_60:=$files.query("name = :1"; "file_60_bytes").first()  // 60 bytes gives 343 bytes sent to the server
			
			//Form.urlGetData60:="http://localhost/getContent?size=60"
			//Form.urlGetData120:="http://localhost/getContent?size=120"
			
			
			//Form.body:=Form.file_60.getText()
			//Form.data60:=True
			//Form.data120:=False
			
			manageTexts
			
			
		: ($formEventCode=On Page Change:K2:54)
			
			Case of 
					
				: (FORM Get current page:C276=2)
					
					
					
					
					//: (FORM Get current page=3)
					
					//If (Not(WEB Server().isRunning))
					//WEB Server().start({quotas: {inBytesPerMin: 350; outBytesPerMin: Null}})
					//DELAY PROCESS(Current process; 60)
					//Else 
					//WEB Server().quotas.inBytesPerMin:=350
					//WEB Server().quotas.outBytesPerMin:=Null
					//End if 
					
					
					//: (FORM Get current page=4)
					//If (Not(WEB Server().isRunning))
					//WEB Server().start({quotas: {outBytesPerMin: 130; inBytesPerMin: Null}})
					//DELAY PROCESS(Current process; 60)
					//Else 
					//WEB Server().quotas.outBytesPerMin:=130
					//WEB Server().quotas.inBytesPerMin:=Null
					//End if 
					
					//Form.attempts:=0
					
					
					
			End case 
			
			//Form.quotas:=WEB Server().quotas
			
			
		: (Form event code:C388=On Close Box:K2:21)
			If (Is Windows:C1573 && Application info:C1599().SDIMode)
				QUIT 4D:C291
			Else 
				CANCEL:C270
			End if 
			
	End case 
	
	
Function applyQuota($quotaName : Text; $quotaValue : Integer)
	
	This:C1470.resetQuotas()
	WEB Server:C1674().quotas[$quotaName]:=$quotaValue
	
	Form:C1466.quotas:=This:C1470.getQuotas()
	
	
Function resetQuotas()
	
	For each ($name; This:C1470.quotaNames)
		WEB Server:C1674.quotas[$name]:=Null:C1517
	End for each 
	
	
Function getQuotas() : Object
	
	var $result:={}
	
	For each ($name; WEB Server:C1674().quotas)
		If ($name#"currentValues")
			$result[$name]:=WEB Server:C1674().quotas[$name]
		End if 
	End for each 
	
	return $result
	
	
Function testNow()
	
	OPEN URL:C673("http://127.0.0.1/testQuotas.html")
	
	
	
	
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
	