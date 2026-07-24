#!/usr/bin/env python
#########################################################################
# File Name: numpyDemo.py
# Author: LiHongjin
# mail: 872648180@qq.com
# Created Time: Fri  6 Sep 18:15:12 2024
#########################################################################
"""
NumPy 常用 API 演示脚本。

用法:
    python numpyDemo.py              # 运行所有演示
    python numpyDemo.py -s create    # 只运行指定节
    python numpyDemo.py -l           # 列出所有可用节
"""

import argparse
import numpy as np


# ============================================================
#  各演示节
# ============================================================

def demo_create():
    """数组创建: array, arange, linspace, zeros, ones, eye, full, empty, *_like"""
    print("\n===== 数组创建 =====")

    arr = np.array([1, 2, 3, 4, 5])
    print("一维数组:", arr)

    arr_2d = np.array([[1, 2, 3], [4, 5, 6]])
    print("二维数组:\n", arr_2d)

    range_arr = np.arange(0, 10, 2)
    print("arange 数组:", range_arr)

    linspace_arr = np.linspace(0, 10, 5)
    print("linspace 数组:", linspace_arr)

    rows, cols = 6, 9
    objp = np.zeros((rows * cols, 3), np.float32)
    print("zeros (dtype=float32):\n", objp[:3], "... shape:", objp.shape)
    objp[:, :2] = np.mgrid[0:cols, 0:rows].T.reshape(-1, 2)
    print("棋盘格世界坐标(前3点):\n", objp[:3])

    print("ones:\n", np.ones((3, 4), dtype=np.int32))
    print("单位矩阵:\n", np.eye(3, dtype=np.float32))
    full_arr = np.full((2, 3), 7.5)
    print("full(7.5):\n", full_arr)
    print("empty (未初始化):\n", np.empty((2, 3)))
    print("zeros_like(full_arr):\n", np.zeros_like(full_arr))


def demo_dtype():
    """数据类型与属性: dtype, astype, iinfo, finfo"""
    print("\n===== 数据类型与属性 =====")

    print("int64 数组:", np.array([1, 2, 3]).dtype)
    print("float32 数组:", np.array([1, 2, 3], dtype=np.float32).dtype)
    print("bool 数组:", np.array([True, False]).dtype)
    print("float -> int (astype):", np.array([1.7, 2.3, 3.9]).astype(np.int32))
    print("int32 范围:", np.iinfo(np.int32).min, "~", np.iinfo(np.int32).max)
    print("float32 精度:", np.finfo(np.float32).eps)


def demo_random():
    """随机数: random, randn, randint, shuffle, choice"""
    print("\n===== 随机数 =====")

    np.random.seed(42)
    print("random (0~1 均匀):\n", np.random.random((3, 3)))
    print("randn (标准正态):\n", np.random.randn(3, 3))
    print("randint (0~99):\n", np.random.randint(0, 100, (2, 5)))

    arr = np.array([1, 2, 3, 4, 5])
    shuffled = arr.copy()
    np.random.shuffle(shuffled)
    print("shuffle 打乱:", shuffled)
    print("choice (不放回抽3个):", np.random.choice(arr, size=3, replace=False))


def demo_ufunc():
    """基本运算与通用函数: 标量运算, sin, cos, exp, log, sqrt"""
    print("\n===== 基本运算与通用函数 =====")

    arr = np.array([1, 2, 3, 4, 5])
    print("数组加标量:", arr + 5)
    print("数组元素相乘:", arr * arr)

    x_uf = np.array([0, np.pi / 2, np.pi])
    print("sin:", np.sin(x_uf))
    print("cos:", np.cos(x_uf))
    print("exp:", np.exp(np.array([0, 1, 2])))
    print("log:", np.log(np.array([1, np.e, np.e ** 2])))
    print("sqrt:", np.sqrt(np.array([0, 4, 9])))


