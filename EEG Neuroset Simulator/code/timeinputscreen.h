#ifndef TIMEINPUTSCREEN_H
#define TIMEINPUTSCREEN_H

#include <QWidget>
#include "TimeAndDate.h"
#include "config.h"

namespace Ui {
class TimeInputScreen;
}

class TimeInputScreen : public QWidget
{
    Q_OBJECT

public:
    explicit TimeInputScreen(QWidget *parent = nullptr);
    ~TimeInputScreen();

    // controls
    void start_input();
    void up();
    void down();
    void select();

private:
    Ui::TimeInputScreen *ui;

    TimeAndDate time_and_date;

    // control
    int current_item = 0;
    int day;
    int month;
    int year;
    int hour;
    int minute;

signals:
    void sendTimeAndDate(TimeAndDate time_and_date);
};

#endif // TIMEINPUTSCREEN_H
