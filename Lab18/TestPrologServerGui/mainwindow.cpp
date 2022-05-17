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
#include <QMessageBox>

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

    //pictures = new Images;
    pictures = make_shared<Images>();
    pictures->load();
    left = 18;
    top = 18;
    my_width = 36*(N);
    my_height = 36*(N);
    image = make_shared<QImage>(my_width, my_height, QImage::Format_ARGB32);
    //image = new QImage(width, height, QImage::Format_ARGB32);

    setup_pole_window = make_unique<SetupPoleWindow>();

    busy = false;
    t.release();

    pole = make_shared<BaseMtrx<int>>(5, 5);
    resetPole();

    usualSet();

    redraw();

    ui->pushButton->hide();
}

MainWindow::~MainWindow()
{
    delete ui;
    delete networkManager;
    //delete pictures;
    //delete image;
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
    pole_path.clear();
    // Забираем из документа корневой объект
    QJsonObject root = document.object();
    ui->textEdit->append(root.keys().at(0) + ": ");

    QJsonValue path = root.value("pole");
    // Если значение является массивом, ...
    if (path.isArray())
    {
        resetPole();
        ui->textEdit->clear();
        // ... то забираем массив из данного свойства
        QJsonArray jarray = path.toArray();
        // Перебирая все элементы массива ...
        for (int i = 0; i < jarray.count(); i++)
        {
            resetPole();
            QJsonObject jpole = jarray.at(i).toObject();

            //portals
            ui->textEdit->append(jpole.keys().at(2) + ": ");
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
            ui->textEdit->append(jpole.keys().at(3) + ": ");
            QJsonArray walls = jpole.value("walls").toArray();
            for (int j = 0; j < walls.count(); j++)
            {
                 QJsonObject wall = walls.at(j).toObject();
                 setWall(wall.value("x").toInt(), wall.value("y").toInt(), wall.value("n").toInt());
                 ui->textEdit->append(QString::number(wall.value("x").toInt()) + " " +
                                      QString::number(wall.value("y").toInt()) + " " +
                                      QString::number(wall.value("n").toInt()));
            }

            //player
            ui->textEdit->append(jpole.keys().at(1) + ": ");
            QJsonObject player = jpole.value("player").toObject();
            setPlayer(player.value("x").toInt(), player.value("y").toInt());
            ui->textEdit->append(QString::number(player.value("x").toInt()) + " " + QString::number(player.value("y").toInt()) + "\n");

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
    int n = 5;
    pole = make_shared<BaseMtrx<int>>(n, n);
    my_width = 36*(n);
    my_height = 36*(n);
    image = make_shared<QImage>(my_width, my_height, QImage::Format_ARGB32);
    pole->reset(-1);
    setPlayer(0, 1);
    //setPlayer(4, 3);
    setWall(3, 2, 0);
    setWall(1, 2, 2);
    setWall(3, 3, 4);
    setPortal(2, 1);
    setPortal(1, 3);
    setFinish(4, 4);
}

void MainWindow::usualSet2()
{
    int n = 3;
    pole = make_shared<BaseMtrx<int>>(n, n);
    my_width = 36*(n);
    my_height = 36*(n);
    image = make_shared<QImage>(my_width, my_height, QImage::Format_ARGB32);
    pole->reset(-1);
    setPlayer(0, 1);
    //setPlayer(4, 3);
    //setWall(3, 2, 0);
    //setWall(1, 2, 2);
    //setWall(3, 3, 4);
    //setPortal(2, 1);
    //setPortal(1, 3);
    //setFinish(2, 2);
    setFinish(0, 2);
    //setFinish(4, 4);
}

void MainWindow::usualSet3()
{
    int n = 2;
    pole = make_shared<BaseMtrx<int>>(n, n);
    my_width = 36*(n);
    my_height = 36*(n);
    image = make_shared<QImage>(my_width, my_height, QImage::Format_ARGB32);
    pole->reset(-1);
    setPlayer(0, 0);
    setFinish(1, 0);
}

void MainWindow::usualSet4()
{int n = 2;
    pole = make_shared<BaseMtrx<int>>(n, n);
    my_width = 36*(n);
    my_height = 36*(n);
    image = make_shared<QImage>(my_width, my_height, QImage::Format_ARGB32);
    pole->reset(-1);
    setPlayer(0, 0);
    setFinish(0, 1);
}

void MainWindow::onResult(QNetworkReply *reply)
{
    try
    {
        // Если ошибки отсутсвуют
        if (!reply->error())
        {
            qDebug() << "Reply";
            // То создаём объект Json Document, считав в него все данные из ответа
            QJsonDocument document = QJsonDocument::fromJson(reply->readAll());

            readJson(document);
            //readJson3(document);
        }
        else
        {
            qDebug() << "Reply Error";
        }
        reply->deleteLater();
        //busy = false;
        start();
    }
    catch (BaseError& er)
    {
        QMessageBox::information(this, "Error", er.what());
    }
    catch (...)
    {
        QMessageBox::information(this, "Error", "Unexpected Error");
    }
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
            //painter.drawImage(i * cfx, j * cfy, pictures->getImage(pole[i][j]));
            painter.drawImage(i * cfx, j * cfy, pictures->getImage((*pole)(i, j)));
        }
    this->update();
}

void MainWindow::redraw(Pole &p)
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
            painter.drawImage(i * cfx, j * cfy, pictures->getImage(p(i, j)));
        }
    update(); //JUST DO NOT repaint() HERE :D
}

