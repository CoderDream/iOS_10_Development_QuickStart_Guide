# 第2章 创建用户登录界面 #

## 2.1 从故事面板中创建视图 ##

- 新增2个 View Controller 到原 View Controller 的右侧


![](https://github.com/CoderDream/iOS_10_Development_QuickStart_Guide/blob/master/snapshot/chapter02/chapter02001.gif)

- 新增完毕

![](https://github.com/CoderDream/iOS_10_Development_QuickStart_Guide/blob/master/snapshot/chapter02/chapter02001.png)

- 新建文件

![](https://github.com/CoderDream/iOS_10_Development_QuickStart_Guide/blob/master/snapshot/chapter02/chapter02002.png)

- 选择类型为“Cocoa Touch Class”

![](https://github.com/CoderDream/iOS_10_Development_QuickStart_Guide/blob/master/snapshot/chapter02/chapter02003.png)

- 设置Class和Subclass

![](https://github.com/CoderDream/iOS_10_Development_QuickStart_Guide/blob/master/snapshot/chapter02/chapter02004.png)

- 设置第一个View Controller的Class

![](https://github.com/CoderDream/iOS_10_Development_QuickStart_Guide/blob/master/snapshot/chapter02/chapter02007.png)

- 确保第一个View Controller的“Is Initial View Controller”被选中

![](https://github.com/CoderDream/iOS_10_Development_QuickStart_Guide/blob/master/snapshot/chapter02/chapter02008.png)

- 删除“ViewController.swift”文件

![](https://github.com/CoderDream/iOS_10_Development_QuickStart_Guide/blob/master/snapshot/chapter02/chapter02005.png)

- 选择“Move to Trash”
 
![](https://github.com/CoderDream/iOS_10_Development_QuickStart_Guide/blob/master/snapshot/chapter02/chapter02006.png)

- 最终项目文件结构

![](https://github.com/CoderDream/iOS_10_Development_QuickStart_Guide/blob/master/snapshot/chapter02/chapter02009.png)


## 2.2 搭建用户的登陆界面


### 新增2个文本输入框和3个按钮

- 新增输入框：

![](https://github.com/CoderDream/iOS_10_Development_QuickStart_Guide/blob/master/snapshot/chapter02/chapter02010.png)

- 新增按钮

![](https://github.com/CoderDream/iOS_10_Development_QuickStart_Guide/blob/master/snapshot/chapter02/chapter02011.png)

## 2.3 为SignInVC类的视图创建Outlet和Action关联

- 打开助手编辑器模式，左边显示Main.storyboard，右边显示SignInVC ：

![](https://github.com/CoderDream/iOS_10_Development_QuickStart_Guide/blob/master/snapshot/chapter02/chapter02013.png)

### 2.3.2 为SignInVC创建Outlet

- 设置usernameTxt的Outlet关联

![](https://github.com/CoderDream/iOS_10_Development_QuickStart_Guide/blob/master/snapshot/chapter02/chapter02012.png)

### 2.3.2 为SignInVC创建Action

- 为SignInVC添加Action方法

![](https://github.com/CoderDream/iOS_10_Development_QuickStart_Guide/blob/master/snapshot/chapter02/chapter02014.png)

- “登陆”按钮的关联信息

![](https://github.com/CoderDream/iOS_10_Development_QuickStart_Guide/blob/master/snapshot/chapter02/chapter02015.png)

- 修改signInBtnClicked(_:)方法

```swift
@IBAction func signInBtnClicked(_ sender: UIButton) {
    print("登录按钮被单击")
}
```

- 执行结果：

![](https://github.com/CoderDream/iOS_10_Development_QuickStart_Guide/blob/master/snapshot/chapter02/chapter02016.png)