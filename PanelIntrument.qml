import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtLocation 5.15
import QtPositioning 5.15
import Qt.labs.qmlmodels 1.0
import Qt.labs.platform 1.0

Rectangle{
    id: panelIntrument
    width: 300
    height: 50
    color: "#A6A1A1"
    radius: 10
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    anchors.topMargin: 10
    opacity: 0.8

    Row {
        anchors.fill: parent
        spacing: 5
        anchors.leftMargin: 10
        Rectangle {
            id: butSave
            width: parent.width / 3 - 5
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
                }

                onExited: {
                }

                onPressed: {

                }

                onReleased: {

                }
            }
        }
        Rectangle {
            id: butClear
            width: parent.width / 3 - 5
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
                }

                onExited: {
                }

                onPressed: {

                }

                onReleased: {

                }
            }
        }
        Rectangle {
            id: butCenterPoligon
            width: parent.width / 3 - 5
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
                }

                onExited: {
                }

                onPressed: {

                }

                onReleased: {

                }
            }
        }
    }
}
