#ifndef SETUPPOLEWINDOW_H
#define SETUPPOLEWINDOW_H

#include <QWidget>
#include <QKeyEvent>
#include <QPushButton>

#include "Matrix/BaseMtrx.h"
#include "images.h"

namespace Ui {
class SetupPoleWindow;
}

class SetupPoleWindow : public QWidget
{
    Q_OBJECT

public:
    SetupPoleWindow(QWidget *parent = nullptr, int w = 5, int h = 5, shared_ptr<Images> imgs = NULL);
    ~SetupPoleWindow();

    void updateSize(int w, int h);
    void setImages(shared_ptr<Images> imgs);
    void setPole(shared_ptr<BaseMtrx<int>> p);

protected:
    virtual void mouseReleaseEvent(QMouseEvent *event);
    virtual void mousePressEvent(QMouseEvent *event);
    void paintEvent(QPaintEvent* pEvent);

private:
    void updateSize();
    void redrawPole();

private:
    Ui::SetupPoleWindow *ui;

    int left = 18, top = 18;
    int my_width = 5;
    int my_height = 5;

    shared_ptr<Images> pictures;
    shared_ptr<QImage> image;
    shared_ptr<BaseMtrx<int>> pole;

    bool LMB_is_pressed = false;
    bool RMB_is_pressed = false;

    shared_ptr<QPushButton> btn;
};

#endif // SETUPPOLEWINDOW_H
