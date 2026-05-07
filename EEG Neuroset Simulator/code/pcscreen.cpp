#include "pcscreen.h"
#include "ui_pcscreen.h"

PCScreen::PCScreen(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::PCScreen)
{
    ui->setupUi(this);

    connect(ui->upload_logs_button, SIGNAL(clicked()), this, SLOT(upload_button_click()));
}

PCScreen::~PCScreen()
{
    delete ui;
}

void PCScreen::updateLogs(vector<SessionLog> logs){
    ui->log_list->clear();
    for (auto log : logs){
        ui->log_list->addItem(QString::fromStdString(log.toString()));
    }
}

// slots

void PCScreen::upload_button_click(){
    emit(upload_logs());
}
