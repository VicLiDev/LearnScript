reference: https://www.runoob.com/linux/linux-shell.html


# Shell 环境

Shell 编程跟 JavaScript、php 编程一样，只要有一个能编写代码的文本编辑器和一个能
解释执行的脚本解释器就可以了。
* Linux 的 Shell 种类众多，常见的有：
* Bourne Shell（/usr/bin/sh或/bin/sh）
* Bourne Again Shell（/bin/bash）
* C Shell（/usr/bin/csh）
* K Shell（/usr/bin/ksh）
* Shell for Root（/sbin/sh）
* ……

本教程关注的是 Bash，也就是 Bourne Again Shell，由于易用和免费，Bash 在日常工作中
被广泛使用。同时，Bash 也是大多数Linux 系统默认的 Shell。

在一般情况下，人们并不区分 Bourne Shell 和 Bourne Again Shell，所以，像 #!/bin/sh，
它同样也可以改为 #!/bin/bash。

`#!` 告诉系统其后路径所指定的程序即是解释此脚本文件的 Shell 程序。

运行shell的三种方法：
1. 直接执行，例如：./test.sh。这需要文件具有可执行属性。
2. 使用脚本解释器解释执行，例如：sh ./test.sh。
3. 使用source执行，例如：source ./test.sh。这种方法不开新的shell子进程，也就是在
   当前的shell线程中执行，其他两种方法是要开子线程的。子进程仅会继承父进程的环境
   变量，子进程不会继承父进程的自定义变量。

# Shell 变量

## 作用域

Shell 变量的作用域可以分为三种：
* 有的变量只能在函数内部使用，这叫做局部变量（local variable）
* 有的变量可以在当前 Shell 进程中使用，这叫做全局变量（global variable）
* 而有的变量还可以在子进程中使用，这叫做环境变量（environment variable）

### 局部变量

Shell 也支持自定义函数，但是 Shell 函数和 C++、Java、C# 等其他编程语言函数的一个
不同点就是：在 Shell 函数中定义的变量默认也是全局变量，它和在函数外部定义变量拥有
一样的效果。

要想变量的作用域仅限于函数内部，可以在定义时加上local命令，此时该变量就成了局部变量。

Shell 变量的这个特性和 JavaScript 中的变量是类似的。在 JavaScript 函数内部定义的
变量，默认也是全局变量，只有加上var关键字，它才会变成局部变量。

### Shell 全局变量

所谓全局变量，就是指变量在当前的整个 Shell 进程中都有效。每个 Shell 进程都有自己的
作用域，彼此之间互不影响。在 Shell 中定义的变量，默认就是全局变量。

需要强调的是，全局变量的作用范围是当前的 Shell 进程，而不是当前的 Shell 脚本文件，
它们是不同的概念。打开一个 Shell 窗口就创建了一个 Shell 进程，打开多个 Shell 窗口
就创建了多个 Shell 进程，每个 Shell 进程都是独立的，拥有不同的进程 ID。在一个
Shell 进程中可以使用 source 命令执行多个 Shell 脚本文件，此时全局变量在这些脚本
文件中都有效。

### Shell 环境变量

全局变量只在当前 Shell 进程中有效，对其它 Shell 进程和子进程都无效。如果使用
export命令将全局变量导出，那么它就在所有的子进程中也有效了，这称为“环境变量”。

环境变量被创建时所处的 Shell 进程称为父进程，如果在父进程中再创建一个新的进程来
执行 Shell 命令，那么这个新的进程被称作 Shell 子进程。当 Shell 子进程产生时，
它会继承父进程的环境变量为自己所用，所以说环境变量可从父进程传给子进程。不难理解，
环境变量还可以传递给孙进程。

注意，两个没有父子关系的 Shell 进程是不能传递环境变量的，并且环境变量只能向下传递
而不能向上传递，即“传子不传父”。


## 定义变量

定义变量时，变量名不加美元符号（$，PHP语言中变量需要），如：
your_name="runoob.com"
注意，变量名和等号之间不能有空格，这可能和你熟悉的所有编程语言都不一样。同时，
变量名的命名须遵循如下规则： 
* 命名只能使用英文字母，数字和下划线，首个字符不能以数字开头。 
* 中间不能有空格，可以使用下划线（_）。 
* 不能使用标点符号。 
* 不能使用bash里的关键字（可用help命令查看保留关键字）。 

有效的 Shell 变量名示例如下：
```
RUNOOB
LD_LIBRARY_PATH
_var
var2
```
无效的变量命名：
```
?var=123
user*name=runoob
```
除了显式地直接赋值，还可以用语句给变量赋值，如：
```
for file in `ls /etc`
或
for file in $(ls /etc)
```
以上语句将 /etc 下目录的文件名循环出来。


## 声明变量 declare

reference: https://www.gnu.org/software/bash/manual/bash.html#index-declare

通常情况下隐式声明就足够了

语法：
```
declare [-aAfFgiIlnrtux] [-p] [name[=value] …]

参数说明：
-a  每个名称都是一个索引数组变量（请参阅数组）。
-A  每个名称都是一个关联数组变量（请参阅数组）。
-f  显示 shell 函数。若不加 -f ，则会显示所有 shell 变量与函数，与执行set指令的
    效果相同
-i  该变量将被视为整数；当为变量赋值时执行 算术评估（请参阅Shell 算术）。
-l  当给变量赋值时，所有大写字符都会转换为小写。大写属性被禁用。
-n  为每个名称赋予属性nameref，使其成为对另一个变量的名称引用。该另一个变量
    由name的值定义。对name的所有引用、赋值和属性修改（使用或更改 name 的除外）
    -n属性本身，是对name的值引用的变量执行的 。nameref 属性不能应用于数组变量。
-r  将name设置为只读。这些名称不能通过后续赋值语句赋值或取消设置。
-t  为每个名称赋予属性trace。跟踪函数从调用 shell继承DEBUG和陷阱。RETURNTrace
    属性对于变量没有特殊含义。
-u  当为变量赋值时，所有小写字符都将转换为大写字符。小写属性被禁用。
-x  标记每个名称以通过环境导出到后续命令。
```


## 使用变量

使用一个定义过的变量，只要在变量名前面加美元符号即可，如：
```
your_name="qinjx"
echo $your_name
echo ${your_name}
```
变量名外面的花括号是可选的，加不加都行，加花括号是为了帮助解释器识别变量的边界，
比如下面这种情况： 
```
for skill in Ada Coffe Action Java; do
    echo "I am good at ${skill}Script"
done
```
如果不给skill变量加花括号，写成`echo "I am good at $skillScript"`，解释器就会
把`$skillScript`当成一个变量（其值为空），代码执行结果就不是我们期望的样子了。 
推荐给所有变量加上花括号，这是个好的编程习惯。 
已定义的变量，可以被重新定义，如：
```
your_name="tom"
echo $your_name
your_name="alibaba"
echo $your_name
```
这样写是合法的，但注意，第二次赋值的时候不能写`$your_name="alibaba"`，使用变量的
时候才加美元符`$`。


## 只读变量
使用 readonly 命令可以将变量定义为只读变量，只读变量的值不能被改变。下面的例子
尝试更改只读变量，结果报错：
```
#!/bin/bash
myUrl="https://www.google.com"
readonly myUrl
myUrl="https://www.runoob.com"
```
运行脚本，结果如下：
```
/bin/sh: NAME: This variable is read only.
```


## 删除变量

使用 unset 命令可以删除变量。语法：
```
unset variable_name
```
变量被删除后不能再次使用。unset 命令不能删除只读变量。实例：
```
#!/bin/sh
myUrl="https://www.runoob.com"
unset myUrl
echo $myUrl
```
以上实例执行将没有任何输出。


## 变量类型

运行shell时，会同时存在三种变量：
1. 局部变量 局部变量在脚本或命令中定义，仅在当前shell实例中有效，其他shell启动的
   程序不能访问局部变量。
2. 环境变量 所有的程序，包括shell启动的程序，都能访问环境变量，有些程序需要环境
   变量来保证其正常运行。必要的时候shell脚本也可以定义环境变量。
3. shell变量 shell变量是由shell程序设置的特殊变量。shell变量中有一部分是环境变量，
   有一部分是局部变量，这些变量保证了shell的正常运行


## Shell 字符串
字符串是shell编程中最常用最有用的数据类型（除了数字和字符串，也没啥其它类型好用了），
字符串可以用单引号，也可以用双引号，也可以不用引号。

### 单引号 
```
str='this is a string'
```
单引号字符串的限制： 
* 单引号里的任何字符都会原样输出，单引号字符串中的变量是无效的； 
* 单引号字串中不能出现单独一个的单引号（对单引号使用转义符后也不行），但可成对出现，
  作为字符串拼接使用。 

### 双引号 
```
your_name='runoob'
str="Hello, I know you are \"$your_name\"! \n"
echo -e $str
```
输出结果为：
```
Hello, I know you are "runoob"! 
```
双引号的优点：
* 双引号里可以有变量 
* 双引号里可以出现转义字符 

### 拼接字符串 
```
your_name="runoob"
# 使用双引号拼接
greeting="hello, "$your_name" !"
greeting_1="hello, ${your_name} !"
echo $greeting  $greeting_1
# 使用单引号拼接
greeting_2='hello, '$your_name' !'
greeting_3='hello, ${your_name} !'
echo $greeting_2  $greeting_3
```
输出结果为：
```
hello, runoob ! hello, runoob !
hello, runoob ! hello, ${your_name} !
```

### 查找子字符串 

查找字符 i 或 o 的位置(哪个字母先出现就计算哪个)：
```
string="runoob is a great site"
echo `expr index "$string" io`  # 输出 4
```


### 其它常用操作

```
${#string}  $string的长度

${string:position}  在$string中, 从位置$position开始提取子串
${string:position:length}  在$string中, 从位置$position开始提取长度为$length的子串

${string#substring}  从变量$string的开头, 删除最短匹配$substring的子串
${string##substring}  从变量$string的开头, 删除最长匹配$substring的子串
${string%substring}  从变量$string的结尾, 删除最短匹配$substring的子串
${string%%substring}  从变量$string的结尾, 删除最长匹配$substring的子串

${string/substring/replacement}  使用$replacement, 来代替第一个匹配的$substring
${string//substring/replacement}  使用$replacement, 代替所有匹配的$substring
${string/#substring/replacement}  如果$string的前缀匹配$substring, 那么就用$replacement来代替匹配到的$substring
${string/%substring/replacement}  如果$string的后缀匹配$substring, 那么就用$replacement来代替匹配到的$substring

${string^}  把变量中的第一个字符换成大写
${string^^} 把变量中的所有小写字母，全部替换为大写
${string,}  把变量中的第一个字符换成小写
${string,,}  把变量中的所有大写字母，全部替换为小写
```
## 内置集合 `set`

[bash 在线手册](https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin)

使用set可以设置或取消设置 shell 属性

| 选项     | 说明
|--|--|
| -a       | 标记已修改的变量，以供输出至环境变量(意味着’set -a’之后定义的普通变量可在子shell中访问到)。 |
| -b       | 使被中止的后台程序立刻回报执行状态。                                                        |
| -C       | 转向所产生的文件无法覆盖已存在的文件。                                                      |
| -d       | Shell预设会用杂凑表记忆使用过的指令，以加速指令的执行。使用-d参数可取消。                   |
| -e       | 若指令传回值不等于0，则立即退出shell。                                                      |
| -f       | 取消使用通配符。                                                                            |
| -h       | 自动记录函数的所在位置。                                                                    |
| -H Shell | 可利用"!"加<指令编号>的方式来执行history中记录的指令。                                      |
| -k       | 指令所给的参数都会被视为此指令的环境变量。                                                  |
| -l       | 记录for循环的变量名称。                                                                     |
| -m       | 使用监视模式。                                                                              |
| -n       | 只读取指令，而不实际执行。                                                                  |
| -p       | 启动优先顺序模式。                                                                          |
| -P       | 启动-P参数后，执行指令时，会以实际的文件或目录来取代符号连接。                              |
| -t       | 执行完随后的指令，即退出shell。                                                             |
| -u       | 当执行时使用到未定义过的变量，则显示错误信息。                                              |
| -v       | 显示shell所读取的输入值。                                                                   |
| -x       | 执行指令前，会先显示该指令及其参数。                                                        |