void MainWindow::redraw(BaseMtrx<int> &p)
{
    image->fill(0);
    int w = p.getWidth();
    int h = p.getHeight();
    //width = 36*(w);
    //height = 36*(h);
    double cfx = 1.0 * 36; //width / SIZE;
    double cfy = 1.0 * 36; //height / SIZE;
    QPainter painter(image.get());
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
                //this_thread::sleep_for(chrono::seconds(1));
                this_thread::sleep_for(chrono::milliseconds(500));
                redraw(p);
            }
            busy = false;
        });
    }
}

void MainWindow::sendJson()
{
    string url_str = "http://localhost:" + port + "/";
    QNetworkRequest request(QUrl(QString::fromStdString(url_str)));
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
    //const QUrl url(QStringLiteral("http://localhost:3000/"));
    string url_str = "http://localhost:" + port + "/";
    const QUrl url = QUrl(QString::fromStdString(url_str));
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
        switch (elem)
        {
        case -5:
            item_data.insert(cell_str, QJsonValue("player"));
            break;
        case -3:
            item_data.insert(cell_str, QJsonValue("finish"));
            break;
        case -2:
            item_data.insert(cell_str, QJsonValue("block1"));
            break;
        case -4:
            item_data.insert(cell_str, QJsonValue("portal"));
            break;
        case -1:
            item_data.insert(cell_str, QJsonValue("empty"));
            break;
        /*case 2:
            item_data.insert(cell_str, QJsonValue("block2"));
            break;
        case 4:
            item_data.insert(cell_str, QJsonValue("block4"));
            break;*/
        default:
            string str = "block" + to_string(elem);
            item_data.insert(cell_str, QJsonValue(QString::fromStdString(str)));
            break;
        }
        /*if (elem == -5)
            item_data.insert(cell_str, QJsonValue("player"));
        else if (elem == -3)
            item_data.insert(cell_str, QJsonValue("finish"));
        else if (elem == -2)
            item_data.insert(cell_str, QJsonValue("block1"));
        else
            item_data.insert(cell_str, QJsonValue("empty"));*/

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

    //const QUrl url(QStringLiteral("http://localhost:3000/"));
    string url_str = "http://localhost:" + port + "/";
    const QUrl url = QUrl(QString::fromStdString(url_str));
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
    //usualSet3();
    sendPole();
}


void MainWindow::on_set_usual_btn_clicked()
{
    if (!busy)
    {
        usualSet();
        redraw();
    }
}


void MainWindow::on_set_usual_btn_2_clicked()
{
    if (!busy)
    {
        usualSet2();
        redraw();
    }
}


void MainWindow::on_set_usual_btn_3_clicked()
{
    if (!busy)
    {
        usualSet3();
        redraw();
    }
}


void MainWindow::on_set_usual_btn_4_clicked()
{
    if (!busy)
    {
        usualSet4();
        redraw();
    }
}


void MainWindow::on_setup_pole_window_btn_clicked()
{
    //setup_pole_window = make_unique<SetupPoleWindow>(this, 5, 5);
    setup_pole_window->setPole(pole);
    setup_pole_window->show();
    setup_pole_window->activateWindow();
}

