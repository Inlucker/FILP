#include "mainwindow.h"
#include "ui_mainwindow.h"
//#include "windows.h"

#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QUrlQuery>
#include <QNetworkReply>
#include <QUrl>
#include <QPainter>
#include <iostream>
#include <unistd.h>

using namespace std;

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);

    pole_path = vector<Pole>();

    networkManager = new QNetworkAccessManager();
    // Подключаем networkManager к обработчику ответа
    connect(networkManager, &QNetworkAccessManager::finished, this, &MainWindow::onResult);
    // Получаем данные, а именно JSON файл с сайта по определённому url
    networkManager->get(QNetworkRequest(QUrl("http://localhost:3000/")));

    pictures = new Images;
    pictures->load();
    left = 0;
    top = 0;
    width = 36*6;
    height = 36*6;
    image = new QImage(width, height, QImage::Format_ARGB32);

    resetPole();
    setPlayer(0, 1);
    redraw();
}

MainWindow::~MainWindow()
{
    delete ui;
    delete networkManager;
    delete pictures;
    delete image;
}

void MainWindow::paintEvent(QPaintEvent *pEvent)
{
    QPainter painter(this);
    painter.drawImage(left, top, *image);
}

void MainWindow::onResult(QNetworkReply *reply)
{
    // Если ошибки отсутсвуют
    if (!reply->error())
    {
        // То создаём объект Json Document, считав в него все данные из ответа
        QJsonDocument document = QJsonDocument::fromJson(reply->readAll());

        // Забираем из документа корневой объект
        QJsonObject root = document.object();
        ui->textEdit->append(root.keys().at(0) + ": ");

        QJsonValue path = root.value("pole");
        // Если значение является массивом, ...
        if (path.isArray())
        {
            resetPole();
            // ... то забираем массив из данного свойства
            QJsonArray jarray = path.toArray();
            // Перебирая все элементы массива ...
            for (int i = 0; i < jarray.count(); i++)
            {
                resetPole();
                QJsonObject jpole = jarray.at(i).toObject();

                //portals
                ui->textEdit->append(jpole.keys().at(1) + ": ");
                QJsonArray portals = jpole.value("portals").toArray();
                for (int j = 0; j < portals.count(); j++)
                {
                     QJsonObject portal = portals.at(j).toObject();
                     setPortal(portal.value("x").toInt(), portal.value("y").toInt());
                     ui->textEdit->append(QString::number(portal.value("x").toInt()) + " " + QString::number(portal.value("y").toInt()));
                }

                //finish
                ui->textEdit->append(jpole.keys().at(0) + ": ");
                QJsonObject finish = jpole.value("finish").toObject();
                setFinish(finish.value("x").toInt(), finish.value("y").toInt());
                ui->textEdit->append(QString::number(finish.value("x").toInt()) + " " + QString::number(finish.value("y").toInt()));


                //walls
                ui->textEdit->append(jpole.keys().at(2) + ": ");
                QJsonArray walls = jpole.value("walls").toArray();
                for (int j = 0; j < walls.count(); j++)
                {
                     QJsonObject wall = walls.at(j).toObject();
                     setWall(wall.value("x").toInt(), wall.value("y").toInt(), wall.value("n").toInt());
                     ui->textEdit->append(QString::number(wall.value("x").toInt()) + " " + QString::number(wall.value("y").toInt()));
                }

                //player
                ui->textEdit->append(jpole.keys().at(0) + ": ");
                QJsonObject player = jpole.value("player").toObject();
                setPlayer(player.value("x").toInt(), player.value("y").toInt());
                ui->textEdit->append(QString::number(player.value("x").toInt()) + " " + QString::number(player.value("y").toInt()));

                //printPole();
                pole_path.push_back(Pole(pole));
            }
        }
        // В конце забираем свойство количества сотрудников отдела и также выводим в textEdit
        //ui->textEdit->append(QString::number(root.value("number").toInt()));
    }
    reply->deleteLater();
    //redraw(0);
    start();
}

void MainWindow::resetPole()
{
    for (int i = 0; i < 5; i++)
        for (int j = 0; j < 5; j++)
            pole[i][j] = -1;

    /*pole[3][2] = -2; //block
    pole[1][2] = -2; //block 1/2
    pole[3][3] = -2; //block 1/4
    pole[4][4] = -3; //finish
    pole[2][1] = -4; //portal
    pole[1][3] = -4; //portal*/
}

void MainWindow::printPole()
{
    for (int i = 0; i < 5; i++)
    {
        for (int j = 0; j < 5; j++)
            cout << pole[j][i] << " ";
        cout << endl;
    }
    cout << endl;
}

void MainWindow::setPole(Pole &p)
{
    for (int i = 0; i < 5; i++)
        for (int j = 0; j < 5; j++)
            pole[i][j] = p(i, j);
}

/*void MainWindow::resetPole(int p[5][5])
{
    for (int i = 0; i < 5; i++)
        for (int j = 0; j < 5; j++)
            p[i][j] = -1;
}*/

void MainWindow::setPlayer(int x, int y)
{
    pole[x][y] = -5;
}

void MainWindow::setPortal(int x, int y)
{
    pole[x][y] = -4;
}

void MainWindow::setWall(int x, int y, int n)
{
    if (n == 0)
        pole[x][y] = -2;
    else
        pole[x][y] = n;
}

void MainWindow::setFinish(int x, int y)
{
    pole[x][y] = -3;
}

void MainWindow::redraw()
{
    image->fill(0);
    QPainter painter(image);
    double cfx = 1.0 * width / 5.0;
    double cfy = 1.0 * height / 5.0;
    for (int i = 0; i < 5; i++)
        for (int j = 0; j < 5; j++)
        {
            painter.drawImage(i * cfx, j * cfy, pictures->getImage(pole[i][j]));
        }
    this->update();
}

void MainWindow::redraw(int i)
{
    setPole(pole_path[i]);
    redraw();
}

void MainWindow::redraw(Pole &p)
{
    image->fill(0);
    QPainter painter(image);
    double cfx = 1.0 * width / 5.0;
    double cfy = 1.0 * height / 5.0;
    for (int i = 0; i < 5; i++)
        for (int j = 0; j < 5; j++)
        {
            painter.drawImage(i * cfx, j * cfy, pictures->getImage(p(i, j)));
        }
    //this->update();
    repaint();
}

void MainWindow::start()
{
    for (auto& p : pole_path)
    {
        redraw(p);
        sleep(1);
    }
}


void MainWindow::on_pushButton_clicked()
{
    start();
}