def demo_index():
    """索引/过滤/条件: 基本索引, 高级索引, 布尔索引, where, select, argwhere, extract, clip, isclose"""
    print("\n===== 索引、过滤与条件 =====")

    arr = np.array([1, 2, 3, 4, 5])
    print("索引第一个元素:", arr[0])
    print("切片 [1:4]:", arr[1:4])

    fancy_arr = np.arange(16).reshape(4, 4)
    print("原数组:\n", fancy_arr)
    print("取第0和第2行:\n", fancy_arr[[0, 2]])
    print("取 (0,1) (2,3) (3,0) 位置:", fancy_arr[[0, 2, 3], [1, 3, 0]])
    print("前3行第1和第3列:\n", fancy_arr[:3, [1, 3]])

    print("大于3的元素:", arr[arr > 3])

    w_arr = np.array([1, 5, 3, 7, 2, 9])
    print("where > 3 返回索引:", np.where(w_arr > 3))
    print("where > 3 取元素:", w_arr[np.where(w_arr > 3)])
    print("where 三目运算 (cond, x, y):", np.where(w_arr > 3, 1, 0))
    print("where 多条件 (2~6):", np.where((w_arr > 2) & (w_arr < 6)))

    conds = [w_arr < 3, (w_arr >= 3) & (w_arr < 7), w_arr >= 7]
    choices = [-1, 0, 1]
    print("select 多条件分桶:", np.select(conds, choices, default=-99))

    aw_arr = np.array([[0, 5, 0], [3, 0, 8], [0, 2, 0]])
    print("argwhere (非零坐标):\n", np.argwhere(aw_arr))
    print("extract (>0):", np.extract(aw_arr > 0, aw_arr))
    print("flatnonzero:", np.flatnonzero(aw_arr))

    print("clip [0, 2]:", np.clip(np.arange(-3, 6), 0, 2))

    a_close = np.array([1.0, 2.0, 3.0])
    b_close = np.array([1.0001, 1.9999, 3.0002])
    print("isclose:", np.isclose(a_close, b_close, atol=1e-3))
    print("allclose (atol=1e-3):", np.allclose(a_close, b_close, atol=1e-3))


def demo_shape():
    """形状与维度操作: reshape, newaxis, expand_dims, squeeze, flatten, ravel, transpose, rot90, roll"""
    print("\n===== 形状与维度操作 =====")

    arr_2d = np.array([[1, 2, 3], [4, 5, 6]])
    print("reshape (1,6):\n", arr_2d.reshape(1, 6))
    print("reshape (-1, 1):\n", np.arange(6).reshape(-1, 1))

    dim_arr = np.array([1, 2, 3])
    print("newaxis 列向量 shape:", dim_arr[:, np.newaxis].shape)
    print("newaxis 行向量 shape:", dim_arr[np.newaxis, :].shape)
    print("expand_dims axis=1 shape:", np.expand_dims(dim_arr, axis=1).shape)

    sq_arr = np.array([[[1], [2], [3]]])
    print("原 shape:", sq_arr.shape, "-> squeeze:", np.squeeze(sq_arr).shape)

    multi_arr = np.arange(6).reshape(2, 3)
    print("flatten:", multi_arr.flatten())
    print("ravel:", multi_arr.ravel())

    t_arr = np.arange(6).reshape(2, 3)
    print("原数组 (2,3):\n", t_arr)
    print("transpose .T (3,2):\n", t_arr.T)
    print("swapaxes 指定轴:\n", np.transpose(t_arr, axes=(1, 0)))

    r_arr = np.array([[1, 2, 3], [4, 5, 6]])
    print("rot90 逆时针:\n", np.rot90(r_arr))
    print("roll +2:", np.roll(np.array([1, 2, 3, 4, 5]), shift=2))


def demo_broadcast():
    """广播: 形状兼容, broadcast_to, broadcast_arrays"""
    print("\n===== 广播 =====")

    arr_5x1 = np.array([[1], [2], [3], [4], [5]])
    arr_1x3 = np.array([[1, 2, 3]])
    print("广播乘法 (5,1) * (1,3):\n", arr_5x1 * arr_1x3)

    small_br = np.array([1, 2, 3])[:, np.newaxis]
    print("broadcast_to (3,1) -> (3,4):\n", np.broadcast_to(small_br, (3, 4)))

    a_br = np.array([1, 2, 3]).reshape(3, 1)
    b_br = np.array([10, 20, 30, 40])
    bca, bcb = np.broadcast_arrays(a_br, b_br)
    print("broadcast_arrays shapes:", bca.shape, bcb.shape)


