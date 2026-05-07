#ifndef EEGSENSOR_H
#define EEGSENSOR_H

#include <QObject>
#include "config.h"
#include "resumabletimer.h"

using namespace std;

class EEGSensor : public QObject{
Q_OBJECT
public:
    EEGSensor();
    ~EEGSensor();

    float takeBaseline();
    void startTreatment(float baseline);
    void pauseTreatment();
    void resumeTreatment();
    void stopTreatment();

    void loadData(SensorData data);

    inline bool isVisited() const { return siteVisited; };
    inline void visit() { siteVisited = true; };
    void reset();

private:
    float amplitude_1 = 0;
    float amplitude_2 = 0;
    float amplitude_3 = 0;

    float frequency_1 = 0;
    float frequency_2 = 0;
    float frequency_3 = 0;

    bool siteVisited = false;

    bool treating = false;

    float treatment_baseline = 0;     // baseline used for treating, get from session

    ResumableTimer treatment_timer;

    // properties
    float treatment_time = 1.0f / 16.0f;

    void applyTreatment();

private slots:
    void treatmentTimerTimeout();
};
#endif
