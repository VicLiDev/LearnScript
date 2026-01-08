#include <stdio.h>

int dump_info()
{
    printf("======> func:%s line:%d\n", __func__, __LINE__);

    return 0;
}
