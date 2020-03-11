//Import the declarative plugins
import QtQuick 2.11
import QtQuick.Controls 2.4

//Implementation of the Button control.
Item {
    id: settings
    width: 60
    height: 50
    property color settingsColor: "#03FFFFFF" //1% White Opaque //"#0DFFFFFF" //5% White Opaque
    property color borderColor: "#000000"
    property string borderWidth: "0.25"
    property bool mediaState;
    opacity: state === "Pressed" ? 0.85 : 1
    onEnabledChanged: state = ""
    signal clicked

    //define a scale animation
    Behavior on scale {
        NumberAnimation {
            duration: 100
            easing.type: Easing.InOutQuad
        }
    }

    //Rectangle to draw the square
    Rectangle{
        id: rectangleSettings
        anchors.fill: parent
        opacity: settings.enabled ? settings.opacity : 0.50
        border.width: borderWidth
        border.color: borderColor
        smooth: true
        color: settingsColor


        Image {
            id:imgSettings
            sourceSize.width: parent.width
            sourceSize.height: parent.height
            width: parent.width
            height: parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: mediaState ? "qrc:/images/video.png" : "qrc:/images/video-no.png"
            fillMode: Image.PreserveAspectFit
            scale: 0.8
        }
    }

    //change the image of the button in differen button states
    states: [
        State {
            name: "Hovering"
            PropertyChanges {
                target: rectangleSettings
                color: "#3b3c3f"
                border.width: 0.50
            }
        },
        State {
            name: "Pressed"
            PropertyChanges {
                target: rectangleSettings
                color: "#3b3c3f"
                opacity: 0.97
                border.width: 0.50
            }
        }
    ]

    //define transmission for the states
    transitions: [
        Transition {
            from: ""; to: "Hovering"
             NumberAnimation { properties: "scale, opacity"; easing.type: Easing.InOutQuad; duration: 200 }
        },
        Transition {
            from: "*"; to: "Pressed"
             NumberAnimation { properties: "scale, opacity"; easing.type: Easing.InOutQuad; duration: 10 }
        }
    ]

    //Mouse area to react on click events
    MouseArea {
        width: 100
        height: 50
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        anchors.fill: settings
        onEntered: { settings.state='Hovering'}
        onExited: { settings.state=''}
        onClicked: { settings.clicked();}
        onPressed: { settings.state="Pressed" }
        onReleased: {
            if (containsMouse)
                settings.state="Hovering";
            else
               settings.state="";
        }
    }
}
