#ifndef DEVICE_H
#define DEVICE_H

#include <QWidget>

#include <iostream>

#include "Neureset.h"
#include "resumabletimer.h"

// screens
#include "menuscreen.h"
#include "sessionscreen.h"
#include "timeinputscreen.h"
#include "logdisplayscreen.h"
#include "warningscreen.h"

using namespace std;

namespace Ui {
class device;
}

class device : public QWidget
{
    Q_OBJECT

public:
    explicit device(QWidget *parent = nullptr);
    ~device();

    // getters
    inline Neureset* getNeureset() { return &neureset; };

    void loadData(vector<SensorData> data);

private:
    Ui::device *ui;

    // screens
    MenuScreen* menu_screen;
    SessionScreen* session_screen;
    TimeInputScreen* time_input_screen;
    LogDisplayScreen* log_display_screen;
    WarningScreen* warning_screen;

    Neureset neureset;

    // flash light control
    bool disconnect_light_on = false;
    bool treatment_light_on = false;

    ResumableTimer disconnect_light_flash_timer;
    ResumableTimer treatment_light_flash_timer;

    void stopFlashDisconnectLight();
    void stopFlashTreatmentLight();

public slots:
    void connectSensor();
    void disconnectSensor();
    void pauseClick();
    void resumeClick();
    void stopClick();
    void upClick();
    void downClick();
    void selectClick();
    void menuClick();
    void powerClick();

    void sessionStarted();
    void sessionEnded();
    void sessionPaused();
    void sessionResumed();
    void newSessionState(SessionState state);

    void sensorConnected();
    void sensorDisconnected();

    void flashDisconnectLight();
    void flashTreatmentLight();

    void powerOff();
    void powerOn();

    void getTimeAndDate(TimeAndDate time_and_date);

    void updateSessionProgressBar();

    void updateBattery();

    void beep();
};

#endif // DEVICE_H
