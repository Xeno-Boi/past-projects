#include "warningscreen.h"
#include "ui_warningscreen.h"

WarningScreen::WarningScreen(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::WarningScreen)
{
    ui->setupUi(this);
}

WarningScreen::~WarningScreen()
{
    delete ui;
}
