import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtLocation 5.15
import QtPositioning 5.15
import Qt.labs.qmlmodels 1.0
import Qt.labs.platform 1.0

Window {
    width: 800
    height: 480
    visible: true
    title: qsTr("Hello World")

    function pointInPolygon(point, polygon) {
        var crossings = 0
        var count = polygon.count
        for (var i = 0; i < count; i++) {
            var a = polygon.get(i)
            var j = i + 1
            if (j >= count) {
                j = 0
            }
            var b = polygon.get(j)
            if ((a.y > point.y) != (b.y > point.y)) {
                var atX = (b.x - a.x) * (point.y - a.y) / (b.y - a.y) + a.x
                if (point.x < atX) {
                    crossings++
                }
            }
        }
        return (crossings % 2) > 0
    }
//    function calculateCentroid(polygon) {
//        var area = 0;
//        var centroid = {x: 0, y: 0};

//        for (var i = 0; i < polygon.count; i++) {
//            var p1 = polygon.get(i);
//            var p2 = polygon.get((i + 1) % polygon.count);

//            var f = p1.latitude * p2.longitude - p2.latitude * p1.longitude;
//            centroid.x += (p1.latitude + p2.latitude) * f;
//            centroid.y += (p1.longitude + p2.longitude) * f;
//            area += f / 2;
//        }

//        centroid.x /= 6 * area;
//        centroid.y /= 6 * area;
//        return {latitude: centroid.x, longitude: centroid.y};
//    }

    function calculateCentroid(polygon) {
        var centroid = {x: 0, y: 0};
        var signedArea = 0;
        var x0 = 0;
        var y0 = 0;
        var x1 = 0;
        var y1 = 0;
        var a = 0.0;
        for (var i = 0; i < polygon.length - 1; ++i) {
            x0 = polygon[i].x;
            y0 = polygon[i].y;
            x1 = polygon[i+1].x;
            y1 = polygon[i+1].y;
            a = x0*y1 - x1*y0;
            signedArea += a;
            centroid.x += (x0 + x1)*a;
            centroid.y += (y0 + y1)*a;
        }
        x0 = polygon[i].x;
        y0 = polygon[i].y;
        x1 = polygon[0].x;
        y1 = polygon[0].y;
        a = x0*y1 - x1*y0;
        signedArea += a;
        centroid.x += (x0 + x1)*a;
        centroid.y += (y0 + y1)*a;

        signedArea *= 0.5;
        centroid.x /= (6.0*signedArea);
        centroid.y /= (6.0*signedArea);

        return centroid;
    }

    ListModel { id: lineModel }
    ListModel { id: centralPointModel }
    ListModel { id: cppCentralPointModel }
    ListModel { id: cppCentralInnerPointModel }
    ListModel { id: cppGeodesiccentroidModel }
    ListModel { id: cppInterioirModel }

    function appendToLineModel(lat, lon) {
        lineModel.append({"latitude": lat, "longitude": lon});
    }
    function appendToCentralPointModel(lat, lon) {
        centralPointModel.append({"latitude": lat, "longitude": lon});
    }
    function appendCppCentralPointModel(lat, lon) {
        cppCentralPointModel.append({"latitude": lat, "longitude": lon});
    }
    function appendCentralInnerPointModel(lat, lon) {
        cppCentralInnerPointModel.append({"latitude": lat, "longitude": lon});
    }
    function appendCentralGoedisidPointModel(lat, lon) {
        cppGeodesiccentroidModel.append({"latitude" : lat, "longitude" : lon})
    }

    Map {
        id: map
        anchors.fill: parent
        plugin: Plugin {name: "mapboxgl"}
        center: QtPositioning.coordinate(50.527887655789385, 30.614663315058465)
        zoomLevel: 14


        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onDoubleClicked: {
                var clickedCoordinate = map.toCoordinate(Qt.point(mouse.x, mouse.y))
                if (centralPointModel.count === 0) {
                    appendToCentralPointModel(clickedCoordinate.latitude, clickedCoordinate.longitude)
                } else {
                    appendToLineModel(clickedCoordinate.latitude, clickedCoordinate.longitude)
                }
            }
        }
        MapPolygon {
            id: polygon
            color: 'red' // Transparent orange
            border.width: 10
            border.color: 'orange'
            opacity: 0.2
            path: {
                var coordinates = [];
                for (var i = 0; i < lineModel.count; i++) {
                    var item = lineModel.get(i);
                    coordinates.push(QtPositioning.coordinate(item.latitude, item.longitude));
                }
                return coordinates;
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    var polygonPoints = [];
                     for (var i = 0; i < lineModel.count; i++) {
                         var item = lineModel.get(i);
                         polygonPoints.push({x: item.longitude, y: item.latitude});
                     }
                     if (centralPointModel.count > 0) {
                         var centroid = calculateCentroid(polygonPoints);
                         console.log("calculateCentroid: Latitude: " + centroid.y + ", Longitude: " + centroid.x);
                         centralPointModel.set(0, {"latitude": centroid.y, "longitude": centroid.x})


                         for (var k = 0; k < lineModel.count; k++) {
                             var item2 = lineModel.get(k);
                             polygonPoints.push(Qt.point(item2.longitude, item2.latitude));
                         }


//                         var qmlPolygon = centoidCalc.createPolygon(polygonPoints);
//                         var centroid2 = centoidCalc.calculateCentroid(qmlPolygon);

//                         console.log("Centroid2: Latitude: " + centroid2.y + ", Longitude: " + centroid2.x);
//                         centralPointModel.set(1, {"latitude": centroid2.y, "longitude": centroid2.x})

//                         var cenroid3 = centoidCalc.calculateInnerCentoid(qmlPolygon)
//                         centralPointModel.set(2, {"latitude": cenroid3.y, "longitude": cenroid3.x})

//                         var cenroid4 = centoidCalc.calculateGeodesicCentroid(qmlPolygon)
//                         console.log ("calculateGeodesicCentroid" +cenroid4.longitude )
//                         centralPointModel.set(3, {"latitude": cenroid4.y, "longitude": cenroid4.x})

//                         var cenroid5 = centoidCalc.calculateInteriorPoint(qmlPolygon)
//                         console.log ("calculateInteriorPoint" +cenroid5.x )
//                         centralPointModel.set(4, {"latitude": cenroid5.y, "longitude": cenroid5.x})

                     }
                }
            }
        }
        MapPolyline {
            id: polyline
            line.width: 3
            line.color: 'orange'
            path: {
                var coordinates = [];
                for (var i = 0; i < lineModel.count; i++) {
                    var item = lineModel.get(i);
                    coordinates.push(QtPositioning.coordinate(item.latitude, item.longitude));
                }
                if (coordinates.length > 0) {
                    coordinates.push(coordinates[0]); // Add first coordinate at the end to close the line
                }
                return coordinates;
            }
        }

        MapItemGroup {
            id: groupPoint
        }

        CentralPoint {
        }
        MapItemView {
            id: itemViewLine
            model: lineModel
            scale: 1

            property int modelIndexMarkerPoint: 0

            delegate: MapQuickItem {
                id: markerPoint
                property var modelData: model // create persistent modelData property
                property var itemIndex: index // New property

                coordinate: QtPositioning.coordinate(model.latitude, model.longitude)
                anchorPoint.x: rec.width / 2
                anchorPoint.y: rec.height / 2

                sourceItem: Rectangle {
                    id: rec
                    width: 28
                    height: 28
                    radius: 28
                    color: index === 0 ? "green" : (index === lineModel.count - 1 ? "orange" : "lightblue")

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
                                text: index
                                color: "black"
                                font.pixelSize: 11
                                anchors.centerIn: parent
                            }
                        }
                    }
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    drag.target: markerPoint
                    hoverEnabled: true
                    drag.axis: Drag.XAndYAxis

                    onClicked:  {
                        if (mouse.button == Qt.RightButton) {
                            markerMenu.target = markerPoint.modelData // use modelData instead of model
                            markerMenu.open()
                        }
                    }

                    onEntered: {
                        itemViewLine.modelIndexMarkerPoint = index
                    }

                    onReleased: {
                        var coorinate3 = parent.coordinate
                        lineModel.set(model.index, {"latitude": coorinate3.latitude, "longitude": coorinate3.longitude});
                    }

                    onPositionChanged: {
                        var coorinate3 = parent.coordinate
                        lineModel.set(model.index, {"latitude": coorinate3.latitude, "longitude": coorinate3.longitude});
                    }
                }


                Menu {
                    id: markerMenu
                    Timer { // Додав таймер для того щоб маркери видалялися перш ніж до нього можгна буде звернутися
                        id: timerDeleteMarker;
                        interval: 200;
                        onTriggered: {
                            for (var i = 0; i < lineModel.count; ++i) {
                                var item = lineModel.get(i);
                                if (item.latitude === markerMenu.target.latitude && item.longitude === markerMenu.target.longitude) {
                                    lineModel.remove(i);
                                    break;
                                }
                            }
                        }
                    }
                    property var target: null
                    MenuItem {
                        text: "Delete"
                        onTriggered: {
                            mouseArea.enabled = false
                            timerDeleteMarker.start()
                            menu.close();
                        }
                    }
                }
            }
        }
        PanelIntrument {
            id: panelIntrument
        }
    }
}