例如：
```
"Exit immediately if a simple command exits with a non-zero status."
set -e返回值不等于零时立刻退出shell
set -e返回值不等于零时立刻退出shell
```

## `IFS`

### set 和 env

Shell 脚本中有个变量叫IFS(Internal Field Seprator) ，内部域分隔符。

Shell 的环境变量分为set, env两种，其中 set 变量可以通过 export 工具导入到 env 变量中。

set 是显示设置shell变量，仅在本 shell 中有效；env 是显示设置用户环境变量 ，仅在
当前会话中有效。

换句话说，set 变量里包含了env 变量，但set变量不一定都是env 变量。这两种变量不同
之处在于变量的作用域不同。显然，env 变量的作用域要大些，它可以在 subshell 中使用。

IFS 是一种 set 变量，当 shell 处理"命令替换"和"参数替换"时，shell 根据 IFS 的值，
默认是 space, tab, newline 来拆解读入的变量，然后对特殊字符进行处理，最后重新组合
赋值给该变量

### IFS 使用

查看 IFS 的值：
```shell
set | grep ^IFS
# IFS是以空格、制表符、换行符来进行分隔的
IFS=$' \t\n
```
查看IFS的值发现 `env | grep IFS` 为空，而 `set | grep IFS` 有值，说明IFS是局部变量

举例：
```
// name.txt
li li
lu cy
lu lu
na cy
na na
ly
loral
```
```shell
OLDIFS=$IFS

# IFS="\n"
# IFS=$"\n"
IFS=$'\n'

for i in $(cat name.txt)
do
  echo $i
done

IFS=$OLDIFS
```

### IFS 、$ 、单双引号

```shell
# 这三个赋值看起来都比较像”将换行符赋值给IFS“，但实际上只有最后一种写法才是我想要的结果。

# IFS="\n" //将字符n作为IFS的换行符。
IFS="\n"

# IFS=$"\n" //这里\n确实通过$转化为了换行符，但仅当被解释时（或被执行时）才被转化
# 为换行符;第一个和第二个是等价的
IFS=$"\n"

# IFS=$'\n' //这才是真正的换行符。
IFS=$'\n'
```

# Shell 注释

以 # 开头的行就是注释，会被解释器忽略。

通过每一行加一个 # 号设置多行注释，像这样： 
```
#--------------------------------------------
# 这是一个注释
# author： 
#--------------------------------------------
##### 用户配置区 开始 #####
#
#
# 这里可以添加脚本描述信息
# 
#
##### 用户配置区 结束  #####
```

如果在开发过程中，遇到大段的代码需要临时注释起来，过一会儿又取消注释，怎么办呢？

每一行加个#符号太费力了，可以把这一段要注释的代码用一对花括号括起来，定义成一个
函数，没有地方调用这个函数，这块代码就不会执行，达到了和注释一样的效果。

## 多行注释 

多行注释还可以使用以下格式：
```
:<<EOF
注释内容...
注释内容...
注释内容...
EOF
```
EOF 也可以使用其他符号:
```
:<<'
注释内容...
注释内容...
注释内容...
'

:<<!
注释内容...
注释内容...
注释内容...
!
```

# Shell 传递参数

我们可以在执行 Shell 脚本时，向脚本传递参数，脚本内获取参数的格式为：`$n`。
`n` 代表一个数字，0 代表脚本本身，1 为执行脚本的第一个参数，2 为执行脚本的第二个
参数，以此类推……

以下实例我们向脚本传递三个参数，并分别输出，其中 $0 为执行的文件名：
```
#!/bin/bash

echo "Shell 传递参数实例！";
echo "执行的文件名：$0";
echo "第一个参数为：$1";
echo "第二个参数为：$2";
echo "第三个参数为：$3";
```
执行输出结果如下所示：
```
$ ./test.sh 1 2 3
Shell 传递参数实例！
执行的文件名：./test.sh
第一个参数为：1
第二个参数为：2
第三个参数为：3
```
另外，还有几个特殊字符用来处理参数：
```
参数 说明
$#  传递到脚本的参数个数
$*  以一个单字符串显示所有向脚本传递的参数。
如"$*"用「"」括起来的情况、以"$1 $2 … $n"的形式输出所有参数。
$$  脚本运行的当前进程ID号
$!  后台运行的最后一个进程的ID号
$@  与$*相同，但是使用时加引号，并在引号中返回每个参数。
如"$@"用「"」括起来的情况、以"$1" "$2" … "$n" 的形式输出所有参数。 
$-  显示Shell使用的当前选项，与set命令功能相同。
$?  显示最后命令的退出状态。0表示没有错误，其他任何值表明有错误。
```

```
#!/bin/bash

echo "Shell 传递参数实例！";
echo "第一个参数为：$1";

echo "参数个数为：$#";
echo "传递的参数作为一个字符串显示：$*";
```
执行脚本，输出结果如下所示：
```
$ ./test.sh 1 2 3
Shell 传递参数实例！
第一个参数为：1
参数个数为：3
传递的参数作为一个字符串显示：1 2 3
```
$* 与 $@ 区别：
* 相同点：都是引用所有参数。
* 不同点：只有在双引号中体现出来。假设在脚本运行时写了三个参数 1、2、3，，则 "*"
  等价于 "1 2 3"（传递了一个参数），而 "@" 等价于 "1" "2" "3"（传递了三个参数）。 
```
#!/bin/bash

echo "-- \$* 演示 ---"
for i in "$*"; do
    echo $i
done

echo "-- \$@ 演示 ---"
for i in "$@"; do
    echo $i
done
```
执行脚本，输出结果如下所示：
```
$ ./test.sh 1 2 3
-- $* 演示 ---
1 2 3
-- $@ 演示 ---
1
2
3
```

## shift 命令

shift 命令同样可以用来处理参数
位置参数可以用shift命令左移。比如shift 3表示原来的$4现在变成$1，原来的$5现在变成
$2等等，原来的$1、$2、$3丢弃，$0不移动。不带参数的shift命令相当于shift 1。

对于位置变量或命令行参数，其个数必须是确定的，或者当 Shell 程序不知道其个数时，
可以把所有参数一起赋值给变量$*。若用户要求 Shell 在不知道位置变量个数的情况下，
还能逐个的把参数一一处理，也就是在 $1 后为 $2,在 $2 后面为 $3 等。在 shift 命令
执行前变量 $1 的值在 shift 命令执行后就不可用了。

举例：
```shell
while [ $# -gt 0 ]; do
    echo "cnt:$# para: $1"
    shift
done
```
执行 bash 1 2 3 4
```
cnt:4 para: 1
cnt:3 para: 2
cnt:2 para: 3
cnt:1 para: 4
```

# Shell 数组

Bash Shell 只支持一维数组（不支持多维数组），并且没有限定数组的大小，初始化时不
需要定义数组大小（与 PHP 类似）。

与大部分编程语言类似，数组元素的下标由0开始。

获取数组中的元素要利用下标，下标可以是整数或算术表达式，其值应大于或等于 0。

Shell 数组用括号来表示，元素用"空格"符号分割开，如果一个元素是字符串且字符串内有
空格的话，也会被当作一个数组元素，而不是两个，但前提是要用引号将其引起来

如果在for循环中使用`${array[@]}`进行遍历的话，有空格的字符串会被分开作为多个元素，
因为`${array[@]}`的作用可以理解为将整个数组展开铺平为一个字符串列表，这时候以空格
分割

语法格式如下：
```
array_name=(value1 ... valuen)
```

实例
```
#!/bin/bash

my_array=(A B "C" D)
或者 
array_name=(
value0
value1
value2
value3
)
```

我们也可以直接使用下标来定义数组:
```
array_name[0]=value0
array_name[1]=value1
array_name[2]=value2
```
可以不使用连续的下标，而且下标的范围没有限制。

也可以执行相应的命令生成数组：
```
array_name=($(my_cmd))
or
array_name=(`my_cmd`)
```

## 读取数组
读取数组元素值的一般格式是：
```
${array_name[index]}
```

实例
```
#!/bin/bash

my_array=(A B "C" D)

echo "第一个元素为: ${my_array[0]}"
echo "第二个元素为: ${my_array[1]}"
echo "第三个元素为: ${my_array[2]}"
echo "第四个元素为: ${my_array[3]}"
```
执行脚本，输出结果如下所示：
```
$ chmod +x test.sh 
$ ./test.sh
第一个元素为: A
第二个元素为: B
第三个元素为: C
第四个元素为: D
```

## 获取数组中的所有元素
使用@ 或 * 可以获取数组中的所有元素，例如：
```
#!/bin/bash

my_array[0]=A
my_array[1]=B
my_array[2]=C
my_array[3]=D

echo "数组的元素为: ${my_array[*]}"
echo "数组的元素为: ${my_array[@]}"
```
执行脚本，输出结果如下所示：
```
$ chmod +x test.sh 
$ ./test.sh
数组的元素为: A B C D
数组的元素为: A B C D
```

## 获取数组的长度
获取数组长度的方法与获取字符串长度的方法相同，例如：
```
#!/bin/bash

my_array[0]=A
my_array[1]=B
my_array[2]=C
my_array[3]=D

echo "数组元素个数为: ${#my_array[*]}"
echo "数组元素个数为: ${#my_array[@]}"
```
执行脚本，输出结果如下所示：
```
$ chmod +x test.sh 
$ ./test.sh
数组元素个数为: 4
数组元素个数为: 4
# 取得数组单个元素的长度
lengthn=${#array_name[n]}
```

## 复制数组
```
array_a=(1 2 3)
array_b=(a b c)

echo ${array_a[@]}
echo ${array_b[@]}

# method 1，复制数组到另一个数组，最后得到的是一个新的数组
array_new=("${array_b[@]}")

echo "method 1 array_new: "${array_new[@]}
echo "method 1 array_new: "${array_new[0]}

# method 2，复制数组到一个长字符串，最后得到的是一个长字符串
select="a"
# eval array_new2='$'{array_${select}[@]}
# 只要加上括号，就是数组赋值
# eval array_new2=('$'{array_${select}[@]})

echo "method 2 array_new2: "${array_new2}
echo "method 2 array_new2: "${array_new2[@]}
echo "method 2 array_new2: "${array_new2[0]}
```

## 遍历数组
```
str_arr=("a" "b c")

for ((i = 0; i < ${#str_arr[@]}; i++))
do
	echo ${str_arr[${i}]}
done
```
执行结果如下:
```
a
b c
```

## 函数传递数组

关于`local -n`:
local -n 是一个声明，用于创建一个对另一个变量的引用，即一个 nameref（名称引用）。
具体来说，local 用于声明一个局部变量，而 -n 选项则指示该变量应该是一个对另一个
变量（可能是数组）的引用。

当使用 local -n 声明一个变量时，你实际上是在创建一个指向另一个变量的别名。通过这个
别名，可以访问和修改原始变量的内容，就好像你直接操作它一样。这在函数内部特别有用，
因为你可以通过引用传递变量或数组，而不是传递它们的值或副本。

```shell
#!/bin/bash

# 定义函数，接受一个数组名称作为参数
my_function() {
    local -n array_ref="$1"  # 创建一个对传入数组名称的引用
    for element in "${array_ref[@]}";
    do
        echo "$element"
    done
}

# 定义数组
my_array=("element1" "element2" "element3")

# 调用函数，传递数组名称
my_function "my_array"
```

# Shell 基本运算符

Shell 和其他编程语言一样，支持多种运算符，包括：
* 算数运算符
* 关系运算符
* 布尔运算符
* 字符串运算符
* 文件测试运算符

