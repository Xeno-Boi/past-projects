#include "menuscreen.h"
#include "ui_menuscreen.h"

using namespace std;

MenuScreen::MenuScreen(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::MenuScreen)
{
    ui->setupUi(this);

    ui->menu_list->addItem("NEW SESSION");
    ui->menu_list->addItem("SESSION LOG");
    ui->menu_list->addItem("TIME AND DATE");

    ui->menu_list->setCurrentRow(0);

    // disables selection
    ui->menu_list->setFocusPolicy(Qt::NoFocus);
    ui->menu_list->setSelectionMode(QAbstractItemView::NoSelection);
}

MenuScreen::~MenuScreen()
{
    delete ui;
}

// setters
void MenuScreen::setHighlightItem(int index){
    ui->menu_list->setSelectionMode(QAbstractItemView::SingleSelection);
    ui->menu_list->setCurrentRow(index);
    ui->menu_list->setSelectionMode(QAbstractItemView::NoSelection);
}

// getters
int MenuScreen::getCurrentItem(){
    return ui->menu_list->currentRow();
}

int MenuScreen::getItemCount(){
    return ui->menu_list->count();
}


