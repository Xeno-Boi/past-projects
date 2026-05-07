#include "mainwindow.h"
#include "ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    ecs = new ECS();

    // connect
    //connect(ui->aButton, SIGNAL(released()), this, SLOT(aFun()));
    connect(ui->debug_button, SIGNAL(released()), ecs->getElevator(0), SLOT(debug()));
    connect(ui->debug_button_2, SIGNAL(released()), ecs, SLOT(debug()));
    connect(ui->debug_button_3, SIGNAL(released()), this, SLOT(debug()));


    // ECS

    // floor button
    connect(ui->floor_up_button_1, SIGNAL(released()), ecs->getFloorButton(), SLOT(press1Up()));

    connect(ui->floor_up_button_2, SIGNAL(released()), ecs->getFloorButton(), SLOT(press2Up()));
    connect(ui->floor_down_button_2, SIGNAL(released()), ecs->getFloorButton(), SLOT(press2Down()));

    connect(ui->floor_up_button_3, SIGNAL(released()), ecs->getFloorButton(), SLOT(press3Up()));
    connect(ui->floor_down_button_3, SIGNAL(released()), ecs->getFloorButton(), SLOT(press3Down()));

    connect(ui->floor_up_button_4, SIGNAL(released()), ecs->getFloorButton(), SLOT(press4Up()));
    connect(ui->floor_down_button_4, SIGNAL(released()), ecs->getFloorButton(), SLOT(press4Down()));

    connect(ui->floor_up_button_5, SIGNAL(released()), ecs->getFloorButton(), SLOT(press5Up()));
    connect(ui->floor_down_button_5, SIGNAL(released()), ecs->getFloorButton(), SLOT(press5Down()));

    connect(ui->floor_up_button_6, SIGNAL(released()), ecs->getFloorButton(), SLOT(press6Up()));
    connect(ui->floor_down_button_6, SIGNAL(released()), ecs->getFloorButton(), SLOT(press6Down()));

    connect(ui->floor_down_button_7, SIGNAL(released()), ecs->getFloorButton(), SLOT(press7Down()));

    connect(ecs->getFloorButton(), SIGNAL(Signal_LightsUp(int, bool)), this, SLOT(lightsUpFloorButton(int, bool)));
    connect(ecs->getFloorButton(), SIGNAL(Signal_LightsOff(int, bool)), this, SLOT(lightsOffFloorButton(int, bool)));


    // emergency
    connect(ui->emergency, SIGNAL(released()), ecs, SLOT(emergency()));

    // fire
    connect(ui->fire, SIGNAL(released()), ecs, SLOT(fire()));

    // power out
    connect(ui->power_out, SIGNAL(released()), ecs, SLOT(power_out()));


    // elevator 1

    // car
    connect((ecs->getElevator(0))->getCar(), SIGNAL(updateDirectionDisplay(string)), this, SLOT(updateDirectionDisplay1(string)));

    // close door
    connect(ui->close_door_button_1, SIGNAL(released()), (ecs->getElevator(0))->getCloseButton(), SLOT(press()));

    // floor buttons
    connect(ui->elevator_1_floor_1, SIGNAL(released()), (ecs->getElevator(0))->getFloorButton(), SLOT(buttonPressed1()));
    connect(ui->elevator_1_floor_2, SIGNAL(released()), (ecs->getElevator(0))->getFloorButton(), SLOT(buttonPressed2()));
    connect(ui->elevator_1_floor_3, SIGNAL(released()), (ecs->getElevator(0))->getFloorButton(), SLOT(buttonPressed3()));
    connect(ui->elevator_1_floor_4, SIGNAL(released()), (ecs->getElevator(0))->getFloorButton(), SLOT(buttonPressed4()));
    connect(ui->elevator_1_floor_5, SIGNAL(released()), (ecs->getElevator(0))->getFloorButton(), SLOT(buttonPressed5()));
    connect(ui->elevator_1_floor_6, SIGNAL(released()), (ecs->getElevator(0))->getFloorButton(), SLOT(buttonPressed6()));
    connect(ui->elevator_1_floor_7, SIGNAL(released()), (ecs->getElevator(0))->getFloorButton(), SLOT(buttonPressed7()));

    // floor sensor
    connect(ui->detect_floor_1, SIGNAL(released()), (ecs->getElevator(0))->getFloorSensor(), SLOT(detectFloor()));

    // door
    connect((ecs->getElevator(0))->getDoor(), SIGNAL(updateDoorDisplay(string)), this, SLOT(updateDoorDisplay1(string)));

    // elevator
    connect(ecs->getElevator(0), SIGNAL(updateFloorDisplay(int)), this, SLOT(updateFloorDisplay1(int)));

    // open door
    connect(ui->open_door_button_1, SIGNAL(released()), (ecs->getElevator(0))->getOpenButton(), SLOT(press()));

    // audio
    connect((ecs->getElevator(0))->getAudio(), SIGNAL(updateAudio(string)), this, SLOT(updateAudio1(string)));

    // display
    connect((ecs->getElevator(0))->getDisplay(), SIGNAL(updateDisplay(string)), this, SLOT(updateDisplay1(string)));

    // help
    connect(ui->help_button_1, SIGNAL(released()), (ecs->getElevator(0))->getHelpButton(), SLOT(press()));
    connect(ui->building_safty_reply_button_1, SIGNAL(released()), ecs->getElevator(0), SLOT(buildingSafetyReplied()));

    // door obstruct
    connect(ui->door_obstruct_1, SIGNAL(released()), (ecs->getElevator(0)->getDoorSensor()), SLOT(obstruct()));
    connect(ui->door_unobstruct_1, SIGNAL(released()), (ecs->getElevator(0)->getDoorSensor()), SLOT(unobstruct()));

    // weight sensor
    connect(ui->overweight_1, SIGNAL(released()), (ecs->getElevator(0))->getWeightSensor(), SLOT(overload()));
    connect(ui->stop_overweight_1, SIGNAL(released()), (ecs->getElevator(0))->getWeightSensor(), SLOT(normalLoad()));


    // elevator 2

    // car
    connect((ecs->getElevator(1))->getCar(), SIGNAL(updateDirectionDisplay(string)), this, SLOT(updateDirectionDisplay2(string)));

    // close door
    connect(ui->close_door_button_2, SIGNAL(released()), (ecs->getElevator(1))->getCloseButton(), SLOT(press()));

    // floor buttons
    connect(ui->elevator_2_floor_1, SIGNAL(released()), (ecs->getElevator(1))->getFloorButton(), SLOT(buttonPressed1()));
    connect(ui->elevator_2_floor_2, SIGNAL(released()), (ecs->getElevator(1))->getFloorButton(), SLOT(buttonPressed2()));
    connect(ui->elevator_2_floor_3, SIGNAL(released()), (ecs->getElevator(1))->getFloorButton(), SLOT(buttonPressed3()));
    connect(ui->elevator_2_floor_4, SIGNAL(released()), (ecs->getElevator(1))->getFloorButton(), SLOT(buttonPressed4()));
    connect(ui->elevator_2_floor_5, SIGNAL(released()), (ecs->getElevator(1))->getFloorButton(), SLOT(buttonPressed5()));
    connect(ui->elevator_2_floor_6, SIGNAL(released()), (ecs->getElevator(1))->getFloorButton(), SLOT(buttonPressed6()));
    connect(ui->elevator_2_floor_7, SIGNAL(released()), (ecs->getElevator(1))->getFloorButton(), SLOT(buttonPressed7()));

    // floor sensor
    connect(ui->detect_floor_2, SIGNAL(released()), (ecs->getElevator(1))->getFloorSensor(), SLOT(detectFloor()));

    // door
    connect((ecs->getElevator(1))->getDoor(), SIGNAL(updateDoorDisplay(string)), this, SLOT(updateDoorDisplay2(string)));

    // elevator
    connect(ecs->getElevator(1), SIGNAL(updateFloorDisplay(int)), this, SLOT(updateFloorDisplay2(int)));

    // open door
    connect(ui->open_door_button_2, SIGNAL(released()), (ecs->getElevator(1))->getOpenButton(), SLOT(press()));

    // audio
    connect((ecs->getElevator(1))->getAudio(), SIGNAL(updateAudio(string)), this, SLOT(updateAudio2(string)));

    // display
    connect((ecs->getElevator(1))->getDisplay(), SIGNAL(updateDisplay(string)), this, SLOT(updateDisplay2(string)));

    // help
    connect(ui->help_button_2, SIGNAL(released()), (ecs->getElevator(1))->getHelpButton(), SLOT(press()));
    connect(ui->building_safty_reply_button_2, SIGNAL(released()), ecs->getElevator(1), SLOT(buildingSafetyReplied()));

    // door obstruct
    connect(ui->door_obstruct_2, SIGNAL(released()), (ecs->getElevator(1)->getDoorSensor()), SLOT(obstruct()));
    connect(ui->door_unobstruct_2, SIGNAL(released()), (ecs->getElevator(1)->getDoorSensor()), SLOT(unobstruct()));

    // weight sensor
    connect(ui->overweight_2, SIGNAL(released()), (ecs->getElevator(1))->getWeightSensor(), SLOT(overload()));
    connect(ui->stop_overweight_2, SIGNAL(released()), (ecs->getElevator(1))->getWeightSensor(), SLOT(normalLoad()));


    // elevator 3

    // car
    connect((ecs->getElevator(2))->getCar(), SIGNAL(updateDirectionDisplay(string)), this, SLOT(updateDirectionDisplay3(string)));

    // close door
    connect(ui->close_door_button_3, SIGNAL(released()), (ecs->getElevator(2))->getCloseButton(), SLOT(press()));

    // floor buttons
    connect(ui->elevator_3_floor_1, SIGNAL(released()), (ecs->getElevator(2))->getFloorButton(), SLOT(buttonPressed1()));
    connect(ui->elevator_3_floor_2, SIGNAL(released()), (ecs->getElevator(2))->getFloorButton(), SLOT(buttonPressed2()));
    connect(ui->elevator_3_floor_3, SIGNAL(released()), (ecs->getElevator(2))->getFloorButton(), SLOT(buttonPressed3()));
    connect(ui->elevator_3_floor_4, SIGNAL(released()), (ecs->getElevator(2))->getFloorButton(), SLOT(buttonPressed4()));
    connect(ui->elevator_3_floor_5, SIGNAL(released()), (ecs->getElevator(2))->getFloorButton(), SLOT(buttonPressed5()));
    connect(ui->elevator_3_floor_6, SIGNAL(released()), (ecs->getElevator(2))->getFloorButton(), SLOT(buttonPressed6()));
    connect(ui->elevator_3_floor_7, SIGNAL(released()), (ecs->getElevator(2))->getFloorButton(), SLOT(buttonPressed7()));

    // floor sensor
    connect(ui->detect_floor_3, SIGNAL(released()), (ecs->getElevator(2))->getFloorSensor(), SLOT(detectFloor()));

    // door
    connect((ecs->getElevator(2))->getDoor(), SIGNAL(updateDoorDisplay(string)), this, SLOT(updateDoorDisplay3(string)));

    // elevator
    connect(ecs->getElevator(2), SIGNAL(updateFloorDisplay(int)), this, SLOT(updateFloorDisplay3(int)));

    // open door
    connect(ui->open_door_button_3, SIGNAL(released()), (ecs->getElevator(2))->getOpenButton(), SLOT(press()));

    // audio
    connect((ecs->getElevator(2))->getAudio(), SIGNAL(updateAudio(string)), this, SLOT(updateAudio3(string)));

    // display
    connect((ecs->getElevator(2))->getDisplay(), SIGNAL(updateDisplay(string)), this, SLOT(updateDisplay3(string)));

    // help
    connect(ui->help_button_3, SIGNAL(released()), (ecs->getElevator(2))->getHelpButton(), SLOT(press()));
    connect(ui->building_safty_reply_button_3, SIGNAL(released()), ecs->getElevator(2), SLOT(buildingSafetyReplied()));

    // door obstruct
    connect(ui->door_obstruct_3, SIGNAL(released()), (ecs->getElevator(2)->getDoorSensor()), SLOT(obstruct()));
    connect(ui->door_unobstruct_3, SIGNAL(released()), (ecs->getElevator(2)->getDoorSensor()), SLOT(unobstruct()));

    // weight sensor
    connect(ui->overweight_3, SIGNAL(released()), (ecs->getElevator(2))->getWeightSensor(), SLOT(overload()));
    connect(ui->stop_overweight_3, SIGNAL(released()), (ecs->getElevator(2))->getWeightSensor(), SLOT(normalLoad()));

}

