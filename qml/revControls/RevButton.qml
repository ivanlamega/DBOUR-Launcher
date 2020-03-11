//Import the declarative plugins
import QtQuick 2.11
import QtQuick.Controls 2.4

//Implementation of the Button control.
Item {
    FontLoader { id: fontMuli; source: "qrc:/font/Muli.ttf" }

    id: button
    width: 200
    height: 50
    property alias buttonText: innerText.text;
    property alias textFont: fontMuli.name;
    property color textColor: "white"
    property color textOutline: "black"
    property color buttonColor: "transparent"
    property int fontSize: 13 //10
    scale: state === "Pressed" ? 0.96 : 1.0
    onEnabledChanged: state = ""
    signal clicked

    //define a scale animation
    Behavior on scale {
        NumberAnimation {
            duration: 100
            easing.type: Easing.InOutQuad
        }
    }

    //Rectangle to draw the button
    Rectangle{
        id: rectangleButton
        anchors.fill: parent
        opacity: button.enabled ? button.opacity : 0.80
        smooth: true
        color: buttonColor

        Image {
            id:imgButton
            sourceSize.width: parent.width
            sourceSize.height: parent.height
            width: parent.width
            height: parent.height
            source: rectangleButton.enabled ? "qrc:/images/button.png" : "qrc:/images/button_click.png"
            fillMode: Image.Stretch

            Text {
                id: innerText
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.family: textFont
                font.pixelSize: fontSize
                anchors.centerIn: parent
                color: textColor
                font.weight: Font.Bold
                style: Text.Outline
                styleColor: textOutline
            }
        }
    }

    //change the image of the button in different button states
    states: [
        State {
            name: "Hovering"
            PropertyChanges {
                target: imgButton
                source: "qrc:/images/button_hover.png"
            }
        },
        State {
            name: "Pressed"
            PropertyChanges {
                target: imgButton
                source: "qrc:/images/button_click.png"
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
        cursorShape: Qt.PointingHandCursor
        width: 100
        height: 50
        hoverEnabled: true
        anchors.fill: button
        onEntered: { button.state='Hovering'}
        onExited: { button.state=''}
        onClicked: { button.clicked();}
        onPressed: { button.state="Pressed" }
        onReleased: {
            if (containsMouse)
                button.state="Hovering";
            else
                button.state="";
        }
    }
}
