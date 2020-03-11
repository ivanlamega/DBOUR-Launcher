import QtQuick 2.11
import QtQuick.Window 2.11
import QtMultimedia 5.11
import QtQuick.Controls 2.4
import QtGraphicalEffects 1.0

Window {
    id: revPlayWin
    title: "Dragon Ball Online Universe Revelations Cinematics"
    width: if(playSrc == credits) { loginWindow.width } else { Screen.width }
    height: if(playSrc == credits) { loginWindow.height } else { Screen.height - 1 }
    x: if(playSrc == credits) { loginWindow.x } else { loginWindow.Screen.virtualX }
    y: if(playSrc == credits) { loginWindow.y } else { loginWindow.Screen.virtualY }
    flags: Qt.Dialog | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
    modality: Qt.WindowModal
    color: "transparent"
    FontLoader { id: fontMuli; source: "qrc:/font/Muli.ttf" }
    property string playSrc: ""
    property string credits: "file:///" + applicationDirPath + "/Client/movie/credits.avi";

    NumberAnimation {
        id: fadeOutWin
        target: revPlayWin
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
            revplay.stop()
            revplay.source = ""
            revPlayWin.hide()
            revPlayWin.destroy()
        }
    }

    Rectangle {
        id: playRect
        color: "#161616"
        anchors.fill: parent

        Rectangle {
            id:winBorder
            x: 1
            y: 1
            z: 100
            anchors.fill: parent
            color: "#00000000"
            border.width: 1
        }

        MouseArea {
            id: revPlayWinDrag
            enabled: if(playSrc == credits) { true } else { false }
            z: 1
            anchors.fill: parent
            property int mx
            property int my
            onPressed: { mx = mouseX; my = mouseY }
            onPositionChanged: {
                loginWindow.x += mouseX - mx
                loginWindow.y += mouseY - my
            }
        }

        Rectangle {
            id: playCtrls
            z: 2
            width: revPlayWin.width
            height: 165
            color: "transparent"
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                id: textCtrls
                z: 4
                color: "#80FFFFFF"
                text: "Pause/Play [ Space ]\nSkip Backward [ Left Arrow ]\nSkip Forward [ Right Arrow ]\nExit [ Escape ]"
                font.family: fontMuli.name
                font.pointSize:if(playSrc == credits) {13} else {20}
                style: Text.Raised
                font.weight: Font.Black
                font.bold: true

                anchors.fill: parent
                verticalAlignment: Text.AlignTop
                horizontalAlignment: Text.AlignLeft
                anchors.leftMargin: 4
            }
        }

        Video {
            id: revplay
            width: playRect.width
            height: playRect.height
            fillMode: VideoOutput.PreserveAspectCrop

            autoPlay: true
            source: revPlayWin.playSrc
            onStopped:{
                fadeOutWin.start(); fadeOutWin.running = true;
                closeWin.start(); closeWin.running === true;
            }
            
            focus: true
            Keys.onSpacePressed: revplay.playbackState == MediaPlayer.PlayingState ? revplay.pause() : revplay.play()
            Keys.onLeftPressed: revplay.seek(revplay.position - 5000)
            Keys.onRightPressed: revplay.seek(revplay.position + 5000)
            Keys.onEscapePressed: {
                fadeOutWin.start(); fadeOutWin.running === true;
                closeWin.start(); closeWin.running === true;
            }
        }
    }
}