MainWindow::~MainWindow()
{
    delete ui;
    delete ecs;
}

void MainWindow::aFun(){
    qInfo("hello world");
}

// elevator 1
void MainWindow::updateDirectionDisplay1(string direction){
    ui->direction_display_1->setText(QString::fromStdString(direction));
}

void MainWindow::updateFloorDisplay1(int floor){
    ui->floor_display_1->setText(QString::number(floor));
}

void MainWindow::updateDoorDisplay1(string status){
    ui->door_display_1->setText(QString::fromStdString(status));
}

void MainWindow::updateAudio1(string message){
    ui->audio_box_1->setText(QString::fromStdString(message));
}

void MainWindow::updateDisplay1(string message){
    ui->display_box_1->setText(QString::fromStdString(message));
}

// elevator 2
void MainWindow::updateDirectionDisplay2(string direction){
    ui->direction_display_2->setText(QString::fromStdString(direction));
}

void MainWindow::updateFloorDisplay2(int floor){
    ui->floor_display_2->setText(QString::number(floor));
}

void MainWindow::updateDoorDisplay2(string status){
    ui->door_display_2->setText(QString::fromStdString(status));
}

void MainWindow::updateAudio2(string message){
    ui->audio_box_2->setText(QString::fromStdString(message));
}

void MainWindow::updateDisplay2(string message){
    ui->display_box_2->setText(QString::fromStdString(message));
}

