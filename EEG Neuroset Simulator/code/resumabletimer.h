#ifndef RESUMABLETIMER_H
#define RESUMABLETIMER_H

#include <QObject>
#include <QTimer>
#include <QElapsedTimer>

#include <iostream>

using namespace std;

class ResumableTimer : public QObject
{
    Q_OBJECT
public:
    ResumableTimer();

    // time in seconds
    void start(float time);
    void resume();
    void pause();
    void stop();

    // getters
    float getElapsedTime();
    inline float getTotalTime() const { return total_time / 1000; };
    bool isActive();

private:
    QTimer timer;
    QElapsedTimer elapsed_timer;

    float total_time;
    float elapsed_time;

private slots:
    void timerTimeout();

signals:
    void timeout();
};

#endif // RESUMABLETIMER_H
