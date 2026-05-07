#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QPushButton>
#include <QVBoxLayout>

#include <iostream>

#include "config.h"
#include "dataset.h"

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
    //main window variable
    Ui::MainWindow *ui;

private slots:
    void printComputerLogClick();
    void upload_pc_logs();

    // load data
    void loadDataset1();
    void loadDataset2();
    void loadDatasetAlpha();
    void loadDatasetBeta();
    void loadDatasetDelta();
    void loadDatasetTheta();
    void loadDatasetGamma();
};

#endif
