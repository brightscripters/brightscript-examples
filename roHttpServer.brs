' roHttpServer sample code
' Documentation: https://brightsign.atlassian.net/wiki/spaces/DOC/pages/370673123/roHttpServer

' Run this sample code from the BrightSign shell
' BrightSign> script rohttpserver.brs
' Use a web browser with the url's below

' Example: Simple hello world server
' Using HTTP GET to read a file

' Create hello.txt
writeAsciiFile("hello.txt", "Hello!")

' Instantiate a server listening to TCP port 12345
server = createObject("roHttpServer", { port: 12345 } )

server.AddGetFromFile({ url_path: "/hello", content_type: "text/plain; charset=utf-8", filename: "hello.txt" })
' Test with web browser http://brightsign-< player S.N. >:12345/hello

' With HTML file
writeAsciiFile("hello.html", "<h1>Hello!</h1>")
server.AddGetFromFile({ url_path: "/hello.html", content_type: "text/html; charset=utf-8", filename: "hello.html" })
' Test with web browser http://brightsign-< player S.N. >:12345/hello.html

server.AddGetFromString( { url_path: "/string$", body:"Hello String!"} )
' Test with web browser http://brightsign-< player S.N. >:12345/string$

server.AddGetFromString( { url_path: "/static.html", body:"<h1>Hello HTML!</h1>"} )
' Test with web browser http://brightsign-< player S.N. >:12345/static.html


' Hadling HTTP Event
' Test with web browser http://brightsign-< player S.N. >:12345/dateTime.json

msgPort = createObject("roMessagePort")
server.setPort(msgPort)

' Handler/Callback for HTTP request
httpServerCallback = function (event)
    dateTimeStr$ = createObject("roSystemTime").GetLocalDateTime().getString()
    print "@callback Date Time: "; dateTimeStr$
    response = { dateTime: dateTimeStr$ }
    event.SetResponseBodyString( formatJson(response) )
    event.SendResponse( 200 )
end function

serverConfig = {
     url_path: "/dateTime.json"
     content_type: "application/json; charset=utf-8"
     user_data: { fnCallback: httpServerCallback }
    }

server.AddGetFromEvent( serverConfig )

print "Waiting for event..."

    EVENT_LOOP:
    while true

        event = msgPort.WaitMessage(0)
        print "Event type: "; type(event), event.GetMethod()

            if type(event) <> "roHttpEvent" then goto EVENT_LOOP

        userData = event.getUserData()    
        
            if type(userData) = invalid  then goto EVENT_LOOP
            if type(userData.fnCallback) <> "roFunction" then goto EVENT_LOOP
        
        userData.fnCallback(event)

    end while

