#include "SetupPoleWindow.h"
#include "ui_SetupPoleWindow.h"
#include "Matrix/BaseMtrx.hpp"

#include <QPainter>

SetupPoleWindow::SetupPoleWindow(QWidget *parent, int w, int h, shared_ptr<Images> imgs) :
    QWidget(parent),
    ui(new Ui::SetupPoleWindow)
{
    ui->setupUi(this);

    setImages(imgs);
    pole = make_shared<BaseMtrx<int>>(my_width, my_height);
    pole->reset(-1);
    btn = make_shared<QPushButton>("Set Pole", this);
    btn->setFixedSize(200, 36);
    updateSize(w, h);
}

SetupPoleWindow::~SetupPoleWindow()
{
    delete ui;
}

void SetupPoleWindow::updateSize(int w, int h)
{
    my_width = w;
    my_height = h;
    updateSize();
}

void SetupPoleWindow::setImages(shared_ptr<Images> imgs)
{
    if (imgs)
        pictures = imgs;
    else
    {
        pictures = make_shared<Images>();
        pictures->load();
    }
}

void SetupPoleWindow::setPole(shared_ptr<BaseMtrx<int>> p)
{
    pole = p;
    updateSize(pole->getWidth(), pole->getHeight());
    //redrawPole();
}

void SetupPoleWindow::mouseReleaseEvent(QMouseEvent *event)
{
    if (event->button() == Qt::LeftButton)
    {
        LMB_is_pressed = false;
        holding = -10;
        update();
    }

    if (event->button() == Qt::RightButton)
        RMB_is_pressed = false;
}

void SetupPoleWindow::mousePressEvent(QMouseEvent *event)
{
    if (event->button() == Qt::LeftButton && !LMB_is_pressed && this->rect().contains(event->pos()))
    {
        LMB_is_pressed = true;
        holding = getHolding(event->position().x(),event->position().y());
        //if (isInCell(event->position().x(),event->position().y(), empty_x, empty_y)
        //if (clicked_player())
    }

    if (event->button() == Qt::RightButton && !RMB_is_pressed && this->rect().contains(event->pos()))
        RMB_is_pressed = true;
}

void SetupPoleWindow::mouseMoveEvent(QMouseEvent *event)
{
    //cout << "Holding = " << holding << endl;
    mouse_x = event->position().x();
    mouse_y = event->position().y();
    if (LMB_is_pressed && holding != -10)
    {
        update();
        //drawHoldingCell(mouse_x, mouse_y);
    }
}

void SetupPoleWindow::paintEvent(QPaintEvent *pEvent)
{
    image->fill(0);
    drawPole();
    drawCells();
    drawHoldingCell(mouse_x, mouse_y);

    QPainter painter(this);
    painter.drawImage(18, 18, *image);
}

void SetupPoleWindow::updateSize()
{
    this->setFixedHeight(max(360+36+72, (36 * (my_height + 1) + 72)));
    this->setFixedWidth(max(200 + 36 , (36 * (my_width + 1) + 72)));
    image = make_shared<QImage>(max(0, (my_width+2)*36), max(360, my_height*36), QImage::Format_ARGB32);

    btn->setGeometry(18, this->height() - 54, 200, 36);
    updatePole();
}

void SetupPoleWindow::updatePole()
{
    int w = pole->getWidth();
    double cfx = 1.0 * 36;
    double cfy = 1.0 * 36;

    empty_x = w * cfx + 36, empty_y = 0 * (18 + cfy);
    player_x = w * cfx + 36, player_y = 1 * (18 + cfy);
    finish_x = w * cfx + 36, finish_y = 2 * (18 + cfy);
    wall1_x = w * cfx + 36, wall1_y = 3 * (18 + cfy);
    wall2_x = w * cfx + 36, wall2_y = 4 * (18 + cfy);
    wall4_x = w * cfx + 36, wall4_y = 5 * (18 + cfy);
    portal_x = w * cfx + 36, portal_y = 6 * (18 + cfy);

    update();
}

bool SetupPoleWindow::isInCell(int x, int y, int cell_x, int cell_y)
{
    //cout << "X = " << x << "; Y = " << y << "; cell_x = " << cell_x << "; cell_y = " << cell_y << endl;
    bool res = (x >= cell_x && x <= cell_x + cell_size &&
                y >= cell_y && y <= cell_y + cell_size);
    return res;
}

bool SetupPoleWindow::isInPole(qreal x, qreal y)
{
    bool res = (x >= 0 && x <= my_width*cell_size &&
                y >= 0 && y <= my_height*cell_size);
    return res;
}

int SetupPoleWindow::getHolding(int x, int y)
{
    x -= left;
    y -= top;
    if (isInCell(x, y, empty_x, empty_y))
        return EMPTY;
    else if (isInCell(x, y, player_x, player_y))
        return PLAYER;
    else if (isInCell(x, y, finish_x, finish_y))
        return FINISH;
    else if (isInCell(x, y, wall1_x, wall1_y))
        return WALL;
    else if (isInCell(x, y, wall2_x, wall2_y))
        return 2;
    else if (isInCell(x, y, wall4_x, wall4_y))
        return 4;
    else if (isInCell(x, y, portal_x, portal_y))
        return 4;
    else
        return -10;
}

void SetupPoleWindow::drawPole()
{
    int w = pole->getWidth();
    int h = pole->getHeight();
    double cfx = 1.0 * 36;
    double cfy = 1.0 * 36;
    QPainter painter(image.get());
    for (int i = 0; i < w; i++)
        for (int j = 0; j < h; j++)
        {
            painter.drawImage(i * cfx, j * cfy, pictures->getImage((*pole)(i, j)));
        }
}

void SetupPoleWindow::drawCells()
{
    QPainter painter(image.get());
    painter.drawImage(empty_x, empty_y, pictures->getImage(EMPTY));
    painter.drawImage(player_x, player_y, pictures->getImage(PLAYER));
    painter.drawImage(finish_x, finish_y, pictures->getImage(FINISH));
    painter.drawImage(wall1_x, wall1_y, pictures->getImage(WALL));
    painter.drawImage(wall2_x, wall2_y, pictures->getImage(2));
    painter.drawImage(wall4_x, wall4_y, pictures->getImage(4));
    painter.drawImage(portal_x, portal_y, pictures->getImage(PORTAL));
}

void SetupPoleWindow::drawHoldingCell(qreal x, qreal y)
{
    x -= left;
    y -= top;
    if (holding != -10)
    {
        QPainter painter(image.get());
        if (isInPole(x, y))
        {
            QPoint res;
            int pole_x = int(x/cell_size);
            int pole_y = int(y/cell_size);
            res.setX(cell_size * pole_x);
            res.setY(cell_size * pole_y);
            painter.drawImage(res, pictures->getImage(holding));
        }
        else
            painter.drawImage(x-cell_size/2, y-cell_size/2, pictures->getImage(holding));
    }
}





