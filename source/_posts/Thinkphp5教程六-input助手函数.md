---
title: 'Thinkphp5教程六:input助手函数'
date: 2018-08-07 15:07:19
categories:
- 阅读笔记
tags:
- PHP
- Thinkphp
---
> 最近在学thinkPHP, 但是官网给的教程十分简陋, 惜字如金, 很多没有解释清楚. 所以自己整理了一些笔记, 供参考. 转载请联系.

开始之前, 可以首先将application文件夹名字修改为app, 然后修改public/index.php入口文件中的`define('APP_PATH', __DIR__ . '/../application/');` 变为`define('APP_PATH', __DIR__ . '/../app/');`, 这样之后的代码在逻辑上可能更好理解. 我项目的主目录是ThinkPHP/, 如果你的项目不是这个名字, 需要自行修改保证url能正常访问.

input助手函数定义在helper.php, 注意自己定义的函数里面不能有input, 否则不能正常使用input. 废话不说，直接例子：
app/index/controller/Index.php:
```
<?php
namespace app\index\controller;

use think\Request;

class Index
{
    public function index(Request $request)
    {
      dump($request->param());
      // $res = input('post.id');
      // dump($request->post('id'));

      $res = input('get.id');
      dump($request->get('id'));
      // 强制过滤
      $res = input('post.id', 100, 'intval');
      dump($request->get('id', 100, 'intval'));
      session('email', '222@qq.com');
      dump(input('session.email'));
      dump($res);

    }
}
```
访问http://localhost/ThinkPHP/public/index/Index/index/type/5.html?id=10, 若同时收到get和post,且他们含有同一个参数名id, 那么$res = input('id');不能正常取到所有的值, 需要使用$res = input('post.id');或者$res = input(get.id');才行. 建议直接使用Request对象里面的各种方法获取参数, 使用input助手函数会出现重定义出错问题。
