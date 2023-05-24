#include "centoidcalc.h"
#include "qvariant.h"

CentoidCalc::CentoidCalc(QObject *parent)
    : QObject{parent}
{

}

QPointF CentoidCalc::calculateCentroid(const QPolygonF &polygon)
{
    int n = polygon.size();
    double area = 0.0;
    QPointF centroid(0.0, 0.0);

    // Вычисляем центроид методом площадей.
    // Для этого разбиваем полигон на треугольники и вычисляем их площади.
    // Затем находим сумму площадей всех треугольников и координаты их центров масс.
    for (int i = 0; i < n; i++) {
        int j = (i + 1) % n;
        double temp_area = polygon[i].x() * polygon[j].y() - polygon[j].x() * polygon[i].y();
        area += temp_area;
        centroid += (polygon[i] + polygon[j]) * temp_area;
    }

    area *= 0.5;
    centroid /= (6.0 * area);

    // Возвращаем координаты центроида.
    return centroid;
}

QPointF CentoidCalc::calculateInnerCentoid(const QPolygonF &polygon, int numIterations)
{
    // Вычисляем центроид исходного полигона
    QPointF initialCentroid = calculateCentroid(polygon);
    // Начальное значение центроида внутренней точки - центроид исходного полигона
    QPointF innerCentroid = initialCentroid;
    // Начальное значение для минимальной суммы квадратов расстояний до точек полигона - максимальное возможное число
    double minSumSquares = std::numeric_limits<double>::max();

    // Проводим заданное количество итераций для поиска внутренней точки
    for (int i = 0; i < numIterations; i++) {
        // Генерируем случайную точку вокруг центроида исходного полигона
        QPointF randomPoint = QPointF(
            initialCentroid.x() + (qrand() % 100 - 50) * 0.01,
            initialCentroid.y() + (qrand() % 100 - 50) * 0.01
        );

        // Если точка находится вне полигона, пропускаем итерацию
        if (!polygon.containsPoint(randomPoint, Qt::OddEvenFill)) {
            continue;
        }

        // Считаем сумму квадратов расстояний от случайной точки до всех вершин полигона
        double sumSquares = 0;
        for (const QPointF &point : polygon) {
            double dx = point.x() - randomPoint.x();
            double dy = point.y() - randomPoint.y();
            sumSquares += dx * dx + dy * dy;
        }

        // Если новая точка имеет меньшую сумму квадратов расстояний, заменяем внутренний центроид
        if (sumSquares < minSumSquares) {
            minSumSquares = sumSquares;
            innerCentroid = randomPoint;
        }
    }

    // Возвращаем найденный центроид внутренней точки
    return innerCentroid;
}

QPointF CentoidCalc::calculateGeodesicCentroid(const QPolygonF  &polygon)
{
    int n = polygon.size();
    double totalArea = 0.0;
    double centroidLat = 0.0;
    double centroidLong = 0.0;

    for (int i = 0; i < n; i++) {
        int j = (i + 1) % n;

        double p1Long = polygon[i].x() * M_PI / 180.0; // Convert to radians
        double p1Lat = polygon[i].y() * M_PI / 180.0; // Convert to radians
        double p2Long = polygon[j].x() * M_PI / 180.0; // Convert to radians
        double p2Lat = polygon[j].y() * M_PI / 180.0; // Convert to radians

        double dLong = p2Long - p1Long;
        double area = p1Lat * sin(dLong) + p2Lat * sin(dLong);

        centroidLat += (p1Lat + p2Lat) * area;
        centroidLong += (p1Long + p2Long) * area;

        totalArea += area;
    }

    totalArea *= 0.5;
    centroidLat /= (3.0 * totalArea);
    centroidLong /= (3.0 * totalArea);

    // Convert back to degrees
    centroidLat *= 180.0 / M_PI;
    centroidLong *= 180.0 / M_PI;

    return QPointF(centroidLat,centroidLong);
}
QPointF CentoidCalc::calculateInteriorPoint(const QPolygonF &polygon)
{
    // Рандомно обираємо чотирикутник всередині полігона
    int n = polygon.size();
    int i1 = qrand() % n;
    int i2 = (i1 + qrand() % (n-2) + 1) % n;
    int i3 = (i2 + qrand() % (n-2) + 1) % n;
    int i4 = (i3 + qrand() % (n-2) + 1) % n;

    // Знаходимо дві діагоналі чотирикутника
    QLineF diag1(polygon[i1], polygon[i3]);
    QLineF diag2(polygon[i2], polygon[i4]);

    // Знаходимо точку перетину діагоналей
    QPointF interiorPoint;
    QLineF::IntersectType intersectType = diag1.intersect(diag2, &interiorPoint);

    // Якщо точка перетину визначена, повертаємо її
    if (intersectType == QLineF::BoundedIntersection) {
        return interiorPoint;
    }

    // Якщо точка перетину не визначена, повторюємо спробу
    return calculateInteriorPoint(polygon);
}
QPolygonF CentoidCalc::createPolygon(const QVariantList& points) {
    QPolygonF polygon;
    for (const QVariant& var : points) {
        QPointF pt = var.toPointF(); // Convert QVariant to QPointF
        polygon << pt;
    }
    return polygon;
}
