#include "Neureset.h"

//constructor / destructor
Neureset::Neureset(){
    battery_timer.start(1);
    // connect
    connect(&session, SIGNAL(writeLog(SessionLog)), this, SLOT(getLog(SessionLog)));
    connect(&session, SIGNAL(sessionEnded()), this, SLOT(sessionEnded()));
    connect(&battery_timer, SIGNAL(timeout()), this, SLOT(batteryTimerTimeout()));
    connect(&session, SIGNAL(powerOff()), this, SLOT(togglePowerOn()));
}
Neureset::~Neureset() {}

// sensor control
void Neureset::connectSensor(){
    if (!is_connected){
        is_connected = true;
        if (session_started){
            emit(connectSignal());
            // resumes session
            resumeSession();
        } else if (session_created){
            emit(connectSignal());
            // starts session
            startSession();
        }
    }
}

void Neureset::disconnectSensor(){
    if (is_connected){
        if (session_started || session_created){
            emit(disconnectSignal());
        }
        is_connected = false;
        pauseSession();
    }
}

// sets the time and date
void Neureset::setTimeAndDate(TimeAndDate time_and_date) {
    this->time_and_date = time_and_date;
}

// retrieves log history - the int n indicates which UI the log history is for - 1 means for headset(times) , 2 means for computer UI(baselines + times)
vector<SessionLog> Neureset::getLogHistory() {
    return logs;
}

// retreives computer format log history
void Neureset::getComputerLog(){
    cout<<"logs"<<endl;
    for (auto log : logs){
        cout<<log<<endl;
    }
}

// session control

void Neureset::startSession(){
    session_started = true;
    session.startSession(time_and_date);
    emit (sessionStartSignal());
}

void Neureset::newSession() {
    if (!session_created){
        // session not already created
        session_created = true;
        if (is_connected){
            emit(connectSignal());
            // starts session
            startSession();
        } else {
            emit(disconnectSignal());
        }
    }
}

void Neureset::pauseSession(){
    session.pauseSession();
}

void Neureset::resumeSession(){
    if (is_connected){
        session.resumeSession();
    }
}

void Neureset::stopSession(){
    session.stopSession();
}

// slots

void Neureset::getLog(SessionLog log){
    logs.push_back(log);
}

void Neureset::sessionEnded(){
    session_created = false;
    session_started = false;
    time_and_date = TimeAndDate();
    emit (sessionEndSignal());
}

void Neureset::chargeBattery(){
    battery = 100.0f;
}

void Neureset::togglePowerOn(){
    if (power_on){
        // is on
        stopSession();
        disconnectSensor();
        battery_timer.pause();
        emit(powerOffSignal());
        power_on = false;
    } else {
        // is off
        if (battery > 0){
            battery_timer.resume();
            emit(powerOnSignal());
            power_on = true;
        }
    }
}

void Neureset::batteryTimerTimeout(){
    if (power_on){
        battery -= depletion_rate;
        battery_timer.start(1);
        if (battery <= 0){
            togglePowerOn();
            battery_timer.pause();
        }
    } else {
        battery_timer.start(1);
        battery_timer.pause();
    }
    emit(updateBattery());
}
