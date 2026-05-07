#ifndef SESSIONSCREEN_H
#define SESSIONSCREEN_H

#include <sstream>
#include <QWidget>
#include "resumabletimer.h"
#include "config.h"

namespace Ui {
class SessionScreen;
}

class SessionScreen : public QWidget
{
    Q_OBJECT

public:
    explicit SessionScreen(QWidget *parent = nullptr);
    ~SessionScreen();

    // session control
    void startSession(int total_time);
    void pauseSession();
    void resumeSession();
    void stopSession();

    void updateState(SessionState state);

    // setters
    inline void setCurrentSite(int site) { current_site = site; };

    // progress bar
    void setProgressBarRange(float range);
    void setProgressBarValue(float value);

private:
    Ui::SessionScreen *ui;

    ResumableTimer timer;
    ResumableTimer progress_timer;

    int current_site;

private slots:
    void timerTimeout();
    void progressTimerTimeout();

signals:
    void updateProgressBar();
};

#endif // SESSIONSCREEN_H
