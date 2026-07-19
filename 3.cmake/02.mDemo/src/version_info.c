/*************************************************************************
  > File Name: version_info.c
  > 参考: mpp/mpp/mpp_info.c
  > 描述: 把 CMake 三种方式生成的 git/build 版本信息统一落地为 static const
  >       全局变量，字符串作为初值直接落进 .rodata，实现版本信息「持久化」
  >       嵌入二进制。即使没有任何函数引用，只要本文件被编译链接进 demo，
  >       字符串就一定保留 —— 可被 strings 检索。
  >
  >       三个 method 对应 CMakeLists.txt 三种版本信息生成方式:
  >         method 1: git_version.h              (ver1, FILE WRITE)
  >         method 2: config.h 的 VER_INFO       (ver2, configure_file)
  >         method 3: config.h 的 GIT_VER_HIST_* (ver3, configure_file @ONLY)
 ************************************************************************/

#include <stdio.h>
#include "git_version.h"   /* method 1 数据源 (ver1, FILE WRITE 生成) */
#include "config.h"        /* method 2/3 数据源 (ver2/ver3, configure_file 生成) */
#include "version_info.h"

/* =====================================================================
 * method 1: git_version.h 的分字段版本信息
 *   来源: CMakeLists.txt ver1 (FILE WRITE 生成 git_version.h)
 *   宏:   GIT_VER / GIT_AUTHOR / GIT_DATE / GIT_HASH / GIT_BRANCH /
 *         GIT_COMMIT_CNT / GIT_TIME_ISO / GIT_DIRTY / GIT_REMOTE + BUILD_*
 *
 *   关键: `static const char[]`（数组而非指针）把字符串字面量作为初值直接
 *   嵌进 .rodata。仿 mpp/mpp_info.c 的:
 *     static const char mpp_version[] = MPP_VERSION;
 * ===================================================================== */
static const char m1_ver[]      = GIT_VER;
static const char m1_author[]   = GIT_AUTHOR;
static const char m1_date[]     = GIT_DATE;
static const char m1_hash[]     = GIT_HASH;
static const char m1_branch[]   = GIT_BRANCH;
static const int  m1_commit_cnt = GIT_COMMIT_CNT;
static const char m1_time_iso[] = GIT_TIME_ISO;
static const int  m1_dirty      = GIT_DIRTY;
static const char m1_remote[]   = GIT_REMOTE;
/* method 1 的构建环境信息 */
static const char m1_build_host[]     = BUILD_HOST;
static const char m1_build_user[]     = BUILD_USER;
static const char m1_build_time[]     = BUILD_TIME;
static const char m1_build_os[]       = BUILD_OS;
static const char m1_build_compiler[] = BUILD_COMPILER;
static const char m1_build_type[]     = BUILD_TYPE;

/* =====================================================================
 * method 2: config.h 的 VER_INFO (单条版本 log)
 *   来源: CMakeLists.txt ver2 (configure_file config.h.in)
 *   宏:   VER_INFO  (格式 "%h author: %<|(30)%an %cd %s %d")
 * ===================================================================== */
static const char m2_ver_log[] = VER_INFO;

/* =====================================================================
 * method 3: config.h 的 GIT_VER_HIST_0..9 (版本历史 log)
 *   来源: CMakeLists.txt ver3 (configure_file config.h.in @ONLY)
 *   宏:   GIT_VERSION / GIT_VER_HIST_CNT / GIT_VER_HIST_0..9
 *
 *   仿 mpp/mpp_info.c 的指针数组:
 *     static const char *mpp_history[] = { MPP_VER_HIST_0, ... };
 *   每个元素指向 .rodata 里的字符串字面量；git 历史不足 10 条时,
 *   未取到的项为 NULL, 由 m3_hist_cnt 限定循环范围。
 * ===================================================================== */
static const char *m3_history[] = {
    GIT_VER_HIST_0, GIT_VER_HIST_1, GIT_VER_HIST_2, GIT_VER_HIST_3,
    GIT_VER_HIST_4, GIT_VER_HIST_5, GIT_VER_HIST_6, GIT_VER_HIST_7,
    GIT_VER_HIST_8, GIT_VER_HIST_9,
};
static const int m3_hist_cnt = GIT_VER_HIST_CNT;

/* ---- method 1: 打印分字段版本信息 ---- */
void show_version(void)
{
    printf("version: %s\n", m1_ver);
    printf("author:  %s\n", m1_author);
    printf("date:    %s\n", m1_date);
    printf("hash:    %s\n", m1_hash);
    printf("branch:  %s\n", m1_branch);
    printf("commits: %d\n", m1_commit_cnt);
    printf("time:    %s\n", m1_time_iso);
    printf("dirty:   %s\n", m1_dirty ? "yes" : "no");
    printf("remote:  %s\n", m1_remote);
    printf("-- build info --\n");
    printf("host:     %s\n", m1_build_host);
    printf("user:     %s\n", m1_build_user);
    printf("built:    %s\n", m1_build_time);
    printf("os:       %s\n", m1_build_os);
    printf("compiler: %s\n", m1_build_compiler);
    printf("type:     %s\n", m1_build_type);
}

const char *get_version(void)
{
    return m1_ver;
}

/* ---- method 2: 打印单条版本 log (VER_INFO) ---- */
void show_version_log(void)
{
    printf("ver_log: %s\n", m2_ver_log);
}

/* ---- method 3: 打印版本历史 log (GIT_VER_HIST_0..9) ---- */
void show_version_history(void)
{
    int i;
    int n   = m3_hist_cnt;
    int cap = (int)(sizeof(m3_history) / sizeof(m3_history[0]));
    if (n > cap)            /* 防御: cnt 不超过数组容量 */
        n = cap;
    for (i = 0; i < n; i++)
        if (m3_history[i])  /* 跳过 git 历史不足时未取到的 NULL 项 */
            printf("%s\n", m3_history[i]);
}
