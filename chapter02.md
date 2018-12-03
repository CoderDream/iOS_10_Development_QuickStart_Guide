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

![](https://github.com/CoderDream/iOS_10_Development_QuickStart_Guide/blob/master/snapshot/chapter02/chapter02010.png)


## 2.2 搭建用户的登陆界面


### 新增2个文本输入框和3个按钮

- 内容如下：

```
platform :ios, '8.0' # '12.1'
use_frameworks!

target 'Instagram' do
   pod 'LeanCloud'
end
```

- 在终端中执行安装命令

```
pod install
```

- 安装结果

![](https://github.com/CoderDream/iOS_10_Development_QuickStart_Guide/blob/master/snapshot/chapter01/chapter01004.png)


### 修改源代码

- 修改 AppDelegate.swfit 的    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool 方法

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions 
	launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    LeanCloud.initialize(applicationID: "Your App ID", applicationKey: "Your App Key")
    
    /* Create an object. */
    let object = LCObject(className: "Post")
    object.set("words", value: "Hello World!")
    /* Save the object to LeanCloud application. */
    object.save { result in
        switch result {
        case .success: print("Success")
        case .failure: print("Failure")
        }
    }
    
    return true
}
```

- 运行结果

![](https://github.com/CoderDream/iOS_10_Development_QuickStart_Guide/blob/master/snapshot/chapter01/chapter01005.png)