def demo_stack():
    """拼接/分割/修改: concatenate, v/h/dstack, column_stack, r_/c_, vsplit/hsplit, tile, repeat, pad, delete, insert, append"""
    print("\n===== 拼接、分割与修改 =====")

    a1 = np.array([[1, 2], [3, 4]])
    a2 = np.array([[5, 6], [7, 8]])

    print("concatenate axis=0:\n", np.concatenate((a1, a2), axis=0))
    print("concatenate axis=1:\n", np.concatenate((a1, a2), axis=1))
    print("vstack:\n", np.vstack((a1, a2)))
    print("hstack:\n", np.hstack((a1, a2)))
    print("dstack:\n", np.dstack((a1, a2)))
    print("column_stack:\n", np.column_stack((np.array([1, 2, 3]), np.array([4, 5, 6]))))

    print("r_[0:3, 7:10]:", np.r_[0:3, 7:10])
    print("r_[数组拼接]:\n", np.r_[np.array([1, 2]), np.array([3, 4])])
    print("c_[1D 列拼接]:\n", np.c_[np.array([1, 2, 3]), np.array([4, 5, 6])])

    split_arr = np.arange(12).reshape(3, 4)
    print("vsplit (分成3个):")
    for s in np.vsplit(split_arr, 3):
        print(" ", s)
    print("hsplit (分成2个):")
    for s in np.hsplit(split_arr, 2):
        print(" ", s)

    print("tile (2, 3):\n", np.tile(np.array([1, 2, 3]), (2, 3)))
    print("repeat 每元素重复3次:", np.repeat(np.array([1, 2, 3]), 3))

    pad_arr = np.array([[1, 2], [3, 4]])
    print("pad 环绕填充:\n", np.pad(pad_arr, pad_width=1, mode="constant", constant_values=1))

    mod_arr = np.array([10, 20, 30, 40, 50])
    print("delete 索引2:", np.delete(mod_arr, 2))
    print("insert 索引2前插入99:", np.insert(mod_arr, 2, 99))
    print("append:", np.append(np.array([1, 2]), np.array([3, 4])))


def demo_copyview():
    """拷贝与视图: view vs copy"""
    print("\n===== 拷贝与视图 =====")

    orig = np.array([1, 2, 3, 4, 5])
    view = orig[1:4]
    view[0] = 99
    print("修改视图后原数组:", orig, "(视图影响原数组)")

    copy_arr = orig.copy()
    copy_arr[0] = 0
    print("修改拷贝后原数组:", orig, "(拷贝不影响原数组)")


def demo_sort():
    """排序: sort, argsort, lexsort, partition, argpartition"""
    print("\n===== 排序 =====")

    print("sort 排序:", np.sort(np.array([30, 10, 20])))

    sort_arr = np.array([30, 10, 40, 20, 50])
    idx = np.argsort(sort_arr)
    print("argsort 索引:", idx, "-> 排序结果:", sort_arr[idx])

    names = np.array(["Bob", "Alice", "Bob", "Alice"])
    scores = np.array([85, 92, 78, 88])
    print("lexsort (先按名字再按分数):", np.lexsort((scores, names)))

    part_arr = np.array([7, 1, 9, 3, 5, 8, 2])
    print("partition (前3个最小):", np.partition(part_arr, 3))
    print("argpartition:", np.argpartition(part_arr, 3))


def demo_stat():
    """统计: mean, std, max, min, percentile, quantile, histogram, ptp, axis操作, cumsum, cumprod, diff, gradient, corrcoef"""
    print("\n===== 统计 =====")

    arr = np.array([1, 2, 3, 4, 5])
    print("均值:", np.mean(arr), "| 标准差:", np.std(arr))
    print("最大值:", np.max(arr), "最小值:", np.min(arr), "最小值索引:", np.argmin(arr))

    stat_arr = np.array([3, 7, 1, 9, 2, 8, 4, 6, 5])
    print("中位数:", np.percentile(stat_arr, 50))
    print("分位数 0.25/0.5/0.75:", np.quantile(stat_arr, [0.25, 0.5, 0.75]))

    hist, bins = np.histogram(stat_arr, bins=3)
    print("histogram 计数:", hist, "分界:", bins)
    print("ptp:", np.ptp(stat_arr))

    axis_arr = np.arange(1, 13).reshape(3, 4)
    print("原数组:\n", axis_arr)
    print("sum axis=0:", axis_arr.sum(axis=0))
    print("sum axis=1:", axis_arr.sum(axis=1))
    print("mean axis=0:", axis_arr.mean(axis=0))

    print("cumsum:", np.cumsum(np.array([1, 2, 3, 4, 5])))
    print("cumprod:", np.cumprod(np.array([1, 2, 3, 4, 5])))
    print("diff 一阶:", np.diff(np.array([1, 3, 6, 10, 15])))
    print("gradient:", np.gradient(np.array([1.0, 2.0, 4.0, 7.0, 11.0])))

    c1 = np.array([1, 2, 3, 4, 5])
    c2 = np.array([2, 4, 6, 8, 10])
    c3 = np.array([5, 4, 3, 2, 1])
    print("相关系数矩阵:\n", np.corrcoef([c1, c2, c3]))


