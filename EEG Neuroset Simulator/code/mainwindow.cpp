#include "mainwindow.h"
#include "ui_mainwindow.h"

#include "device.h"
#include "pcscreen.h"

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);

    connect(ui->connect_button, SIGNAL(clicked()), ui->device_widget, SLOT(connectSensor()));
    connect(ui->disconnect_button, SIGNAL(clicked()), ui->device_widget, SLOT(disconnectSensor()));
    connect(ui->charge_battery_button, SIGNAL(clicked()), ui->device_widget->getNeureset(), SLOT(chargeBattery()));
    connect(ui->print_computer_log_button, SIGNAL(clicked()), this, SLOT(printComputerLogClick()));
    connect(ui->pc_screen, SIGNAL(upload_logs()), this, SLOT(upload_pc_logs()));

    connect(ui->dataset_1_button, SIGNAL(clicked()), this, SLOT(loadDataset1()));
    connect(ui->dataset_2_button, SIGNAL(clicked()), this, SLOT(loadDataset2()));
    connect(ui->dataset_alpha_button, SIGNAL(clicked()), this, SLOT(loadDatasetAlpha()));
    connect(ui->dataset_beta_button, SIGNAL(clicked()), this, SLOT(loadDatasetBeta()));
    connect(ui->dataset_delta_button, SIGNAL(clicked()), this, SLOT(loadDatasetDelta()));
    connect(ui->dataset_theta_button, SIGNAL(clicked()), this, SLOT(loadDatasetTheta()));
    connect(ui->dataset_gamma_button, SIGNAL(clicked()), this, SLOT(loadDatasetGamma()));
}

//destructor for the UI
MainWindow::~MainWindow()
{
    delete ui;
}

// slots

void MainWindow::printComputerLogClick(){
    ui->device_widget->getNeureset()->getComputerLog();
}

void MainWindow::upload_pc_logs(){
    ui->pc_screen->updateLogs(ui->device_widget->getNeureset()->getLogHistory());
}

// load data
void MainWindow::loadDataset1(){
    ui->device_widget->loadData(Dataset::getDataset1());
}

void MainWindow::loadDataset2(){
    ui->device_widget->loadData(Dataset::getDataset2());
}

void MainWindow::loadDatasetAlpha(){
    ui->device_widget->loadData(Dataset::getDatasetAlpha());
}

void MainWindow::loadDatasetBeta(){
    ui->device_widget->loadData(Dataset::getDatasetBeta());
}

void MainWindow::loadDatasetDelta(){
    ui->device_widget->loadData(Dataset::getDatasetDelta());
}

void MainWindow::loadDatasetTheta(){
    ui->device_widget->loadData(Dataset::getDatasetTheta());
}

void MainWindow::loadDatasetGamma(){
    ui->device_widget->loadData(Dataset::getDatasetGamma());
}
