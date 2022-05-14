QT       += core gui network

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

CONFIG += c++14

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
    Iterator/AbstractIterator.cpp \
    Matrix/AbstractMtrx.cpp \
    images.cpp \
    main.cpp \
    mainwindow.cpp \
    pole.cpp

HEADERS += \
    Errors/BaseError.h \
    Errors/IteratorErrors.h \
    Errors/MtrxErrors.h \
    Iterator/AbstractIterator.h \
    Iterator/BaseIterator.h \
    Iterator/BaseIterator.hpp \
    Iterator/ConstIterator.h \
    Iterator/ConstIterator.hpp \
    Iterator/Iterator.h \
    Iterator/Iterator.hpp \
    Matrix/AbstractMtrx.h \
    Matrix/BaseMtrx.h \
    Matrix/BaseMtrx.hpp \
    images.h \
    mainwindow.h \
    pole.h

FORMS += \
    mainwindow.ui

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
