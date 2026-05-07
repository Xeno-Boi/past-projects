#include "mainwindow.h"
#include "dataset.h"

#include <QApplication>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    MainWindow w;
    w.show();
    Dataset::initDataset();
    return a.exec();
}
