/****************************************************************************
** Meta object code from reading C++ file 'Neureset.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.9.1)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../Neureset.h"
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'Neureset.h' doesn't include <QObject>."
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
struct qt_meta_tag_ZN8NeuresetE_t {};
} // unnamed namespace

template <> constexpr inline auto Neureset::qt_create_metaobjectdata<qt_meta_tag_ZN8NeuresetE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "Neureset",
        "sessionStartSignal",
        "",
        "sessionEndSignal",
        "connectSignal",
        "disconnectSignal",
        "powerOffSignal",
        "powerOnSignal",
        "updateBattery",
        "getLog",
        "SessionLog",
        "log",
        "sessionEnded",
        "chargeBattery",
        "togglePowerOn",
        "batteryTimerTimeout"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'sessionStartSignal'
        QtMocHelpers::SignalData<void()>(1, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'sessionEndSignal'
        QtMocHelpers::SignalData<void()>(3, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'connectSignal'
        QtMocHelpers::SignalData<void()>(4, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'disconnectSignal'
        QtMocHelpers::SignalData<void()>(5, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'powerOffSignal'
        QtMocHelpers::SignalData<void()>(6, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'powerOnSignal'
        QtMocHelpers::SignalData<void()>(7, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'updateBattery'
        QtMocHelpers::SignalData<void()>(8, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'getLog'
        QtMocHelpers::SlotData<void(SessionLog)>(9, 2, QMC::AccessPublic, QMetaType::Void, {{
            { 0x80000000 | 10, 11 },
        }}),
        // Slot 'sessionEnded'
        QtMocHelpers::SlotData<void()>(12, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'chargeBattery'
        QtMocHelpers::SlotData<void()>(13, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'togglePowerOn'
        QtMocHelpers::SlotData<void()>(14, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'batteryTimerTimeout'
        QtMocHelpers::SlotData<void()>(15, 2, QMC::AccessPrivate, QMetaType::Void),
    };
    QtMocHelpers::UintData qt_properties {
    };
    QtMocHelpers::UintData qt_enums {
    };
    return QtMocHelpers::metaObjectData<Neureset, qt_meta_tag_ZN8NeuresetE_t>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}
Q_CONSTINIT const QMetaObject Neureset::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN8NeuresetE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN8NeuresetE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN8NeuresetE_t>.metaTypes,
    nullptr
} };

void Neureset::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<Neureset *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->sessionStartSignal(); break;
        case 1: _t->sessionEndSignal(); break;
        case 2: _t->connectSignal(); break;
        case 3: _t->disconnectSignal(); break;
        case 4: _t->powerOffSignal(); break;
        case 5: _t->powerOnSignal(); break;
        case 6: _t->updateBattery(); break;
        case 7: _t->getLog((*reinterpret_cast< std::add_pointer_t<SessionLog>>(_a[1]))); break;
        case 8: _t->sessionEnded(); break;
        case 9: _t->chargeBattery(); break;
        case 10: _t->togglePowerOn(); break;
        case 11: _t->batteryTimerTimeout(); break;
        default: ;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (Neureset::*)()>(_a, &Neureset::sessionStartSignal, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (Neureset::*)()>(_a, &Neureset::sessionEndSignal, 1))
            return;
        if (QtMocHelpers::indexOfMethod<void (Neureset::*)()>(_a, &Neureset::connectSignal, 2))
            return;
        if (QtMocHelpers::indexOfMethod<void (Neureset::*)()>(_a, &Neureset::disconnectSignal, 3))
            return;
        if (QtMocHelpers::indexOfMethod<void (Neureset::*)()>(_a, &Neureset::powerOffSignal, 4))
            return;
        if (QtMocHelpers::indexOfMethod<void (Neureset::*)()>(_a, &Neureset::powerOnSignal, 5))
            return;
        if (QtMocHelpers::indexOfMethod<void (Neureset::*)()>(_a, &Neureset::updateBattery, 6))
            return;
    }
}

const QMetaObject *Neureset::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *Neureset::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN8NeuresetE_t>.strings))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int Neureset::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 12)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 12;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 12)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 12;
    }
    return _id;
}

// SIGNAL 0
void Neureset::sessionStartSignal()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void Neureset::sessionEndSignal()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}

// SIGNAL 2
void Neureset::connectSignal()
{
    QMetaObject::activate(this, &staticMetaObject, 2, nullptr);
}

// SIGNAL 3
void Neureset::disconnectSignal()
{
    QMetaObject::activate(this, &staticMetaObject, 3, nullptr);
}

// SIGNAL 4
void Neureset::powerOffSignal()
{
    QMetaObject::activate(this, &staticMetaObject, 4, nullptr);
}

// SIGNAL 5
void Neureset::powerOnSignal()
{
    QMetaObject::activate(this, &staticMetaObject, 5, nullptr);
}

// SIGNAL 6
void Neureset::updateBattery()
{
    QMetaObject::activate(this, &staticMetaObject, 6, nullptr);
}
QT_WARNING_POP