def demo_nan():
    """NaN与特殊值: nanmean, nanstd, nanmax, nansum, isnan, isinf, isfinite"""
    print("\n===== NaN 与特殊值 =====")

    nan_arr = np.array([1.0, 2.0, np.nan, 4.0, 5.0])
    print("含 NaN 数组:", nan_arr)
    print("mean (含 NaN):", nan_arr.mean(), "| nanmean:", np.nanmean(nan_arr))
    print("nanstd:", np.nanstd(nan_arr), "| nanmax:", np.nanmax(nan_arr))
    print("nansum:", np.nansum(nan_arr))

    sv_arr = np.array([1.0, np.nan, np.inf, -np.inf, 0.0, 3.5])
    print("isnan:", np.isnan(sv_arr))
    print("isinf:", np.isinf(sv_arr))
    print("isfinite:", np.isfinite(sv_arr))


def demo_set():
    """布尔聚合与集合: any, all, intersect1d, union1d, setdiff1d, setxor1d, isin"""
    print("\n===== 布尔聚合与集合 =====")

    bool_arr = np.array([True, False, True, True, False])
    print("any:", np.any(bool_arr), "| all:", np.all(bool_arr))
    print("存在 > 6:", np.any(np.array([1, 3, 5, 7, 9]) > 6))

    s1 = np.array([1, 2, 3, 4, 5])
    s2 = np.array([3, 4, 5, 6, 7])
    print("交集:", np.intersect1d(s1, s2))
    print("并集:", np.union1d(s1, s2))
    print("差集 (s1-s2):", np.setdiff1d(s1, s2))
    print("对称差:", np.setxor1d(s1, s2))
    print("s1 中元素是否在 s2 (isin):", np.isin(s1, s2))


def demo_linalg():
    """线性代数: dot, inv, det, solve, lstsq, eig, svd, norm, trace, rank, matrix_power, outer, cross, vdot, tensordot"""
    print("\n===== 线性代数 =====")

    A = np.array([[1, 2], [3, 4]])
    B = np.array([[5, 6], [7, 8]])

    print("dot 矩阵乘法:\n", np.dot(A, B))

    if np.linalg.det(A) != 0:
        print("逆矩阵:\n", np.linalg.inv(A))
    print("解线性方程组 Ax=B:", np.linalg.solve(np.array([[2, 1], [1, -1]]), np.array([4, -1])))

    x_ls = np.array([0, 1, 2, 3])
    y_ls = np.array([1.1, 1.9, 3.2, 4.0])
    A_ls = np.vstack([x_ls, np.ones_like(x_ls)]).T
    m_ls, c_ls = np.linalg.lstsq(A_ls, y_ls, rcond=None)[0]
    print(f"最小二乘拟合: y = {m_ls:.3f}x + {c_ls:.3f}")

    eigvals, _ = np.linalg.eig(np.array([[4, -2], [1, 1]]))
    print("特征值:", eigvals)

    U, S, Vt = np.linalg.svd(np.array([[1, 2, 3], [4, 5, 6]]))
    print("SVD 奇异值:", S)

    print("L2 范数:", np.linalg.norm(np.array([3.0, 4.0])))
    la_mat = np.array([[1, 2, 3], [4, 5, 6], [7, 8, 9]])
    print("trace:", np.trace(la_mat))
    print("matrix_rank:", np.linalg.matrix_rank(la_mat))
    print("matrix_power (A^2):\n", np.linalg.matrix_power(A, 2))

    print("outer 外积:\n", np.outer(np.array([1, 2, 3]), np.array([4, 5])))
    print("cross 叉积:", np.cross(np.array([1, 0, 0]), np.array([0, 1, 0])))
    print("vdot 共轭内积:", np.vdot(np.array([1+2j, 3+4j]), np.array([5+6j, 7+8j])))

    tdA = np.arange(4).reshape(2, 2)
    tdB = np.arange(4, 8).reshape(2, 2)
    print("tensordot axes=1:\n", np.tensordot(tdA, tdB, axes=1))


