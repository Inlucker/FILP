#include "pole.h"

Pole::Pole(int p[5][5])
{
    for (int i = 0; i < 5; i++)
        for (int j = 0; j < 5; j++)
            pole[i][j] = p[i][j];
}

void Pole::reset()
{
    for (int i = 0; i < 5; i++)
        for (int j = 0; j < 5; j++)
            pole[i][j] = -1;
}

int& Pole::operator ()(int i, int j)
{
    return pole[i][j];
}
