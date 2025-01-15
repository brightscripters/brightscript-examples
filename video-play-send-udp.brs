
' This sample code loops a video and send out a UDP message at the end of the video.
' Created by BrightScripters

' Usage
' Place this script at the root of a blank microSD card.
' Typically this file would be renamed to autorun.brs so it starts automatically.
' Place a video file at the root of the microSD card. The script will look for file name video1.mp4.
' Every time the video file reaches its end, a UDP message is sent out and the video restarts.
' Make adjustments to the variables bellow.

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Variables
videoFileName$ = "video1.mp4"
udpMessage$ = "my_udp_message"
udpPort% = 5000
udpDestinationIp$ = "255.255.255.255"

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''

u = createObject("roDatagramSender")
u.setDestination( udpDestinationIp$, udpPort% )

v = createObject("roVideoPlayer")
msgPort = createObject("roMessagePort")
v.setPort(msgPort)

videoPlayerUserData = { 
    videoPlayer: v
    videoFile: videoFileName$
    sender: u
    udpMessage: udpMessage$

    callback: function(e) as void
        if e.getInt() <> 8 then return
        m.sender.send(m.udpMessage)
        m.videoPlayer.playFile(m.videoFile)
    end function
}

v.setUserData(videoPlayerUserData)

v.playFile(videoFileName$)

while true
    event = wait(0,msgPort)

    if type(event) = "roVideoEvent" then
        event.getUserData().callback(event)
    end if

end while
