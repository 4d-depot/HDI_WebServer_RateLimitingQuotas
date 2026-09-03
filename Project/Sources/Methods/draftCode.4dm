//%attributes = {}


For each ($name; WEB Server:C1674.quotas)
	If ($name#"currentValues")
		WEB Server:C1674.quotas[$name]:=Null:C1517
	End if 
End for each 