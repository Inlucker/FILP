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

    //btn->show();
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
        LMB_is_pressed = false;

    if (event->button() == Qt::RightButton)
        RMB_is_pressed = false;
}

void SetupPoleWindow::mousePressEvent(QMouseEvent *event)
{
    if (event->button() == Qt::LeftButton && !LMB_is_pressed && this->rect().contains(event->pos()))
    {
        LMB_is_pressed = true;
        //if (clicked_player())
    }

    if (event->button() == Qt::RightButton && !RMB_is_pressed && this->rect().contains(event->pos()))
        RMB_is_pressed = true;
}

void SetupPoleWindow::paintEvent(QPaintEvent *pEvent)
{
    QPainter painter(this);
    painter.drawImage(18, 18, *image);
}

void SetupPoleWindow::updateSize()
{
    this->setFixedHeight(max(360+36+72, (36 * (my_height + 1) + 72)));
    this->setFixedWidth(max(200 + 36 , (36 * (my_width + 1) + 72)));
    image = make_shared<QImage>(max(0, (my_width+2)*36), max(360, my_height*36), QImage::Format_ARGB32);

    btn->setGeometry(18, this->height() - 54, 200, 36);
    redrawPole();
}

void SetupPoleWindow::redrawPole()
{
    image->fill(0);
    int w = pole->getWidth();
    int h = pole->getHeight();
    //width = 36*(w);
    //height = 36*(h);
    double cfx = 1.0 * 36;
    double cfy = 1.0 * 36;
    QPainter painter(image.get());
    for (int i = 0; i < w; i++)
        for (int j = 0; j < h; j++)
        {
            painter.drawImage(i * cfx, j * cfy, pictures->getImage((*pole)(i, j)));
        }

    //redrawCells();
    painter.drawImage(w * cfx + 36, 0 * (18 + cfy), pictures->getImage(7));
    painter.drawImage(w * cfx + 36, 1 * (18 + cfy), pictures->getImage(PLAYER));
    painter.drawImage(w * cfx + 36, 2 * (18 + cfy), pictures->getImage(FINISH));
    painter.drawImage(w * cfx + 36, 3 * (18 + cfy), pictures->getImage(WALL));
    painter.drawImage(w * cfx + 36, 4 * (18 + cfy), pictures->getImage(2));
    painter.drawImage(w * cfx + 36, 5 * (18 + cfy), pictures->getImage(4));
    painter.drawImage(w * cfx + 36, 6 * (18 + cfy), pictures->getImage(PORTAL));

    update();
}
