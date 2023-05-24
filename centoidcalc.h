#ifndef CENTOIDCALC_H
#define CENTOIDCALC_H
#include <QObject>
#include <QPolygonF>

class CentoidCalc : public QObject
{
    Q_OBJECT
public:
    explicit CentoidCalc(QObject *parent = nullptr);


    Q_INVOKABLE QPointF calculateCentroid(const QPolygonF &polygon);
    Q_INVOKABLE QPointF calculateInnerCentoid (const QPolygonF &polygon, int numIterations = 1000) ;

signals:

};

#endif // CENTOIDCALC_H
