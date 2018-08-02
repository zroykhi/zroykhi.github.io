---
title: 'Thinkphp5教程四:路由'
date: 2018-08-02 15:20:04
categories:
- 阅读笔记
tags:
- PHP
- Thinkphp
---
> 最近在学thinkPHP, 但是官网给的教程十分简陋, 惜字如金, 很多没有解释清楚. 所以自己整理了一些笔记, 供参考. 转载请联系.

开始之前, 可以首先将application文件夹名字修改为app, 然后修改public/index.php入口文件中的`define('APP_PATH', __DIR__ . '/../application/');` 变为`define('APP_PATH', __DIR__ . '/../app/');`, 这样之后的代码在逻辑上可能更好理解. 我项目的主目录是ThinkPHP/, 如果你的项目不是这个名字, 需要自行修改保证url能正常访问.

# 路由
路由是为了规范访问的url, 使得访问的地址更简洁. 同时隐藏文件的真实地址, 使得网站更加安全. 开启路由的方法: 复制convention.php下的`url_router_on`到应用的config.php里并修改其值为true, 新建文件conf/router.php:
```
<?php
return [
    ‘news/:id’ => ‘index/index/info’
];
```

index模块的Index.php文件:
```
<?php
namespace app\index\controller;

class Index
{
    public function index()
    {
        return ‘index index index’;
    }

    public function info($id)
    {
        // 没开路由前: localhost/index/index/info/id/5
        // 设置路由之后: localhost/news/5.html
        echo url(‘index/index/info’, [‘id => 10]) . “<br>”;
        echo url(‘index/index/index’, [‘id => 10]) . “<br>”;
        return “{$id}”;
    }
    public function demo()
    {
        echo ‘demo’;
    }
}
```
若conf/config.php文件中增加了`’url_router_must’ => true`, 则正常的url不能访问, 比如
http://localhost/ThinkPHP/public/index/Index/demo 会报错, 此时我们需要在路由router.php里面设置`‘index/index/demo’  => ‘index/index/demo’`, 才可以正确访问. 这么麻烦, 所以一般开发时候我们设置`’url_router_must’ => false`.
