#include "Sessions.h"
#include <iostream>

//constructor / destructors

Sessions::Sessions(){
    for (int i = 0; i < getTotalSiteNumber(); ++i) {
        sites[i] = new EEGSensor();
    }

    // connect
    connect(&session_timer, SIGNAL(timeout()), this, SLOT(sessionTimerTimeout()));
    connect(&pause_timer, SIGNAL(timeout()), this, SLOT(pauseTimerTimeout()));
}

Sessions::~Sessions() {
    for (auto* i : sites){
        delete i;
    }
}

// session control

// initialize session environment
void Sessions::startSession(TimeAndDate time_and_date) {
    pre_baseline = 0;
    post_baseline = 0;
    state = SessionState::takingPreBaseline;
    last_state = state;
    this->time_and_date = time_and_date;
    session_started = true;
    resetSites();
    current_site = 0;
    current_site_baseline = 0;
    log = SessionLog();

    emit(sessionStarted());

    // starts handling session
    sessionHandle();
}

// user pauses session
void Sessions::pauseSession() {
    if (state != SessionState::idle && state != SessionState::paused){
        // session is running and not already paused
        state = SessionState::paused;
        session_timer.pause();
        pause_timer.start(pause_timeout_time);

        if (last_state == SessionState::treatingSite){
            // pause current site's treatment
            if (current_site < getTotalSiteNumber()){
                sites[current_site]->pauseTreatment();
            }
        }
        emit(sessionPaused());
    }
}

// resumes the session from either connection lost or pause
void Sessions::resumeSession() {
    if (state == SessionState::paused){
        // session is paused
        state = last_state;
        session_timer.resume();
        pause_timer.stop();

        if (last_state == SessionState::treatingSite){
            // resume current site's treatment
            if (current_site < getTotalSiteNumber()){
                sites[current_site]->resumeTreatment();
            }
        }
        emit(sessionResumed());
    }
}

// stops session
void Sessions::stopSession(){
    state = SessionState::idle;
    last_state = state;
    session_started = false;
    pause_timer.stop();
    session_timer.stop();
    resetSites();
    emit(sessionEnded());
}

// session handler

// baseline values are returned in slots, called when a site finishes taking baseline
void Sessions::sessionHandle(){
    if (session_started){
        switch(state){
        case SessionState::takingPreBaseline:
            session_timer.start(baseline_time);
            break;

        case SessionState::takingSiteBaseline:
            if (current_site < getTotalSiteNumber()){
                // not all sites visited
                session_timer.start(baseline_time);
            } else {
                // all sites visited
                sessionTimerTimeout();
            }
            break;

        case SessionState::treatingSite:
            if (current_site < getTotalSiteNumber()){
                // not all sites visited
                session_timer.start(treatment_time);
                sites[current_site]->startTreatment(current_site_baseline);
            } else {
                sessionTimerTimeout();
            }
            break;

        case SessionState::takingPostBaseline:
            session_timer.start(baseline_time);
            break;

        case SessionState::logging:
            // log the data
            log = SessionLog(time_and_date, pre_baseline, post_baseline);
            emit(writeLog(log));
            // stop session
            stopSession();
            break;

        case SessionState::idle:
            break;
        case SessionState::paused:
            break;
        }
    }
}

// getters
float Sessions::getTotalTime(){
    return (baseline_time * 2 + (baseline_time + treatment_time) * getTotalSiteNumber());
}

// data loader
void Sessions::loadData(vector<SensorData> data){
    for (int i = 0; i < 21; i++){
        sites[i]->loadData(data[i]);
    }
}

// Helper
bool Sessions::everySiteVisited(){
    for (auto* i : sites){
        if (!i->isVisited()){
            // unvisited site found
            return false;
        }
    }
    // every site visited
    return true;
}

void Sessions::resetSites(){
    for (auto* i : sites){
        i->reset();
    }
}

// slots

void Sessions::pauseTimerTimeout(){
    if (session_started){
        stopSession();
        emit(powerOff());
    }
}

void Sessions::sessionTimerTimeout(){
    if (session_started){
        switch(state){
        case SessionState::takingPreBaseline:
            // get total baseline of all sites
            for (auto* i : sites){
                pre_baseline += i->takeBaseline();
            }
            // find average
            pre_baseline /= getTotalSiteNumber();


            // moves to next state
            resetSites();
            state = SessionState::takingSiteBaseline;
            last_state = state;
            break;

        case SessionState::takingSiteBaseline:
            if (current_site < getTotalSiteNumber()){
                // not all sites visited
                current_site_baseline = sites[current_site]->takeBaseline();
            }

            // moves to next state
            state = SessionState::treatingSite;
            last_state = state;
            break;

        case SessionState::treatingSite:
            if (current_site < getTotalSiteNumber()){
                // not all sites visited
                sites[current_site]->stopTreatment();
                // moves to next site
                current_site++;
                // moves to next state
                state = SessionState::takingSiteBaseline;
                last_state = state;
            } else {
                // all sites visited
                // moves to next state
                state = SessionState::takingPostBaseline;
                last_state = state;
            }
            break;

        case SessionState::takingPostBaseline:
            // get total baseline of all sites
            for (auto* i : sites){
                post_baseline += i->takeBaseline();
            }
            // find average
            post_baseline /= getTotalSiteNumber();

            // moves to next state
            resetSites();
            state = SessionState::logging;
            last_state = state;
            break;

        case SessionState::logging:
            break;
        case SessionState::idle:
            break;
        case SessionState::paused:
            break;
        }

        emit(newState(state));

        // handles session
        sessionHandle();
    }
}
