/****************************************************************************
** Meta object code from reading C++ file 'Sessions.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.9.1)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../Sessions.h"
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'Sessions.h' doesn't include <QObject>."
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
struct qt_meta_tag_ZN8SessionsE_t {};
} // unnamed namespace

template <> constexpr inline auto Sessions::qt_create_metaobjectdata<qt_meta_tag_ZN8SessionsE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "Sessions",
        "setEEGSiteNum",
        "",
        "value",
        "updateProgress",
        "writeLog",
        "SessionLog",
        "log",
        "sessionStarted",
        "sessionPaused",
        "sessionResumed",
        "sessionEnded",
        "newState",
        "SessionState",
        "state",
        "powerOff",
        "pauseTimerTimeout",
        "sessionTimerTimeout"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'setEEGSiteNum'
        QtMocHelpers::SignalData<void(int)>(1, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Int, 3 },
        }}),
        // Signal 'updateProgress'
        QtMocHelpers::SignalData<void(int)>(4, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Int, 3 },
        }}),
        // Signal 'writeLog'
        QtMocHelpers::SignalData<void(SessionLog)>(5, 2, QMC::AccessPublic, QMetaType::Void, {{
            { 0x80000000 | 6, 7 },
        }}),
        // Signal 'sessionStarted'
        QtMocHelpers::SignalData<void()>(8, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'sessionPaused'
        QtMocHelpers::SignalData<void()>(9, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'sessionResumed'
        QtMocHelpers::SignalData<void()>(10, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'sessionEnded'
        QtMocHelpers::SignalData<void()>(11, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'newState'
        QtMocHelpers::SignalData<void(SessionState)>(12, 2, QMC::AccessPublic, QMetaType::Void, {{
            { 0x80000000 | 13, 14 },
        }}),
        // Signal 'powerOff'
        QtMocHelpers::SignalData<void()>(15, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'pauseTimerTimeout'
        QtMocHelpers::SlotData<void()>(16, 2, QMC::AccessPrivate, QMetaType::Void),
        // Slot 'sessionTimerTimeout'
        QtMocHelpers::SlotData<void()>(17, 2, QMC::AccessPrivate, QMetaType::Void),
    };
    QtMocHelpers::UintData qt_properties {
    };
    QtMocHelpers::UintData qt_enums {
    };
    return QtMocHelpers::metaObjectData<Sessions, qt_meta_tag_ZN8SessionsE_t>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}
Q_CONSTINIT const QMetaObject Sessions::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN8SessionsE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN8SessionsE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN8SessionsE_t>.metaTypes,
    nullptr
} };

void Sessions::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<Sessions *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->setEEGSiteNum((*reinterpret_cast< std::add_pointer_t<int>>(_a[1]))); break;
        case 1: _t->updateProgress((*reinterpret_cast< std::add_pointer_t<int>>(_a[1]))); break;
        case 2: _t->writeLog((*reinterpret_cast< std::add_pointer_t<SessionLog>>(_a[1]))); break;
        case 3: _t->sessionStarted(); break;
        case 4: _t->sessionPaused(); break;
        case 5: _t->sessionResumed(); break;
        case 6: _t->sessionEnded(); break;
        case 7: _t->newState((*reinterpret_cast< std::add_pointer_t<SessionState>>(_a[1]))); break;
        case 8: _t->powerOff(); break;
        case 9: _t->pauseTimerTimeout(); break;
        case 10: _t->sessionTimerTimeout(); break;
        default: ;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (Sessions::*)(int )>(_a, &Sessions::setEEGSiteNum, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (Sessions::*)(int )>(_a, &Sessions::updateProgress, 1))
            return;
        if (QtMocHelpers::indexOfMethod<void (Sessions::*)(SessionLog )>(_a, &Sessions::writeLog, 2))
            return;
        if (QtMocHelpers::indexOfMethod<void (Sessions::*)()>(_a, &Sessions::sessionStarted, 3))
            return;
        if (QtMocHelpers::indexOfMethod<void (Sessions::*)()>(_a, &Sessions::sessionPaused, 4))
            return;
        if (QtMocHelpers::indexOfMethod<void (Sessions::*)()>(_a, &Sessions::sessionResumed, 5))
            return;
        if (QtMocHelpers::indexOfMethod<void (Sessions::*)()>(_a, &Sessions::sessionEnded, 6))
            return;
        if (QtMocHelpers::indexOfMethod<void (Sessions::*)(SessionState )>(_a, &Sessions::newState, 7))
            return;
        if (QtMocHelpers::indexOfMethod<void (Sessions::*)()>(_a, &Sessions::powerOff, 8))
            return;
    }
}

const QMetaObject *Sessions::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *Sessions::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN8SessionsE_t>.strings))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int Sessions::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 11)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 11;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 11)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 11;
    }
    return _id;
}

// SIGNAL 0
void Sessions::setEEGSiteNum(int _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 0, nullptr, _t1);
}

// SIGNAL 1
void Sessions::updateProgress(int _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 1, nullptr, _t1);
}

// SIGNAL 2
void Sessions::writeLog(SessionLog _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 2, nullptr, _t1);
}

// SIGNAL 3
void Sessions::sessionStarted()
{
    QMetaObject::activate(this, &staticMetaObject, 3, nullptr);
}

// SIGNAL 4
void Sessions::sessionPaused()
{
    QMetaObject::activate(this, &staticMetaObject, 4, nullptr);
}

// SIGNAL 5
void Sessions::sessionResumed()
{
    QMetaObject::activate(this, &staticMetaObject, 5, nullptr);
}

// SIGNAL 6
void Sessions::sessionEnded()
{
    QMetaObject::activate(this, &staticMetaObject, 6, nullptr);
}

// SIGNAL 7
void Sessions::newState(SessionState _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 7, nullptr, _t1);
}

// SIGNAL 8
void Sessions::powerOff()
{
    QMetaObject::activate(this, &staticMetaObject, 8, nullptr);
}
QT_WARNING_POP
