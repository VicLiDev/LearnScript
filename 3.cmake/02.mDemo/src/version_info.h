#ifndef __VERSION_INFO_H__
#define __VERSION_INFO_H__

/*
 * 版本信息持久化接口 (仿 mpp/mpp_info.h)
 *
 * 把 CMake 生成的三套版本信息统一落地为 static const 全局变量
 * (见 version_info.c)，字符串进 .rodata，无论是否被调用都一定存在于
 * 二进制中 —— 可用 `strings <bin> | grep ...` 检索。
 *
 * 三个 method 对应 CMakeLists.txt 里三种版本信息生成方式:
 *   method 1: git_version.h              (ver1, FILE WRITE)
 *   method 2: config.h 的 VER_INFO       (ver2, configure_file)
 *   method 3: config.h 的 GIT_VER_HIST_* (ver3, configure_file @ONLY)
 */

/* ---- method 1: git_version.h 的分字段版本信息 ---- */
void show_version(void);
const char *get_version(void);

/* ---- method 2: config.h 的单条版本 log (VER_INFO) ---- */
void show_version_log(void);

/* ---- method 3: config.h 的版本历史 log (GIT_VER_HIST_0..9) ---- */
void show_version_history(void);

#endif /* __VERSION_INFO_H__ */
