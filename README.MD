# Terant: the new termux-ant.

--------------------------------------------

## 使用方法：

1. 同步脚本
````sh
$ git clone https://github.com/urain39/terant
````

2. 进入目录
````sh
$ cd terant
````
3. 安装（解包）
````sh
$ bash terant.sh # 本人只保证bash能执行。
````
4. 启动系统
````sh
$ terant
````

## 扩展支持

dev版里支持使用module文件载入模块，以对特定发行版做优化

因为模块本身就是shell脚本的原因，所以除了必要的环境变量以外

可以按照自己喜欢的方式进行自定义。如下arch-pre.module

````sh
# 一些关于作者的信息，随便改。
echo "Module by urain39"

# 系统名称
SYSTEM="archlinux-arm"

# 保存文件名字
TGZ_FILE=${PWD}/${SYSTEM}.tgz

# 64位下载地址
DOWN_URL64="http://mirrors.ustc.edu.cn/archlinuxarm/os/ArchLinuxARM-aarch64-latest.tar.gz"

# 32位下载地址
DOWN_URL32="http://mirrors.ustc.edu.cn/archlinuxarm/os/ArchLinuxARM-armv5-latest.tar.gz"

# 余下的自由发挥
````
pre和post本质区别是pre是解包前运行，post是解包后运行。

### 其他说明

1. 只有一个不知道是64位或者32位链接时记得两个都填上！以防意外。

2. 模块不能同时使用，除非是通用的模块，不含下载链接的。

3. 模块仅在安装时有效，安装后无效。

---------------------------------------------------------------

## 注意事项：

    1. 可能需要执行两次脚本才能生效
    
    2. 卸载请运行uninst.sh脚本

    3. 本页面接受任何模块，请fork本项目以后发PR