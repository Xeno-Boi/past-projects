#include "device.h"
#include "ui_device.h"

#include "menuscreen.h"

using namespace std;

device::device(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::device)
{
    ui->setupUi(this);

    // connect screens to stackedScreens
    menu_screen = new MenuScreen();
    ui->stacked_screens->addWidget(menu_screen);

    session_screen = new SessionScreen();
    ui->stacked_screens->addWidget(session_screen);

    time_input_screen = new TimeInputScreen();
    ui->stacked_screens->addWidget(time_input_screen);

    log_display_screen = new LogDisplayScreen();
    ui->stacked_screens->addWidget(log_display_screen);

    warning_screen = new WarningScreen();
    ui->stacked_screens->addWidget(warning_screen);

    // default screen
    ui->stacked_screens->setCurrentWidget(menu_screen);

    // connect

    // buttons
    connect(ui->pause_button, SIGNAL(clicked()), this, SLOT(pauseClick()));
    connect(ui->resume_button, SIGNAL(clicked()), this, SLOT(resumeClick()));
    connect(ui->stop_button, SIGNAL(clicked()), this, SLOT(stopClick()));
    connect(ui->up_button, SIGNAL(clicked()), this, SLOT(upClick()));
    connect(ui->down_button, SIGNAL(clicked()), this, SLOT(downClick()));
    connect(ui->select_button, SIGNAL(clicked()), this, SLOT(selectClick()));
    connect(ui->menu_button, SIGNAL(clicked()), this, SLOT(menuClick()));
    connect(ui->power_button, SIGNAL(clicked()), this, SLOT(powerClick()));

    // session state
    connect(&neureset, SIGNAL(sessionStartSignal()), this, SLOT(sessionStarted()));
    connect(&neureset, SIGNAL(sessionEndSignal()), this, SLOT(sessionEnded()));
    connect(neureset.getSession(), SIGNAL(sessionPaused()), this, SLOT(sessionPaused()));
    connect(neureset.getSession(), SIGNAL(sessionResumed()), this, SLOT(sessionResumed()));
    connect(neureset.getSession(), SIGNAL(newState(SessionState)), this, SLOT(newSessionState(SessionState)));

    // sensor connection
    connect(&neureset, SIGNAL(connectSignal()), this, SLOT(sensorConnected()));
    connect(&neureset, SIGNAL(disconnectSignal()), this, SLOT(sensorDisconnected()));

    // flash light control
    connect(&disconnect_light_flash_timer, SIGNAL(timeout()), this, SLOT(flashDisconnectLight()));
    connect(&treatment_light_flash_timer, SIGNAL(timeout()), this, SLOT(flashTreatmentLight()));

    // power on / off
    connect(&neureset, SIGNAL(powerOffSignal()), this, SLOT(powerOff()));
    connect(&neureset, SIGNAL(powerOnSignal()), this, SLOT(powerOn()));

    // time and date input
    connect(time_input_screen, SIGNAL(sendTimeAndDate(TimeAndDate)), this, SLOT(getTimeAndDate(TimeAndDate)));

    // session screen
    connect(session_screen, SIGNAL(updateProgressBar()), this, SLOT(updateSessionProgressBar()));

    // battery display
    connect(&neureset, SIGNAL(updateBattery()), this, SLOT(updateBattery()));
}

device::~device()
{
    delete ui;
    delete menu_screen;
    delete session_screen;
    delete time_input_screen;
    delete log_display_screen;
    delete warning_screen;
}

void device::loadData(vector<SensorData> data){
    neureset.getSession()->loadData(data);
}

// flash light control
void device::stopFlashDisconnectLight(){
    disconnect_light_flash_timer.stop();
    ui->disconnect_light->setStyleSheet("background-color: white");
    disconnect_light_on = false;
}

void device::stopFlashTreatmentLight(){
    treatment_light_flash_timer.stop();
    ui->treatment_light->setStyleSheet("background-color: white");
    treatment_light_on = false;
}


// slots

void device::connectSensor(){
    if (neureset.isPowerOn()){
        neureset.connectSensor();
    }
}

void device::disconnectSensor(){
    if (neureset.isPowerOn()){
        neureset.disconnectSensor();
    }
}

void device::pauseClick(){
    if (neureset.isPowerOn()){
        neureset.pauseSession();
    }
}

void device::resumeClick(){
    if (neureset.isPowerOn()){
        neureset.resumeSession();
    }
}

void device::stopClick(){
    if (neureset.isPowerOn()){
        neureset.stopSession();
    }
}

void device::upClick(){
    if (neureset.isPowerOn()){
        QWidget* current_widget = ui->stacked_screens->currentWidget();
        if (current_widget == menu_screen){
            // menu screen functions
            int index = menu_screen->getCurrentItem() - 1;
            if (index < 0){
                index = menu_screen->getItemCount() - 1;
            }
            menu_screen->setHighlightItem(index);
        } else if (current_widget == session_screen){
            // session screen functions
        } else if (current_widget == time_input_screen){
            // time input screen functions
            time_input_screen->up();
        } else if (current_widget == log_display_screen){
            // log display screen functions
            int index = log_display_screen->getCurrentItem() - 1;
            if (index < 0){
                index = 0;
            }
            log_display_screen->setHighlightItem(index);
        }
    }
}

