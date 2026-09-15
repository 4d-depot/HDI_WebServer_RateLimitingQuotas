

property data60 : Boolean
property data120 : Boolean

property quotaNames : Collection


Class constructor
	
	This:C1470.quotaNames:=New collection:C1472()
	
	This:C1470.quotaNames.push("inBytesPerMin")
	This:C1470.quotaNames.push("outBytesPerMin")
	
	This:C1470.quotaNames.push("inBytesPerHour")
	This:C1470.quotaNames.push("outBytesPerHour")
	
	This:C1470.quotaNames.push("nbRequestsPerMin")
	This:C1470.quotaNames.push("nbRequestsPerHour")
	
	This:C1470.quotaNames.push("inBytesPerMinPerSession")
	This:C1470.quotaNames.push("outBytesPerMinPerSession")
	
	This:C1470.quotaNames.push("inBytesPerHourPerSession")
	This:C1470.quotaNames.push("outBytesPerHourPerSession")
	
	This:C1470.quotaNames.push("nbRequestsPerMinPerSession")
	This:C1470.quotaNames.push("nbRequestsPerHourPerSession")
	
	This:C1470.quotaNames.push("nbSessions")
	This:C1470.quotaNames.push("nbGuestSessions")
	
	This:C1470.quotaNames.push("nbEntitySetsPerSession")
	
	
Function formEventHandler($formEventCode : Integer)
	
	Case of 
			
		: ($formEventCode=On Load:K2:1)
			
			btnTrace:=False:C215
			
			InitInfo
			
			If (Not:C34(WEB Server:C1674().isRunning))
				//WEB Server().start({sessionCookieSameSite: Web SameSite Lax})
				WEB Server:C1674().start()
				DELAY PROCESS:C323(Current process:C322; 60)
			End if 
			
			Form:C1466.proposedQuotas:={inBytesPerMin: 3000; outBytesPerMin: 3000; nbRequestsPerMin: 10; inBytesPerMinPerSession: 2000; outBytesPerMinPerSession: 3000; nbRequestsPerMinPerSession: 5}
			Form:C1466.proposedQuotas.nbSessions:=4
			Form:C1466.proposedQuotas.nbGuestSessions:=2
			
			This:C1470.resetQuotas()
			Form:C1466.quotas:=This:C1470.getQuotas()
			
			manageTexts
			
			
		: ($formEventCode=On Page Change:K2:54)
			
			Form:C1466.proposedQuotas:={inBytesPerMin: 3000; outBytesPerMin: 3000; nbRequestsPerMin: 10; inBytesPerMinPerSession: 2000; outBytesPerMinPerSession: 3000; nbRequestsPerMinPerSession: 5}
			Form:C1466.proposedQuotas.nbSessions:=4
			Form:C1466.proposedQuotas.nbGuestSessions:=2
			
			
		: (Form event code:C388=On Close Box:K2:21)
			If (Is Windows:C1573 && Application info:C1599().SDIMode)
				QUIT 4D:C291
			Else 
				CANCEL:C270
			End if 
			
	End case 
	
	
Function applyQuota($quotaName : Text; $quotaValue : Integer; $resetQuotas : Boolean)
	
	If ($resetQuotas)
		This:C1470.resetQuotas()
	End if 
	
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
	
	
Function resetThisQuota($quotaName : Text)
	
	WEB Server:C1674().quotas[$quotaName]:=Null:C1517
	Form:C1466.proposedQuotas[$quotaName]:=0
	Form:C1466.quotas:=This:C1470.getQuotas()
	
	
Function testNow()
	
	//var $folder : 4D.Folder
	
	//$folder:=Folder("/RESOURCES/")
	
	//OPEN URL($folder.platformPath+"testQuotas.html")
	
	startComponentWebServer
	
	OPEN URL:C673("http://127.0.0.1:8044/testQuotas.html")
	
	
Function restartWebServer()
	
	WEB Server:C1674().stop()
	
	DELAY PROCESS:C323(Current process:C322(); 60)
	
	WEB Server:C1674().start()
	
	Form:C1466.quotas:=This:C1470.getQuotas()
	
	
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
	