import QtQuick 2.11
import QtQuick.Window 2.11
import QtMultimedia 5.11
import QtQuick.Controls 2.4
import QtGraphicalEffects 1.0

//import custom controls
import "revControls" as RevControls
import io.dbour.Network 1.0
import io.dbour.HttpDownloader 1.0
import io.dbour.Logged 1.0

ApplicationWindow {
    id: mainWindow
    title: "Dragon Ball Online Universe Revelations Launcher"
    visible: false //true
    width: 820
    height: 611
    maximumWidth: mainWindow.width
    maximumHeight: mainWindow.height
    flags: Qt.Window | Qt.FramelessWindowHint
    color: "transparent"
    opacity: 0.8 //1

    onActiveChanged: if(!contextMediaMain.mediaState){ //on window focus state toggle background
                         if(!active) {
                             animatedBg.pause()
                         } else if (active) {
                             animatedBg.play()
                         }
                     }
HttpDownloader
{
        id:downloader
        onValueChanged:{
            getDownloadInfo()
            speed()
            progbarText.text = currentTask + ": " + downloadSizeString + " remaining" +  " (" + downloadSpeed + " " + downloadUnit + ")"
        }
        onFileDownloaded:
        {
            progbarText.text = downloader.getDownloadedFile() + " Downloaded";
        }
}

Logged
{
        id:logged

        Component.onCompleted: checkIsLaunchable()
        Component.onDestruction: logged.cleanup();
        //Component.onStatusChanged: checkIsLaunchable()

        onAllFilesDone:
        {
            currentTask = "Done";
            downloadSpeed = 0;
            downloadUnit = "bytes/sec";
            startButton.enabled = true;
            patchStatus = "Updated";
            startButton.buttonText = "Start"
            patchToggle.checked = false;
            patchToggle.enabled = false;
            progbarText.text = currentTask
        }


}
Network{
    id: network
    Component.onCompleted:
    {
        network.setLoggedPtr(logged)
        logged.setDownloader(downloader)
        logged.connectSignals()
        network.checkForLauncherUpdate()
    }
}


    Item {
        Loader {
            id: loginWin
            active: true
            source: "qrc:/qml/login.qml"
            onLoaded: {
                mainWindow.hide();
            }
        }

    }

    FontLoader { id: fontMuli; source: "qrc:/font/Muli.ttf" }

    property string currentTask: "Check"; //Downloading, Patching, Done
    property double percentDone: 0; // percentage down / 100
    property double downloadTotal: 0; //Total Download Size in MB
    property double downloadSize: 0;
    property string downloadSizeString: ""//(downloadTotal - (percentDone / 100) * downloadTotal).toFixed(2) + " MB"; //Remaining Download size in MB
    property double downloadSpeed: 0; //Download Speed in Bytes
    property string downloadUnit: "bytes/sec"; //   b / kB / MB
    property string serverResponse: "OK"; //OK, Game Issues, Chat Issues, Login Issues, Offline
    property string patchStatus : "Outdated" //Updated, Outdated, Install

    function speed() {
        if (downloadSpeed <= 1024) {
            downloadUnit = "bytes/sec";
        } else if (downloadSpeed <= 1024*1024) {
            downloadSpeed /= 1024;
            downloadSpeed = downloadSpeed.toFixed(0);
            downloadUnit = "kB/s";
        } else if (downloadSpeed >= 1024*1024) {
            downloadSpeed /= 1024*1024;
            downloadSpeed = downloadSpeed.toFixed(2);
            downloadUnit = "MB/s";
        }
    }
    function getDownloadInfo()
    {
        downloadTotal = logged.getDownloadTotal()
        downloadSize = logged.getDownloadSize()
        downloadSizeString = downloadSize.toFixed(2) + "MB"
        downloadSpeed = logged.getDownloadSpeed()
        percentDone = (downloadSize/downloadTotal * 100)/100
    }

    function checkIsLaunchable()
    {
        if(logged.isStartable() === true)
        {

            currentTask = "Done";
            downloadSpeed = 0;
            downloadUnit = "bytes/sec";
            startButton.enabled = true;
            patchStatus = "Updated";
            startButton.buttonText = "Start"
            patchToggle.checked = false;
            patchToggle.enabled = false;
            progbarText.text = currentTask

        }
    }

    NumberAnimation {
        id: fadeInWin
        target: mainWindow
        property: "opacity"
        duration: 1000
        easing.type: Easing.InOutQuad
        from: 0
        to: 1
    }

    NumberAnimation {
        id: fadeOutWin
        target: mainWindow
        property: "opacity"
        duration: 1000
        easing.type: Easing.InOutQuad
        from: 1
        to: 0
    }

    Timer {
        id: closeWin
        interval: 1100
        running: false
        repeat: false
        onTriggered: {
            close();
        }
    }

    Rectangle {
        id: rectMain
        x: 10
        y: 10
        width: 800
        height: 591
        implicitWidth: 800
        implicitHeight: 591
        opacity: 1 //0
        color: "transparent"
        visible: true
        anchors.margins: 10 //DropShadow

        Rectangle {
            id:winBorder
            y: 39
            z: 3
            width: 800
            height: 552
            color: "#00000000"
            border.width: 1
        }

        MouseArea {
            id: winDrag
            z: 1
            anchors.fill: parent
            property int mx
            property int my
            onPressed: { mx = mouseX; my = mouseY }
            onPositionChanged: {
                mainWindow.x += mouseX - mx
                mainWindow.y += mouseY - my
            }
        }

        RevControls.RevMedia {
            id: contextMediaMain
            x: 557
            y: 39
            z: 4
            enabled: mainWindow.onActiveChanged ? mainWindow.active : !mainWindow.active
            onClicked:  {
                mediaState = !mediaState;
                if (mediaState) {
                    animatedBg.stop();
                } else if (!mediaState) {
                    animatedBg.play();
                }
            }
        }


        RevControls.RevSettings {
            id: contextOptions
            x: 618
            y: 39
            z: 4
            visible: false
            onClicked: {
                var configWin = Qt.createComponent("qrc:/qml/config.qml");
                if (configWin.status === Component.Ready) {
                    var config = configWin.createObject(parent,{popupType: 1});
                    config.show();
                }
            }
        }

        RevControls.RevMin {
            id: contextMinimize
            x: 679
            y: 39
            z: 4

            onClicked:  {
                mainWindow.showMinimized()
            }
        }

        RevControls.RevExit {
            id: contextExit
            x: 740
            y: 39
            z: 4

            onClicked: {
                closeWin.start();
                fadeOutWin.start();
            }
        }

        Image {
            id: dborLogo
            x: 263
            y: 0
            z: 100
            width: 276
            height: 133
            fillMode: Image.PreserveAspectFit
            source: "qrc:/images/logo2.png"
        }

        Video {
            id: animatedBg
            y: 39
            width: 800
            height: 552
            fillMode: VideoOutput.PreserveAspectCrop
            loops: MediaPlayer.Infinite
            onStopped: if(!contextMediaMain.mediaState){animatedBg.seek(1); animatedBg.play();} else {animatedBg.stop();}
            autoLoad: true
            autoPlay: false
            source: "qrc:/mp4/main-bg.avi"

            Image {
                z: -1
                anchors.fill: parent
                fillMode: Image.PreserveAspectCrop
                source: "qrc:/images/main-still.jpg"
            }
        }

        //Server Status
        Rectangle {
            id: quickLink
            x: 8
            y: 45
            z: 4
            width: 228
            height: 40
            radius: 0
            border.width: 0
            border.color: "#80000000"
            color: "transparent" //"#40000000" //#803b3c3f //#33ffffff //#40000000

            Image {
                id: linkImage
                source: "qrc:/images/glass_box_sml.png"
                width: quickLink.width
                height: quickLink.height
                fillMode: Image.Stretch
            }

            Button  {
                id: homeBtn
                width: 76
                height: 40
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 0

                background: Rectangle {
                    color: parent.hovered ? "#40000000" : "transparent"
                    border.color: parent.hovered ? "black" : ""
                    border.width: parent.hovered ? "0.50" : "0"
                }

                Text {
                    id: homeLink
                    color: "#ffffff"
                    text: "Home"
                    anchors.fill: parent
                    font.pixelSize: 15 //11
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.family: fontMuli.name
                    font.weight: Font.Bold
                    style: Text.Raised
                    styleColor: "black"

                    layer.enabled: true
                    layer.effect: DropShadow {
                        color: "black"
                        horizontalOffset: 1
                        verticalOffset: 1
                        radius: 8
                        samples: 10
                    }
                }

                MouseArea {
                    anchors.bottomMargin: 0
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {Qt.openUrlExternally("https://universe.dborevelations.com/home/")}
                }
            }

            Button {
                id: forumBtn
                width: 76
                height: 40
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                background: Rectangle {
                    color: parent.hovered ? "#40000000" : "transparent"
                    border.color: parent.hovered ? "black" : ""
                    border.width: parent.hovered ? "0.50" : "0"
                }

                Text {
                    id: forumsLink
                    color: "#ffffff"
                    text: "Forums"
                    font.pixelSize: 15 //11
                    anchors.fill: parent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.family: fontMuli.name
                    font.weight: Font.Bold
                    style: Text.Raised
                    styleColor: "black"

                    layer.enabled: true
                    layer.effect: DropShadow {
                        color: "black"
                        horizontalOffset: 1
                        verticalOffset: 1
                        radius: 8
                        samples: 10
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {Qt.openUrlExternally("https://universe.dborevelations.com/forum/")}
                }
            }

            Button  {
                id: supportBtn
                width: 76
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom

                background: Rectangle {
                    color: parent.hovered ? "#40000000" : "transparent"
                    border.color: parent.hovered ? "black" : ""
                    border.width: parent.hovered ? "0.50" : "0"
                }

                Text {
                    id: supportLink
                    color: "#ffffff"
                    text: "Support"
                    anchors.fill: parent
                    font.pixelSize: 15 //11
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.family: fontMuli.name
                    font.weight: Font.Bold
                    style: Text.Raised
                    styleColor: "black"

                    layer.enabled: true
                    layer.effect: DropShadow {
                        color: "black"
                        horizontalOffset: 1
                        verticalOffset: 1
                        radius: 8
                        samples: 10
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {Qt.openUrlExternally("https://universe.dborevelations.com/forum/")}
                }
            }
        }


        Rectangle {
            id: statusbg
            x: 8
            y: 90
            z: 2
            width: 228
            height: 30
            color: "transparent" //"#40000000" //#40000000
            radius: 0
            border.width: 0
            border.color: "#80000000"
            //#33ffffff //#803b3c3f //"#0D000000" //#663b3c3f

            Image {
                id: statusImage
                height: 26
                anchors.fill: parent
                source: "qrc:/images/glass_box_sml.png"
                fillMode: Image.Stretch
            }

            Rectangle {
                width: 114
                height: parent.height
                color: "transparent"
                border.width: 0

                Text {
                    id: statusLabel
                    text: "Server Status"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.fill: parent
                    color: "#ffffff"
                    font.pixelSize: 14 //10.5
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.family: fontMuli.name
                    font.weight: Font.Bold
                    style: Text.Raised
                    styleColor: "black"

                    layer.enabled: true
                    layer.effect: DropShadow {
                        color: "black"
                        horizontalOffset: 1
                        verticalOffset: 1
                        radius: 8
                        samples: 10
                    }

                }
            }

            Rectangle {
                id: statusRect
                x: 114
                y: 0
                width: 114
                height: parent.height
                color: "transparent"
                border.width: 0

                Text {
                    id: statusState
                    text: serverResponse
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.fill: parent
                    //color: "#00e209"
                    //color: "#ff4040"
                    color: {
                        if(serverResponse === "Offline") {
                            statusState.color = "#ff4040"
                        } else if(serverResponse === "OK") {
                            statusState.color = "#00e209"
                        } else if (serverResponse === "Login Issues" || "Chat Issues" || "Game Issues") {
                            statusState.color = "#e5e500"
                        }
                    }
                    font.pixelSize: 14 //10.5
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.family: fontMuli.name
                    font.weight: Font.Bold
                    style: Text.Outline
                    styleColor: "black"

                    layer.enabled: true
                    layer.effect: DropShadow {
                        color: "black"
                        horizontalOffset: 1
                        verticalOffset: 1
                        radius: 8
                        samples: 10
                    }
                }
            }
        }

        Rectangle {
            id: socialRect
            x: 8
            y: 126
            z: 4
            width: 228
            height: 37
            color: "transparent"
            radius: 0
            border.width: 0
            border.color: "#80000000"

            layer.enabled: true
            layer.effect: DropShadow {
                color: "black"
                horizontalOffset: 1
                verticalOffset: 1
                radius: 8
                samples: 10
            }

            Image {
                width: socialRect.width
                height: socialRect.height
                source: "qrc:/images/glass_box_sml.png"
                fillMode: Image.Stretch
            }

            Rectangle {
                id:socialCont
                x: 44
                y: 53
                width: socialRect.width
                height: socialRect.height
                color: "transparent"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                border.width: 0

                Rectangle {
                    id: socialFacebook
                    x: 16
                    y: 5
                    width: 28
                    height: 28
                    color: "transparent"

                    Image {
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectFit
                        source: "qrc:/images/social/facebook.png"
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {Qt.openUrlExternally("https://www.facebook.com/dbouniverse.revelations")}
                        onPressed: parent.opacity = 0.8; onReleased: parent.opacity = 1;
                        onEntered: parent.y = 2; onExited: parent.y = 5;
                    }
                }

                Rectangle {
                    id: socialYoutube
                    x: 50
                    y: 5
                    width: 28
                    height: 28
                    color: "transparent"

                    Image {
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectFit
                        source: "qrc:/images/social/youtube.png"
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {Qt.openUrlExternally("https://www.youtube.com/dbouniverserevelations")}
                        onPressed: parent.opacity = 0.8; onReleased: parent.opacity = 1;
                        onEntered: parent.y = 2; onExited: parent.y = 5;

                    }
                }

                Rectangle {
                    id: socialTwitter
                    x: 84
                    y: 5
                    width: 28
                    height: 28
                    color: "transparent"

                    Image {
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectFit
                        source: "qrc:/images/social/twitter.png"
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {Qt.openUrlExternally("https://twitter.com/dboursupport")}
                        onPressed: parent.opacity = 0.8; onReleased: parent.opacity = 1;
                        onEntered: parent.y = 2; onExited: parent.y = 5;
                    }
                }

                Rectangle {
                    id: socialDiscord
                    x: 118
                    y: 5
                    width: 28
                    height: 28
                    color: "transparent"

                    Image {
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectFit
                        source: "qrc:/images/social/discord.png"
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {Qt.openUrlExternally("https://discord.gg/EXVatKN")}
                        onPressed: parent.opacity = 0.8; onReleased: parent.opacity = 1;
                        onEntered: parent.y = 2; onExited: parent.y = 5;
                    }
                }

                Rectangle {
                    id: socialReddit
                    x: 152
                    y: 5
                    width: 28
                    height: 28
                    color: "transparent"
                    visible: false

                    Image {
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectFit
                        source: "qrc:/images/social/reddit.png"
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {Qt.openUrlExternally("#")}
                        onPressed: parent.opacity = 0.8; onReleased: parent.opacity = 1;
                        onEntered: parent.y = 2; onExited: parent.y = 5;
                    }
                }

                Rectangle {
                    id: socialStream
                    x: 186
                    y: 5
                    width: 28
                    height: 28
                    color: "transparent"
                    visible: false

                    Image {
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectFit
                        source: "qrc:/images/social/youtubegaming.png"
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {Qt.openUrlExternally("https://www.youtube.com/c/dbouniverserevelations")}
                        onPressed: parent.opacity = 0.8; onReleased: parent.opacity = 1;
                        onEntered: parent.y = 2; onExited: parent.y = 5;
                    }
                }
            }
        }

        Timer {
            id: startPatch
            interval: 1000
            running: false
            repeat: true
            onTriggered: {
                if(percentDone < 100) {

                } else if (percentDone == 100) {
                    currentTask = "Done";
                    downloadSpeed = 0;
                    downloadUnit = "bytes/sec";
                    startButton.enabled = true;
                    patchStatus = "Updated";
                    startButton.buttonText = "Start"
                    startPatch.stop();
                    patchToggle.checked = false;
                    patchToggle.enabled = false;
                }
            }
        }

        RevControls.RevButton {
            id: startButton
            x: 8
            y: 522
            z: 2
            width: 156
            height: 63
            fontSize: 24 //18
            buttonText: {
                if (patchStatus === "Outdated") {
                    startButton.buttonText = "Patch"
                } else if (patchStatus === "Updated") {
                    startButton.buttonText = "Start"
                } else if(patchStatus === "Install") {
                    startButton.buttonText = "Install"
                }  //"Start" "Patch" "Install"
            }
            onClicked:  {
                if(!logged.isStartable())
                {
                    startButton.enabled = false;
                    patchToggle.enabled = true;
                    patchToggle.checked = true;
                    currentTask = "Downloading";
                    logged.downloadStart();
                }
                else
                {
                    logged.on_play_clicked()

                }
            }

        }

        Button {
            id: patchToggle
            x: 185
            y: 537
            z: 2
            width: 40
            height: 40
            scale: onPressed ? 0.96 : 1
            opacity: enabled ? 1 : 0.50
            enabled: false
            checkable: true
            visible: false
            onClicked: if (patchToggle.checked){startPatch.start()} else {startPatch.stop()}

            background: Rectangle {
                color: parent.hovered ? '#3b3c3f' : '#1AFFFFFF' //&& parent.enabled ? '#1AFFFFFF' :'#3b3c3f' //'#0DFFFFFF'
                border.color: "#80000000"
                border.width: parent.hovered ? 1 : 0.50
                scale: parent.hovered ? "1.04" : "1"
                radius: 6
            }

            Image {
                id: imgPatch
                width:  24
                height:  24
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                source: patchToggle.checked ? "qrc:/images/pause.png" : "qrc:/images/play.png"
                fillMode: Image.PreserveAspectFit

                layer.enabled: true
                layer.effect: DropShadow {
                    color: "black"
                    horizontalOffset: 1
                    verticalOffset: 1
                    radius: 8
                    samples: 10
                }

                transitions: Transition {
                    NumberAnimation { properties: "source"; easing.type: Easing.InOutQuad; duration: 500 }
                }
            }

            MouseArea {cursorShape: Qt.PointingHandCursor}
        }

        ProgressBar {
            id: progbar
            x: 233
            y: 546
            z: 2
            from: 0
            to: 100
            value: percentDone
            indeterminate: false

            layer.enabled: true
            layer.effect: DropShadow {
                color: "black"
                horizontalOffset: 1
                verticalOffset: 1
                radius: 8
                samples: 10
            }

            background: Rectangle {
                implicitWidth: 467 //width: 467
                implicitHeight: 20 //height: 20
                color: "#1AFFFFFF" //'#0DFFFFFF'
                radius: 4
                border.width: 0.50 //0.25
                border.color: "#80000000"
            }

            contentItem: Item {
                id: itemProgbar
                implicitWidth: 0
                implicitHeight: 20
                anchors.fill: parent
                anchors.margins: 4
                anchors.rightMargin: if(percentDone === 100) {4} else {0}

                Rectangle {
                    width: progbar.visualPosition * parent.width
                    height: parent.height
                    border.color: "black"
                    radius: 1

                    color: "#000000" //"#525e5e"
                    gradient: Gradient {
                        GradientStop {
                            position: 0
                            color: "#525e5e"
                        }

                        GradientStop {
                            position: 1
                            color: "#212123"
                        }
                    }
                }

                ToolTip {
                    id:  progTooltip
                    width: 38
                    height: 25
                    x: progbar.visualPosition * itemProgbar.width - 19
                    y: itemProgbar.y + 9
                    z: 40
                    visible: progbar.value > 1 //&& progbar.value < 100

                    contentItem: Text {
                        text: progbar.value.toFixed(0) + "%"
                        clip: true
                        color: "#ffffff"
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                    }

                    background: Rectangle {
                        color: "transparent" //"#525e5e"
                        border.width: 0
                        radius: 4

                        Image {
                            anchors.fill: parent
                            fillMode: Image.Stretch
                            source: "qrc:/images/tooltip.png"
                        }

                    }
                }

                Item { //Indetermiate Animation
                    id: indeterBar
                    anchors.fill: parent
                    anchors.margins: 2
                    anchors.rightMargin: 4
                    visible: progbar.indeterminate
                    clip: true

                    Row {
                        Repeater {
                            Rectangle {
                                color: index % 2 ? "#525e5e" : "#212123"
                                width: 20 ; height: progbar.height
                            }
                            model: progbar.width / 20 + 2
                        }
                        XAnimator on x {
                            from: 0 ; to: -40
                            loops: Animation.Infinite
                            running: progbar.indeterminate
                        }
                    }
                }

            }

            Text {
                id: progbarText
                z: 2
                color: "#ffffff"
                font.family: fontMuli.name
                text: currentTask + ": " + downloadSizeString + " remaining" +  " (" + downloadSpeed + " " + downloadUnit + ")"
                renderType: Text.NativeRendering
                anchors.fill: parent
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottomMargin: 2
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
        }


        Button {
            id: repatchBtn
            x: 727
            y: 528
            width: 51
            height: 51
            z: 2
            visible: false

            property bool rounded: true

            Image {
                id: imgRepatch
                anchors.rightMargin: 0
                anchors.bottomMargin: 0
                anchors.leftMargin: 1
                anchors.topMargin: 3
                source: "qrc:/images/repatch.png"
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit

                layer.enabled: true
                layer.effect: DropShadow {
                    color: "black"
                    horizontalOffset: 1
                    verticalOffset: 1
                    radius: 8
                    samples: 10
                }
            }

            background: Rectangle {
                color: parent.hovered ? '#3b3c3f' : '#1AFFFFFF' && parent.enabled ? '#1AFFFFFF' :'#3b3c3f'//'#0DFFFFFF'
                border.color: "#80000000"
                border.width: parent.hovered ? 1 : 0.50
                scale: parent.hovered ? "1.2" : "1"
                radius: 4
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onPressed: { parent.scale = "0.96" } onReleased: { parent.scale = "1" }
            }
        }

        CheckBox {
            id: autoBoot
            x: 596
            y: 522
            width: 100
            height: 19
            z: 2
            visible: false

            indicator: Rectangle {
                implicitWidth: 16
                implicitHeight: 16
                radius: 3
                x: autoBoot.leftPadding
                y: parent.height / 2 - height / 2
                border.color: autoBoot.checked ? "black" : "#000"
                border.width: 1
                smooth: true

                Rectangle {
                    visible: autoBoot.checked
                    color: "#555"
                    border.color: "#333"
                    radius: 1
                    anchors.margins: 4
                    anchors.fill: parent
                    smooth: true
                }
            }

            Text {
                id: autoBootText
                color: "white"
                opacity:  autoBoot.hovered ? 0.90 : 1
                text: "Auto Boot"
                font.family: fontMuli.name
                anchors.fill: parent
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignBottom
                font.pixelSize: 14 //10.5
                styleColor: "#000000"
                style: Text.Outline
                font.bold: true

                layer.enabled: true
                layer.effect: DropShadow {
                    color: "black"
                    horizontalOffset: 1
                    verticalOffset: 1
                    radius: 8
                    samples: 10
                }

            }
        }

    } // rectMain END --|| Used for rigging || --

    DropShadow {
        anchors.fill: rectMain
        horizontalOffset: 1
        verticalOffset: 1
        radius: winDrag.pressed ? 5 : 8
        samples: 10
        source: rectMain
        color: "black"
        Behavior on radius { PropertyAnimation { duration: 100 } }
        opacity: 0
        visible: false
    }
} // END MAIN WINDOW