// elevator 3
void MainWindow::updateDirectionDisplay3(string direction){
    ui->direction_display_3->setText(QString::fromStdString(direction));
}

void MainWindow::updateFloorDisplay3(int floor){
    ui->floor_display_3->setText(QString::number(floor));
}

void MainWindow::updateDoorDisplay3(string status){
    ui->door_display_3->setText(QString::fromStdString(status));
}

void MainWindow::updateAudio3(string message){
    ui->audio_box_3->setText(QString::fromStdString(message));
}

void MainWindow::updateDisplay3(string message){
    ui->display_box_3->setText(QString::fromStdString(message));
}

// floor button
void MainWindow::lightsUpFloorButton(int floor, bool up){
    if (up){
        switch(floor){
        case 1:
            ui->floor_up_button_1->setStyleSheet("QPushButton { background-color: yellow; }");
            break;
        case 2:
            ui->floor_up_button_2->setStyleSheet("QPushButton { background-color: yellow; }");
            break;
        case 3:
            ui->floor_up_button_3->setStyleSheet("QPushButton { background-color: yellow; }");
            break;
        case 4:
            ui->floor_up_button_4->setStyleSheet("QPushButton { background-color: yellow; }");
            break;
        case 5:
            ui->floor_up_button_5->setStyleSheet("QPushButton { background-color: yellow; }");
            break;
        case 6:
            ui->floor_up_button_6->setStyleSheet("QPushButton { background-color: yellow; }");
            break;
        }
    } else {
        switch(floor){
        case 2:
            ui->floor_down_button_2->setStyleSheet("QPushButton { background-color: yellow; }");
            break;
        case 3:
            ui->floor_down_button_3->setStyleSheet("QPushButton { background-color: yellow; }");
            break;
        case 4:
            ui->floor_down_button_4->setStyleSheet("QPushButton { background-color: yellow; }");
            break;
        case 5:
            ui->floor_down_button_5->setStyleSheet("QPushButton { background-color: yellow; }");
            break;
        case 6:
            ui->floor_down_button_6->setStyleSheet("QPushButton { background-color: yellow; }");
            break;
        case 7:
            ui->floor_down_button_7->setStyleSheet("QPushButton { background-color: yellow; }");
            break;
        }
    }
}

