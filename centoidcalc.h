#ifndef CENTOIDCALC_H
#define CENTOIDCALC_H
#include <QObject>
#include <QPolygonF>
#include <cmath>
#include <QVariant>
#include <QLineF>

class CentoidCalc : public QObject
{
    Q_OBJECT
public:
    explicit CentoidCalc(QObject *parent = nullptr);

    Q_INVOKABLE QPointF calculateCentroid(const QPolygonF &polygon);
    Q_INVOKABLE QPointF calculateInnerCentoid (const QPolygonF &polygon, int numIterations = 10000) ;
    Q_INVOKABLE QPointF calculateGeodesicCentroid (const QPolygonF &polygon);
    Q_INVOKABLE QPolygonF createPolygon(const QVariantList& points);
    Q_INVOKABLE QPointF calculateInteriorPoint(const QPolygonF &polygon);

signals:

};

#endif // CENTOIDCALC_H
