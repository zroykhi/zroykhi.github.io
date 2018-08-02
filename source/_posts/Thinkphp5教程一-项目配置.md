---
title: 'Thinkphp5教程一:项目配置'
date: 2018-08-02 14:32:39
categories:
- 阅读笔记
tags:
- PHP
- Thinkphp
---
> 最近在学thinkPHP, 但是官网给的教程十分简陋, 惜字如金, 很多没有解释清楚. 所以自己整理了一些笔记, 供参考. 转载请联系.


开始之前, 可以首先将application文件夹名字修改为app, 然后修改public/index.php入口文件中的`define('APP_PATH', __DIR__ . '/../application/');` 变为`define('APP_PATH', __DIR__ . '/../app/');`, 这样之后的代码在逻辑上可能更好理解. 我项目的主目录是ThinkPHP/, 如果你的项目不是这个名字, 需要自行修改保证url能正常访问.

# 惯例配置
在入口文件中定义项目config文件夹.
```
// 定义配置文件目录
define('CONF_PATH', __DIR__ . '/../conf/');
```
convention.php里面有默认定义, 默认是application文件夹之下的config.php, 然后在app同级文件中建立一个新文件夹conf/, 该文件夹中建立一个config.php文件, 里面的配置对所有的应用起效. 这样的规划对项目后期维护很方便, 因为它的默认配置有很多是不变的。访问: http://localhost/ThinkPHP/public/index/Index/index  即可查看所有的config.

application文件夹下的config.php文件配置会覆盖convention文件的配置

# 拓展配置
可以在上面建立的conf文件夹之下建立一个extra文件夹, 里面建立一个email.php, 写入:
```
<?php
return [
  'host' => 'stmp@qq.com',
  'name' => '333@qq.com'
];
```
Index.php控制器中输入:
```
<?php
namespace app\index\controller;

class index{
  public function index()
  {
    dump(config()); // 打印所有配置
  }
}
```
那么打印的配置中会多了一项email, 其值为一个数组就是上面我们设置的. 它默认文件名为配置名称, return回来是该名称配置的数组配置值. 我们可以同样修改database等配置, 一般不是很复杂的开发时候, 没有必要这么做, 也可以将database.php放置在conf文件夹下, 同样可以生效(因为几乎每个项目都用到database, 出于人性化考虑, thinkPHP提供这样的功能, 但其他配置名称未必可以这么做了), 这些单独建立的配置文件的优先级高于config.php文件中的配置, 所以会覆盖其中的配置.

# 场景配置
不同场景下使用的配置, 如家里和公司的配置文件
在conf/config.php中加上一个配置: ‘app_status’ => ‘home’
然后在conf文件夹之下建立一个文件home.php, 里面设置在家时使用的配置, 比如数据库密码不同, 但注意**数据库**需要设置**全部的配置**, 否则数据库配置会不全(thinkphp一个bug). 同样, 可以建立office.php, 里面设置在办公室时候的配置. 之后如果需要切换, 只需要将app_status修改为home或者office即可

# 模块配置
之前的配置是对所有模块都会生效. 如果想某配置只对某模块起作用该怎么办? 在conf文件夹下建立模块同名的文件夹如index/, 其下新建config.php, 里面设置的配置只对index这个模块生效. 此外, 你也可以再建立文件conf/index/extra/demo.php, 里面设置一些拓展配置, 同样该配置只对index模块起作用.

# 动态配置
主要对当前控制器或者当前方法设置配置. 比如在index控制器中写入:
```
<?php
namespace app\index\controller;

class index{
  public function __construction()
  {
    config('before', 'beforeAction');
  }

  public function index()
  {
    config('indexActionn', 'index');
    dump(config()); // 打印所有配置
  }

  public function demo()
  {
    dump(config());
  }
}
```

** __construction() ** 会在执行所有方法之前执行, 打开浏览器输入
http://localhost/ThinkPHP/public/index/Index/index  和
http://localhost/ThinkPHP/public/index/Index/demo
即可查看两种方法下config的区别.

# config类和助手函数config
config函数可以看做是config类的一个简化, 使用它的时候比较简单比如不需要设置namespace等. Index控制器中输入:
```
<?php
namespace app\index\controller;

use think\Config;

class Index
{
  public function index()
  {
    // get param
    // $res = Config::get(); // same result as below
    // $res = config();

    // $res = Config::get('app_namespace');// get parameter's value
    // $res = config('app_namespace'); // same result as above

    // dump($res);

    // set params
    // Config::set('username', 'theo');
    // config('username', 'theo');
    // dump(Config::get('username')); // return null if para doesn't exist

    // 设置作用域(第三个参数)
    // Config::set('username', 'theo', 'index'); // get时候同样需要设置作用域
    // config('username', 'theo', 'index');
    // dump(Config::get('username'), 'index');
    // dump(Config::get('username')); // return null if para doesn't exist

    $res = config('?username');
    $res = Config::has('username');
    dump($res);

  }
}
```
取消注释看不同的结果. config()定义在thinkphp/helper.php这个文件里. 可自行查看其代码实现
