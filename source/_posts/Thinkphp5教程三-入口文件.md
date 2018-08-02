---
title: 'Thinkphp5教程三:入口文件'
date: 2018-08-02 15:05:51
categories:
- 阅读笔记
tags:
- PHP
- Thinkphp
---
> 最近在学thinkPHP, 但是官网给的教程十分简陋, 惜字如金, 很多没有解释清楚. 所以自己整理了一些笔记, 供参考. 转载请联系.

开始之前, 可以首先将application文件夹名字修改为app, 然后修改public/index.php入口文件中的`define('APP_PATH', __DIR__ . '/../application/');` 变为`define('APP_PATH', __DIR__ . '/../app/');`, 这样之后的代码在逻辑上可能更好理解. 我项目的主目录是ThinkPHP/, 如果你的项目不是这个名字, 需要自行修改保证url能正常访问.

# 入口文件
单入口文件: 应用程序的所有http请求都由某文件接收并由这个文件转发到功能代码中. thinkPHP框架中所有的请求都经过public/index.php.

单入口文件优势:
  + 安全检测
  + 请求过滤

`public/index.php`文件中必须加载框架引导文件`start.php`, 该文件为我们处理安全过滤.可以修改app/index/controller/Index.php文件:
```
<?php
namespace app\index\controller;

class index
{
  public function index()
  {
    dump(config());// print all the configs
  }
}
```

# 隐藏入口文件
方法:
  + 将websever的根目录设置为项目的public/文件夹
  + 取消注释`httpd.conf`文件(Ubuntu中在/opt/lampp/etc/下)里的`LoadModule rewrite_module modules/mod_rewrite.so`
  + 将该文件中的<Directory “root_dir_of_your_web_server”>下的`AllowOverride None改为AllowOverride All`
  + 同时保证网站目录public/.htaccess文件中内容为:
```
<IfModule mod_rewrite.c>
  Options +FollowSymlinks -Multiviews
  RewriteEngine On

  RewriteCond %{REQUEST_FILENAME} !-d
  RewriteCond %{REQUEST_FILENAME} !-f
  RewriteRule ^(.*)$ index.php/$1 [QSA,PT,L]
</IfModule>
```
  + 重启Apache

注释: `RewriteRule ^(.*)$ index.php/$1 [QSA,PT,L]`是指将所有请求`^(.*)$`放到index.php/后面的`$1`这里, 所以保证我们能正常访问.

# 入口文件的绑定
在入口文件index.php添加:
```
define('BIND_MODULE', 'demo');
```
则url访问demo模块下Index控制器的index方法需要输入: http://localhost/ThinkPHP/public/Index/index

若是`define('BIND_MODULE', 'demo/index');`, 则url访问demo模块下Index控制器的index方法需要输入: http://localhost/ThinkPHP/public/index
总之要保证define里面参数加上url的参数最终得到: 模块/控制器/方法 的形式, 才可以正确访问, 只有小项目的时候需要设置入口文件绑定, 大项目一般不用设置.

假设我们的项目需要给第三方提供接口, 这时我们不希望第三方还访问经过public/index.php, 我们可以建立public/api.php, 写入:
```
<?php
define('APP_PATH', __DIR__ . '/../application/');
define('CONF_PATH', __DIR__ . '/../conf/');
define('BIND_MODULE', 'api');
require __DIR__ . '/../thinkphp/start.php';
```
此时我们访问: http://localhost/ThinkPHP/public/api.php, 则只能访问到api这个模块了.

或者使用thinkPHP提供的另一个功能. 在conf/config.php文件中添加配置: `‘auto_bind_module’  => true`, 这时系统会根据url里面含有的php文件名自动访问对应的同名模块. 这时假设我们url输入: http://localhost/ThinkPHP/public/api.php/index/demo
即可直接访问api模块下的index控制器的demo方法.

需要注意的是, 通过设置`auto_bind_module`绑定的方法是可以访问其他模块的, 而通过define方式绑定的入口若没有该模块则直接报错.
