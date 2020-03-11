import QtQuick 2.11
import QtQuick.Window 2.11
import QtQuick.Controls 2.3
import QtGraphicalEffects 1.0

//import custom controls
import "revControls" as RevControls

Window {
    id: settingsWindow
    title: "Dragon Ball Online Universe Revelations Settings"
    width: 660 //495
    height: 440 //620
    flags: Qt.Dialog | Qt.FramelessWindowHint
    modality: Qt.WindowModal
    color: "transparent"
    opacity: 1.0

    x: mainWindow.x + 94 //145
    y: mainWindow.y + 97 //-15  //92

    FontLoader { id: fontMuli; source: "qrc:/font/Muli.ttf" }

	NumberAnimation {
        id: fadeOutWin
        target: settingsWindow
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
            settingsWindow.destroy();
        }
    }

    Rectangle {
        id: settingsRect
        x: 10
        y: 10
        width: 640 //475
        height: 420 //600
        color: "transparent" //"#161616"
        border.width: 1
        anchors.margins: 10 //DropShadow

        MouseArea {
            id: configWinDrag
            z: 1
            anchors.fill: parent;
            property int mx
            property int my
            onPressed: { mx = mouseX; my = mouseY }
            onPositionChanged: {
                settingsWindow.x += mouseX - mx
                settingsWindow.y += mouseY - my
            }
        }

        Image {
            id: configBackground
            z: 2
            width: 475
            height: 600
            anchors.rightMargin: 1
            anchors.leftMargin: 1
            anchors.bottomMargin: 1
            anchors.topMargin: 1
            clip: false

            source: "qrc:/images/Karinga-home.png"
            fillMode: Image.PreserveAspectCrop
            anchors.fill: parent
            horizontalAlignment: Image.AlignRight

            Text {
                id: configHead
                x: 0
                y: 0
                width: 146
                height: 50
                z: 5
                color: "#ffffff"
                text: "Settings"
                style: Text.Raised
                font.weight: Font.Bold
                font.bold: false
                font.family: fontMuli.name
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                font.pixelSize: 36 //27

                layer.enabled: true
                layer.effect: DropShadow {
                    color: "black"
                    horizontalOffset: 1
                    verticalOffset: 1
                    radius: 8
                    samples: 10
                }

                Rectangle {
                    x: 2
                    y: 50
                    width: 147
                    height: 2
                    color: "white"
                    border.color: "#00000000"
                }
            }


            //}       configBackground END --|| original, not used for rigging || --

            RevControls.RevExit {
                id: contextExit
                x: 410
                anchors.top: parent.top
                anchors.topMargin: -1
                anchors.right: parent.right
                anchors.rightMargin: -1
                z: 2

                onClicked: {
                    fadeOutWin.start();
                    closeWin.start();
                }

                Keys.onEscapePressed: {
                    fadeOutWin.start();
                    closeWin.start();
                }
            }

            Rectangle {
                id: systemBounds
                x: 170
                y: 79
                z: 4
                width: 301
                height: 110
                color: "#80000000"
                radius: 4
                border.width: 1

                Image {
                    id: sysimg
                    width: 300
                    source: "qrc:/images/glass_box.png"
                    height:   systemBounds.height
                    fillMode: Image.Stretch
                }

                Text {
                    id: systemText
                    x: 8
                    y: -27
                    color: "#ffffff"
                    text: "System"
                    font.family: fontMuli.name
                    style: Text.Raised
                    font.pixelSize: 36//27

                    layer.enabled: true
                    layer.effect: DropShadow {
                        color: "black"
                        horizontalOffset: 1
                        verticalOffset: 1
                        radius: 8
                        samples: 10
                    }
                }

                Rectangle {
                    //rectangle to align obj
                    id: alignSys
                    x: 16
                    y: 17
                    width: 269
                    height: 84
                    color: "transparent" //#40ffffff"

                    Text {
                        id: langText
                        x: 8
                        y: 14
                        width: 110
                        height: 25
                        color: "#ffffff"
                        text: "Game Language"
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        font.family: fontMuli.name
                        style: Text.Raised
                        font.pixelSize: 12 //9
                        font.bold: false

                        ComboBox {
                            id: langCombo
                            x: 115
                            y: 0
                            z: 4
                            width: 140
                            height: 25
                            focusPolicy: Qt.ClickFocus
                            wheelEnabled: true
                            currentIndex: 0
                            model: ["English", "Français", "Taiwanese", "Korean"]
                        }
                    }


                    Text {
                        id: profanityText
                        x: 8
                        y: 45
                        width: 110
                        height: 25
                        color: "#ffffff"
                        text: "Profanity Filter"
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        scale: 1
                        style: Text.Raised
                        font.pixelSize: 12 //9
                        font.bold: false
                        font.family: fontMuli.name

                        CheckBox {
                            id: profanitySwitch
                            x: 115
                            y: 0
                            width: 140
                            z: 4
                            height: 25
                            padding: 0
                            topPadding: 0
                            bottomPadding: 0
                            rightPadding: 0
                            leftPadding: 60
                            checked: false
                            focusPolicy: Qt.ClickFocus
                            wheelEnabled: true

                            indicator: Rectangle {
                                implicitWidth: 16
                                implicitHeight: 16
                                radius: 3
                                x: profanitySwitch.leftPadding
                                y: parent.height / 2 - height / 2
                                border.color: profanitySwitch.checked ? "black" : "#000"
                                border.width: 1
                                smooth: true

                                Rectangle {
                                    visible: profanitySwitch.checked
                                    color: "#555"
                                    border.color: "#333"
                                    radius: 1
                                    anchors.margins: 4
                                    anchors.fill: parent
                                    smooth: true
                                }
                            }
                        }

                    }
                }
            }

            Rectangle {
                id: displayBound
                x: 8
                y: 211
                z: 4
                width: 301
                height: 185
                color: "#80000000" // "#bf000000
                radius: 4

                Image {
                    id: displayimg
                    source: "qrc:/images/glass_box_lrg.png"
                    width: displayBound.width
                    height:  displayBound.height
                    fillMode: Image.Stretch
                }

                Text {
                    id: displayText
                    x: 8
                    y: -27
                    color: "#ffffff"
                    text: "Display"
                    style: Text.Raised
                    font.pixelSize: 36//27
                    font.family: fontMuli.name

                    layer.enabled: true
                    layer.effect: DropShadow {
                        color: "black"
                        horizontalOffset: 1
                        verticalOffset: 1
                        radius: 8
                        samples: 10
                    }

                }

                Rectangle {
                    //rectangle to align obj
                    id: alignDisplay
                    x: 16
                    y: 17
                    width: 269
                    height: 149
                    color: "transparent" //#40ffffff"

                    Text {
                        id: resText
                        x: 7
                        y: 25
                        width: 110
                        height: 25
                        color: "#ffffff"
                        text: "Resolution"
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        font.pixelSize: 12 //9
                        font.family: fontMuli.name
                        style: Text.Raised

                        ComboBox {
                            id: resCombo
                            x: 115
                            y: 0
                            width: 140
                            height: 25
                            focusPolicy: Qt.ClickFocus
                            wheelEnabled: true
                            currentIndex: 0
                            model: [ "1024x768", "1152x864", "1280x720", "1280x768", "1280x800", "1280x960", "1280x1024", "1360x768", "1366x768", "1440x900", "1600x900", "1600x1024", "1680x1050", "1920x1080"]

                        }
                    }

                    Text {
                        id: gfxpresetText
                        x: 7
                        y: 55
                        width: 110
                        height: 25
                        color: "#ffffff"
                        text: "Graphics Preset"
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        font.pixelSize: 12//9
                        font.family: fontMuli.name
                        style: Text.Raised

                        ComboBox {
                            id: gfxpreset_combo
                            x: 115
                            y: 0
                            z: 4
                            width: 140
                            height: 25
                            focusPolicy: Qt.ClickFocus
                            wheelEnabled: true
                            currentIndex: 0
                            model: ["Very Low","Low", "Medium", "High"]

                        }
                    }

                    Text {
                        id: windowedText
                        x: 7
                        y: 85
                        width: 110
                        height: 25
                        color: "#ffffff"
                        text: "Windowed Mode"
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        font.pixelSize: 12//9
                        font.family: fontMuli.name
                        style: Text.Raised

                        CheckBox {
                            id: windowedSwitch
                            x: 115
                            y: 0
                            z:4
                            width: 140
                            height: 25
                            padding: 0
                            rightPadding: 0
                            bottomPadding: 0
                            topPadding: 0
                            leftPadding: 60
                            focusPolicy: Qt.ClickFocus
                            wheelEnabled: true

                            indicator: Rectangle {
                                implicitWidth: 16
                                implicitHeight: 16
                                radius: 3
                                x: windowedSwitch.leftPadding
                                y: parent.height / 2 - height / 2
                                border.color: windowedSwitch.checked ? "black" : "#000"
                                border.width: 1
                                smooth: true

                                Rectangle {
                                    visible: windowedSwitch.checked
                                    color: "#555"
                                    border.color: "#333"
                                    radius: 1
                                    anchors.margins: 4
                                    anchors.fill: parent
                                    smooth: true
                                }
                            }
                        }

                    }

                    Text {
                        id: gammaText
                        x: 7
                        y: 115
                        width: 110
                        height: 25
                        color: "#ffffff"
                        text: "Gamma"
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: 12//9
                        font.family: fontMuli.name
                        style: Text.Raised

                        Slider {
                            id: gammaSlide
                            x: 115
                            y: 0
                            z: 4
                            width: 140
                            height: 25
                            value: 0.5
                            from: 0.0
                            to: 1.0
                            stepSize: 0.1
                            focusPolicy: Qt.ClickFocus
                            wheelEnabled: true

                            handle: Rectangle {
                                x: gammaSlide.leftPadding + gammaSlide.visualPosition * (gammaSlide.availableWidth - width)
                                y: gammaSlide.topPadding + gammaSlide.availableHeight / 2 - height / 2
                                implicitWidth: 18
                                implicitHeight: 18
                                radius: 13
                                color: gammaSlide.pressed ? "#f0f0f0" : "#f6f6f6"
                                border.color: "#bdbebf"
                            }

                        }
                    }

                }
            }


            Rectangle {
                id: soundBounds
                x: 331
                y: 211
                z: 4
                width: 301
                height: 185
                color: "#80000000"
                radius: 4

                Image {
                    id: soundimg
                    source: "qrc:/images/glass_box_lrg.png"
                    width: soundBounds.width
                    height:  soundBounds.height
                    fillMode: Image.Stretch
                }

                Text {
                    id: soundText
                    x: 8
                    y: -27
                    color: "#ffffff"
                    text: "Sound"
                    font.weight: Font.Normal
                    styleColor: "#000000"
                    style: Text.Raised
                    font.pixelSize: 36 //27
                    font.family: fontMuli.name

                    layer.enabled: true
                    layer.effect: DropShadow {
                        color: "black"
                        horizontalOffset: 1
                        verticalOffset: 1
                        radius: 8
                        samples: 10
                    }
                }

                Rectangle {
                    //rectangle to align obj
                    id: alignSound
                    x: 16
                    y: 17
                    width: 269
                    height: 148
                    color: "transparent" //#40ffffff"

                    Text {
                        id: mvolText
                        x: 7
                        y: 25
                        width: 110
                        height: 25
                        color: "#ffffff"
                        text: "Master Volume"
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: 12//9
                        font.family: fontMuli.name
                        style: Text.Raised

                        Slider {
                            id: mvolSlide
                            x: 115
                            y: 0
                            z: 4
                            width: 140
                            height: 25
                            wheelEnabled: true
                            to: 1
                            from: 0.0
                            stepSize: 0.1
                            value: 0.8

                            handle: Rectangle {
                                x: mvolSlide.leftPadding + mvolSlide.visualPosition * (mvolSlide.availableWidth - width)
                                y: mvolSlide.topPadding + mvolSlide.availableHeight / 2 - height / 2
                                implicitWidth: 18
                                implicitHeight: 18
                                radius: 13
                                color: mvolSlide.pressed ? "#f0f0f0" : "#f6f6f6"
                                border.color: "#bdbebf"
                            }
                        }
                    }

                    Text {
                        id: bgmText
                        x: 7
                        y: 55
                        width: 110
                        height: 25
                        color: "#ffffff"
                        text: "Background Music"
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        font.pixelSize: 12//9
                        font.family: fontMuli.name
                        style: Text.Raised

                        Slider {
                            id: bgmSlide
                            x: 115
                            y: 0
                            z: 4
                            width: 140
                            height: 25
                            wheelEnabled: true
                            to: 1
                            from: 0.0
                            stepSize: 0.1
                            value: 0.6

                            handle: Rectangle {
                                x: bgmSlide.leftPadding + bgmSlide.visualPosition * (bgmSlide.availableWidth - width)
                                y: bgmSlide.topPadding + bgmSlide.availableHeight / 2 - height / 2
                                implicitWidth: 18
                                implicitHeight: 18
                                radius: 13
                                color: bgmSlide.pressed ? "#f0f0f0" : "#f6f6f6"
                                border.color: "#bdbebf"
                            }
                        }

                    }

                    Text {
                        id: sfxText
                        x: 7
                        y: 85
                        width: 110
                        height: 25
                        color: "#ffffff"
                        text: "Sound Effects"
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        font.pixelSize: 12//9
                        font.family: fontMuli.name
                        style: Text.Raised

                        Slider {
                            id: sfxSlide
                            x: 115
                            y: 0
                            z: 4
                            width: 140
                            height: 25
                            wheelEnabled: true
                            to: 1
                            from: 0.0
                            stepSize: 0.1
                            value: 0.6

                            handle: Rectangle {
                                x: sfxSlide.leftPadding + sfxSlide.visualPosition * (sfxSlide.availableWidth - width)
                                y: sfxSlide.topPadding + sfxSlide.availableHeight / 2 - height / 2
                                implicitWidth: 18
                                implicitHeight: 18
                                radius: 13
                                color: sfxSlide.pressed ? "#f0f0f0" : "#f6f6f6"
                                border.color: "#bdbebf"
                            }
                        }
                    }

                    Text {
                        id: ambientText
                        x: 7
                        y: 115
                        width: 110
                        height: 25
                        color: "#ffffff"
                        text: "Ambient Sounds"
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: 12//9
                        font.family: fontMuli.name
                        style: Text.Raised

                        Slider {
                            id: ambientSlide
                            x: 115
                            y: 0
                            z: 4
                            width: 140
                            height: 25
                            wheelEnabled: true
                            to: 1
                            from: 0.0
                            stepSize: 0.1
                            value: 0.2

                            handle: Rectangle {
                                x: ambientSlide.leftPadding + ambientSlide.visualPosition * (ambientSlide.availableWidth - width)
                                y: ambientSlide.topPadding + ambientSlide.availableHeight / 2 - height / 2
                                implicitWidth: 18
                                implicitHeight: 18
                                radius: 13
                                color: ambientSlide.pressed ? "#f0f0f0" : "#f6f6f6"
                                border.color: "#bdbebf"
                            }
                        }
                    }

                }
            }


        }
    } // configBackground END --|| Used for rigging || --

    DropShadow {
        anchors.fill: settingsRect
        horizontalOffset: 1
        verticalOffset: 1
        radius: configWinDrag.pressed ? 5 : 8
        samples: 10
        source: settingsRect
        color: "black"
        Behavior on radius { PropertyAnimation { duration: 100 } }
    }


}