原生bash不支持简单的数学运算，但是可以通过其他命令来实现，例如 awk 和 expr，expr 最常用。

expr 是一款表达式计算工具，使用它能完成表达式的求值操作。例如，两个数相加：
```shell
#!/bin/bash

val=`expr 2 + 2`
echo "两数之和为 : $val"
```
执行脚本，输出结果如下所示：
```shell
两数之和为 : 4
```
```
注意：
表达式和运算符之间要有空格，例如 2+2 是不对的，必须写成 2 + 2，这与我们熟悉的
大多数编程语言不一样。
完整的表达式要被` `包含，注意这个字符不是常用的单引号，在 Esc 键下边。
```

## 算术运算符

下表列出了常用的算术运算符，假定变量 a 为 10，变量 b 为 20：

| 运算符 | 说明                                          | 举例                          |
|--------|-----------------------------------------------|-------------------------------|
| +      | 加法                                          | `expr $a + $b` 结果为 30。    |
| -      | 减法                                          | `expr $a - $b` 结果为 -10。   |
| *      | 乘法                                          | `expr $a \* $b` 结果为  200。 |
| /      | 除法                                          | `expr $b / $a` 结果为 2。     |
| %      | 取余                                          | `expr $b % $a` 结果为 0。     |
| =      | 赋值                                          | a=$b 将把变量 b 的值赋给 a。  |
| ==     | 相等。用于比较两个数字，相同则返回 true。     | [ $a == $b ] 返回 false。     |
| !=     | 不相等。用于比较两个数字，不相同则返回 true。 | [ $a != $b ] 返回 true。      |

```
注意：条件表达式要放在方括号之间，并且要有空格，例如: [$a==$b] 是错误的，必须写成 [ $a == $b ]。
```

实例
```shell
#!/bin/bash
a=10
b=20

val=`expr $a + $b`
echo "a + b : $val"

val=`expr $a - $b`
echo "a - b : $val"

val=`expr $a \* $b`
echo "a * b : $val"

val=`expr $b / $a`
echo "b / a : $val"

val=`expr $b % $a`
echo "b % a : $val"

if [ $a == $b ]
then
   echo "a 等于 b"
fi
if [ $a != $b ]
then
   echo "a 不等于 b"
fi
```
执行脚本，输出结果如下所示：
```shell
a + b : 30
a - b : -10
a * b : 200
b / a : 2
b % a : 0
a 不等于 b
```

```
注意：
乘号(*)前边必须加反斜杠(\)才能实现乘法运算；
if...then...fi 是条件语句，后续将会讲解。
在 MAC 中 shell 的 expr 语法是：$((表达式))，此处表达式中的 "*" 不需要转义符号 "\" 。
```

## 关系运算符

关系运算符只支持数字，不支持字符串，除非字符串的值是数字。
下表列出了常用的关系运算符，假定变量 a 为 10，变量 b 为 20：

| 运算符 | 说明                                                  | 举例                       |
|--------|-------------------------------------------------------|----------------------------|
| -eq    | 检测两个数是否相等，相等返回 true。                   | [ $a -eq $b ] 返回 false。 |
| -ne    | 检测两个数是否不相等，不相等返回 true。               | [ $a -ne $b ] 返回 true。  |
| -gt    | 检测左边的数是否大于右边的，如果是，则返回 true。     | [ $a -gt $b ] 返回 false。 |
| -lt    | 检测左边的数是否小于右边的，如果是，则返回 true。     | [ $a -lt $b ] 返回 true。  |
| -ge    | 检测左边的数是否大于等于右边的，如果是，则返回 true。 | [ $a -ge $b ] 返回 false。 |
| -le    | 检测左边的数是否小于等于右边的，如果是，则返回 true。 | [ $a -le $b ] 返回 true。  |

实例
```shell
#!/bin/bash

a=10
b=20

if [ $a -eq $b ]
then
   echo "$a -eq $b : a 等于 b"
else
   echo "$a -eq $b: a 不等于 b"
fi
if [ $a -ne $b ]
then
   echo "$a -ne $b: a 不等于 b"
else
   echo "$a -ne $b : a 等于 b"
fi
if [ $a -gt $b ]
then
   echo "$a -gt $b: a 大于 b"
else
   echo "$a -gt $b: a 不大于 b"
fi
if [ $a -lt $b ]
then
   echo "$a -lt $b: a 小于 b"
else
   echo "$a -lt $b: a 不小于 b"
fi
if [ $a -ge $b ]
then
   echo "$a -ge $b: a 大于或等于 b"
else
   echo "$a -ge $b: a 小于 b"
fi
if [ $a -le $b ]
then
   echo "$a -le $b: a 小于或等于 b"
else
   echo "$a -le $b: a 大于 b"
fi
```
执行脚本，输出结果如下所示：
```shell
10 -eq 20: a 不等于 b
10 -ne 20: a 不等于 b
10 -gt 20: a 不大于 b
10 -lt 20: a 小于 b
10 -ge 20: a 小于 b
10 -le 20: a 小于或等于 b
```

## 布尔运算符

下表列出了常用的布尔运算符，假定变量 a 为 10，变量 b 为 20：

| 运算符 | 说明                                                | 举例                                     |
|--------|-----------------------------------------------------|------------------------------------------|
| !      | 非运算，表达式为 true 则返回 false，否则返回 true。 | [ ! false ] 返回 true。                  |
| -o     | 或运算，有一个表达式为 true 则返回 true。           | [ $a -lt 20 -o $b -gt 100 ] 返回 true。  |
| -a     | 与运算，两个表达式都为 true 才返回 true。           | [ $a -lt 20 -a $b -gt 100 ] 返回 false。 |

实例
```shell
#!/bin/bash
a=10
b=20

if [ $a != $b ]
then
   echo "$a != $b : a 不等于 b"
else
   echo "$a == $b: a 等于 b"
fi
if [ $a -lt 100 -a $b -gt 15 ]
then
   echo "$a 小于 100 且 $b 大于 15 : 返回 true"
else
   echo "$a 小于 100 且 $b 大于 15 : 返回 false"
fi
if [ $a -lt 100 -o $b -gt 100 ]
then
   echo "$a 小于 100 或 $b 大于 100 : 返回 true"
else
   echo "$a 小于 100 或 $b 大于 100 : 返回 false"
fi
if [ $a -lt 5 -o $b -gt 100 ]
then
   echo "$a 小于 5 或 $b 大于 100 : 返回 true"
else
   echo "$a 小于 5 或 $b 大于 100 : 返回 false"
fi
```
执行脚本，输出结果如下所示：
```shell
10 != 20 : a 不等于 b
10 小于 100 且 20 大于 15 : 返回 true
10 小于 100 或 20 大于 100 : 返回 true
10 小于 5 或 20 大于 100 : 返回 false
```

## 逻辑运算符
以下介绍 Shell 的逻辑运算符，假定变量 a 为 10，变量 b 为 20:

| 运算符 | 说明       | 举例                                       |
|--------|------------|--------------------------------------------|
| &&     | 逻辑的 AND | [[ $a -lt 100 && $b -gt 100 ]] 返回 false  |
| \|\|   | 逻辑的 OR  | [[ $a -lt 100 \|\| $b -gt 100 ]] 返回 true |

实例
```shell
#!/bin/bash
a=10
b=20

if [[ $a -lt 100 && $b -gt 100 ]]
then
   echo "返回 true"
else
   echo "返回 false"
fi

if [[ $a -lt 100 || $b -gt 100 ]]
then
   echo "返回 true"
else
   echo "返回 false"
fi
```
执行脚本，输出结果如下所示：
```shell
返回 false
返回 true
```

## 字符串运算符

下表列出了常用的字符串运算符，假定变量 a 为 "abc"，变量 b 为 "efg"：
| 运算符 | 说明                                         | 举例                     |
|--------|----------------------------------------------|--------------------------|
| =      | 检测两个字符串是否相等，相等返回 true。      | [ $a = $b ] 返回 false。 |
| !=     | 检测两个字符串是否相等，不相等返回 true。    | [ $a != $b ] 返回 true。 |
| -z     | 检测字符串长度是否为0，为0返回 true。        | [ -z $a ] 返回 false。   |
| -n     | 检测字符串长度是否不为 0，不为 0 返回 true。 | [ -n "$a" ] 返回 true。  |
| $      | 检测字符串是否为空，不为空返回 true。        | [ $a ] 返回 true。       |

实例
```shell
#!/bin/bash

a="abc"
b="efg"

if [ $a = $b ]
then
   echo "$a = $b : a 等于 b"
else
   echo "$a = $b: a 不等于 b"
fi
if [ $a != $b ]
then
   echo "$a != $b : a 不等于 b"
else
   echo "$a != $b: a 等于 b"
fi
if [ -z $a ]
then
   echo "-z $a : 字符串长度为 0"
else
   echo "-z $a : 字符串长度不为 0"
fi
if [ -n "$a" ]
then
   echo "-n $a : 字符串长度不为 0"
else
   echo "-n $a : 字符串长度为 0"
fi
if [ $a ]
then
   echo "$a : 字符串不为空"
else
   echo "$a : 字符串为空"
fi
```
执行脚本，输出结果如下所示：
```shell
abc = efg: a 不等于 b
abc != efg : a 不等于 b
-z abc : 字符串长度不为 0
-n abc : 字符串长度不为 0
abc : 字符串不为空
```

## 文件测试运算符

文件测试运算符用于检测 Unix 文件的各种属性。
属性检测描述如下：
| 操作符  | 说明                                                                        | 举例                     |
|---------|-----------------------------------------------------------------------------|--------------------------|
| -b file | 检测文件是否是块设备文件，如果是，则返回 true。                             | [ -b $file ] 返回 false。|
| -c file | 检测文件是否是字符设备文件，如果是，则返回 true。                           | [ -c $file ] 返回 false。|
| -d file | 检测文件是否是目录，如果是，则返回 true。                                   | [ -d $file ] 返回 false。|
| -f file | 检测文件是否是普通文件（既不是目录，也不是设备文件），如果是，则返回 true。 | [ -f $file ] 返回 true。 |
| -g file | 检测文件是否设置了 SGID 位，如果是，则返回 true。                           | [ -g $file ] 返回 false。|
| -k file | 检测文件是否设置了粘着位(Sticky Bit)，如果是，则返回 true。                 | [ -k $file ] 返回 false。|
| -p file | 检测文件是否是有名管道，如果是，则返回 true。                               | [ -p $file ] 返回 false。|
| -u file | 检测文件是否设置了 SUID 位，如果是，则返回 true。                           | [ -u $file ] 返回 false。|
| -r file | 检测文件是否可读，如果是，则返回 true。                                     | [ -r $file ] 返回 true。 |
| -w file | 检测文件是否可写，如果是，则返回 true。                                     | [ -w $file ] 返回 true。 |
| -x file | 检测文件是否可执行，如果是，则返回 true。                                   | [ -x $file ] 返回 true。 |
| -s file | 检测文件是否为空（文件大小是否大于0），不为空返回 true。                    | [ -s $file ] 返回 true。 |
| -e file | 检测文件（包括目录）是否存在，如果是，则返回 true。                         | [ -e $file ] 返回 true。 |

其他检查符：
```
-S: 判断某文件是否 socket。
-L: 检测文件是否存在并且是一个符号链接。
```

实例
变量 file 表示文件 /var/www/runoob/test.sh，它的大小为 100 字节，具有 rwx 权限。
下面的代码，将检测该文件的各种属性：
```shell
#!/bin/bash

file="/var/www/runoob/test.sh"
if [ -r $file ]
then
   echo "文件可读"
else
   echo "文件不可读"
fi
if [ -w $file ]
then
   echo "文件可写"
else
   echo "文件不可写"
fi
if [ -x $file ]
then
   echo "文件可执行"
else
   echo "文件不可执行"
fi
if [ -f $file ]
then
   echo "文件为普通文件"
else
   echo "文件为特殊文件"
fi
if [ -d $file ]
then
   echo "文件是个目录"
else
   echo "文件不是个目录"
fi
if [ -s $file ]
then
   echo "文件不为空"
else
   echo "文件为空"
fi
if [ -e $file ]
then
   echo "文件存在"
else
   echo "文件不存在"
fi
```
执行脚本，输出结果如下所示：
```shell
文件可读
文件可写
文件可执行
文件为普通文件
文件不是个目录
文件不为空
文件存在
```

