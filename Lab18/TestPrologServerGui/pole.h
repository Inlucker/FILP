#ifndef POLE_H
#define POLE_H

#include <vector>

using namespace std;

class Pole
{
public:
    Pole() = delete;
    Pole(int p[5][5]);

    void reset();
    int &operator ()(int i, int j);

private:
    int pole[5][5];
};

#endif // POLE_H
