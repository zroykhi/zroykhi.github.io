---
title: 'Thinkphp5教程五:请求对象Request'
date: 2018-08-02 15:27:48
categories:
- 阅读笔记
tags:
- PHP
- Thinkphp
---
> 最近在学thinkPHP, 但是官网给的教程十分简陋, 惜字如金, 很多没有解释清楚. 所以自己整理了一些笔记, 供参考. 转载请联系.

开始之前, 可以首先将application文件夹名字修改为app, 然后修改public/index.php入口文件中的`define('APP_PATH', __DIR__ . '/../application/');` 变为`define('APP_PATH', __DIR__ . '/../app/');`, 这样之后的代码在逻辑上可能更好理解. 我项目的主目录是ThinkPHP/, 如果你的项目不是这个名字, 需要自行修改保证url能正常访问.

# 请求对象Request
Generally, we use the following three methods to get parameters.
 + 直接使用request方法
 + 使用Request类, 单例模式, 在整个应用中, 只能实例化一次
 + 直接注入方法, 传入参数(建议使用, 更加直白)

具体代码例子如下:

```
<?php
namespace app\index\controller;

use think\Request;

class Index
{
    public function index()
    {
      // method 1
      // $request = request();
      // method 2
      $request = Request::instance();
      dump($request);
    }
    // method 3
    public function demo(Request $request)
    {
        dump($request);
    }
}
```
内部流程是：入口文件index.php-> 引入start.php->执行App::run()-> 返回一个Request对象, 所以后面就可以直接使用request了. Example：
app/index/controller/Index.php
```
<?php
namespace app\index\controller;

use think\Request;

class Index
{
    public function index(Request $request)
    {
      // 获取浏览器输入框的值
      dump($request->domain());
      dump($request->pathinfo());
      dump($request->path());

      // 请求类型
      dump($request->method());
      dump($request->isGet());
      dump($request->isPost());
      dump($request->isAjax());

      // 请求的参数
      dump($request->get());
      dump($request->param());
      dump($request->post());
      // session('name', 'theo');
      dump($request->session());
      // cookie('email', '222@qq.com');
      dump($request->cookie());
      dump($request->param('type'));
      dump($request->cookie('email'));

      // 获取模块, 控制器, 操作, 用于验证是否有权限等
      dump($request->module());
      dump($request->controller());
      dump($request->action());
      dump($request->url());
      dump($request->baseUrl());


    }
}

```

然后我们在浏览器输入: http://localhost/ThinkPHP/public/index/Index/index/type/5.html?id=10

要注意的是:需要将convention.php中的session设置复制到app的config.php中, 然后记得删除**httponly**和**secure**这两项设置, 才能正常启用session. (实际测试中, 不删除也可以使用)