# Shell echo命令

Shell 的 echo 指令与 PHP 的 echo 指令类似，都是用于字符串的输出。命令格式：
```shell
echo string
```
您可以使用echo实现更复杂的输出格式控制。

## 1.显示普通字符串:
```shell
echo "It is a test"
```
这里的双引号完全可以省略，以下命令与上面实例效果一致：
```shell
echo It is a test
```

## 2.显示转义字符
```shell
echo "\"It is a test\""
```
结果将是:
```shell
"It is a test"
```
同样，双引号也可以省略

## 3.显示变量
read 命令从标准输入中读取一行,并把输入行的每个字段的值指定给 shell 变量
```shell
#!/bin/sh
read name 
echo "$name It is a test"
```
以上代码保存为 test.sh，name 接收标准输入的变量，结果将是:
```shell
[root@www ~]# sh test.sh
OK                     #标准输入
OK It is a test        #输出
```

## 4.显示换行
```shell
echo -e "OK! \n" # -e 开启转义
echo "It is a test"
```
输出结果：
```shell
OK!

It is a test
```

## 5.显示不换行
```shell
#!/bin/sh
echo -e "OK! \c" # -e 开启转义 \c 不换行
echo "It is a test"
```
输出结果：
```shell
OK! It is a test
```

## 6.显示结果定向至文件
```shell
echo "It is a test" > myfile
```

## 7.原样输出字符串，不进行转义或取变量(用单引号)
```shell
echo '$name\"'
```
输出结果：
```shell
$name\"
```

## 8.显示命令执行结果
```shell
echo `date`
```
结果将显示当前日期
```shell
Thu Jul 24 10:08:46 CST 2014
```

# Shell printf 命令

上一章节我们学习了 Shell 的 echo 命令，本章节我们来学习 Shell 的另一个输出命令 printf。
* printf 命令模仿 C 程序库（library）里的 printf() 程序。
* printf 由 POSIX 标准所定义，因此使用 printf 的脚本比使用 echo 移植性好。
* printf 使用引用文本或空格分隔的参数，外面可以在 printf 中使用格式化字符串，还
  可以制定字符串的宽度、左右对齐方式等。默认 printf 不会像 echo 自动添加换行符，
  我们可以手动添加 \n。

printf 命令的语法：
```shell
printf  format-string  [arguments...]
参数说明：
format-string: 为格式控制字符串
arguments: 为参数列表。
```
实例如下：
```shell
$ echo "Hello, Shell"
Hello, Shell
$ printf "Hello, Shell\n"
Hello, Shell
```

接下来,我来用一个脚本来体现printf的强大功能：
```shell
#!/bin/bash

printf "%-10s %-8s %-4s\n" 姓名 性别 体重kg  
printf "%-10s %-8s %-4.2f\n" 郭靖 男 66.1234 
printf "%-10s %-8s %-4.2f\n" 杨过 男 48.6543 
printf "%-10s %-8s %-4.2f\n" 郭芙 女 47.9876 
```
执行脚本，输出结果如下所示：
```shell
姓名     性别   体重kg
郭靖     男      66.12
杨过     男      48.65
郭芙     女      47.99
```
* %s %c %d %f都是格式替代符
* %-10s 指一个宽度为10个字符（-表示左对齐，没有则表示右对齐），任何字符都会被显示
  在10个字符宽的字符内，如果不足则自动以空格填充，超过也会将内容全部显示出来。
* %-4.2f 指格式化为小数，其中.2指保留2位小数。

更多实例：
```shell
#!/bin/bash

# format-string为双引号
printf "%d %s\n" 1 "abc"

# 单引号与双引号效果一样 
printf '%d %s\n' 1 "abc" 

# 没有引号也可以输出
printf %s abcdef

# 格式只指定了一个参数，但多出的参数仍然会按照该格式输出，format-string 被重用
printf %s abc def

printf "%s\n" abc def

printf "%s %s %s\n" a b c d e f g h i j

# 如果没有 arguments，那么 %s 用NULL代替，%d 用 0 代替
printf "%s and %d \n" 
```
执行脚本，输出结果如下所示：
```shell
1 abc
1 abc
abcdefabcdefabc
def
a b c
d e f
g h i
j  
 and 0
```


## printf的转义序列
| 序列  | 说明                           |
|-------|--------------------------------|
| \a    | 警告字符，通常为ASCII的BEL字符 |
| \b    | 后退                           |
| \c    | 抑制（不显示）输出结果中任何结尾的换行字符（只在%b格式指示符控制下的参数字符串中有效），而且，任何留在参数里的字符、任何接下来的参数以及任何留在格式字符串中的字符，都被忽略 |
| \f    | 换页（formfeed）               |
| \n    | 换行                           |
| \r    | 回车（Carriage return）        |
| \t    | 水平制表符                     |
| \v    | 垂直制表符                     |
| \\    | 一个字面上的反斜杠字符         |
| \ddd  | 表示1到3位数八进制值的字符。仅在格式字符串中有效 |
| \0ddd | 表示1到3位的八进制值字符       |

实例
```shell
$ printf "a string, no processing:<%s>\n" "A\nB"
a string, no processing:<A\nB>

$ printf "a string, no processing:<%b>\n" "A\nB"
a string, no processing:<A
B>

$ printf "www.runoob.com \a"
www.runoob.com $                  #不换行
```


# Shell test 命令

Shell中的 test 命令用于检查某个条件是否成立，它可以进行数值、字符和文件三个方面的
测试。

## 数值测试

| 参数 | 说明 |
|--|--|
| -eq | 等于则为真 |
| -ne | 不等于则为真 |
| -gt | 大于则为真 |
| -ge | 大于等于则为真 |
| -lt | 小于则为真 |
| -le | 小于等于则为真 |

实例演示：
```shell
num1=100
num2=100
if test $[num1] -eq $[num2]
then
    echo '两个数相等！'
else
    echo '两个数不相等！'
fi
```

输出结果：
```shell
两个数相等！
```
代码中的 [] 执行基本的算数运算，如：
```shell
#!/bin/bash

a=5
b=6

result=$[a+b] # 注意等号两边不能有空格
echo "result 为： $result"
```
结果为:
```shell
result 为： 11
```

## 字符串测试
| 参数 | 说明 |
|--|--|
| = | 等于则为真 |
| != | 不相等则为真 |
| -z 字符串 | 字符串的长度为零则为真 |
| -n 字符串 | 字符串的长度不为零则为真 |

实例演示：
```shell
num1="ru1noob"
num2="runoob"
if test $num1 = $num2
then
    echo '两个字符串相等!'
else
    echo '两个字符串不相等!'
fi
```
输出结果：
```shell
两个字符串不相等!
```

## 文件测试

| 参数 | 说明 |
|--|--|
| -e 文件名 | 如果文件存在则为真 |
| -r 文件名 | 如果文件存在且可读则为真 |
| -w 文件名 | 如果文件存在且可写则为真 |
| -x 文件名 | 如果文件存在且可执行则为真 |
| -s 文件名 | 如果文件存在且至少有一个字符则为真 |
| -d 文件名 | 如果文件存在且为目录则为真 |
| -f 文件名 | 如果文件存在且为普通文件则为真 |
| -c 文件名 | 如果文件存在且为字符型特殊文件则为真 |
| -b 文件名 | 如果文件存在且为块特殊文件则为真 |

实例演示：
```shell
cd /bin
if test -e ./bash
then
    echo '文件已存在!'
else
    echo '文件不存在!'
fi
```
输出结果：
```shell
文件已存在!
```

另外，Shell还提供了与( -a )、或( -o )、非( ! )三个逻辑操作符用于将测试条件连接起来，
其优先级为："!"最高，"-a"次之，"-o"最低。例如：
```shell
cd /bin
if test -e ./notFile -o -e ./bash
then
    echo '至少有一个文件存在!'
else
    echo '两个文件都不存在'
fi
```
输出结果：
```shell
至少有一个文件存在!
```

# Shell 流程控制

和Java、PHP等语言不一样，sh的流程控制不可为空，如(以下为PHP流程控制写法)：
```php
<?php
if (isset($_GET["q"])) {
    search(q);
}
else {
    // 不做任何事情
}
```
在sh/bash里可不能这么写，如果else分支没有语句执行，就不要写这个else。

## if else

### if

if 语句语法格式：
```shell
if condition
then
    command1 
    command2
    ...
    commandN 
fi
```
写成一行（适用于终端命令提示符）：
```shell
if [ $(ps -ef | grep -c "ssh") -gt 1 ]; then echo "true"; fi
```
末尾的fi就是if倒过来拼写，后面还会遇到类似的。

### if else
if else 语法格式：
```shell
if condition
then
    command1 
    command2
    ...
    commandN
else
    command
fi
```

### if else-if else

if else-if else 语法格式：
```shell
if condition1
then
    command1
elif condition2 
then 
    command2
else
    commandN
fi
```
以下实例判断两个变量是否相等：
```shell
a=10
b=20
if [ $a == $b ]
then
   echo "a 等于 b"
elif [ $a -gt $b ]
then
   echo "a 大于 b"
elif [ $a -lt $b ]
then
   echo "a 小于 b"
else
   echo "没有符合的条件"
fi
```
输出结果：
```shell
a 小于 b
```
if else语句经常与test命令结合使用，如下所示：
```shell
num1=$[2*3]
num2=$[1+5]
if test $[num1] -eq $[num2]
then
    echo '两个数字相等!'
else
    echo '两个数字不相等!'
fi
```
输出结果：
```shell
两个数字相等!
```

### 多条件处理