def demo_grid():
    """网格: meshgrid, mgrid, ogrid"""
    print("\n===== 网格 =====")

    X, Y = np.meshgrid(np.array([1, 2, 3]), np.array([4, 5]))
    print("meshgrid X:\n", X)
    print("meshgrid Y:\n", Y)

    grid_x, grid_y = np.mgrid[0:3, 0:2]
    print("mgrid x:\n", grid_x)

    og_x, og_y = np.ogrid[0:3, 0:2]
    print("ogrid x shape:", og_x.shape, "| ogrid y shape:", og_y.shape)


def demo_io():
    """文件读写: save/load (npy), savetxt/loadtxt (txt), savez (多数组)"""
    print("\n===== 文件读写 =====")

    io_arr = np.array([[1.5, 2.3, 3.7], [4.1, 5.9, 6.2]])

    np.save("/tmp/numpy_demo.npy", io_arr)
    print("save/load (npy):", np.load("/tmp/numpy_demo.npy").shape)

    np.savetxt("/tmp/numpy_demo.txt", io_arr, fmt="%.2f", delimiter=",")
    print("savetxt/loadtxt:\n", np.loadtxt("/tmp/numpy_demo.txt", delimiter=","))

    np.savez("/tmp/numpy_demo.npz", a=io_arr, b=io_arr * 2)
    data = np.load("/tmp/numpy_demo.npz")
    print("savez keys:", list(data.keys()), "| a shape:", data["a"].shape)


def demo_struct():
    """结构化数组: 自定义 dtype, 按列名访问"""
    print("\n===== 结构化数组 =====")

    dtype = np.dtype([("name", "U10"), ("age", "i4"), ("score", "f4")])
    stu = np.array([("Alice", 20, 88.5), ("Bob", 22, 92.0)], dtype=dtype)
    print("结构化数组:\n", stu)
    print("年龄列:", stu["age"])
    print("score > 90:", stu[stu["score"] > 90])


def demo_advanced():
    """高级操作: einsum, apply_along_axis, searchsorted, digitize, unique, bincount, nonzero, interp, convolve, polyfit, vectorize, nditer"""
    print("\n===== 其他高级操作 =====")

    eA = np.array([[1, 2], [3, 4]])
    eB = np.array([[5, 6], [7, 8]])
    print("einsum 矩阵乘法 (ij,jk->ik):\n", np.einsum("ij,jk->ik", eA, eB))
    print("einsum 内积 (i,i->):", np.einsum("i,i->", np.array([1, 2, 3]), np.array([4, 5, 6])))

    app_arr = np.arange(6).reshape(2, 3)
    print("apply 沿 axis=1 sum:", np.apply_along_axis(lambda x: x.sum(), axis=1, arr=app_arr))

    sorted_s = np.array([1, 3, 5, 7, 9])
    print("searchsorted 插入位置:", np.searchsorted(sorted_s, np.array([0, 4, 8, 10])))
    print("digitize 分桶:", np.digitize(np.array([-1, 2, 5, 8, 12]), np.array([0, 3, 7, 10])))

    u_arr = np.array([3, 1, 2, 1, 3, 2, 5, 1, 2])
    vals_u, counts_u = np.unique(u_arr, return_counts=True)
    print("unique + counts:", dict(zip(vals_u, counts_u)))
    vals_u, inv_u = np.unique(u_arr, return_inverse=True)
    print("unique + 反向映射:", vals_u[inv_u])

    print("bincount:", np.bincount(np.array([0, 1, 1, 3, 2, 1, 3, 0, 1])))

    cond_arr = np.array([[0, 2, 0], [3, 0, 5]])
    print("nonzero:\n", np.nonzero(cond_arr))
    print("count_nonzero:", np.count_nonzero(cond_arr))

    print("interp 线性插值:", np.interp(np.array([0.5, 1.5, 2.5]),
          np.array([0, 1, 2, 3]), np.array([0, 10, 20, 30])))
    print("convolve 卷积:", np.convolve(np.array([1, 2, 3, 4, 5]),
          np.array([0.5, 0.5]), mode="valid"))

    px = np.array([0, 1, 2, 3, 4, 5])
    py = np.array([0, 0.8, 3.2, 7.5, 13.6, 22.0])
    coeffs = np.polyfit(px, py, deg=2)
    print(f"polyfit: y = {coeffs[0]:.3f}x^2 + {coeffs[1]:.3f}x + {coeffs[2]:.3f}")

    def is_even(n):
        return "even" if n % 2 == 0 else "odd"
    print("vectorize:", np.vectorize(is_even)(np.array([1, 2, 3, 4])))

    it_arr = np.arange(4).reshape(2, 2)
    print("nditer 迭代:", end="")
    for x in np.nditer(it_arr):
        print("", x, end="")
    print()
    print("ndenumerate:")
    for idx, val in np.ndenumerate(it_arr):
        print(f"  {idx}: {val}")


