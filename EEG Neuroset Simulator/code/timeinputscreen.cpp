#include "timeinputscreen.h"
#include "ui_timeinputscreen.h"

TimeInputScreen::TimeInputScreen(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::TimeInputScreen)
{
    ui->setupUi(this);
}

TimeInputScreen::~TimeInputScreen()
{
    delete ui;
}

// controls
void TimeInputScreen::start_input(){
    current_item = 0;
    ui->year_display->setStyleSheet("background-color: gray");
    ui->month_display->setStyleSheet("background-color: white");
    ui->day_display->setStyleSheet("background-color: white");
    ui->hour_display->setStyleSheet("background-color: white");
    ui->minute_display->setStyleSheet("background-color: white");
}

void TimeInputScreen::up(){
    switch(current_item){
    case 0: // year
    {
        int new_year = ui->year_display->value() + 1;
        ui->year_display->display(new_year);
        break;
    }
    case 1: // month
    {
        int new_month = ui->month_display->value() + 1;
        if (new_month > 12){
            new_month = 1;
        }
        ui->month_display->display(new_month);
        break;
    }
    case 2: // day
    {
        int new_day = ui->day_display->value() + 1;
        int current_month = ui->month_display->value();
        if (current_month == 1 || current_month == 3 || current_month == 5 ||
            current_month == 7 || current_month == 8 || current_month == 10 ||
            current_month == 12){
            if (new_day > 31){
                new_day = 1;
            }
        } else if (current_month == 4 || current_month == 6 || current_month == 9 ||
                   current_month == 11){
            if (new_day > 30){
                new_day = 1;
            }
        } else if (current_month == 2){
            if (new_day > 28){
                new_day = 1;
            }
        }
        ui->day_display->display(new_day);
        break;
    }
    case 3: // hour
    {
        int new_hour = ui->hour_display->value() + 1;
        if (new_hour > 23){
            new_hour = 0;
        }
        ui->hour_display->display(new_hour);
        break;
    }
    case 4: // minute
    {
        int new_minute = ui->minute_display->value() + 1;
        if (new_minute > 59){
            new_minute = 0;
        }
        ui->minute_display->display(new_minute);
        break;
    }
    }
}

void TimeInputScreen::down(){
    switch(current_item){
    case 0: // year
    {
        int new_year = ui->year_display->value() - 1;
        ui->year_display->display(new_year);
        break;
    }
    case 1: // month
    {
        int new_month = ui->month_display->value() - 1;
        if (new_month < 1){
            new_month = 12;
        }
        ui->month_display->display(new_month);
        break;
    }
    case 2: // day
    {
        int new_day = ui->day_display->value() - 1;
        if (new_day < 1){
            int current_month = ui->month_display->value();
            if (current_month == 1 || current_month == 3 || current_month == 5 ||
                current_month == 7 || current_month == 8 || current_month == 10 ||
                current_month == 12){
                new_day = 31;
            } else if (current_month == 4 || current_month == 6 || current_month == 9 ||
                       current_month == 11){
                new_day = 30;
            } else if (current_month == 2){
                new_day = 28;
            }
        }
        ui->day_display->display(new_day);
        break;
    }
    case 3: // hour
    {
        int new_hour = ui->hour_display->value() - 1;
        if (new_hour < 0){
            new_hour = 23;
        }
        ui->hour_display->display(new_hour);
        break;
    }
    case 4: // minute
    {
        int new_minute = ui->minute_display->value() - 1;
        if (new_minute < 0){
            new_minute = 59;
        }
        ui->minute_display->display(new_minute);
        break;
    }
    }
}

void TimeInputScreen::select(){
    if (current_item >= 4){
        // minute
        minute = ui->minute_display->value();
        // emit time and date to neureset
        time_and_date = TimeAndDate(minute, hour, day, month, year);
        emit(sendTimeAndDate(time_and_date));
    } else {
        switch(current_item){
        case 0: // year
        {
            year = ui->year_display->value();
            ui->year_display->setStyleSheet("background-color: white");
            ui->month_display->setStyleSheet("background-color: gray");
            break;
        }
        case 1: // month
        {
            month = ui->month_display->value();
            int new_day = ui->day_display->value();
            if (month == 1 || month == 3 || month == 5 ||
                    month == 7 || month == 8 || month == 10 ||
                    month == 12){
                if (new_day > 31){
                    new_day = 31;
                }
            } else if (month == 4 || month == 6 || month == 9 ||
                       month == 11){
                if (new_day > 30){
                    new_day = 30;
                }
            } else if (month == 2){
                if (new_day > 28){
                    new_day = 28;
                }
            }
            ui->day_display->display(new_day);
            ui->month_display->setStyleSheet("background-color: white");
            ui->day_display->setStyleSheet("background-color: gray");
            break;
        }
        case 2: // day
        {
            day = ui->day_display->value();
            ui->day_display->setStyleSheet("background-color: white");
            ui->hour_display->setStyleSheet("background-color: gray");
            break;
        }
        case 3: // hour
        {
            hour = ui->hour_display->value();
            ui->hour_display->setStyleSheet("background-color: white");
            ui->minute_display->setStyleSheet("background-color: gray");
            break;
        }
        }

        current_item++;
    }
}
