#ifndef PCSCREEN_H
#define PCSCREEN_H

#include <QWidget>
#include<vector>

#include "config.h"

namespace Ui {
class PCScreen;
}

class PCScreen : public QWidget
{
    Q_OBJECT

public:
    explicit PCScreen(QWidget *parent = nullptr);
    ~PCScreen();

    void updateLogs(vector<SessionLog> logs);

private:
    Ui::PCScreen *ui;

private slots:
    void upload_button_click();

signals:
    void upload_logs();
};

#endif // PCSCREEN_H
