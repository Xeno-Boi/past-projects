#include "logdisplayscreen.h"
#include "ui_logdisplayscreen.h"

LogDisplayScreen::LogDisplayScreen(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::LogDisplayScreen)
{
    ui->setupUi(this);

    // disables selection
    ui->log_list->setFocusPolicy(Qt::NoFocus);
    ui->log_list->setSelectionMode(QAbstractItemView::NoSelection);
}

LogDisplayScreen::~LogDisplayScreen()
{
    delete ui;
}

void LogDisplayScreen::updateLogs(vector<SessionLog> logs){
    ui->log_list->clear();
    for (auto log : logs){
        ui->log_list->addItem(QString::fromStdString(log.toTimeAndDate()));
    }
    setHighlightItem(0);
}

// setters
void LogDisplayScreen::setHighlightItem(int index){
    ui->log_list->setSelectionMode(QAbstractItemView::SingleSelection);
    ui->log_list->setCurrentRow(index);
    ui->log_list->setSelectionMode(QAbstractItemView::NoSelection);
}

// getters
int LogDisplayScreen::getCurrentItem(){
    return ui->log_list->currentRow();
}

int LogDisplayScreen::getItemCount(){
    return ui->log_list->count();
}
