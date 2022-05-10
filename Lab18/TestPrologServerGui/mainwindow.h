#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include "images.h"
#include "pole.h"

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

private:
    void resetPole();
    void printPole();
    void setPlayer(int x, int y);
    void setPortal(int x, int y);
    void setWall(int x, int y, int n);
    void setFinish(int x, int y);
    void redraw();
    void redraw(Pole& p);
    void start();

    //void threadFunc();

private:
    Ui::MainWindow *ui;
    QNetworkAccessManager *networkManager;
    Images* pictures;
    int pole[N][N];
    QImage* image;
    int left, top, width, height;
    vector<Pole> pole_path;
    bool busy = true;
    mutex m1, m2, m3;
    unique_ptr<std::thread> t;
    std::vector<std::exception_ptr>  g_exceptions;
};
#endif // MAINWINDOW_H
