import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtLocation 5.15
import QtPositioning 5.15
import Qt.labs.qmlmodels 1.0
import Qt.labs.platform 1.0

Rectangle{
    id: panelIntrument
    width: 700
    height: 50
    color: "#A6A1A1"
    radius: 10
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    anchors.topMargin: 10
    opacity: 0.9
    MouseArea {
    anchors.fill: parent
    }

    Row {
        anchors.fill: parent
        spacing: 5
        leftPadding: 2
        Rectangle {
            id: butSave
            width: parent.width / 6 - 5
            height: parent.height - 10
            anchors.verticalCenter: parent.verticalCenter
            color: parent.parent.color
            radius: 10
            border.width: 2
            border.color:  "white"

            Text {
                id: textbutSave
                text: qsTr("Зберегти")
                anchors.centerIn: parent
                color: "white"
                font.pixelSize: 15

            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                    butSave.border.color = "lightblue"
                }

                onExited: {
                    butSave.border.color = "white"
                }

                onPressed: {
                    butSave.scale = 0.9
                }

                onReleased: {
                    butSave.scale = 1
                }
            }
        }
        Rectangle {
            id: butClear
            width: parent.width / 6 - 5
            height: parent.height - 10
            anchors.verticalCenter: parent.verticalCenter
            color: parent.parent.color
            radius: 10
            border.width: 2
            border.color:  "white"

            Text {
                id: textbutClear
                text: qsTr("Очистити")
                anchors.centerIn: parent
                color: "white"
                font.pixelSize: 15

            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                    butClear.border.color = "lightblue"
                }

                onExited: {
                    butClear.border.color = "white"
                }

                onPressed: {
                    butClear.scale = 0.9
                }

                onReleased: {
                    butClear.scale = 1
                    lineModel.clear()
                    centralPointModel.clear()
                }
            }
        }
        Rectangle {
            id: butCenterPoligon
            width: parent.width / 6 - 5
            height: parent.height - 10
            anchors.verticalCenter: parent.verticalCenter
            color: parent.parent.color
            radius: 10
            border.width: 2
            border.color:  "white"

            Text {
                id: textbutCenterPoligon
                text: qsTr("Центр Пол.")
                anchors.centerIn: parent
                color: "white"
                font.pixelSize: 15
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                    butCenterPoligon.border.color = "lightblue"
                }

                onExited: {
                    butCenterPoligon.border.color = "white"
                }

                onPressed: {
                    butCenterPoligon.scale = 0.9
                }

                onReleased: {
                    butCenterPoligon.scale = 1
                }
            }
        }
        Rectangle {
            id: butCenterPoligonCpp
            width: parent.width / 6 - 5
            height: parent.height - 10
            anchors.verticalCenter: parent.verticalCenter
            color: parent.parent.color
            radius: 10
            border.width: 2
            border.color:  "white"

            Text {
                id: textbutCenterPoligonCpp
                text: qsTr("ПолCpp.")
                anchors.centerIn: parent
                color: "white"
                font.pixelSize: 15
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                    butCenterPoligonCpp.border.color = "lightblue"
                }

                onExited: {
                    butCenterPoligonCpp.border.color = "white"
                }

                onPressed: {
                    butCenterPoligonCpp.scale = 0.9
                }

                onReleased: {
                    butCenterPoligonCpp.scale = 1
                }
            }
        }
        Rectangle {
            id: butCenterPoligonCppInner
            width: parent.width / 6 - 5
            height: parent.height - 10
            anchors.verticalCenter: parent.verticalCenter
            color: parent.parent.color
            radius: 10
            border.width: 2
            border.color:  "white"

            Text {
                id: textbutCenterPoligonCppInner
                text: qsTr("ПолCppInner.")
                anchors.centerIn: parent
                color: "white"
                font.pixelSize: 15
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                    butCenterPoligonCppInner.border.color = "lightblue"
                }

                onExited: {
                    butCenterPoligonCppInner.border.color = "white"
                }

                onPressed: {
                    butCenterPoligonCppInner.scale = 0.9
                }

                onReleased: {
                    butCenterPoligonCppInner.scale = 1
                }
            }
        }
        Rectangle {
            id: butCenterPoligonCppGeodesic
            width: parent.width / 6 - 5
            height: parent.height - 10
            anchors.verticalCenter: parent.verticalCenter
            color: parent.parent.color
            radius: 10
            border.width: 2
            border.color:  "white"

            Text {
                id: textbutCenterPoligonCppGeodesic
                text: qsTr("ПолCppGeodesic.")
                anchors.centerIn: parent
                color: "white"
                font.pixelSize: 15
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                    butCenterPoligonCppGeodesic.border.color = "lightblue"
                }

                onExited: {
                    butCenterPoligonCppGeodesic.border.color = "white"
                }

                onPressed: {
                    butCenterPoligonCppGeodesic.scale = 0.9
                }

                onReleased: {
                    butCenterPoligonCppGeodesic.scale = 1
                }
            }
        }
    }
}
