#include "mainwindow.h"
#include "ui_mainwindow.h"
#include "Matrix/BaseMtrx.hpp"
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
    //pole_path = vector<Pole>();
    pole_path = vector<BaseMtrx<int>>();

    networkManager = new QNetworkAccessManager();
    // Подключаем networkManager к обработчику ответа
    connect(networkManager, &QNetworkAccessManager::finished, this, &MainWindow::onResult);
    // Получаем данные, а именно JSON файл с сайта по определённому url
    //networkManager->get(QNetworkRequest(QUrl("http://localhost:3000/")));

    pictures = new Images;
    pictures->load();
    left = 18;
    top = 18;
    width = 36*(N);
    height = 36*(N);
    image = new QImage(width, height, QImage::Format_ARGB32);

    busy = false;
    t.release();

    pole = make_shared<BaseMtrx<int>>(5, 5);
    resetPole();

    usualSet();

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

void MainWindow::readJson(QJsonDocument& document)
{
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
            //pole_path.push_back(Pole(pole));
            pole_path.push_back(BaseMtrx<int>(*pole));
        }
    }
}

void MainWindow::readJson2(QJsonDocument &document)
{
    QJsonObject root = document.object();

    ui->textEdit->append(root.keys().at(0) + ": ");
    QJsonValue v1 = root.value("item1");
    ui->textEdit->append(v1.toString( ));

    ui->textEdit->append(root.keys().at(1) + ": ");
    QJsonValue v2 = root.value("item2");
    ui->textEdit->append(v2.toString( ));
}

void MainWindow::readJson3(QJsonDocument &document)
{
    // Забираем из документа корневой объект
    QJsonObject root = document.object();
    ui->textEdit->append(root.keys().at(0) + ": ");

    QJsonValue path = root.value("pole");
    // Если значение является массивом, ...
    if (path.isArray())
    {
        // ... то забираем массив из данного свойства
        QJsonArray jarray = path.toArray();
        // Перебирая все элементы массива ...
        for (int i = 0; i < jarray.count(); i++)
        {
            QJsonObject j_obj = jarray.at(i).toObject();
            //HERE
            ui->textEdit->append(QString::number(j_obj.value("x").toInt()) + " " +
                                 QString::number(j_obj.value("y").toInt()) + " " +
                                 j_obj.value("cell").toString());
            cout << i << endl;
        }
    }
}

void MainWindow::usualSet()
{
    pole = make_shared<BaseMtrx<int>>(5, 5);
    pole->reset(-1);
    setPlayer(0, 1);
    setWall(3, 2, 0);
    setFinish(4, 4);
}

void MainWindow::onResult(QNetworkReply *reply)
{
    qDebug() << "Reply2";
    // Если ошибки отсутсвуют
    if (!reply->error())
    {
        // То создаём объект Json Document, считав в него все данные из ответа
        QJsonDocument document = QJsonDocument::fromJson(reply->readAll());

        readJson(document);
        //readJson3(document);
    }
    reply->deleteLater();
    //busy = false;
    start();
}

void MainWindow::resetPole()
{
    pole->reset(-1);
    /*for (int i = 0; i < N; i++)
        for (int j = 0; j < N; j++)
            pole[i][j] = -1;*/
}

void MainWindow::printPole()
{
    /*for (int i = 0; i < N; i++)
    {
        for (int j = 0; j < N; j++)
            cout << pole[j][i] << " ";
        cout << endl;
    }
    cout << endl;*/
    cout << pole;
}

void MainWindow::setPlayer(int x, int y)
{
    //pole[x][y] = -5;
    (*pole)(x, y) = -5;
}

void MainWindow::setPortal(int x, int y)
{
    //pole[x][y] = -4;
    (*pole)(x, y) = -4;
}

void MainWindow::setWall(int x, int y, int n)
{
    /*if (n == 0)
        pole[x][y] = -2;
    else
        pole[x][y] = n;*/
    if (n == 0)
        (*pole)(x, y) = -2;
    else
        (*pole)(x, y) = n;
}

void MainWindow::setFinish(int x, int y)
{
    //pole[x][y] = -3;
    (*pole)(x, y) = -3;
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
            //painter.drawImage(i * cfx, j * cfy, pictures->getImage(pole[i][j]));
            painter.drawImage(i * cfx, j * cfy, pictures->getImage((*pole)(i, j)));
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

void MainWindow::redraw(BaseMtrx<int> &p)
{
    image->fill(0);
    int w = p.getWidth();
    int h = p.getHeight();
    width = 36*(w);
    height = 36*(h);
    double cfx = 1.0 * 36; //width / SIZE;
    double cfy = 1.0 * 36; //height / SIZE;
    QPainter painter(image);
    for (int i = 0; i < w; i++)
        for (int j = 0; j < h; j++)
        {
            painter.drawImage(i * cfx, j * cfy, pictures->getImage(p(i, j)));
        }
    update();
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

void MainWindow::sendJson()
{
    QNetworkRequest request(QUrl("http://localhost:3000/"));
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    QJsonObject json;
    json.insert("item1", "value1");
    json.insert("item2", "value2");

    //QNetworkAccessManager nam;
    //QNetworkReply *reply = nam.post(request, QJsonDocument(json).toJson());
    QNetworkReply *reply = networkManager->post(request, QJsonDocument(json).toJson());
    qDebug() << "Request";
}

void MainWindow::sendJson2()
{
    //QNetworkAccessManager *networkManager = new QNetworkAccessManager(this);
    const QUrl url(QStringLiteral("http://localhost:3000/"));
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QJsonObject obj;

    obj.insert("item1", "value1");
    obj.insert("item2", "value2");

    //Это не работает
    //obj["item1"] = "value1";
    //obj["item1"] = "value2";

    QJsonDocument doc(obj);
    QByteArray data = doc.toJson();
    // or
    // QByteArray data("{\"key1\":\"value1\",\"key2\":\"value2\"}");
    QNetworkReply *reply = networkManager->post(request, data);
    qDebug() << "Request";
}

void MainWindow::sendPole()
{
    QJsonObject final_obj;
    QJsonArray arr;
    QString x_str("x");
    QString y_str("y");
    QString cell_str("cell");

    int i = 0;
    int j = 0;
    int w = pole->getWidth();
    int h = pole->getHeight();
    for (auto& elem : *pole)
    {
        QJsonObject item_data;

        item_data.insert(x_str, QJsonValue(i));
        item_data.insert(y_str, QJsonValue(j++));
        if (elem == -5)
            item_data.insert(cell_str, QJsonValue("player"));
        else if (elem == -3)
            item_data.insert(cell_str, QJsonValue("finish"));
        else if (elem == -2)
            item_data.insert(cell_str, QJsonValue("block1"));
        else
            item_data.insert(cell_str, QJsonValue("empty"));

        arr.push_back(QJsonValue(item_data));
        if (j == w)
        {
            j = 0;
            i++;
        }
    }
    final_obj.insert(QString("pole"), QJsonValue(arr));
    final_obj.insert(QString("width"), QJsonValue(w));
    final_obj.insert(QString("height"), QJsonValue(h));

    const QUrl url(QStringLiteral("http://localhost:3000/"));
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    QJsonDocument doc(final_obj);
    QByteArray data = doc.toJson();
    // or
    // QByteArray data("{\"key1\":\"value1\",\"key2\":\"value2\"}");
    QNetworkReply *reply = networkManager->post(request, data);
    qDebug() << "Request";
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


void MainWindow::on_sendJson_btn_clicked()
{
    usualSet();
    sendPole();
}

