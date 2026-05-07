#ifndef NEURESET_H
#define NEURESET_H

#include <QObject>
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <iostream>
#include <vector>
#include "config.h"
#include "Sessions.h"
#include "resumabletimer.h"

using namespace std;

class Neureset : public QObject{
Q_OBJECT
public:
    Neureset();
    ~Neureset();

    // sensor contoll
    void connectSensor();
    void disconnectSensor();

    void setTimeAndDate(TimeAndDate time_and_date);
    vector<SessionLog> getLogHistory();
    void getComputerLog();  // prints computer format

    // session control
    void startSession();
    void newSession();
    void pauseSession();
    void resumeSession();
    void stopSession();

    // getter
    inline bool isPowerOn() const { return power_on; };
    inline float getTotalTime() { return session.getTotalTime(); };
    inline Sessions* getSession() { return &session; };
    inline float getBattery() { return battery; };
    inline float sessionHasStarted() const { return session_started; };

private:
    bool is_connected = false;
    bool session_created = false;
    bool session_started = false;
    bool power_on = true;
    TimeAndDate time_and_date;

    float battery = 100.0f;
    float depletion_rate = 0.025f;    // per second
    ResumableTimer battery_timer;

    // session handler
    Sessions session;

    vector<SessionLog> logs;

public slots:
    void getLog(SessionLog log);
    void sessionEnded();
    void chargeBattery();
    void togglePowerOn();

private slots:
    void batteryTimerTimeout();

signals:
    void sessionStartSignal();
    void sessionEndSignal();
    void connectSignal();
    void disconnectSignal();

    void powerOffSignal();
    void powerOnSignal();

    void updateBattery();
};

#endif