def demo_fft():
    """FFT: 快速傅里叶变换"""
    print("\n===== FFT 快速傅里叶变换 =====")

    signal = np.array([0.0, 1.0, 0.0, -1.0, 0.0, 1.0, 0.0, -1.0])
    fft_result = np.fft.fft(signal)
    print("FFT 频谱:", np.abs(fft_result))
    print("FFT 主频分量索引:", np.argmax(np.abs(fft_result[1:])))


# ============================================================
#  节注册表 { 名称: (函数, 描述) }
# ============================================================

DEMOS = {
    "create":    (demo_create,    "数组创建: array, arange, linspace, zeros, ones, eye, full, empty 等"),
    "dtype":     (demo_dtype,     "数据类型与属性: dtype, astype, iinfo, finfo"),
    "random":    (demo_random,    "随机数: random, randn, randint, shuffle, choice"),
    "ufunc":     (demo_ufunc,     "基本运算与通用函数: 标量运算, sin, cos, exp, log, sqrt"),
    "index":     (demo_index,     "索引/过滤/条件: 高级索引, 布尔索引, where, select, argwhere, extract, clip, isclose"),
    "shape":     (demo_shape,     "形状与维度: reshape, newaxis, squeeze, flatten, transpose, rot90, roll"),
    "broadcast": (demo_broadcast, "广播: shape兼容, broadcast_to, broadcast_arrays"),
    "stack":     (demo_stack,     "拼接/分割/修改: v/h/dstack, r_/c_, vsplit, tile, repeat, pad, delete, insert"),
    "copyview":  (demo_copyview,  "拷贝与视图: view vs copy"),
    "sort":      (demo_sort,      "排序: sort, argsort, lexsort, partition"),
    "stat":      (demo_stat,      "统计: mean/std/max/min, percentile, histogram, axis, cumsum, diff, corrcoef"),
    "nan":       (demo_nan,       "NaN与特殊值: nanmean, nanstd, isnan, isinf, isfinite"),
    "set":       (demo_set,       "布尔聚合与集合: any, all, intersect1d, union1d, setdiff1d, isin"),
    "linalg":    (demo_linalg,    "线性代数: dot, inv, solve, lstsq, eig, svd, norm, trace, outer, cross 等"),
    "grid":      (demo_grid,      "网格: meshgrid, mgrid, ogrid"),
    "io":        (demo_io,        "文件读写: save, load, savetxt, loadtxt, savez"),
    "struct":    (demo_struct,    "结构化数组: 自定义 dtype, 按列名访问"),
    "advanced":  (demo_advanced,  "高级操作: einsum, apply_along_axis, searchsorted, digitize, unique, interp, polyfit 等"),
    "fft":       (demo_fft,       "FFT: 快速傅里叶变换"),
}


def main():
    parser = argparse.ArgumentParser(
        description="NumPy 常用 API 演示脚本",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="示例:\n"
               "  python numpyDemo.py                   # 运行所有演示\n"
               "  python numpyDemo.py -s create         # 只运行数组创建\n"
               "  python numpyDemo.py -s linalg,fft     # 运行多个节\n"
               "  python numpyDemo.py -l                # 列出所有可用节",
    )
    parser.add_argument(
        "-s", "--section",
        type=str,
        default="all",
        help="要运行的演示节名称，多个用逗号分隔 (默认: all)",
    )
    parser.add_argument(
        "-l", "--list",
        action="store_true",
        help="列出所有可用节",
    )
    args = parser.parse_args()

    if args.list:
        print("可用演示节:\n")
        for name, (_, desc) in DEMOS.items():
            print(f"  {name:<12} {desc}")
        return

    if args.section == "all":
        for name, (func, _) in DEMOS.items():
            func()
    else:
        for name in args.section.split(","):
            name = name.strip()
            if name not in DEMOS:
                print(f"未知的节: '{name}'，使用 -l 查看可用节")
                continue
            DEMOS[name][0]()


if __name__ == "__main__":
    main()
