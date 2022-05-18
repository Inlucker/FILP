#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include "images.h"
#include "pole.h"
#include "Matrix/BaseMtrx.h"
#include "SetupPoleWindow.h"

#include <QMainWindow>
#include <QNetworkAccessManager>
#include <iostream>
#include <thread>
#include <mutex>
#include <memory>

using namespace std;

#define N 5
#define SIZE 5.
#define SIZE_X SIZE
#define SIZE_Y SIZE

QT_BEGIN_NAMESPACE
namespace Ui { class MainWindow; }
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

protected:
    void paintEvent(QPaintEvent* pEvent);

private slots:
    // Обработчик данных полученных от объекта QNetworkAccessManager
    void onResult(QNetworkReply *reply);

    void on_pushButton_clicked();

    void on_sendJson_btn_clicked();

    void on_set_usual_btn_clicked();

    void on_set_usual_btn_2_clicked();

    void on_set_usual_btn_3_clicked();

    void on_set_usual_btn_4_clicked();

    void on_setup_pole_window_btn_clicked();

private:
    void resetPole();
    void printPole();
    void setPlayer(int x, int y);
    void setPortal(int x, int y);
    void setWall(int x, int y, int n);
    void setFinish(int x, int y);
    void redraw();
    void redraw(Pole& p);
    void redraw(BaseMtrx<int>& p);
    void start();

    void sendJson();
    void sendJson2();
    void sendPole();
    void readJson(QJsonDocument &document);
    void readJson2(QJsonDocument &document);
    void readJson3(QJsonDocument &document);

    void usualSet();
    void usualSet2();
    void usualSet3();
    void usualSet4();
    //void threadFunc();

    void updateSize(int n);

private slots:
    void redrawSlot();

    void on_edit_pole_window_btn_clicked();

private:
    Ui::MainWindow *ui;
    QNetworkAccessManager *networkManager;
    string port = "1234";
    shared_ptr<Images> pictures;
    //int pole[N][N];
    shared_ptr<BaseMtrx<int>> pole;
    shared_ptr<QImage> image;
    int left, top, my_width, my_height;
    //vector<Pole> pole_path;
    vector<BaseMtrx<int>> pole_path;
    bool busy = false;
    mutex m1, m2, m3;
    unique_ptr<std::thread> t;

    unique_ptr<SetupPoleWindow> setup_pole_window;
};
#endif // MAINWINDOW_H
