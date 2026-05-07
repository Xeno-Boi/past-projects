#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QString>
#include <string>

#include "ecs.h"

QT_BEGIN_NAMESPACE
namespace Ui { class MainWindow; }
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private:
    Ui::MainWindow *ui;

    ECS* ecs;

private slots:
    void aFun();

    // elevator 1
    void updateDirectionDisplay1(string);
    void updateFloorDisplay1(int);
    void updateDoorDisplay1(string);
    void updateAudio1(string);
    void updateDisplay1(string);

    // elevator 2
    void updateDirectionDisplay2(string);
    void updateFloorDisplay2(int);
    void updateDoorDisplay2(string);
    void updateAudio2(string);
    void updateDisplay2(string);

    // elevator 3
    void updateDirectionDisplay3(string);
    void updateFloorDisplay3(int);
    void updateDoorDisplay3(string);
    void updateAudio3(string);
    void updateDisplay3(string);

    // floor button
    void lightsUpFloorButton(int floor, bool up);
    void lightsOffFloorButton(int floor, bool up);
    void debug();
};
#endif // MAINWINDOW_H
