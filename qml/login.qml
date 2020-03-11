import QtQuick 2.11
import QtQuick.Window 2.11
import QtQuick.Controls 2.4
import QtMultimedia 5.11
import QtQuick.Dialogs 1.3
import QtGraphicalEffects 1.0

//import custom controls
import "revControls" as RevControls
import io.dbour.HttpDownloader 1.0
ApplicationWindow {
    id: loginWindow
    title: "Dragon Ball Online Universe Revelations Login"
    visible: true
    width: 820
    height: 611
    maximumWidth: loginWindow.width
    maximumHeight: loginWindow.height
    flags:   Qt.Window | Qt.FramelessWindowHint
    color: "transparent"
    opacity: 1

    HttpDownloader
    {
            id:downloader
            onFileDownloaded:
            {
                progbarText.text = downloader.getDownloadedFile() + " Downloaded";
            }
    }

    onActiveChanged: if(!contextMediaLogin.mediaState){ //on window focus state toggle background
                         if(!active) {
                             loginBg.pause()
                         } else if (active) {
                             loginBg.play()
                         }
                     }

    Component.onCompleted: {
        loginScroll.start()
    }
    property color borderColored: "transparent"
    property color underline : "white"
    property bool isPressed : false
    property int resultCode : 0

    FontLoader { id: fontMuli; source: "qrc:/font/Muli.ttf" }

    function enableAction() {
        contextExit.enabled = true //exit button
        contextMinimize.enabled = true //minimize button
        loginUser.readOnly = false // username text box
        loginPwd.readOnly = false // password text box
        forgotpwd.enabled = true //recover password button
        loginStart.enabled = true  // login button
        loginRegister.enabled = true // register account
        creditsbtn.enabled = true // credits button
        moviebtn.enabled = true //cinematics button
        creditsbtn.enabled = true //credits button
    }
    function disableAction() {
        contextExit.enabled = false //exit button
        contextMinimize.enabled = false //minimize button
        loginUser.readOnly = true // username text box
        loginPwd.readOnly = true // password text box
        forgotpwd.enabled = false //recover password button
        loginStart.enabled = false // login button
        loginRegister.enabled = false // register account
        creditsbtn.enabled = false // credits button
        moviebtn.enabled = false //cinematics button
    }
    function loginAnimate() { //animate the login form
        loginUser.visible = false
        loginPwd.visible = false
        forgotpwd.visible = false
        rmbrme.visible = false
        loginStart.visible = false
        loginRegister.visible = false
        moviebtn.enabled = false //disable Movie Button
        creditsbtn.enabled = false //disable credits button
        loginForm.height = "184"
        loginForm.y = "233"
        img.source = "qrc:/images/success_avatar.png"
        loginAvatar.y = "187"
        textAnimate.running = true
    }
    function registerAnimate() { //animate the login form

        loginForm.y = "-400"
        loginAvatar.y = "-400"
        registerForm.x = "230"
        registerAvatar.x = "350"
    }
    function registerBackAnimate() { //animate the login form

        loginForm.y = "190"
        loginAvatar.y = "147"
        registerForm.x = "960"
        registerAvatar.x = "1079"
    }

    Timer {
        id: loginScroll
        interval: 1000
        running: false
        repeat: false
        onTriggered: {
            loginForm.y = 190
            loginAvatar.y = 147
        }
    }

    NumberAnimation    {
        id: fadeOutWin
        target: loginWindow
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
            mainWindow.close();
        }
    }

    Rectangle {
        id: rectLogin
        x: 10
        y: 10
        width: 800
        height: 591
        color: "transparent"
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
            id: loginWinDrag
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

        RevControls.RevMedia {
            id: contextMediaLogin
            x: 618
            y: 39
            z: 4
            enabled: loginWindow.onActiveChanged ? loginWindow.active : !loginWindow.active
            onClicked:  {
                mediaState = !mediaState;
                if (mediaState) {
                    loginBg.stop();
                } else if (!mediaState) {
                    loginBg.play();
                }
            }
        }

        RevControls.RevMin {
            id: contextMinimize
            x: 679
            y: 39
            z: 4

            onClicked:  {
                loginWindow.showMinimized()
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
            id: loginBg
            y: 39
            width: 800
            height: 552
            fillMode: VideoOutput.Stretch
            loops: MediaPlayer.Infinite
            onStopped: if(!contextMediaLogin.mediaState){loginBg.seek(1); loginBg.play();}
            autoLoad: true
            autoPlay: true
            source: "qrc:/mp4/login-bg.avi"

            Image {
                z: -1
                anchors.fill: parent
                fillMode: Image.Stretch
                source: "qrc:/images/login-still.jpg"
            }

            Rectangle {
                Image {
                    fillMode: Image.Stretch
                    source: "qrc:/images/login_stripes.png"
                }
            }
        }

//        MessageDialog {
//            id: messageDialog
//            title: "Launcher Update Available"
//            text: "To update launcher click OK."
//            icon: StandardIcon.Information
//            modality: "WindowModal"
//            standardButtons: StandardButton.Ok | StandardButton.Abort
//            onAccepted: {
//                console.log("Updating...")
//            }

//            onRejected: {
//                console.log("Declined Update");
//                Qt.quit()
//            }

//        }


        Rectangle {
            id: loginAvatar
            x: 350
            y: -400 //147
            z: 5
            width: 102
            height: 102
            color: "transparent"

            Behavior on y {
                NumberAnimation  { duration: 1000 ; easing.type: Easing.InOutQuad  }
            }

            Image {
                id: img
                source: "qrc:/images/login_avatar.png"
                fillMode: Image.PreserveAspectFit
                width: 98
                height: 98
            }
        }

        Rectangle {
            id: loginForm
            width: 340
            height: 310
            x: 230
            y: -400 //190
            z: 2
            color: "#40000000" //"#40000000" //"#BF000000"
            radius: 3
            border.color: "#D9000000"
            border.width: 1
            smooth: true

            Image {
                id: formImage
                source: "qrc:/images/login_form.png"
                width: loginForm.width
                height: loginForm.height
            }

            layer.enabled: loginForm.enabled
            layer.effect: DropShadow {
                verticalOffset: 1
                horizontalOffset: 1
                color: "#BF000000"
                spread: 0
                radius: 10
            }

            Behavior on y {
                NumberAnimation  { duration: 1000 ; easing.type: Easing.InOutQuad  }
            }


            Behavior on height {
                NumberAnimation  { duration: 550 ; easing.type: Easing.InOutQuad  }
            }

            TextField {
                id: loginUser
                x: 36
                y: 74
                width: 269
                height: 40
                font.family: fontMuli.name
                color: "white"
                font.pixelSize: 14 //10.5
                maximumLength: 16
                placeholderText: "Username"
                selectByMouse: true

                background: Rectangle {
                    id: userBorder
                    color: loginUser.focus ? "#80000000" : "#59000000"
                    border.color: borderColored
                    radius: 2
                }

                Rectangle {
                    width: 269
                    height: 1
                    color: underline
                    y: 39
                }

                Keys.onReturnPressed: { loginStart.clicked() }
                Keys.onEnterPressed: { loginStart.clicked()}

            }

            TextField {
                id: loginPwd
                x: 36
                y: 129
                width: 267
                height: 40
                color: "white"
                font.pixelSize: 14 //10.5
                maximumLength: 128
                font.family: fontMuli.name
                placeholderText: "Password"
                echoMode: TextInput.Password
                selectByMouse: true
                padding: 6

                background: Rectangle {
                    id: pwdBorder
                    color: loginPwd.focus ?  "#80000000" : "#59000000"
                    border.color: borderColored
                    radius: 2
                }

                Rectangle {
                    width: 267
                    height: 1
                    color: underline
                    y: 39
                }

                Keys.onReturnPressed: { loginStart.clicked() }
                Keys.onEnterPressed: { loginStart.clicked()}
            }

            Rectangle {
                id: rectangle
                x: 36
                y: 180
                width: 267
                height: 36
                color: "transparent"

                CheckBox {
                    id: rmbrme
                    //                x: 36
                    //                y: 187
                    width: 125
                    height: 26
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    enabled: false

                    indicator: Rectangle {
                        implicitWidth: 16
                        implicitHeight: 16
                        radius: 3
                        x: rmbrme.leftPadding
                        y: parent.height / 2 - height / 2
                        border.color: rmbrme.checked ? "black" : "#000"
                        border.width: 1
                        smooth: true

                        Rectangle {
                            visible: rmbrme.checked
                            color: "#555"
                            border.color: "#333"
                            radius: 1
                            anchors.margins: 4
                            anchors.fill: parent
                            smooth: true
                        }
                    }

                    Text {
                        id: rmbrmeText
                        height: 26
                        color: "white"
                        text: "Remember me?"
                        opacity: rmbrme.hovered ? 0.90 : 1
                        anchors.bottomMargin: 1
                        anchors.fill: parent
                        style: rmbrme.hovered ? Text.Outline : Text.Normal
                        font.pixelSize: 13 //9.75
                        font.bold: true
                        font.family: fontMuli.name
                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked:  {
                        //registerAnimate();
                    }
                }

                Button {
                    id: forgotpwd
                    x: 161
                    //                x: 199
                    //                y: 184
                    width: 106
                    height: 26
                    anchors.top: parent.top
                    anchors.topMargin: 5
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    enabled: false
                    background: Rectangle {
                        id: lostPwdStyle
                        color: "transparent"
                        border.color: "transparent"
                    }

                    Text {
                        id: lostPwdText
                        text: "Lost Password?"
                        color: "white"
                        opacity: forgotpwd.hovered ? 0.90 : 1
                        style: forgotpwd.hovered ? Text.Outline : Text.Normal
                        font.family: fontMuli.name
                        font.pixelSize: 13 //9.75
                        font.bold: true

                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.capitalization: Font.MixedCase

                    }

                    MouseArea {
                        anchors.fill: parent
                        onPressed: {lostPwdText.color = "grey"}
                        onReleased: {lostPwdText.color = "white"}
                    }
                }
                Text {
                    id: textInfo
                    x: 5
                    y: 30
                    width: 259
                    height: 22
                    text: ""
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 14
                    color : "#e3423e"

                }
            }

            //LoginSpinner Handler


            Timer  {
                id: loginTimer
                interval: 1500;
                running: false;
                repeat: false;
                onTriggered: {
                    switch(resultCode)
                    {
                    case 100: //make authentication function here someday

                        indicatorFrame.visible = false
                        loginIndicator.close();
                        enableAction();
                        loginAnimate();
                        gotoMain.start();
                        break;

                    case 107:
                        //Wrong Password
                        borderColored = "#e3423e"
                        underline = "#e3423e"
                        indicatorFrame.visible = false
                        loginIndicator.close();
                        loginPwd.clear();
                        textInfo.text = "Incorrect Password"
                        enableAction();
                        break;

                    case 108:
                        //User Not Found
                        borderColored = "#e3423e"
                        underline = "#e3423e"
                        indicatorFrame.visible = false
                        loginIndicator.close();
                        loginPwd.clear();
                        textInfo.text = "User not found"
                        enableAction();
                        break;
                    case 110:
                        //Already Logged in
                        borderColored = "#e3423e"
                        underline = "#e3423e"
                        indicatorFrame.visible = false
                        loginIndicator.close();
                        loginPwd.clear();
                        textInfo.text = "User is already logged in"
                        enableAction();
                        break;
                    case 113:
                    case 114:
                    case 118:
                        //Banned or Temp Ban
                        borderColored = "#e3423e"
                        underline = "#e3423e"
                        indicatorFrame.visible = false
                        loginIndicator.close();
                        loginPwd.clear();
                        textInfo.text = "This account is currently banned"
                        enableAction();
                        break;
                    case 120:
                        //Email not Validated
                        borderColored = "#e3423e"
                        underline = "#e3423e"
                        indicatorFrame.visible = false
                        loginIndicator.close();
                        loginPwd.clear();
                        textInfo.text = "This account is awating email verification"
                        enableAction();
                        break;
                    case 6969:
                        //Auth Server Offline
                        borderColored = "#e3423e"
                        underline = "#e3423e"
                        indicatorFrame.visible = false
                        loginIndicator.close();
                        loginPwd.clear();
                        textInfo.text = "The Authentication Server is<br>Currently Down for Maintenance"
                        enableAction();
                        break;
                    case 420:
                        //Missing Username or password
                        borderColored = "#e3423e"
                        underline = "#e3423e"
                        indicatorFrame.visible = false
                        loginIndicator.close();
                        loginPwd.clear();
                        textInfo.text = "Please enter both username and password"
                        enableAction();
                        break;
                    default:
                        //if login fail do this
                        borderColored = "#e3423e"
                        underline = "#e3423e"
                        indicatorFrame.visible = false
                        loginIndicator.close();
                        loginPwd.clear();
                        textInfo.text = "Unknown Failure:" + resultCode + "<br>please contact DBOUR team"
                        enableAction();
                        break;
                    }
                }
            }

            Timer {
                id: gotoMain
                interval: 1250;
                running: false;
                repeat: false;
                onTriggered: {
                    fadeOutWin.start();
                    mainWindow.x = loginWindow.x; mainWindow.y = loginWindow.y;
                    mainWindow.show();
                    if (contextMediaLogin.mediaState){contextMediaMain.clicked();}
                    fadeInWin.start();
                    closeLogin.start();
                }
            }

            Timer {
                id: closeLogin
                interval: 500;
                running: false;
                repeat: false;
                onTriggered: {
                    loginWindow.hide();
                    loginWin.source = "";
                }
            }

            RevControls.RevButton {
                id: loginStart
                x: 36
                y: 246
                width: 106
                height: 43
                buttonText: "Login"
                focus: true

                Keys.onReturnPressed: {
                    loginStart.clicked()
                }

                onClicked: {
                    loginTimer.start()
                    indicatorFrame.visible = true
                    loginIndicator.open()
                    disableAction()
                    borderColored = "transparent"
                    underline =  "white"

                    resultCode = network.sendAuth(loginUser.text, loginPwd.text)
                }
            }

            RevControls.RevButton {
                id: loginRegister
                x: 199
                y: 246
                width: 106
                height: 43
                buttonText: "Register"

                onClicked: {
                    Qt.openUrlExternally("https://universe.dborevelations.com/register/index.php");
                    //registerAnimate()
                }
            }

            Rectangle {
                id: indicatorFrame
                width: 340
                height: 310
                visible: false
                color: "#d9000000"
                radius: 4

                Popup {
                    id: loginIndicator
                    width: 340
                    height: 310
                    dim: false
                    focus: true
                    modal: true
                    closePolicy: "NoAutoClose"

                    background: Rectangle {
                        color: "transparent"
                    }

                    enter: Transition {
                        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0 }
                    }
                    exit: Transition {
                        NumberAnimation { property: "opacity"; from: 1.0; to: 0.0 }
                    }

                    contentItem: BusyIndicator {
                        id: loginSpinner
                        width: 340
                        height: 310
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter

                        contentItem: Item {
                            id: loginSpinBounds
                            width: 140
                            height: 140
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter //70

                            Item { // the spinner
                                id: spinner
                                width: 140
                                height: 140
                                visible: true
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.verticalCenter: parent.verticalCenter
                                opacity: loginSpinner.running ? 1 : 0

                                Behavior on opacity {
                                    OpacityAnimator {
                                        duration: 250
                                    }
                                }

                                RotationAnimator {
                                    target: spinner
                                    running: loginSpinner.visible && loginSpinner.running
                                    from: 0
                                    to: 360
                                    loops: Animation.Infinite
                                    duration: 1250
                                }

                                Repeater { // the orange circles
                                    id: repeater
                                    model: 7

                                    Rectangle {
                                        x: spinner.width / 2 - width / 2
                                        y: spinner.height / 2 - height / 2
                                        implicitWidth: 10
                                        implicitHeight: 10
                                        radius: 5
                                        color: "#ff8b11"
                                        transform: [
                                            Translate {
                                                y: -Math.min(spinner.width, spinner.height) * 0.5 + 5
                                            },
                                            Rotation {
                                                angle: index / repeater.count * 360
                                                origin.x: 5
                                                origin.y: 5
                                            }
                                        ]
                                    }
                                } // end of the orange circles
                            }
                        }
                    }

                }
            }

            //max characters 18

            Text {
                id: welcomeText
                y: 20
                width: 323
                height: 58
                color: "#ffffff"
                text: "Welcome back!\nTime Patroller,\n" + loginUser.text + "!"
                opacity: 0
                anchors.verticalCenterOffset: 16
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: 1
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.capitalization: Font.MixedCase
                font.bold: true
                font.family: fontMuli.name
                fontSizeMode: Text.HorizontalFit
                font.pixelSize: 24 //18
                wrapMode: Text.WordWrap
                style: Text.Outline

                OpacityAnimator {
                    id: textAnimate
                    target: welcomeText
                    from: 0.0
                    to: 1.0
                    duration: 1500
                    running: false
                }
            }


        } //loginForm end

        RevControls.RevButton {
            id: creditsbtn
            x: 141
            y: 535
            z: 3
            width: 106
            height: 43
            buttonText: "Credits"
            enabled: true
            visible: false

            onClicked: {
                var playerWin = Qt.createComponent("qrc:/qml/revPlayer.qml");
                if (playerWin.status === Component.Ready) {
                    var playerLoader = playerWin.createObject(loginWindow, {popupType: 1, playSrc: "file:///" + applicationDirPath + "/movie/credits.avi"});
                    playerLoader.show();
                }
            }
        }

        RevControls.RevButton {
            id: moviebtn
            x: 15
            y: 535
            z: 3
            width: 106
            height: 43
            buttonText: "Cinematics"

            onClicked: {
                movieSelFrame.visible = true
                movieSelect.open()
                disableAction()
            }
        }

        Rectangle {
            id: movieSelFrame
            y: 39
            z: 70
            width: 800
            height: 552
            color: "#d9000000"
            visible: false

            Popup {
                id: movieSelect
                x: 313
                y: 146
                z: 75
                width: 200
                height: 300
                focus: true
                modal: true
                dim: false
                closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
                onAboutToHide: {
                    movieSelFrame.visible = false
                    enableAction()
                }

                enter: Transition {
                    NumberAnimation { property: "opacity"; from: 0.0; to: 1.0 }
                }
                exit: Transition {
                    NumberAnimation { property: "opacity"; from: 1.0; to: 0.0 }
                }

                background: Rectangle {

                    color: "#00000000"
                    radius: 6
                    border.color: "#000000"
                    border.width: 9

                    Image {
                        id: movieSelBg
                        anchors.fill: parent
                        scale: 0.99
                        opacity: 0.98
                        fillMode: Image.PreserveAspectCrop
                        source: "qrc:/images/papayaMountain.png"
                    }

                }

                contentItem: Rectangle {
                    id: movPopupBox
                    color: "#00000000"
                    anchors.fill: parent

                    RevControls.RevExit {
                        id: movieSelExit
                        z: 76
                        width: 60
                        height: 50
                        anchors.topMargin: 1
                        anchors.top: parent.top
                        anchors.right: parent.right

                        onClicked: {
                            movieSelFrame.visible = false
                            movieSelect.close()
                        }
                    }

                    RevControls.RevButton {
                        id: tenkaichiBtn
                        width: 185
                        height: 35
                        buttonText: "Base of Tenkaichi"
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: -25
                        onClicked: {
                            var playerWin = Qt.createComponent("qrc:/qml/revPlayer.qml");
                            if (playerWin.status === Component.Ready) {
                                var playerLoader = playerWin.createObject(loginWindow, {popupType: 1, playSrc: "file:///" + applicationDirPath + "/Client/movie/The_base_of_Tenkaichi.avi"});
                                playerLoader.show();
                            }
                        }
                    }

                    RevControls.RevButton {
                        id: ageBtn
                        width: 185
                        height: 35
                        buttonText: "Age 1000"
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: 20

                        onClicked: {
                            var playerWin = Qt.createComponent("qrc:/qml/revPlayer.qml");
                            if (playerWin.status === Component.Ready) {
                                var playerLoader = playerWin.createObject(loginWindow, {popupType: 1, playSrc: "file:///" + applicationDirPath + "/Client/movie/opening.avi"});
                                playerLoader.show();
                            }
                        }
                    }

                } // end Popup
            }
        }

        Rectangle {
            id: registerAvatar
            x: 1079
            y: 115
            width: 102
            height: 102
            color: "#00000000"
            z: 5
            Behavior on x {
                NumberAnimation  { duration: 1500 ; easing.type: Easing.InOutQuad  }
            }

            Image {
                id: img1
                y: 0
                width: 98
                height: 98
                fillMode: Image.PreserveAspectFit
                source: "qrc:/images/login_avatar.png"
            }
        }


        Rectangle {
            id: registerForm
            x: 960
            y: 150
            width: 340
            height: 399
            color: "#40000000"
            radius: 3
            z: 2
            layer.enabled: registerForm.enabled
            layer.effect: DropShadow {
                color: "#bf000000"
                radius: 10
                spread: 0
                horizontalOffset: 1
                verticalOffset: 1
            }
            Behavior on x {
                NumberAnimation  { duration: 1500 ; easing.type: Easing.InOutQuad  }
            }

            Image {
                id: formImage1
                width: registerForm.width
                height: registerForm.height
                source: "qrc:/images/login_form.png"
            }

            TextField {
                id: registerUser
                x: 36
                y: 74
                width: 269
                height: 40
                color: "#ffffff"
                maximumLength: 17
                placeholderText: "Username"
                selectByMouse: true
                background: Rectangle {
                    id: userBorder1
                    color: registerUser.focus ? "#80000000" : "#59000000"
                    radius: 2
                    border.color: borderColored
                }
                font.pixelSize: 14
                Rectangle {
                    y: 39
                    width: 269
                    height: 1
                    color: underline
                }
                font.family: fontMuli.name
            }

            TextField {
                id: registerConfirm
                x: 36
                y: 179
                width: 267
                height: 40
                color: "#ffffff"
                selectByMouse: true
                placeholderText: "Confirm Password"
                maximumLength: 17
                background: Rectangle {
                    id: pwdBorder2
                    color: registerConfirm.focus ?  "#80000000" : "#59000000"
                    radius: 2
                    border.color: borderColored
                }
                font.pixelSize: 14
                Rectangle {
                    y: 39
                    width: 267
                    height: 1
                    color: underline
                }
                echoMode: TextInput.Password
                padding: 6
                font.family: fontMuli.name
            }

            TextField {
                id: registerPwd
                x: 36
                y: 129
                width: 267
                height: 40
                color: "#ffffff"
                maximumLength: 17
                placeholderText: "Password"
                selectByMouse: true
                background: Rectangle {
                    id: pwdBorder1
                    color: registerPwd.focus ?  "#80000000" : "#59000000"
                    radius: 2
                    border.color: borderColored
                }
                font.pixelSize: 14
                Rectangle {
                    y: 39
                    width: 267
                    height: 1
                    color: underline
                }
                echoMode: TextInput.Password
                padding: 6
                font.family: fontMuli.name
            }

            Rectangle {
                id: rectangle1
                x: 55
                y: 294
                width: 267
                height: 36
                color: "#00000000"
                CheckBox {
                    id: acceptTos
                    width: 125
                    height: 26
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    Text {
                        id: acceptTosText
                        height: 26
                        color: "#ffffff"
                        text: "Accept Terms and Conditions?"
                        anchors.rightMargin: -94
                        opacity: acceptTos.hovered ? 0.90 : 1
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: 13
                        font.bold: true
                        horizontalAlignment: Text.AlignRight
                        anchors.bottomMargin: 1
                        anchors.fill: parent
                        font.family: fontMuli.name
                        style: acceptTos.hovered ? Text.Outline : Text.Normal
                    }
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.bottomMargin: 0
                    indicator: Rectangle {
                        x: acceptTos.leftPadding
                        y: parent.height / 2 - height / 2
                        radius: 3
                        implicitHeight: 16
                        implicitWidth: 16
                        Rectangle {
                            color: "#555555"
                            radius: 1
                            anchors.margins: 4
                            border.color: "#333333"
                            smooth: true
                            anchors.fill: parent
                            visible: acceptTos.checked
                        }
                        border.color: acceptTos.checked ? "black" : "#000"
                        border.width: 1
                        smooth: true
                    }
                    anchors.leftMargin: 0
                }

                Text {
                    id: registerInfo
                    x: 8
                    y: 35
                    width: 259
                    height: 22
                    color: "#e3423e"
                    text: ""
                    font.pixelSize: 14
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            Timer {
                id: loginTimer1
                repeat: false
                interval: 1500
                running: false
            }

            Timer {
                id: gotoMain1
                repeat: false
                interval: 1250
                running: false
            }

            Timer {
                id: closeLogin1
                repeat: false
                interval: 500
                running: false
            }

            RevControls.RevButton {
                id: registerRegister
                x: 36
                y: 348
                width: 106
                height: 43
                buttonText: "Register"
                onClicked:{
                    //if()
                   // new Registration.Register(registerUser, registerPwd, registerEmail)
                    }

            }

            Rectangle {
                id: indicatorFrame1
                width: 340
                height: 398
                color: "#d9000000"
                radius: 4
                Popup {
                    id: loginIndicator1
                    width: 340
                    height: 310
                    focus: true
                    background: Rectangle {
                        color: "#00000000"
                    }
                    contentItem: BusyIndicator {
                        id: loginSpinner1
                        width: 340
                        height: 310
                        contentItem: Item {
                            id: loginSpinBounds1
                            width: 140
                            height: 140
                            Item {
                                id: spinner1
                                width: 140
                                height: 140
                                opacity: loginSpinner1.running ? 1 : 0
                                RotationAnimator {
                                    target: spinner1
                                    from: 0
                                    loops: Animation.Infinite
                                    to: 360
                                    duration: 1250
                                    running: loginSpinner1.visible && loginSpinner1.running
                                }

                                Repeater {
                                    id: repeater1
                                    Rectangle {
                                        x: spinner1.width / 2 - width / 2
                                        y: spinner1.height / 2 - height / 2
                                        color: "#ff8b11"
                                        radius: 5
                                        implicitHeight: 10
                                        implicitWidth: 10
                                        transform: [
                                            Translate {
                                                y: -Math.min(spinner1.width, spinner1.height) * 0.5 + 5
                                            },
                                            Rotation {
                                                origin.x: 5
                                                angle: index / repeater1.count * 360
                                                origin.y: 5
                                            }]
                                    }
                                    model: 7
                                }
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.verticalCenter: parent.verticalCenter
                                visible: true
                            }
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    exit: Transition {
                        NumberAnimation {
                            property: "opacity"
                            from: 1
                            to: 0
                        }
                    }
                    modal: true
                    enter: Transition {
                        NumberAnimation {
                            property: "opacity"
                            from: 0
                            to: 1
                        }
                    }
                    dim: false
                    closePolicy: "NoAutoClose"
                }
                visible: false
            }

            Text {
                id: welcomeText1
                y: 20
                width: 323
                height: 58
                color: "#ffffff"
                text: "Welcome back!\nTime Patroller,\n" + registerUser.text + "!"
                wrapMode: Text.WordWrap
                opacity: 0
                OpacityAnimator {
                    id: textAnimate1
                    target: welcomeText1
                    from: 0
                    to: 1
                    duration: 1500
                    running: false
                }
                font.bold: true
                style: Text.Outline
                font.capitalization: Font.MixedCase
                font.family: fontMuli.name
                fontSizeMode: Text.HorizontalFit
                font.pixelSize: 24
                anchors.verticalCenterOffset: 16
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenterOffset: 1
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }

            TextField {
                id: registerEmail
                x: 36
                y: 229
                width: 267
                height: 40
                color: "#ffffff"
                maximumLength: 17
                placeholderText: "Email"
                selectByMouse: true
                background: Rectangle {
                    id: pwdBorder3
                    color: registerEmail.focus ?  "#80000000" : "#59000000"
                    radius: 2
                    border.color: borderColored
                }
                font.pixelSize: 14
                Rectangle {
                    y: 39
                    width: 267
                    height: 1
                    color: underline
                }
                padding: 6
                font.family: fontMuli.name
                validator: RegExpValidator { regExp:/\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/ }
                onTextChanged: {
                    registerInfo.state ="hide";
                    registerInfo.text = "";
                }
            }

            RevControls.RevButton {
                id: registerBack
                x: 199
                y: 348
                width: 106
                height: 43
                buttonText: "Back"

                onClicked:
                {
                    registerBackAnimate()
                }
            }

            border.color: "#d9000000"
            border.width: 1
            smooth: true
        }
    } // rectLogin END --|| Used for rigging || --

    DropShadow {
        anchors.fill: rectLogin
        horizontalOffset: 1
        verticalOffset: 1
        radius: loginWinDrag.pressed ? 5 : 8
        samples: 10
        source: rectLogin
        color: "black"
        Behavior on radius { PropertyAnimation { duration: 100 } }

        Text {
            id: txtVersion
            x: 8
            y: 41
            width: 88
            height: 19
            color: "#ffffff"
            text: qsTr("Version: 1.1.0")
            font.pixelSize: 12
        }
    }


} // LOGIN WINDOW END
