#ifndef SESSIONS_H
#define SESSIONS_H

#include <QObject>
#include <QTimer>
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <iostream>

#include "config.h"

#include "EEGSensor.h"
#include "TimeAndDate.h"
#include "resumabletimer.h"

using namespace std;

class Sessions : public QObject{
    Q_OBJECT
public:

    //constructor/destructor
    Sessions();
    ~Sessions();

    // session control
    void startSession(TimeAndDate time_and_date);
    void pauseSession();
    void resumeSession();
    void stopSession();

    // session handler
    void sessionHandle();

    // getters
    inline SessionState getState() const { return state; };
    inline float getElaspedTime() { return session_timer.getElapsedTime(); };
    inline float getCurrentStateTotalTime() { return session_timer.getTotalTime(); };
    // gets total estimated time of the session
    float getTotalTime();
    inline int getTotalSiteNumber() { return (sizeof(sites) / sizeof(EEGSensor*)); };
    inline int getCurrentSiteNumber() { return current_site + 1; };     // site ids in arrays starts at 0

    void loadData(vector<SensorData> data);

private:

    EEGSensor* sites[21];
    TimeAndDate time_and_date;
    SessionLog log;

    bool session_started = false;

    float pre_baseline;
    float post_baseline;

    SessionState state = SessionState::idle;     // current state
    SessionState last_state = SessionState::idle;    // state before pause

    ResumableTimer pause_timer;
    ResumableTimer session_timer;

    // Helper
    bool everySiteVisited();
    void resetSites();  // set every site no unvisited

    // counters
    int current_site;   // for treatment loop
    float current_site_baseline;

    // properties
    float baseline_time = 60;
    float treatment_time = 1;
    float pause_timeout_time = 5 * 60;

public slots:

private slots:
    void pauseTimerTimeout();
    void sessionTimerTimeout();

signals:
    void setEEGSiteNum(int value);
    void updateProgress(int value);
    void writeLog(SessionLog log);
    void sessionStarted();
    void sessionPaused();
    void sessionResumed();
    void sessionEnded();
    void newState(SessionState state);
    void powerOff();
};

#endif
