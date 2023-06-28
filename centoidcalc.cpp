#include "centoidcalc.h"
#include "qdebug.h"
#include "qvariant.h"
//calculateCentroid - розраховує центроїд для полігону, використовуючи метод площ.
//calculateInnerCentoid - розраховує внутрішній центроїд полігону, використовуючи ітераційний метод.
//calculateGeodesicCentroid - розраховує геодезичний центроїд полігону.
//calculateInteriorPoint - вираховує точку всередині полігону.
//createPolygon - створює полігон зі списку точок.
//calculateCentroid2 - розраховує центроїд полігону, перетворюючи координати в сферичні.
//calculateCentroid3 - розраховує центроїд полігону, використовуючи просте середнє арифметичне координат точок
CentoidCalc::CentoidCalc(QObject *parent)
    : QObject{parent}
{

}

QPointF CentoidCalc::calculateCentroid(const QPolygonF &polygon) // Функція для пошуку центру мас
{

    // формулa центроїду полігона, яка базується на обчисленні площі та координат вершин полігона.
    int n = polygon.size();
    double area = 0.0;
    QPointF centroid(0.0, 0.0);

    for (int i = 0; i < n; i++) {
        int j = (i + 1) % n;
        double temp_area = polygon[i].x() * polygon[j].y() - polygon[j].x() * polygon[i].y();
        area += temp_area;
        centroid += (polygon[i] + polygon[j]) * temp_area;
    }

    area *= 0.5;
    centroid /= (6.0 * area);

    return centroid; // x - довгота, y - широта
}

QPointF CentoidCalc::calculateInnerCentoid(const QPolygonF &polygon, int numIterations)
{
//    Вона використовує метод випадкового пошуку, щоб знайти найкращу точку всередині полігона.
    if (polygon.isEmpty())
        return QPointF();

    QPointF initialCentroid = calculateCentroid(polygon);
    QPointF innerCentroid = initialCentroid;
    double minSumSquares = std::numeric_limits<double>::max();

    for (int i = 0; i < numIterations; i++) {
        QPointF randomPoint = QPointF(
            initialCentroid.x() + (qrand() % 100 - 50) * 0.01,
            initialCentroid.y() + (qrand() % 100 - 50) * 0.01
        );

        if (!polygon.containsPoint(randomPoint, Qt::OddEvenFill)) {
            continue;
        }

        double sumSquares = 0;
        for (const QPointF &point : polygon) {
            double dx = point.x() - randomPoint.x();
            double dy = point.y() - randomPoint.y();
            sumSquares += dx * dx + dy * dy;
        }

        if (sumSquares < minSumSquares) {
            minSumSquares = sumSquares;
            innerCentroid = randomPoint;
        }
    }

    return innerCentroid; // x - довгота, y - широта
}

QPointF CentoidCalc::calculateGeodesicCentroid(const QPolygonF  &polygon)
{
    if (polygon.isEmpty())
        return QPointF();

    int n = polygon.size();
    double totalArea = 0.0;
    double centroidLong = 0.0;
    double centroidLat = 0.0;

    for (int i = 0; i < n; i++) {
        int j = (i + 1) % n;
        double p1Long = polygon[i].x() * M_PI / 180.0;
        double p1Lat = polygon[i].y() * M_PI / 180.0;
        double p2Long = polygon[j].x() * M_PI / 180.0;
        double p2Lat = polygon[j].y() * M_PI / 180.0;

        double dLong = p2Long - p1Long;
        double area = p1Lat * sin(dLong) + p2Lat * sin(dLong);

        centroidLat += (p1Lat + p2Lat) * area;
        centroidLong += (p1Long + p2Long) * area;

        totalArea += area;
    }

    totalArea *= 0.5;
    centroidLat /= (3.0 * totalArea);
    centroidLong /= (3.0 * totalArea);

    centroidLat *= 180.0 / M_PI;
    centroidLong *= 180.0 / M_PI;

    return QPointF(centroidLong, centroidLat);
}

QPointF CentoidCalc::calculateInteriorPoint(const QPolygonF &polygon)
{
    if (polygon.size() < 4)
        return QPointF();

    int n = polygon.size();
    int i1 = qrand() % n;
    int i2 = (i1 + qrand() % (n-2) + 1) % n;
    int i3 = (i2 + qrand() % (n-2) + 1) % n;
    int i4 = (i3 + qrand() % (n-2) + 1) % n;

    QLineF diag1(polygon[i1], polygon[i3]);
    QLineF diag2(polygon[i2], polygon[i4]);

    QPointF interiorPoint;
    QLineF::IntersectType intersectType = diag1.intersect(diag2, &interiorPoint);

    if (intersectType == QLineF::BoundedIntersection) {
        return interiorPoint; // x - довгота, y - широта
    }

    return calculateInteriorPoint(polygon);
}

QPolygonF CentoidCalc::createPolygon(const QVariantList& points) {
    QPolygonF polygon;
    for (const QVariant& var : points) {
        if (var.type() == QVariant::Map) {
            QVariantMap map = var.toMap();
            qreal x = map.value("x").toDouble();
            qreal y = map.value("y").toDouble();
            qDebug () << "x = longitude createPolygon  " << x;
            qDebug() << "y = latitude createPolygon "<< y;
            polygon << QPointF(x, y);
        }
    }
    return polygon;
}

QPointF CentoidCalc::calculateCentroid2(const QPolygonF& polygon)
{
    if (polygon.isEmpty())
        return QPointF();

    double x = 0;
    double y = 0;
    double z = 0;

    for (const QPointF& point : polygon) {
        double longitude = point.x() * M_PI / 180; // x = longitude
        double latitude = point.y() * M_PI / 180; // y = latitude

        x += cos(latitude) * cos(longitude);
        y += cos(latitude) * sin(longitude);
        z += sin(latitude);
    }

    x /= polygon.size();
    y /= polygon.size();
    z /= polygon.size();

    double longitude = atan2(y, x);
    double hyp = sqrt(x * x + y * y);
    double latitude = atan2(z, hyp);

    return QPointF(longitude * 180 / M_PI, latitude * 180 / M_PI);
}

QPointF CentoidCalc::calculateCentroid3(const QPolygonF& polygon)
{
    if (polygon.isEmpty())
        return QPointF();

    qreal longSum = 0;
    qreal latSum = 0;

    for (const QPointF& point : polygon) {
        qDebug () << "x = longitude calculateCentroid3  " << point.x();
        qDebug() << "y = latitude calculateCentroid3 "<< point.y();
        longSum += point.x(); // x = longitude
        latSum += point.y(); // y = latitude
    }

    longSum /= polygon.size();
    latSum /= polygon.size();

    return QPointF(longSum, latSum);
}