如果多个判断条件需要做与或非：
```shell
#!/usr/bin/env bash
# ============================================
# Bash 多条件判断示例脚本（AND / OR / NOT）
# ============================================

val1="1"
val2="2"

echo "============================================"
echo "输入值：val1=${val1}, val2=${val2}"
echo "============================================"

##############################################
# 1️⃣ 逻辑 AND （两个条件都成立）
##############################################
echo
echo "----- AND 逻辑：两个条件都为真时成立 -----"

# 写法 1：常规 Bash 双中括号
if [[ ${val1} == "1" && ${val2} == "1" ]]; then
    echo "[[ ... && ... ]] -> ok"
else
    echo "[[ ... && ... ]] -> not ok"
fi

# 写法 2：两个独立判断块
if [[ ${val1} == "1" ]] && [[ ${val2} == "1" ]]; then
    echo "双 [[ ]] -> ok"
else
    echo "双 [[ ]] -> not ok"
fi

# 写法 3：POSIX 单中括号（兼容 sh）
if [ "${val1}" = "1" ] && [ "${val2}" = "1" ]; then
    echo "POSIX [ ... ] && [ ... ] -> ok"
else
    echo "POSIX [ ... ] && [ ... ] -> not ok"
fi

# 写法 4：传统 test 语法
if test "${val1}" = "1" -a "${val2}" = "1"; then
    echo "test -a -> ok"
else
    echo "test -a -> not ok"
fi

# 写法 5：算术表达式（数字比较）
if (( val1 == 1 && val2 == 1 )); then
    echo "(( ... && ... )) -> ok"
else
    echo "(( ... && ... )) -> not ok"
fi

# 写法 6：一行短路逻辑
[[ ${val1} == "1" && ${val2} == "1" ]] && echo "&& 一行 -> ok" || echo "&& 一行 -> not ok"


##############################################
# 2️⃣ 逻辑 OR （任意一个条件成立）
##############################################
echo
echo "----- OR 逻辑：任意一个条件为真时成立 -----"

# 写法 1：常规 Bash 写法
if [[ ${val1} == "1" || ${val2} == "1" ]]; then
    echo "[[ ... || ... ]] -> ok"
else
    echo "[[ ... || ... ]] -> not ok"
fi

# 写法 2：两个判断块
if [[ ${val1} == "1" ]] || [[ ${val2} == "1" ]]; then
    echo "双 [[ ]] OR -> ok"
else
    echo "双 [[ ]] OR -> not ok"
fi

# 写法 3：POSIX 单中括号
if [ "${val1}" = "1" ] || [ "${val2}" = "1" ]; then
    echo "POSIX [ ... ] || [ ... ] -> ok"
else
    echo "POSIX [ ... ] || [ ... ] -> not ok"
fi

# 写法 4：传统 test -o
if test "${val1}" = "1" -o "${val2}" = "1"; then
    echo "test -o -> ok"
else
    echo "test -o -> not ok"
fi

# 写法 5：算术表达式（数字）
if (( val1 == 1 || val2 == 1 )); then
    echo "(( ... || ... )) -> ok"
else
    echo "(( ... || ... )) -> not ok"
fi

# 写法 6：case 写法
case "${val1}-${val2}" in
    1-* | *-1)
        echo "case -> ok"
        ;;
    *)
        echo "case -> not ok"
        ;;
esac

# 写法 7：一行短路逻辑
[[ ${val1} == "1" || ${val2} == "1" ]] && echo "|| 一行 -> ok" || echo "|| 一行 -> not ok"


##############################################
# 3️⃣ 逻辑 NOT （条件取反）
##############################################
echo
echo "----- NOT 逻辑：条件为假时成立 -----"

# 写法 1：常规 Bash 取反
if ! [[ ${val1} == "1" ]]; then
    echo "![[ ... ]] -> ok"
else
    echo "![[ ... ]] -> not ok"
fi

# 写法 2：取反组合 OR 条件
if ! ([[ ${val1} == "1" || ${val2} == "1" ]]); then
    echo "!(OR) -> ok"
else
    echo "!(OR) -> not ok"
fi

# 写法 3：POSIX 兼容写法
if ! [ "${val1}" = "1" ] && ! [ "${val2}" = "1" ]; then
    echo "POSIX ![ ... ] -> ok"
else
    echo "POSIX ![ ... ] -> not ok"
fi

# 写法 4：算术表达式取反
if ! (( val1 == 1 || val2 == 1 )); then
    echo "!(( ... )) -> ok"
else
    echo "!(( ... )) -> not ok"
fi

# 写法 5：一行取反
! [[ ${val1} == "1" || ${val2} == "1" ]] && echo "一行 ! -> ok" || echo "一行 ! -> not ok"

echo
echo "============================================"
echo "脚本执行完毕 ✅"
echo "============================================"
```

这里中括号用一层或者用两层都可以，一层中括号和两层中括号的区别可以参考常用括号整理的章节

### 简单写法

1. 使用花括号
使用花括号时，开括号 { 后必须有空格，闭括号 } 前必须有分号或换行
两个花括号中的命令块，只能执行其中一个
在当前shell中执行命令组
`[ condition ] && { command1; command2; command3;} || { command4; command5; command6;}`
示例：
```
[ -e "${HOME}" ] && { echo "ok1"; echo "ok2"; echo "ok3";} || { echo "err1"; echo "err2"; echo "err3";}
[ -e "/abcdef" ] && { echo "ok1"; echo "ok2"; echo "ok3";} || { echo "err1"; echo "err2"; echo "err3";}
```

2. 使用括号
两个括号中的命令块，只能执行其中一个
在子shell中执行命令组
`[ condition ] && (command1; command2; command3) || (command4; command5; command6)`
示例：
```
[ -e "${HOME}" ] && (echo "ok1"; echo "ok2"; echo "ok3") || (echo "err1"; echo "err2"; echo "err3")
[ -e "/abcdef" ] && (echo "ok1"; echo "ok2"; echo "ok3") || (echo "err1"; echo "err2"; echo "err3")
```

3. 不使用括号
实际上这种写法是错误的，只能写一条指令，因为只有 command4 取决于前边一条指令是否
执行成功，commnad5和command6一定会执行
`[ condition ] && command1; command2; command3 || command4; command5; command6`
示例：
```
[ -e "${HOME}" ] && echo "ok1"; echo "ok2"; echo "ok3" || echo "err1"; echo "err2"; echo "err3"
[ -e "/abcdef" ] && echo "ok1"; echo "ok2"; echo "ok3" || echo "err1"; echo "err2"; echo "err3"
```


## for 循环

与其他编程语言类似，Shell支持for循环。
for循环一般格式为：
```shell
for var in item1 item2 ... itemN
do
    command1
    command2
    ...
    commandN
done
```
写成一行：
```shell
for var in item1 item2 ... itemN; do command1; command2… done;
```
当变量值在列表里，for循环即执行一次所有命令，使用变量名获取列表中的当前取值。
命令可为任何有效的shell命令和语句。in列表可以包含替换、字符串和文件名。

in列表是可选的，如果不用它，for循环使用命令行的位置参数。

例如，顺序输出当前列表中的数字：
```shell
for loop in 1 2 3 4 5
do
    echo "The value is: $loop"
done
```
输出结果：
```shell
The value is: 1
The value is: 2
The value is: 3
The value is: 4
The value is: 5
```
顺序输出字符串中的字符：
```shell
for str in 'This is a string'
do
    echo $str
done
```
输出结果：
```shell
This is a string
```

另一种for循环的语法：
```
max=10
for (( i=0; i <= $max; ++i ))
do
    echo "$i"
done
```

另一种for循环的方法：
seq 是 Linux / Unix 下一个专门用来生成数字序列的小工具
```
for i in $(seq 0 3); do
  printf "%s" "$i"
done
```

对于bash可以写成：
```
for i in {0..3}; do
  echo "$i"
done
```


## while 语句

while循环用于不断执行一系列命令，也用于从输入文件中读取数据；命令通常为测试条件。其格式为：
```shell
while condition
do
    command
done
```
以下是一个基本的while循环，测试条件是：如果int小于等于5，那么条件返回真。int从0开始，
每次循环处理时，int加1。运行上述脚本，返回数字1到5，然后终止。
```shell
#!/bin/bash
int=1
while(( $int<=5 ))
do
    echo $int
    let "int++"
done
```
运行脚本，输出：
```shell
1
2
3
4
5
```
以上实例使用了 Bash let 命令，它用于执行一个或多个表达式，变量计算中不需要加上 `$`
来表示变量，具体可查阅：`Bash let` 命令 

while循环可用于读取键盘信息。下面的例子中，输入信息被设置为变量FILM，按`Ctrl-D`
结束循环。
```shell
echo '按下 <CTRL-D> 退出'
echo -n '输入你最喜欢的网站名: '
while read FILM
do
    echo "是的！$FILM 是一个好网站"
done
```
运行脚本，输出类似下面：
```shell
按下 <CTRL-D> 退出
输入你最喜欢的网站名:菜鸟教程
是的！菜鸟教程 是一个好网站
```

## 无限循环

无限循环语法格式：
```shell
while :
do
    command
done
```
或者
```shell
while true
do
    command
done
```
或者
```shell
for (( ; ; ))
```

## until 循环
* until 循环执行一系列命令直至条件为 true 时停止。
* until 循环与 while 循环在处理方式上刚好相反。
* 一般 while 循环优于 until 循环，但在某些时候—也只是极少数情况下，until 循环更加有用。

until 语法格式:
```shell
until condition
do
    command
done
```
condition 一般为条件表达式，如果返回值为 false，则继续执行循环体内的语句，否则跳出循环。
以下实例我们使用 until 命令来输出 0 ~ 9 的数字：
```shell
#!/bin/bash

a=0

until [ ! $a -lt 10 ]
do
   echo $a
   a=`expr $a + 1`
done
```
运行结果：
```shell
输出结果为：
0
1
2
3
4
5
6
7
8
9
```

## case
Shell case语句为多选择语句。可以用case语句匹配一个值与一个模式，如果匹配成功，执行
相匹配的命令。每个 case 分支用右圆括号开始，用两个分号 ;; 表示 break，即执行结束，
跳出整个 case 语句。case语句格式如下：
```shell
case 值 in
模式1)
    command1
    command2
    ...
    commandN
    ;;
模式2）
    command1
    command2
    ...
    commandN
    ;;
esac
```
case工作方式如上所示。取值后面必须为单词in，每一模式必须以右括号结束。取值可以为
变量或常数。匹配发现取值符合某一模式后，其间所有命令开始执行直至 ;;。

取值将检测匹配的每一个模式。一旦模式匹配，则执行完匹配模式相应命令后不再继续其他
模式。如果无一匹配模式，使用星号 * 捕获该值，再执行后面的命令。

下面的脚本提示输入1到4，与每一种模式进行匹配：
```shell
echo '输入 1 到 4 之间的数字:'
echo '你输入的数字为:'
read aNum
case $aNum in
    1)  echo '你选择了 1'
    ;;
    2)  echo '你选择了 2'
    ;;
    3)  echo '你选择了 3'
    ;;
    4)  echo '你选择了 4'
    ;;
    *)  echo '你没有输入 1 到 4 之间的数字'
    ;;
esac
```
输入不同的内容，会有不同的结果，例如：
```shell
输入 1 到 4 之间的数字:
你输入的数字为:
3
你选择了 3
```

## 跳出循环
在循环过程中，有时候需要在未达到循环结束条件时强制跳出循环，Shell使用两个命令来
实现该功能：break和continue。

### break命令

break命令允许跳出所有循环（终止执行后面的所有循环）。
下面的例子中，脚本进入死循环直至用户输入数字大于5。要跳出这个循环，返回到shell
提示符下，需要使用break命令。
```shell
#!/bin/bash
while :
do
    echo -n "输入 1 到 5 之间的数字:"
    read aNum
    case $aNum in
        1|2|3|4|5) echo "你输入的数字为 $aNum!"
        ;;
        *) echo "你输入的数字不是 1 到 5 之间的! 游戏结束"
            break
        ;;
    esac
done
```
执行以上代码，输出结果为：
```shell
输入 1 到 5 之间的数字:3
你输入的数字为 3!
输入 1 到 5 之间的数字:7
你输入的数字不是 1 到 5 之间的! 游戏结束
```


### continue

continue命令与break命令类似，只有一点差别，它不会跳出所有循环，仅仅跳出当前循环。

对上面的例子进行修改：
```shell
#!/bin/bash
while :
do
    echo -n "输入 1 到 5 之间的数字: "
    read aNum
    case $aNum in
        1|2|3|4|5) echo "你输入的数字为 $aNum!"
        ;;
        *) echo "你输入的数字不是 1 到 5 之间的!"
            continue
            echo "游戏结束"
        ;;
    esac
done
```
运行代码发现，当输入大于5的数字时，该例中的循环不会结束，语句 echo "游戏结束" 
永远不会被执行。


# Shell 函数

