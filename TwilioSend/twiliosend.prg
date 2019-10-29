** TwilioSend.prg  Send a text via Twilio
**
PARAMETERS ToNumber, FromNumber, SMS2Send, TwilioSID, TwilioToken

IF EMPTY(SMS2Send) OR EMPTY(ToNumber) OR EMPTY(FromNumber) OR EMPTY(TwilioSID) OR EMPTY(TwilioToken)
	RETURN .F.
ENDIF

ToNumber = "+1" + CHRTRAN(ToNumber, "() -./\", "")
FromNumber = "+1" + CHRTRAN(FromNumber, "() -./\", "")

xhr = CREATEOBJECT("Msxml2.XMLHTTP.6.0")
XURL = "https://api.twilio.com/2010-04-01/Accounts/" +TwilioSID + "/Messages.json"


xhr.OPEN("post",XURL,.F.,TwilioSID,TwilioToken)
xhr.setRequestHeader("Authorization", "Basic AUTH_STRING")
MyHeader = "From=" + FromNumber + "&To=" + ToNumber + "&Body=" + SMS2Send
MyHeader = UTF8ENCODE(MyHeader)
xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded')
xhr.SEND(MyHeader)

DO WHILE .T.
	DO CASE
		CASE xhr.ReadyState = 4
			** WAIT "Sent" WINDOW NOWAIT
			EXIT
		OTHERWISE
			** ? "Waiting for ReadyState:", XHR.readyState, xhr.status
	ENDCASE
ENDDO
lcResultText = xhr.responseText
xhr = NULL

**
**
FUNCTION UTF8ENCODE(lcString)
cUtf = ""
FOR i = 1 TO LEN(lcString)
	c = ASC(SUBSTR(lcString,i,1))
	IF  c < 128
		cUtf = cUtf+CHR(c)
	ELSE
		cUtf = cUtf+CHR(BITOR(192,BITRSHIFT(c,6)))+CHR(BITOR(128,BITAND(c,63)))
	ENDIF
NEXT
RETURN cUtf