void MainWindow::lightsOffFloorButton(int floor, bool up){
    if (up){
        switch(floor){
        case 1:
            ui->floor_up_button_1->setStyleSheet("QPushButton { background-color: white; }");
            break;
        case 2:
            ui->floor_up_button_2->setStyleSheet("QPushButton { background-color: white; }");
            break;
        case 3:
            ui->floor_up_button_3->setStyleSheet("QPushButton { background-color: white; }");
            break;
        case 4:
            ui->floor_up_button_4->setStyleSheet("QPushButton { background-color: white; }");
            break;
        case 5:
            ui->floor_up_button_5->setStyleSheet("QPushButton { background-color: white; }");
            break;
        case 6:
            ui->floor_up_button_6->setStyleSheet("QPushButton { background-color: white; }");
            break;
        }
    } else {
        switch(floor){
        case 2:
            ui->floor_down_button_2->setStyleSheet("QPushButton { background-color: white; }");
            break;
        case 3:
            ui->floor_down_button_3->setStyleSheet("QPushButton { background-color: white; }");
            break;
        case 4:
            ui->floor_down_button_4->setStyleSheet("QPushButton { background-color: white; }");
            break;
        case 5:
            ui->floor_down_button_5->setStyleSheet("QPushButton { background-color: white; }");
            break;
        case 6:
            ui->floor_down_button_6->setStyleSheet("QPushButton { background-color: white; }");
            break;
        case 7:
            ui->floor_down_button_7->setStyleSheet("QPushButton { background-color: white; }");
            break;
        }
    }
}

void MainWindow::debug(){
    ui->floor_down_button_7->setStyleSheet("QPushButton { background-color: white; }");
}
