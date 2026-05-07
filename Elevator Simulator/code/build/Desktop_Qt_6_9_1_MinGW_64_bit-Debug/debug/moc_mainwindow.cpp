/****************************************************************************
** Meta object code from reading C++ file 'mainwindow.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.9.1)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../mainwindow.h"
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'mainwindow.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 69
#error "This file was generated using the moc from 6.9.1. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

#ifndef Q_CONSTINIT
#define Q_CONSTINIT
#endif

QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
QT_WARNING_DISABLE_GCC("-Wuseless-cast")
namespace {
struct qt_meta_tag_ZN10MainWindowE_t {};
} // unnamed namespace

template <> constexpr inline auto MainWindow::qt_create_metaobjectdata<qt_meta_tag_ZN10MainWindowE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "MainWindow",
        "aFun",
        "",
        "updateDirectionDisplay1",
        "string",
        "updateFloorDisplay1",
        "updateDoorDisplay1",
        "updateAudio1",
        "updateDisplay1",
        "updateDirectionDisplay2",
        "updateFloorDisplay2",
        "updateDoorDisplay2",
        "updateAudio2",
        "updateDisplay2",
        "updateDirectionDisplay3",
        "updateFloorDisplay3",
        "updateDoorDisplay3",
        "updateAudio3",
        "updateDisplay3",
        "lightsUpFloorButton",
        "floor",
        "up",
        "lightsOffFloorButton",
        "debug"
    };

    QtMocHelpers::UintData qt_methods {
        // Slot 'aFun'
        QtMocHelpers::SlotData<void()>(1, 2, QMC::AccessPrivate, QMetaType::Void),
        // Slot 'updateDirectionDisplay1'
        QtMocHelpers::SlotData<void(string)>(3, 2, QMC::AccessPrivate, QMetaType::Void, {{
            { 0x80000000 | 4, 2 },
        }}),
        // Slot 'updateFloorDisplay1'
        QtMocHelpers::SlotData<void(int)>(5, 2, QMC::AccessPrivate, QMetaType::Void, {{
            { QMetaType::Int, 2 },
        }}),
        // Slot 'updateDoorDisplay1'
        QtMocHelpers::SlotData<void(string)>(6, 2, QMC::AccessPrivate, QMetaType::Void, {{
            { 0x80000000 | 4, 2 },
        }}),
        // Slot 'updateAudio1'
        QtMocHelpers::SlotData<void(string)>(7, 2, QMC::AccessPrivate, QMetaType::Void, {{
            { 0x80000000 | 4, 2 },
        }}),
        // Slot 'updateDisplay1'
        QtMocHelpers::SlotData<void(string)>(8, 2, QMC::AccessPrivate, QMetaType::Void, {{
            { 0x80000000 | 4, 2 },
        }}),
        // Slot 'updateDirectionDisplay2'
        QtMocHelpers::SlotData<void(string)>(9, 2, QMC::AccessPrivate, QMetaType::Void, {{
            { 0x80000000 | 4, 2 },
        }}),
        // Slot 'updateFloorDisplay2'
        QtMocHelpers::SlotData<void(int)>(10, 2, QMC::AccessPrivate, QMetaType::Void, {{
            { QMetaType::Int, 2 },
        }}),
        // Slot 'updateDoorDisplay2'
        QtMocHelpers::SlotData<void(string)>(11, 2, QMC::AccessPrivate, QMetaType::Void, {{
            { 0x80000000 | 4, 2 },
        }}),
        // Slot 'updateAudio2'
        QtMocHelpers::SlotData<void(string)>(12, 2, QMC::AccessPrivate, QMetaType::Void, {{
            { 0x80000000 | 4, 2 },
        }}),
        // Slot 'updateDisplay2'
        QtMocHelpers::SlotData<void(string)>(13, 2, QMC::AccessPrivate, QMetaType::Void, {{
            { 0x80000000 | 4, 2 },
        }}),
        // Slot 'updateDirectionDisplay3'
        QtMocHelpers::SlotData<void(string)>(14, 2, QMC::AccessPrivate, QMetaType::Void, {{
            { 0x80000000 | 4, 2 },
        }}),
        // Slot 'updateFloorDisplay3'
        QtMocHelpers::SlotData<void(int)>(15, 2, QMC::AccessPrivate, QMetaType::Void, {{
            { QMetaType::Int, 2 },
        }}),
        // Slot 'updateDoorDisplay3'
        QtMocHelpers::SlotData<void(string)>(16, 2, QMC::AccessPrivate, QMetaType::Void, {{
            { 0x80000000 | 4, 2 },
        }}),
        // Slot 'updateAudio3'
        QtMocHelpers::SlotData<void(string)>(17, 2, QMC::AccessPrivate, QMetaType::Void, {{
            { 0x80000000 | 4, 2 },
        }}),
        // Slot 'updateDisplay3'
        QtMocHelpers::SlotData<void(string)>(18, 2, QMC::AccessPrivate, QMetaType::Void, {{
            { 0x80000000 | 4, 2 },
        }}),
        // Slot 'lightsUpFloorButton'
        QtMocHelpers::SlotData<void(int, bool)>(19, 2, QMC::AccessPrivate, QMetaType::Void, {{
            { QMetaType::Int, 20 }, { QMetaType::Bool, 21 },
        }}),
        // Slot 'lightsOffFloorButton'
        QtMocHelpers::SlotData<void(int, bool)>(22, 2, QMC::AccessPrivate, QMetaType::Void, {{
            { QMetaType::Int, 20 }, { QMetaType::Bool, 21 },
        }}),
        // Slot 'debug'
        QtMocHelpers::SlotData<void()>(23, 2, QMC::AccessPrivate, QMetaType::Void),
    };
    QtMocHelpers::UintData qt_properties {
    };
    QtMocHelpers::UintData qt_enums {
    };
    return QtMocHelpers::metaObjectData<MainWindow, qt_meta_tag_ZN10MainWindowE_t>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}
Q_CONSTINIT const QMetaObject MainWindow::staticMetaObject = { {
    QMetaObject::SuperData::link<QMainWindow::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN10MainWindowE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN10MainWindowE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN10MainWindowE_t>.metaTypes,
    nullptr
} };

void MainWindow::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<MainWindow *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->aFun(); break;
        case 1: _t->updateDirectionDisplay1((*reinterpret_cast< std::add_pointer_t<string>>(_a[1]))); break;
        case 2: _t->updateFloorDisplay1((*reinterpret_cast< std::add_pointer_t<int>>(_a[1]))); break;
        case 3: _t->updateDoorDisplay1((*reinterpret_cast< std::add_pointer_t<string>>(_a[1]))); break;
        case 4: _t->updateAudio1((*reinterpret_cast< std::add_pointer_t<string>>(_a[1]))); break;
        case 5: _t->updateDisplay1((*reinterpret_cast< std::add_pointer_t<string>>(_a[1]))); break;
        case 6: _t->updateDirectionDisplay2((*reinterpret_cast< std::add_pointer_t<string>>(_a[1]))); break;
        case 7: _t->updateFloorDisplay2((*reinterpret_cast< std::add_pointer_t<int>>(_a[1]))); break;
        case 8: _t->updateDoorDisplay2((*reinterpret_cast< std::add_pointer_t<string>>(_a[1]))); break;
        case 9: _t->updateAudio2((*reinterpret_cast< std::add_pointer_t<string>>(_a[1]))); break;
        case 10: _t->updateDisplay2((*reinterpret_cast< std::add_pointer_t<string>>(_a[1]))); break;
        case 11: _t->updateDirectionDisplay3((*reinterpret_cast< std::add_pointer_t<string>>(_a[1]))); break;
        case 12: _t->updateFloorDisplay3((*reinterpret_cast< std::add_pointer_t<int>>(_a[1]))); break;
        case 13: _t->updateDoorDisplay3((*reinterpret_cast< std::add_pointer_t<string>>(_a[1]))); break;
        case 14: _t->updateAudio3((*reinterpret_cast< std::add_pointer_t<string>>(_a[1]))); break;
        case 15: _t->updateDisplay3((*reinterpret_cast< std::add_pointer_t<string>>(_a[1]))); break;
        case 16: _t->lightsUpFloorButton((*reinterpret_cast< std::add_pointer_t<int>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<bool>>(_a[2]))); break;
        case 17: _t->lightsOffFloorButton((*reinterpret_cast< std::add_pointer_t<int>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<bool>>(_a[2]))); break;
        case 18: _t->debug(); break;
        default: ;
        }
    }
}

const QMetaObject *MainWindow::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *MainWindow::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN10MainWindowE_t>.strings))
        return static_cast<void*>(this);
    return QMainWindow::qt_metacast(_clname);
}

int MainWindow::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QMainWindow::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 19)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 19;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 19)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 19;
    }
    return _id;
}
QT_WARNING_POP
