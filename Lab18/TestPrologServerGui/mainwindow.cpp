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
    left = 18;
    top = 18;
    width = 36*(N);
    height = 36*(N);
    image = new QImage(width, height, QImage::Format_ARGB32);

    t.release();

    resetPole();
    redraw();
}

MainWindow::~MainWindow()
{
    delete ui;
    delete networkManager;
    delete pictures;
    delete image;
    t.release();
}

void MainWindow::paintEvent(QPaintEvent *pEvent)
{
    //cout << pthread_self() << endl;
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
    }
    reply->deleteLater();
    busy = false;
    start();
}

void MainWindow::resetPole()
{
    for (int i = 0; i < N; i++)
        for (int j = 0; j < N; j++)
            pole[i][j] = -1;
}

void MainWindow::printPole()
{
    for (int i = 0; i < N; i++)
    {
        for (int j = 0; j < N; j++)
            cout << pole[j][i] << " ";
        cout << endl;
    }
    cout << endl;
}

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
    double cfx = 1.0 * width / SIZE;
    double cfy = 1.0 * height / SIZE;
    for (int i = 0; i < N; i++)
        for (int j = 0; j < N; j++)
        {
            painter.drawImage(i * cfx, j * cfy, pictures->getImage(pole[i][j]));
        }
    this->update();
}

void MainWindow::redraw(Pole &p)
{
    image->fill(0);
    double cfx = 1.0 * width / SIZE;
    double cfy = 1.0 * height / SIZE;
    QPainter painter(image);
    for (int i = 0; i < N; i++)
        for (int j = 0; j < N; j++)
        {
            painter.drawImage(i * cfx, j * cfy, pictures->getImage(p(i, j)));
        }
    update(); //JUST DO NOT repaint() HERE :D
}

void MainWindow::start()
{
    if (!busy)
    {
        busy = true;
        t.release();
        t = make_unique<std::thread>([&]()
        {
            for (auto& p : pole_path)
            {
                this_thread::sleep_for(chrono::seconds(1));
                redraw(p);
            }

            busy = false;
        });
    }
}

/*void MainWindow::threadFunc()
{
    cout << pthread_self() << endl;
    m2.lock();
    for (auto& p : pole_path)
    {
        this_thread::sleep_for(chrono::seconds(1));
        redraw(p);
    }
    m2.unlock();

    m1.lock();
    busy = false;
    m1.unlock();
}*/


void MainWindow::on_pushButton_clicked()
{
    start();
}

