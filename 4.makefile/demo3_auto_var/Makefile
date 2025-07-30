# Makefile —— 多目标文件 & 自动变量演示

CC := gcc
CFLAGS := -Wall -g -Iinclude

SRC_DIR := src
OBJ_DIR := build
TARGET := app

# 找出所有 .c 源文件
SRCS := $(wildcard $(SRC_DIR)/*.c)

# 把 src/main.c 转换成 build/main.o 等
OBJS := $(patsubst $(SRC_DIR)/%.c, $(OBJ_DIR)/%.o, $(SRCS))

$(info SRCS: $(SRCS))
$(info OBJS: $(OBJS))

# 默认目标
all: $(TARGET)

# 目标可执行文件依赖所有中间文件（.o）
$(TARGET): $(OBJS)
	@echo "链接目标: $@"
	@echo "链接依赖: $^"
	$(CC) $(CFLAGS) -o $@ $^

# 为每个 .o 文件设置规则，从 .c 编译
# 单独使用 $(OBJ_DIR) 的存在前置规则，避免 order-only 混用出错
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(OBJ_DIR)
	@###############################################################################
	@# 自动变量说明：
	@#   $@    → build/main.o（目标）
	@#   $<    → src/main.c（第一个依赖，通常是.c）
	@#   $^    → 所有依赖（无重复）
	@#   $*    → build/main
	@#   $(@F) → main.o
	@#   $(notdir $<) → main.c
	@#   $(basename $<) → src/main
	@###############################################################################
	@echo "------------------------------------------------"
	@echo "OBJ_DIR :          $(OBJ_DIR)"
	@echo "SRC_DIR :          $(SRC_DIR)"
	@echo "目标文件:          $@"
	@echo "目标名（无路径）:  $(@F)"
	@echo "目标前缀 ($*):     $*"
	@echo "第一个依赖文件:    $<"
	@echo "依赖目录路径:      $(dir $<)"
	@echo "依赖文件名:        $(notdir $<)"
	@echo "依赖主名:          $(basename $<)"
	@echo "依赖扩展名:        $(suffix $<)"
	@echo "------------------------------------------------"
	$(CC) $(CFLAGS) -c $< -o $@

# 清理目标
clean:
	rm -rf $(OBJ_DIR) $(TARGET)

.PHONY: all clean

