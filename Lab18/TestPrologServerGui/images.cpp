#include "images.h"

void Images::load()
{
	images.insert(-1, QImage("PICTURES/empty_tile.png"));
    images.insert(-2, QImage("PICTURES/wall_tile.png"));
    images.insert(-3, QImage("PICTURES/finish_tile.png"));
    images.insert(-4, QImage("PICTURES/portal_tile.png"));
    images.insert(-5, QImage("PICTURES/player1.png"));
    for (int i = 0; i < 16; i++)
        images.insert(i, QImage("PICTURES/figure" + QString::number(i) + ".png"));
}

QImage& Images::getImage(const int& imgNumber)
{
	QMap<int, QImage>::iterator i = images.find(imgNumber);
	if (i == images.end())
		throw 1;
    return i.value();
}

Images::Images(const Images &imgs)
{
    this->images = imgs.images;
}

Images &Images::operator =(const Images &imgs)
{
    this->images = imgs.images;
}
