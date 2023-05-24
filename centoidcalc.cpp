#include "centoidcalc.h"

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
