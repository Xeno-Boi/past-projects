#ifndef WARNINGSCREEN_H
#define WARNINGSCREEN_H

#include <QWidget>

namespace Ui {
class WarningScreen;
}

class WarningScreen : public QWidget
{
    Q_OBJECT

public:
    explicit WarningScreen(QWidget *parent = nullptr);
    ~WarningScreen();

private:
    Ui::WarningScreen *ui;
};

#endif // WARNINGSCREEN_H
