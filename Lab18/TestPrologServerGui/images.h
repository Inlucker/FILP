#ifndef IMAGES_H
#define IMAGES_H

#include <QImage>
#include <QMap>
#include <QString>

#define EMPTY -1
#define WALL -2
#define FINISH -3
#define PORTAL -4
#define PLAYER -5

class Images
{
public:
    Images() = default;

    void load();
	QImage& getImage(const int& imgNumber);

    explicit Images(const Images& imgs); //copy
    Images& operator =(const Images& imgs);

private:
	QMap<int, QImage> images;
};

#endif // IMAGES_H
