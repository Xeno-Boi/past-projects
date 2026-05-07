#include "resumabletimer.h"

ResumableTimer::ResumableTimer()
{
    connect(&timer, SIGNAL(timeout()), this, SLOT(timerTimeout()));
}

void ResumableTimer::start(float time){
    timer.setInterval(time * 1000);
    timer.start();
    elapsed_timer.start();
    total_time = time * 1000;
    elapsed_time = 0.0f;
}

void ResumableTimer::resume(){
    if (!timer.isActive()){
        timer.setInterval((total_time - elapsed_time));
        timer.start();
        elapsed_timer.start();
    }
}

void ResumableTimer::pause(){
    if (timer.isActive()){
        timer.stop();
        elapsed_time += elapsed_timer.elapsed();
        if (elapsed_time > total_time){
            elapsed_time = total_time;
        }
    }
}

void ResumableTimer::stop(){
    timer.stop();
    elapsed_time = total_time;
}

float ResumableTimer::getElapsedTime(){
    if (timer.isActive()){
        pause();
        resume();
    }
    return elapsed_time / 1000;
}

bool ResumableTimer::isActive(){
    return timer.isActive();
}

// Slots

void ResumableTimer::timerTimeout(){
    elapsed_time = total_time;
    timer.stop();
    emit(timeout());
}


