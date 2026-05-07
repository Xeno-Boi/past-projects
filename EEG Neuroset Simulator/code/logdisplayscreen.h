#ifndef LOGDISPLAYSCREEN_H
#define LOGDISPLAYSCREEN_H

#include <QWidget>
#include <vector>

#include "config.h"

namespace Ui {
class LogDisplayScreen;
}

class LogDisplayScreen : public QWidget
{
    Q_OBJECT

public:
    explicit LogDisplayScreen(QWidget *parent = nullptr);
    ~LogDisplayScreen();

    void updateLogs(vector<SessionLog> logs);

    // setters
    void setHighlightItem(int index);

    // getters
    int getCurrentItem();
    int getItemCount();

private:
    Ui::LogDisplayScreen *ui;
};

#endif // LOGDISPLAYSCREEN_H
