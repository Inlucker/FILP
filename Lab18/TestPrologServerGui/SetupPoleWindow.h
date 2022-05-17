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
    virtual void mouseMoveEvent(QMouseEvent *event);
    void paintEvent(QPaintEvent* pEvent);

private:
    void updateSize();
    void updatePole();
    bool isInCell(int x, int y, int cell_x, int cell_y);
    int getHolding(int x, int y);

    void drawPole();
    void drawCells();
    void drawHoldingCell(qreal x, qreal y);

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

    int cell_size = 36;
    int empty_x = 0, empty_y = 0;
    int player_x = 0, player_y = 0;
    int finish_x = 0, finish_y = 0;
    int wall1_x = 0, wall1_y = 0;
    int wall2_x = 0, wall2_y = 0;
    int wall4_x = 0, wall4_y = 0;
    int portal_x = 0, portal_y = 0;
    int holding = -10;

    qreal mouse_x = 0, mouse_y = 0;
};

#endif // SETUPPOLEWINDOW_H