linux shell 可以用户定义函数，然后在shell脚本中可以随便调用。
shell中函数的定义格式如下：
```shell
[ function ] funname()
{
    action;
    [return int;]  #返回值可用$?查询
}
```
说明：
1. 可以带function fun() 定义，也可以直接fun() 定义,不带任何参数。
2. 参数返回，可以显示加：return 返回，如果不加，将以最后一条命令运行结果，作为
   返回值。 return后跟数值n(0-255

下面的例子定义了一个函数并进行调用：
```shell
#!/bin/bash

demoFun(){
    echo "这是我的第一个 shell 函数!"
}
echo "-----函数开始执行-----"
demoFun
echo "-----函数执行完毕-----"
```
输出结果：
```shell
-----函数开始执行-----
这是我的第一个 shell 函数!
-----函数执行完毕-----
```
下面定义一个带有return语句的函数：
```shell
#!/bin/bash

funWithReturn(){
    echo "这个函数会对输入的两个数字进行相加运算..."
    echo "输入第一个数字: "
    read aNum
    echo "输入第二个数字: "
    read anotherNum
    echo "两个数字分别为 $aNum 和 $anotherNum !"
    return $(($aNum+$anotherNum))
}
funWithReturn
echo "输入的两个数字之和为 $? !"
```
输出类似下面：
```shell
这个函数会对输入的两个数字进行相加运算...
输入第一个数字: 
1
输入第二个数字: 
2
两个数字分别为 1 和 2 !
输入的两个数字之和为 3 !
```
函数返回值在调用该函数后通过 $? 来获得。

注意：所有函数在使用前必须定义。这意味着必须将函数放在脚本开始部分，直至shell
解释器首次发现它时，才可以使用。调用函数仅使用其函数名即可。

## 函数参数

在Shell中，调用函数时可以向其传递参数。在函数体内部，通过 $n 的形式来获取参数的值，
例如，$1表示第一个参数，$2表示第二个参数...
带参数的函数示例：
```shell
#!/bin/bash

funWithParam(){
    echo "第一个参数为 $1 !"
    echo "第二个参数为 $2 !"
    echo "第十个参数为 $10 !"
    echo "第十个参数为 ${10} !"
    echo "第十一个参数为 ${11} !"
    echo "参数总数有 $# 个!"
    echo "作为一个字符串输出所有参数 $* !"
}
funWithParam 1 2 3 4 5 6 7 8 9 34 73
```
输出结果：
```shell
第一个参数为 1 !
第二个参数为 2 !
第十个参数为 10 !
第十个参数为 34 !
第十一个参数为 73 !
参数总数有 11 个!
作为一个字符串输出所有参数 1 2 3 4 5 6 7 8 9 34 73 !
```
注意，$10 不能获取第十个参数，获取第十个参数需要${10}。当n>=10时，需要使用${n}来
获取参数。

另外，还有几个特殊字符用来处理参数：
| 参数处理 | 说明 |
|--|--|
| $# | 传递到脚本或函数的参数个数 |
| $* | 以一个单字符串显示所有向脚本传递的参数 |
| $$ | 脚本运行的当前进程ID号 |
| $! | 后台运行的最后一个进程的ID号 |
| $@ | 与$*相同，但是使用时加引号，并在引号中返回每个参数。 |
| $- | 显示Shell使用的当前选项，与set命令功能相同。 |
| $? | 显示最后命令的退出状态。0表示没有错误，其他任何值表明有错误。 |


# Shell 输入/输出重定向

大多数 UNIX 系统命令从你的终端接受输入并将所产生的输出发送回到您的终端。一个命令
通常从一个叫标准输入的地方读取输入，默认情况下，这恰好是你的终端。同样，一个命令
通常将其输出写入到标准输出，默认情况下，这也是你的终端。

重定向命令列表如下：
| 命令 | 说明 |
|--|--|
| `command > file` | 将输出重定向到 file。 |
| `command < file` | 将输入重定向到 file。 |
| `command >> file` | 将输出以追加的方式重定向到 file。 |
| `n > file` | 将文件描述符为 n 的文件重定向到 file。 |
| `n >> file` | 将文件描述符为 n 的文件以追加的方式重定向到 file。 |
| `n >& m` | 将输出文件 m 和 n 合并。 |
| `n <& m` | 将输入文件 m 和 n 合并。 |
| `<< tag` | 将开始标记 tag 和结束标记 tag 之间的内容作为输入。 |

需要注意的是文件描述符 0 通常是标准输入（STDIN），1 是标准输出（STDOUT），2 是
标准错误输出（STDERR）。

## 输出重定向

重定向一般通过在命令间插入特定的符号来实现。特别的，这些符号的语法如下所示:
```shell
command1 > file1
```
上面这个命令执行command1然后将输出的内容存入file1。任何file1内的已经存在的内容将
被新内容替代。如果要将新内容添加在文件末尾，使用>>操作符。

实例

执行下面的 who 命令，它将命令的完整的输出重定向在用户文件中(users):
```shell
$ who > users
```
执行后，并没有在终端输出信息，这是因为输出已被从默认的标准输出设备（终端）重定向
到指定的文件。

你可以使用 cat 命令查看文件内容：
```shell
$ cat users
_mbsetupuser console  Oct 31 17:35 
tianqixin    console  Oct 31 17:35 
tianqixin    ttys000  Dec  1 11:33 
```
输出重定向会覆盖文件内容，请看下面的例子：
```shell
$ echo "菜鸟教程：www.runoob.com" > users
$ cat users
菜鸟教程：www.runoob.com
$
```
如果不希望文件内容被覆盖，可以使用 >> 追加到文件末尾，例如：
```shell
$ echo "菜鸟教程：www.runoob.com" >> users
$ cat users
菜鸟教程：www.runoob.com
菜鸟教程：www.runoob.com
$
```

## 输入重定向

在Shell中，`<<<`、`<` 和 `<<` 都用于将数据传递给命令，但它们在语法和用法上有所
不同。下面逐一解释这些操作符的区别。

1. **`<`（输入重定向）**

`<` 是 **输入重定向** 操作符，用于将文件的内容作为标准输入传递给命令，语法为：
```shell
command1 < file1
```
同时替换输入和输出，执行command1，从文件infile读取内容，然后将输出写入到outfile
中。
```shell
command1 < infile > outfile
```

示例：
```bash
cat < file.txt
```
这条命令的作用是将 `file.txt` 文件的内容传递给 `cat` 命令，`cat` 会将文件内容打印
到屏幕上。
- **作用**：把文件内容传递给命令作为标准输入。
- **用法**：只能重定向文件内容。

2. **`<<`（Here Document）**

`<<` 是 **Here Document**（即“这里文档”）操作符，允许你将多行文本直接嵌入到脚本
中，并将其作为标准输入传递给命令。文本可以是多行的，直到遇到指定的分隔符为止。

示例：
```bash
cat << EOF
This is the first line.
This is the second line.
EOF
```
输出：
```
This is the first line.
This is the second line.
```
- **作用**：将多行文本传递给命令作为标准输入。
- **用法**：你可以在命令行中写多行输入文本，并在最后一个分隔符（如 `EOF`）处结束。

**注意**：`<<` 后面的 `EOF` 是一个自定义的标识符，你可以使用任何你喜欢的字符串
（如 `END` 或 `STOP`），只要在结束的地方使用相同的标识符。

3. **`<<<`（Here String）**

`<<<` 是 **Here String** 操作符，它允许你将一个单行的字符串传递给命令作为标准
输入。它是 `<<` 的简化版本，用于处理单行输入。

示例：
```bash
cat <<< "Hello, World!"
```
输出：
```
Hello, World!
```
- **作用**：将一个单行字符串传递给命令作为标准输入。
- **用法**：这种方式适合直接将一个字符串传递给命令，而不需要额外的多行输入。


**总结对比：**

| 操作符 | 说明                 | 用法示例                | 适用情况                           |
|--------|----------------------|-------------------------|------------------------------------|
| `<`    | 输入重定向           | `cat < file.txt`        | 从文件读取输入并传递给命令         |
| `<<`   | Here Document（多行）| `cat << EOF\ntext\nEOF` | 将多行文本作为标准输入传递给命令   |
| `<<<`  | Here String（单行）  | `cat <<< "Hello"`       | 将单行字符串作为标准输入传递给命令 |


## 重定向深入讲解

一般情况下，每个 Unix/Linux 命令运行时都会打开三个文件：
* 标准输入文件(stdin)：stdin的文件描述符为0，Unix程序默认从stdin读取数据。
* 标准输出文件(stdout)：stdout 的文件描述符为1，Unix程序默认向stdout输出数据。
* 标准错误文件(stderr)：stderr的文件描述符为2，Unix程序会向stderr流中写入错误信息。

默认情况下，command > file 将 stdout 重定向到 file，`command < file` 将stdin 重定向
到 file。如果希望 stderr 重定向到 file，可以这样写：
```shell
$ command 2> file
```

如果希望 stderr 追加到 file 文件末尾，可以这样写：
```shell
$ command 2>> file
```
2 表示标准错误文件(stderr)。

如果希望将 stdout 和 stderr 合并后重定向到 file，可以这样写：
```shell
$ command > file 2>&1
```
或者
```shell
$ command >> file 2>&1
```

如果希望对 stdin 和 stdout 都重定向，可以这样写：
```shell
$ command < file1 >file2
```
command 命令将 stdin 重定向到 file1，将 stdout 重定向到 file2。

## 深入理解 >& 符号

`n>&m`:
1. 将文件描述符 n 重定向到文件描述符 m，即，将 m 复制到 n
2. 如果 n 没有其他备份的话，就会丢失

`>&` 实际上是将后面的文件描述符复制给前面的文件描述符。如果 n 或 m 省略了，那么
它们默认分别指代标准输出（1）和标准错误输出（2）。

保存和恢复的示例
```shell
#!/bin/bash

# 保存原始的标准输出和标准错误输出
# 这里用于保存的数字可以写大一些，避免出现冲突
exec 1001>&1 1002>&2

# 重定向标准输出到标准错误输出
exec 1>&2

# 这条消息将被重定向到标准错误输出
echo "This message is redirected to stderr"

# 恢复原始的标准输出和标准错误输出
exec 1>&1001 2>&1002

# 关闭临时文件描述符
exec 1001>&- 1002>&-

# 这条消息将回到标准输出
echo "This message is back to stdout"
```
* This message is redirected to stderr 被输出到标准错误。
* This message is back to stdout 被输出到标准输出。


`>&` 和 `&>`:
* `>&` 是一个通用的文件描述符重定向操作符，允许你将任意文件描述符的输出重定向到
       另一个文件描述符
* `&>` 是一个简写形式，用于同时将标准输出和标准错误输出重定向到同一个文件

举例：
```shell
#!/bin/bash

# 使用 >&
ls non_existing_file > output_1.txt 2>&1
echo "Using >&: Check output_1.txt for both stdout and stderr"

# 使用 &>
ls non_existing_file &> output_2.txt
echo "Using &>: Check output_2.txt for both stdout and stderr"
```
运行脚本，会发现 output_1.txt 和 output_2.txt 的内容相同，包含了标准输出和标准
错误输出的信息。


`&-` 是用于关闭文件描述符的语法。通过使用 `&-`，你可以关闭特定的文件描述符，释放
与其关联的资源。
* `n>&-`：关闭文件描述符 n
* `>&-`： 省略 n 时，默认是 1>&-，即关闭标准输出（非常少见，通常不关闭标准输出）


## tee 命令

tee 允许用户从标准输入读取数据，并将其内容同时复制到标准输出和一个或多个文件中

举例：
* `echo "Hello, World!" | tee file.txt`：这将输出“Hello, World!”到屏幕，并将其
  写入file.txt文件中。使用覆盖模式写入文件
* `echo "Hello, World!" | tee file.txt`：这将输出“Hello, World!”到屏幕，并将其
  追加到file.txt文件中。使用追加模式写入文件

## Here Document

Here Document 是 Shell 中的一种特殊的重定向方式，用来将输入重定向到一个交互式
Shell 脚本或程序。

它的基本的形式如下：
```shell
command << delimiter
    document
delimiter
```
它的作用是将两个 delimiter 之间的内容(document) 作为输入传递给 command。

注意：
* 结尾的delimiter 一定要顶格写，前面不能有任何字符，后面也不能有任何字符，包括空格和 tab 缩进。
* 开始的delimiter前后的空格会被忽略掉。

实例

在命令行中通过 wc -l 命令计算 Here Document 的行数：
```shell
$ wc -l << EOF
    欢迎来到
    菜鸟教程
    www.runoob.com
EOF
3          # 输出结果为 3 行
$
```
我们也可以将 Here Document 用在脚本中，例如：
```shell
#!/bin/bash

cat << EOF
欢迎来到
菜鸟教程
www.runoob.com
EOF
```
执行以上脚本，输出结果：
```shell
欢迎来到
菜鸟教程
www.runoob.com
```

## /dev/null 文件

如果希望执行某个命令，但又不希望在屏幕上显示输出结果，那么可以将输出重定向到 /dev/null：
```shell
$ command > /dev/null
```
/dev/null 是一个特殊的文件，写入到它的内容都会被丢弃；如果尝试从该文件读取内容，
那么什么也读不到。但是 /dev/null 文件非常有用，将命令的输出重定向到它，会起到
"禁止输出"的效果。

如果希望屏蔽 stdout 和 stderr，可以这样写：
```shell
$ command > /dev/null 2>&1
```
注意：0 是标准输入（STDIN），1 是标准输出（STDOUT），2 是标准错误输出（STDERR）。
这里的 2 和 > 之间不可以有空格，2> 是一体的时候才表示错误输出。


# Shell 文件包含

和其他语言一样，Shell 也可以包含外部脚本。这样可以很方便的封装一些公用的代码作为
一个独立的文件。

Shell 文件包含的语法格式如下：
```shell
. filename   # 注意点号(.)和文件名中间有一空格
```
或
```shell
source filename
```

实例: 创建两个 shell 脚本文件。

test1.sh 代码如下：
```shell
#!/bin/bash

url="http://www.runoob.com"
```
test2.sh 代码如下：
```shell
#!/bin/bash

#使用 . 号来引用test1.sh 文件
. ./test1.sh

# 或者使用以下包含文件代码
# source ./test1.sh

echo "菜鸟教程官网地址：$url"
```
接下来，我们为 test2.sh 添加可执行权限并执行：
```shell
$ chmod +x test2.sh 
$ ./test2.sh 
菜鸟教程官网地址：http://www.runoob.com
```
注：被包含的文件 test1.sh 不需要可执行权限。


# Shell脚本中常用到的括号整理

## 1、双引号 " "

双引号常用于包含一组字符串，在双引号中，除了 `$`、`\`、`(反引号)` 有特殊含义外，
其余字符（如IFS、换行符、回车符等）没有特殊含义。
```shell
$ a=3
$ echo "$a"
```
输出结果为 3，在双引号中 $ 符仍有特殊含义。

## 2、单引号 ' '

单引号的功能与双引号类似，不过单引号中的所有字符都没有特殊含义：
```shell
$ a=3
$ echo '$a'
```
输出结果为 $a，可见在单引号中 $ 符是不起作用的。

## 3、反引号 ` `
反引号的功能是命令替换，在反引号中的内容通常是命令行，程序会优先执行反引号中的
内容，并使用运行结果替换掉反引号处的内容。举个例子：
```shell
$ echo `date`
```
这行命令会先执行反引号中的命令 date，然后用 echo 命令打印出 date 命令的结果
（与直接使用 date 命令效果一样）。再举个例子：
```shell
#!/bin/bash

a=3
b=5
c=`expr $a \* $b`

echo $c

exit 0
```

## 4、$ + 小括号 $( )
`$(...)` 的作用与反引号一样，也是命令替换：
```shell
#!/bin/bash

for file in $(ls /)
do
    echo $file
done

exit 0
```
这个脚本使用 for 循环打印根目录下所有文件的文件名，使用`$(ls /)`先获得根目录下的
所有文件，并将其作为参数列表传给 for 结构。

## 5、$ + 双小括号 $(( ))
`$(( ))` 的功能是进行算术运算，括号中的内容为数学表达式，使用 `$(( ))` 可以求数学
表达式的值：
```shell
#！/bin/bash

a=3
b=5
c=$(($a * $b))
echo $c

exit 0
```
上述脚本的输出结果为 15。

使用 `$(( ))` 进行数学运算时，不需要担心乘号等运算符被 shell 误解为其他含义，因为
它们都在括号内。

## 6、$ + 中括号 $[ ]

`$[ ]` 的功能与 `$(( ))` 一样，都是用于算术运算。

## 7、$ + 大括号 ${ }

（1） ${ } 的功能是变量替换，类似于 $ 符，但是 ${ } 比 $ 的替换范围更精准：

```shell
#！/bin/bash

a=3
b=5
echo $ab
echo ${a}b

exit 0
```
这段脚本，第一次输出 `$ab` 的时候，会把 ab 视作一个变量，然后打印 ab 的值，显然为
空；第二次使用 `${a}b`，则会先输出 a 的值然后再向 STDOUT 打印一个字符 b。


（2） 几种特殊的替换结构
```shell
${var:-string},${var:+string},${var:=string},${var:?string},
```

① `${var:-string}`和`${var:=string}`:
  若变量var为空，则用在命令行中用string来替换`${var:-string}`，否则变量var不为
  空时，则用变量var的值来替换`${var:-string}`；
  对于`${var:=string}`的替换规则和`${var:-string}`是一样的，所不同之处是
  `${var:=string}`若var为空时，用string替换`${var:=string}`的同时，把string赋给
  变量`var： ${var:=string}`很常用的一种用法是，判断某个变量是否赋值，没有的话
  则给它赋上一个默认值。

② `${var:+string}`的替换规则和上面的相反，即只有当var不是空的时候才替换成
  string，若var为空时则不替换或者说是替换成变量 var的值，即空值。(因为变量var
  此时为空，所以这两种说法是等价的)

③ `${var:?string}`替换规则为：若变量var不为空，则用变量var的值来替换`${var:?string}`；
  若变量var为空，则把string输出到标准错误中，并从脚本中退出。我们可利用此特性来
  检查是否设置了变量的值。

补充扩展：在上面这五种替换结构中string不一定是常值的，可用另外一个变量的值或是一种
命令的输出。

## 8、小括号 ( )

①	小括号可以用来定义一个数组变量
如下：
```shell
array1=(1 2 3 4 5)　　　　　　　　　　　　// 在 shell 中定义一个数组变量
array2=(one two three four five)
```
取数组元素的值也是使用 `$` 符号，如下：
```shell
$ echo $array1
$ 1
$
$ echo ${array1[2]}        # 取数组中的一个元素，索引用方括号括起来，从 0 开始
$ 3
$
$ echo ${array2[0]}
$ one
$
$ echo ${array2[*]}        # 输出整个数组
$ one two three four five
```
这里使用了 ${ } 表达式，进行变量替换。
注意：在 shell 中使用数组变量有时会引起一些问题，而且数组变量的可移植性并不好，
因此在 shell 编程中，数组变量使用得并不多。


②命令组。括号中的命令将会新开一个子shell顺序执行，所以括号中的变量不能够被脚本
  余下的部分使用。括号中多个命令之间用分号隔开，最后一个命令可以没有分号，各命令
  和括号之间不必有空格。

## 9、双小括号 (( ))
双小括号命令允许在比较过程中使用高级数学表达式：
```shell
(( expression ))
```
其中，expression 可以是任意的数学赋值或表达式。相比 test 命令只能在比较中使用简单
的算术操作，双小括号命令提供了更多的数学符号，可以在双小括号中进行各种逻辑运算、
数学运算，也支持更多的运算符（如 ++、-- 等）。

常使用的双小括号来在 for 循环中实现 C 语言风格的迭代：
```shell
#!/bin/bash

for ((i = 0; i < 10; i++))
do
    echo -n "$i "
done
echo ""

exit 0
```
如果不使用双括号, 则为for i in `seq 0 4` 或者 `for i in {0 1 2 3 4}`。再如可以
直接使用 `if (($i<5))`, 如果不使用双括号, 则为`if [ $i -lt 5 ]`。

## 10、中括号 [ ]
单个的中括号的功能与 test 命令一样，都是用作条件测试。
```shell
#!/bin/bash

read -p "please enter a number: " num

if [ $num -gt 10 ]; then
    echo "num > 10"
else
    echo "num <= 10"
fi
```

## 11、双中括号 [[ ]]
双中括号提供了针对字符串比较的高级特性，使用双中括号 [[ ]] 进行字符串比较时，可以
把右边的项看做一个模式，故而可以在 [[ ]] 中使用正则表达式：
```shell
#！/bin/bash

if [[ hello == hell* ]]; then
    echo "equal"
else
    echo "unequal"
fi

exit 0
```

## 12、大括号 { }
大括号用于括起一个语句块。如果需要在某些只能使用单个语句的地方（如AND、OR列表中）
使用多条语句，则可以用大括号将这多条语句括起来构造一个语句块。
单大括号，{ cmd1;cmd2;cmd3;} 在当前shell顺序执行命令cmd1,cmd2,cmd3, 各命令之间
用分号隔开, 最后一个命令后必须有分号, 第一条命令和左括号之间必须用空格隔开。

总结：

| 功能                                     | 符号             ｜
|------------------------------------------|------------------|
| 引用字符串，字符串中部分特殊符号有意义   | 双引号""         |
| 引用字符串，字符串中特殊符号全都没有意义 | 单引号''         |
| 命令替换                                 | (反引号)，`$()`  |
| 算数运算                                 | $(())、$[]、(()) |
| 变量替换                                 | ${}              |
| 数组初始化                               | ()               |
| 条件测试                                 | []               |
| 字符串比较                               | [[ ]]            |
| 括起一个语句块                           | { }              |


对{}和()而言, 括号中的重定向符只影响该条命令， 而括号外的重定向符影响到括号中的所有命令。

# 正则表达式

这里讲的内容应该只针对bash，未必适用于其他shell

---

> 适用范围：`[[ string =~ regex ]]`
> **不是 grep / sed / awk 的正则**

---

> **Bash 正则 = 条件判断 + 捕获工具
> 不是文本处理工具**

---

## 基础语法

---

**Bash 正则的使用位置**

Bash 正则 **只能在 `[[ ... =~ ... ]]` 里使用**
```bash
[[ STRING =~ REGEX ]]
```

成功 / 失败
| 结果           | 含义     |
| -------------- | -------- |
| true (返回 0)  | 匹配成功 |
| false (返回 1) | 匹配失败 |

---

**最重要的规则**

正则 **不要加引号**
```bash
# 错误
[[ "$s" =~ "abc.*" ]]

# 正确
[[ "$s" =~ abc.* ]]
```
> 一旦加引号，Bash 会把正则当成普通字符串

---

**BASH_REMATCH**

当正则匹配成功后，Bash 会自动生成数组：
```bash
BASH_REMATCH
```

数组含义
| 索引  | 内容               |
| ----- | ------------------ |
| `[0]` | 整个匹配到的字符串 |
| `[1]` | 第一个 `()`        |
| `[2]` | 第二个 `()`        |
| ...   | 依次类推           |

**示例**
```bash
s="Frame123"
[[ "$s" =~ ([A-Za-z]+)([0-9]+) ]]

echo ${BASH_REMATCH[0]}   # Frame123
echo ${BASH_REMATCH[1]}   # Frame
echo ${BASH_REMATCH[2]}   # 123
```

---

## 基础正则符号（Bash 支持）

字符匹配
| 写法    | 含义          |
| ------- | ------------- |
| `a`     | 匹配字母 a    |
| `.`     | 任意单个字符  |
| `[abc]` | a 或 b 或 c   |
| `[a-z]` | 任意小写字母  |
| `[A-Z]` | 任意大写字母  |
| `[0-9]` | 任意数字      |

---

次数匹配（量词）
| 符号 | 含义         |
| ---- | ------------ |
| `*`  | 0 次或多次   |
| `+`  | 1 次或多次   |
| `?`  | 0 次或 1 次  |

```bash
[[ "aaa" =~ a+ ]]   # true
[[ "" =~ a* ]]      # true
[[ "a" =~ a? ]]     # true
```

---

分组 `()`
```bash
(abc)
```
* 把多个字符当成一个整体
* **必须用 () 才能进 BASH_REMATCH**

---

或 `|`
```bash
cat|dog
```
匹配 `cat` 或 `dog`

---

锚点（位置控制）
| 写法  | 含义       |
| ----- | ---------- |
| `^`   | 字符串开头 |
| `$`   | 字符串结尾 |
```bash
[[ "abc123" =~ ^abc ]]   # true
[[ "abc123" =~ 123$ ]]   # true
```

---

## 常用模式总结

数字
```regex
[0-9]+
```

字母
```regex
[A-Za-z]+
```

字母 + 数字
```regex
[A-Za-z0-9]+
```

Frame / frame / frm + 数字
```regex
([Ff]rame|frm)([0-9]+)
```

文件名（不含路径）
```regex
[^/]+$
```

扩展 Frame 写法
```regex
([Ff]rame|frm)[_-]?([0-9]+)
```

匹配：
```
Frame12
Frame_12
Frame-12
frm3
```

---

**典型完整示例**

```bash
file="/path/to/frame_003/output.yuv"

if [[ "$file" =~ ([Ff]rame|frm)[_-]?([0-9]+) ]]; then
    echo "完整匹配: ${BASH_REMATCH[0]}"
    echo "类型: ${BASH_REMATCH[1]}"
    echo "编号: ${BASH_REMATCH[2]}"
fi
```

输出：
```
完整匹配: frame_003
类型: frame
编号: 003
```

---

## 与 grep 正则的区别

| 项目         | Bash         | grep      |
| ------------ | ------------ | --------- |
| 使用位置     | `[[ =~ ]]`   | 命令      |
| 是否自动捕获 | ✅ 是        | ❌ 否     |
| 变量引用     | 直接变量     | 需要 echo |
| 引号规则     | ❌ 不加      | ✅ 常加   |

---

## Bash 正则不支持的内容

不支持：
* `\d`
* `\w`
* `\s`
* 非贪婪 `*?`
* lookahead / lookbehind

用替代写法：

| 想要     | 写法           |
| -------- | -------------- |
| 数字     | `[0-9]`        |
| 字母数字 | `[A-Za-z0-9_]` |
| 空白     | `[[:space:]]`  |

---

## 最佳实践

1. 正则 **永远不加引号**
2. 用 `()` 才能拿到 `BASH_REMATCH`
3. 能用 `[[ ]]` 就不用 `[ ]`
4. 路径匹配优先用字符串截取，复杂再用正则
5. 匹配完立刻用 `BASH_REMATCH`，别跨语句

---

# Bash 特有的 BASH_SOURCE 系列变量

> 这些都是 **Bash 专用**，在 sh/dash/fish 等 shell 中 **不可用**。

---

## `BASH_SOURCE`

---

* **基本作用**： `BASH_SOURCE` 是一个 **数组变量**，用来记录当前执行的 **脚本文件的路径**。
* 当脚本中有 **函数** 或 **source 引入其他脚本** 时，它比 `$0` 更可靠。
* `$0` 总是显示 **最开始执行的脚本名称**，而 `BASH_SOURCE` 可以追踪 **当前执行上下文**。
* 基本语法`echo "${BASH_SOURCE[0]}"`
    * `[0]` → 当前脚本或函数所在的文件
    * `[1]` → 调用当前脚本或函数的文件
    * `[2]` → 再上一级，依次类推

---

**举例说明**

例子 1：单脚本直接执行
```bash
#!/usr/bin/env bash

echo "BASH_SOURCE[0]: ${BASH_SOURCE[0]}"
echo "0: $0"

# 输出：
# BASH_SOURCE[0]: test.sh
# 0: test.sh
```
---
例子 2：通过 `source` 引入
```
目录结构：
main.sh
lib.sh
```
**lib.sh**
```bash
#!/usr/bin/env bash
echo "Inside lib.sh"
echo "BASH_SOURCE[0]: ${BASH_SOURCE[0]}"
echo "BASH_SOURCE[1]: ${BASH_SOURCE[1]}"
echo "0: $0"
```
**main.sh**
```bash
#!/usr/bin/env bash
source ./lib.sh
```
执行：
```bash
bash main.sh
```
输出：
```
Inside lib.sh
BASH_SOURCE[0]: ./lib.sh
BASH_SOURCE[1]: main.sh
0: main.sh
```
解释：
* `BASH_SOURCE[0]` → 当前被执行/source 的文件 (`lib.sh`)
* `BASH_SOURCE[1]` → 调用它的文件 (`main.sh`)
* `$0` → 最初执行的脚本 (`main.sh`)

这也是为什么 `BASH_SOURCE` 比 `$0` 更适合 **追踪当前脚本位置**。

---

## `FUNCNAME` 与 `BASH_SOURCE` 配合

* `FUNCNAME` 是一个数组，记录 **函数调用栈**
* 常用于 **打印日志或调试堆栈**
```bash
function f1() {
    echo "FUNCNAME[0]: ${FUNCNAME[0]}"
    echo "BASH_SOURCE[0]: ${BASH_SOURCE[0]}"
}

f1
```
输出：
```
FUNCNAME[0]: f1
BASH_SOURCE[0]: script.sh
```

如果多层函数调用，你可以结合 `${FUNCNAME[@]}` 和 `${BASH_SOURCE[@]}` 打印完整调用栈。

---

## 获取当前脚本绝对路径

经常需要获取 **脚本所在目录**，而不是当前工作目录。正确方法：
```bash
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "$script_dir"
```
解释：
1. `${BASH_SOURCE[0]}` → 当前脚本文件
2. `dirname` → 取目录
3. `cd ... && pwd` → 转成绝对路径

这样无论从哪执行脚本，都能得到脚本的真实目录

---

## 常用组合

| 变量             | 用法               | 说明                               |
| ---------------- | ------------------ | ---------------------------------- |
| `BASH_SOURCE[0]` | 当前脚本文件       | 即使在函数里，也能准确获取当前文件 |
| `BASH_SOURCE[1]` | 调用当前文件的脚本 | source 时很有用                    |
| `FUNCNAME[0]`    | 当前函数名         | 调试日志                           |
| `FUNCNAME[1]`    | 上一级函数         | 调用堆栈                           |
| `BASH_SOURCE[@]` | 调用栈文件数组     | 追踪整个脚本调用链                 |

---

## 注意事项

1. **BASH 专用**
   * sh / dash / ksh / zsh 没有 `BASH_SOURCE`
   * 在这些 shell 下会报 `BASH_SOURCE: unbound variable`

2. **source 的文件路径**
   * `BASH_SOURCE[0]` 总是当前被 source 的文件
   * `$0` 永远是最初执行的脚本

3. **数组下标**
   * `[0]` 当前文件
   * `[1]` 调用它的文件
   * `[2]` 再上一级，以此类推

4. **结合函数使用**
   * 常和 `${FUNCNAME[@]}` 搭配打印调用堆栈

---

## 总结

* `$0` → 最初执行的脚本
* `BASH_SOURCE[0]` → 当前文件
* `BASH_SOURCE[1]` → 调用当前文件的脚本
* 用 `$(dirname "${BASH_SOURCE[0]}")` 可以获取脚本目录

> **Tip:** 如果你写可复用的 Bash 脚本库或者调试工具，`BASH_SOURCE` + `FUNCNAME` 是必备组合。

---

# 重要指令

## `dirname`

打印文件或目录所在路径。如：
```shell
$dirname /ete/samba/
$/etc
$dirname /tec/samba/smb.config
$/etc/samba
```
获取当前脚本的相对路径（相对路径由当前路径指向脚本路径）：`$(dirname $0)`
获取当前脚本的绝对路径：$(cd \`dirname $0\` && pwd)

## `readlink -f $path`

获取path所指链接或文件或目录的绝对路径，如果path没有链接，就显示文件或目录本身的
绝对路径，若有则显示相对路径。与dirname不同的是会保留最后的节点。如：
```shell
$readlink -f /etc/samba
$/etc/samba
$readlink -f /etc/samba/smb.conf
$/etc/samba/smb.conf
对于 lt—>/etc/samba
$readlink -f lt
$/etc/samba
```

## 获取CPU核心数

```shell
    JOB_NUM=”$(grep  -c  ^processor   /proc/cpuinfo)”
    grep的参数 -c用于统计数量
```


## `getopts`

getopts后面跟的字符串就是参数列表，每个字母代表一个选项
* 如果字母后面跟一个:，则就表示这个选项还会有一个值
* 如果字母后面没有跟随:，则该字母就是开关型选项，不需要指定值

举例：
```shell
func() {
    echo "Usage:"
    echo "  test.sh [-j S_DIR] [-m D_DIR]"
    echo ""
    echo "Description:"
    echo "  S_DIR,the path of source."
    echo "  D_DIR,the path of destination."
    exit -1
}

upload="false"

while getopts 'h:j:m:u' OPT
do
    case $OPT in
        j)
            S_DIR="$OPTARG"
            ;;
        m)
            D_DIR="$OPTARG"
            ;;
        u)
            upload="true"
            ;;
        h)
            func
            ;;
        ?)
            func
            ;;
    esac
