#include "sessionscreen.h"
#include "ui_sessionscreen.h"

SessionScreen::SessionScreen(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::SessionScreen)
{
    ui->setupUi(this);

    // connect
    connect(&timer, SIGNAL(timeout()), this, SLOT(timerTimeout()));
    connect(&progress_timer, SIGNAL(timeout()), this, SLOT(progressTimerTimeout()));
}

SessionScreen::~SessionScreen()
{
    delete ui;
}

// session control
void SessionScreen::startSession(int total_time){
    // set display timer
    int minute = total_time / 60;
    int second = total_time % 60;
    ui->minute_display->display(minute);
    ui->second_display->display(second);
    timer.start(1);
    progress_timer.start(0.1);
    ui->pause_label->hide();
    ui->progress_bar->show();
    ui->state_display->setText("Taking Overall Baseline");
}

void SessionScreen::pauseSession(){
    timer.pause();
    progress_timer.pause();
    ui->pause_label->show();
    ui->progress_bar->hide();
}

void SessionScreen::resumeSession(){
    timer.resume();
    progress_timer.resume();
    ui->pause_label->hide();
    ui->progress_bar->show();
}

void SessionScreen::stopSession(){
    timer.stop();
    progress_timer.stop();
}

void SessionScreen::updateState(SessionState state){
    stringstream text;
    switch(state){
    case SessionState::takingPreBaseline:
        text << "Taking Overall Baseline";
        break;
    case SessionState::takingSiteBaseline:
        text << "Taking Baseline for site " << current_site;
        break;
    case SessionState::treatingSite:
        text << "Treating site " << current_site;
        break;
    case SessionState::takingPostBaseline:
        text << "Taking Overall Baseline";
        break;
    case SessionState::logging:
        text << "Logging";
        progress_timer.stop();
        ui->progress_bar->hide();
        break;
    }
    ui->state_display->setText(QString::fromStdString(text.str()));
}

// progress bar

void SessionScreen::setProgressBarRange(float range){
    ui->progress_bar->setRange(0, range * 1000);
    progress_timer.start(0.1);
}

void SessionScreen::setProgressBarValue(float value){
    ui->progress_bar->setValue(value * 1000);
}

// slots

void SessionScreen::timerTimeout(){
    int new_minute = ui->minute_display->value();
    int new_second = ui->second_display->value() - 1;
    if (new_second < 0){
        if (new_minute > 0){
            new_second = 59;
            new_minute --;
        } else {
            new_second = 0;
        }
    }
    ui->minute_display->display(new_minute);
    ui->second_display->display(new_second);
    timer.start(1);
}

void SessionScreen::progressTimerTimeout(){
    emit(updateProgressBar());
    progress_timer.start(0.1);
}
