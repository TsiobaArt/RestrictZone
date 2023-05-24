import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtLocation 5.15
import QtPositioning 5.15
import Qt.labs.qmlmodels 1.0
import Qt.labs.platform 1.0

MapItemView {
    model: centralPointModel
    delegate: MapQuickItem {
        id: centralPoint
        coordinate: QtPositioning.coordinate(model.latitude, model.longitude)
        anchorPoint.x: circle.width / 2
        anchorPoint.y: circle.height / 2
        sourceItem: Rectangle {
            id: circle
            width: 28
            height: 28
            color: 'purple'
            radius: width / 2
            Rectangle {
                width: 22
                height: 22
                radius: 22
                anchors.centerIn: parent
                color: "black"

                Rectangle {
                    width: 16
                    height: 16
                    radius: 16
                    anchors.centerIn: parent
                    color: "white"
                    Text {
                        text: index == 0 ? "C" : (index == centralPointModel.count - 1 ? "I" : "cpp")
                        color: "black"
                        font.pixelSize: 10
                        anchors.centerIn: parent
                    }
                }
            }
            MouseArea {
                id: centralPointMouseArea
                anchors.fill: parent
                drag.target: centralPoint
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                drag.axis: Drag.XAndYAxis
                onClicked:  {
                    if (mouse.button == Qt.RightButton) {
                        markerMenuCentalPoint.target = centralPoint.modelData // use modelData instead of model
                        markerMenuCentalPoint.open()
                    }
                }
                onReleased: {
                    if (mouse.button == Qt.LeftButton) {
                    var movedCoordinate = centralPoint.coordinate;
                    centralPointModel.set(model.index, {"latitude": movedCoordinate.latitude, "longitude": movedCoordinate.longitude});
                    }
                }
                onPositionChanged: {
                    var movedCoordinate = centralPoint.coordinate;
                    centralPointModel.set(model.index, {"latitude": centralPoint.latitude, "longitude": centralPoint.longitude});
                }
            }
            Menu {
                id: markerMenuCentalPoint
                Timer { // Додав таймер для того щоб маркери видалялися перш ніж до нього можгна буде звернутися
                    id: timerDeleteMarker1;
                    interval: 200;
                    onTriggered: {
                        centralPointModel.clear()
                    }
                }
                property var target: null
                MenuItem {
                    text: "Delete"
                    onTriggered: {
                        centralPointMouseArea.enabled = false
                        timerDeleteMarker1.start()
                        menu.close();
                    }
                }
            }
        }

    }
}
