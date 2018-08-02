---
title: 'Thinkphp5教程二:系统环境配置和使用'
date: 2018-08-02 14:50:52
categories:
- 阅读笔记
tags:
- PHP
- Thinkphp
---
> 最近在学thinkPHP, 但是官网给的教程十分简陋, 惜字如金, 很多没有解释清楚. 所以自己整理了一些笔记, 供参考. 转载请联系.

开始之前, 可以首先将application文件夹名字修改为app, 然后修改public/index.php入口文件中的`define('APP_PATH', __DIR__ . '/../application/');` 变为`define('APP_PATH', __DIR__ . '/../app/');`, 这样之后的代码在逻辑上可能更好理解. 我项目的主目录是ThinkPHP/, 如果你的项目不是这个名字, 需要自行修改保证url能正常访问.

首先在项目的根目录下面建立一个.env文件(文件名不可以更改), 在里面直接设置环境参数值. 如: email=2222@qq.com, 获取该环境变量只需要`dump($\_ENV[‘PHP_EMAIL’]);`
如果`$\_ENV`为空，其原因通常是php的配置文件/opt/lampp/etc/php.ini的配置项为`variables_order = "GPCS"`。要想让`$\_ENV`的值不为空，那么`variables_order`的值应该加上一个大写字母“E”即`variables_order = "EGPCS"`。然后重启lampp: `sudo /opt/lampp/lampp restart`

使用`$\_ENV`时候, 系统会自动在设置的环境变量名前面增加`PHP_`, 同时将环境变量名变成大写, 所以这时获取某环境变量时记得做相应改变; 为避免这个不方便的地方, 我们可以使用Env类. app/index/controller/Index.php:
```
<?php
namespace app\index\controller;

use think\Config;
use think\Env;

class Index
{
  public function index()
  {
    // dump($_ENV);
    // dump($_ENV['PHP_EMAIL']);

    $res = Env::get('email');
    dump($res);
  }
}
```

我们配合使用场景配置和环境变量设置就可以切换线上线下生产环境的配置. 例子conf/config.php中写:
```
<?php
use think\Env;
return [
    ‘app_status’  =>  Env::get(‘app_status’, ‘dev’)
];
```
Env::get()的第二个参数是默认值(当该该参数没有设置时). conf/test.php:
```
<?php
return [
    ‘app_now_statue’  => ‘test’
];
```
conf/dev.php:
```
<?php
return [
    ‘app_now_statue’  => ‘dev’
];
```
Index.php:
```
<?php
namespace app\index\controller;

use think\Config;
use think\Env;

class Index
{
  public function index()
  {
    dump(config());
  }
}
```
当我们需要改变环境时候, 只需要将.env文件下的status=test和status=dev之间切换, 即可该变环境. 这样我们做到仅仅修改.env文件, 其他文件都不变, 就可以实现不同环境之间的切换.

另一个例子, conf/database.php:
```
<?php
use think\Env;

    return [
        // 数据库类型
        'type'            => 'mysql',
        // 数据库连接DSN配置
        'dsn'             => '',
        // 服务器地址
        'hostname'        => '127.0.0.1',
        // 数据库名
        'database'        => '',
        // 数据库用户名
        'username'        => Env::get(‘database.username’, ‘root’)
        // 数据库密码
        'password'        => '',
        // 数据库连接端口
        'hostport'        => '',
        // 数据库连接参数
        'params'          => [],
        // 数据库编码默认采用utf8
        'charset'         => 'utf8',
        // 数据库表前缀
        'prefix'          => '',
        // 数据库调试模式
        'debug'           => false,
        // 数据库部署方式:0 集中式(单一服务器),1 分布式(主从服务器)
        'deploy'          => 0,
        // 数据库读写是否分离 主从式有效
        'rw_separate'     => false,
        // 读写分离后 主服务器数量
        'master_num'      => 1,
        // 指定从服务器序号
        'slave_no'        => '',
        // 是否严格检查字段是否存在
        'fields_strict'   => true,
        // 数据集返回类型
        'resultset_type'  => 'array',
        // 自动写入时间戳字段
        'auto_timestamp'  => false,
        // 时间字段取出后的默认时间格式
        'datetime_format' => 'Y-m-d H:i:s',
        // 是否需要进行SQL性能分析
        'sql_explain'     => false,
    ],
```
.env文件:
```
[database]
username=root_env
password=root
```
修改username变量即可方便地切换环境.