done

echo $S_DIR
echo $D_DIR
echo $upload
```

## eval

eval 命令是 Unix/Linux shell（包括 bash、zsh 等）中的一个强大但危险的命令，它用于
对参数进行求值并执行结果作为命令。简而言之，eval 会将其后的参数作为一条新的命令来
执行，并且这条命令在解析时会经历通常的 shell 展开（如变量替换、命令替换和算术扩展
等）过程。

### 基本用法

假设有以下变量和命令：
```
CMD="echo Hello, World!"
```
如果你想执行存储在变量 CMD 中的命令，可以使用 eval：
```
eval $CMD
```
或者更安全的做法是：
```
eval "$CMD"
```
后者通过将整个命令作为单个参数传递给 eval，避免了因命令中包含空格或特殊字符而导致
的解析错误或安全问题。

### 使用场景

* 动态构建命令：当你需要根据程序运行时的情况动态构建命令并执行时，eval 可以非常有用。
* 处理复杂变量：当变量中包含需要被 shell 展开的元素（如变量名、引号、反引号等）时，
  使用 eval 可以确保这些元素被正确处理。

举例：
```
val="a"
a_sufix="ok"

eval dst='$'${val}_sufix
# or
# eval dst='$''a_sufix'

echo $dst
```
以上demo最终将dst设置为"ok"，eval 命令会将后面的参数作为一条新的命令来执行。如果
后面的参数中包含了需要被 shell 展开的元素（如变量、命令替换等），eval 会在执行前
进行这些展开。

eval 本身并不限制展开的次数，而是 shell 的展开机制在 eval 执行前对字符串进行处理。
这意味着，如果传递给 eval 的字符串中包含了多层嵌套的展开元素，那么这些元素会在eval
执行前被逐层展开，直到没有更多的展开可以执行为止。

举例：
```
var1="echo First level: \$(echo Second level: \$var2)"
var2="Hello, nested eval!"
eval "$var1"

var3="echo Top level: \$(echo Middle level: \$(echo Bottom level: \$var2))"
eval "$var3"
```

### 警告和安全问题

* 代码注入：eval 最大的危险在于它允许执行任意代码，这可能导致安全漏洞。如果 eval 的
  参数来自不可信的源（如用户输入），攻击者可以注入恶意代码并执行它。
* 复杂性和难以调试：使用 eval 会使代码更难理解和调试，因为它隐式地改变了命令的求值方式。
* 性能影响：虽然在现代系统上这种影响可能微乎其微，但 eval 可能会稍微降低脚本的执行
  速度，因为它需要额外的步骤来解析和执行命令。

### 替代方案

在可能的情况下，最好避免使用 eval，并寻找更安全、更清晰的替代方案。例如：
* 使用函数来封装复杂的命令逻辑。
* 使用数组来存储和遍历命令序列。
* 使用 shell 的内置功能（如变量替换、命令替换等）来直接处理数据，而不是通过 eval
  间接执行。

总之，eval 是一个强大的工具，但它也伴随着很高的风险。在使用之前，请仔细考虑是否真
的需要它，并考虑是否有更安全、更简单的替代方案。