void device::downClick(){
    if (neureset.isPowerOn()){
        QWidget* current_widget = ui->stacked_screens->currentWidget();
        if (current_widget == menu_screen){
            // menu screen functions
            int index = menu_screen->getCurrentItem() + 1;
            if (index > (menu_screen->getItemCount() - 1)){
                index = 0;
            }
            menu_screen->setHighlightItem(index);
        } else if (current_widget == session_screen){
            // session screen functions
        } else if (current_widget == time_input_screen){
            // time input screen functions
            time_input_screen->down();
        } else if (current_widget == log_display_screen){
            // log display screen functions
            int index = log_display_screen->getCurrentItem() + 1;
            if (index > (log_display_screen->getItemCount() - 1)){
                index = log_display_screen->getItemCount() - 1;
            }
            log_display_screen->setHighlightItem(index);
        }
    }
}

void device::selectClick(){
    if (neureset.isPowerOn()){
        QWidget* current_widget = ui->stacked_screens->currentWidget();
        if (current_widget == menu_screen){
            // menu screen functions
            switch(menu_screen->getCurrentItem()){
            case MENU_NEW_SESSION:
                neureset.newSession();
                break;
            case MENU_SESSION_LOG:
                log_display_screen->updateLogs(neureset.getLogHistory());
                ui->stacked_screens->setCurrentWidget(log_display_screen);
                break;
            case MENU_TIME_AND_DATE:
                time_input_screen->start_input();
                ui->stacked_screens->setCurrentWidget(time_input_screen);
                break;
            }
        } else if (current_widget == session_screen){
            // session screen functions
        } else if (current_widget == time_input_screen){
            // time input screen functions
            time_input_screen->select();
        } else if (current_widget == log_display_screen){
            // log display screen functions
        }
    }
}

void device::menuClick(){
    if (neureset.isPowerOn()){
        if (ui->stacked_screens->currentWidget() != session_screen && ui->stacked_screens->currentWidget() != menu_screen){
            // device is not in a session or already at menu screen
            ui->stacked_screens->setCurrentWidget(menu_screen);
            menu_screen->setHighlightItem(0);
        }
    }
}

void device::powerClick(){
    neureset.togglePowerOn();
}

void device::sessionStarted(){
    if (neureset.isPowerOn()){
        session_screen->startSession(neureset.getTotalTime());
        ui->stacked_screens->setCurrentWidget(session_screen);
    }
}

void device::sessionEnded(){
    if (neureset.isPowerOn()){
        session_screen->stopSession();
        ui->stacked_screens->setCurrentWidget(menu_screen);
    }
    ui->connect_light->setStyleSheet("background-color: white");
    stopFlashDisconnectLight();
    stopFlashTreatmentLight();
}

void device::sessionPaused(){
    session_screen->pauseSession();
    stopFlashTreatmentLight();
}

void device::sessionResumed(){
    session_screen->resumeSession();
    if (neureset.getSession()->getState() == SessionState::treatingSite){
        flashTreatmentLight();
    }
}

void device::newSessionState(SessionState state){
    if (state == SessionState::treatingSite){
        flashTreatmentLight();
    } else {
        stopFlashTreatmentLight();
    }
    if (state == SessionState::takingSiteBaseline){
        session_screen->setCurrentSite(neureset.getSession()->getCurrentSiteNumber());
    }
    session_screen->updateState(state);
}

void device::sensorConnected(){
    ui->connect_light->setStyleSheet("background-color: cyan");
    stopFlashDisconnectLight();
    ui->stacked_screens->setCurrentWidget(session_screen);
}

void device::sensorDisconnected(){
    ui->connect_light->setStyleSheet("background-color: white");
    flashDisconnectLight();
    ui->stacked_screens->setCurrentWidget(warning_screen);
}

void device::flashDisconnectLight(){
    if (disconnect_light_on){
        ui->disconnect_light->setStyleSheet("background-color: white");
    } else {
        ui->disconnect_light->setStyleSheet("background-color: red");
    }
    disconnect_light_on = !disconnect_light_on;
    disconnect_light_flash_timer.start(0.5);
    if (neureset.sessionHasStarted()){
        beep();
    }
}

void device::flashTreatmentLight(){
    if (treatment_light_on){
        ui->treatment_light->setStyleSheet("background-color: white");
    } else {
        ui->treatment_light->setStyleSheet("background-color: lime");
    }
    treatment_light_on = !treatment_light_on;
    treatment_light_flash_timer.start(0.1);
}

void device::powerOff(){
    ui->stacked_screens->hide();
    ui->screen_frame->setStyleSheet("background-color: black");
    ui->battery_light->setStyleSheet("background-color: black");
}

void device::powerOn(){
    ui->stacked_screens->show();
    ui->screen_frame->setStyleSheet("background-color: white");
    updateBattery();
}

void device::getTimeAndDate(TimeAndDate time_and_date){
    neureset.setTimeAndDate(time_and_date);
    ui->stacked_screens->setCurrentWidget(menu_screen);
}

void device::updateSessionProgressBar(){
    float new_range = neureset.getSession()->getCurrentStateTotalTime();
    session_screen->setProgressBarRange(new_range);
    float new_value = neureset.getSession()->getElaspedTime();
    session_screen->setProgressBarValue(new_value);
}

void device::updateBattery(){
    float battery = neureset.getBattery();
    if (neureset.isPowerOn()){
        if (battery > 75){
            ui->battery_light->setStyleSheet("background-color: green");
        } else if (battery > 50){
            ui->battery_light->setStyleSheet("background-color: yellow");
        } else if (battery > 25){
            ui->battery_light->setStyleSheet("background-color: orange");
        } else {
            ui->battery_light->setStyleSheet("background-color: red");
        }
    }
}

void device::beep(){
    cout<<"beep"<<endl;
}
