# 第2章 创建用户登录界面 #

## 2.1 从故事面板中创建视图 ##

- 新增2个 View Controller 到原 View Controller 的右侧


![](https://github.com/CoderDream/iOS_10_Development_QuickStart_Guide/blob/master/snapshot/chapter02/chapter02001.gif)

- 新增完毕

![](https://github.com/CoderDream/iOS_10_Development_QuickStart_Guide/blob/master/snapshot/chapter02/chapter02001.png)

- 新建文件

![](https://github.com/CoderDream/iOS_10_Development_QuickStart_Guide/blob/master/snapshot/chapter01/chapter01002.png)

- 选择类型为“Cocoa Touch Class”

![](https://github.com/CoderDream/iOS_10_Development_QuickStart_Guide/blob/master/snapshot/chapter01/chapter01003.png)

- 设置Class和Subclass

![](https://github.com/CoderDream/iOS_10_Development_QuickStart_Guide/blob/master/snapshot/chapter01/chapter01004.png)

- 设置第一个View Controller的Class

![](https://github.com/CoderDream/iOS_10_Development_QuickStart_Guide/blob/master/snapshot/chapter01/chapter01005.png)

- 确保第一个View Controller的“Is Initial View Controller”被选中

![](https://github.com/CoderDream/iOS_10_Development_QuickStart_Guide/blob/master/snapshot/chapter01/chapter01008.png)

## 新建 Instagram 项目 

- 新建项目

![](https://github.com/CoderDream/iOS_10_Development_QuickStart_Guide/blob/master/snapshot/chapter01/chapter01007.png)

- 项目信息
 
![](https://github.com/CoderDream/iOS_10_Development_QuickStart_Guide/blob/master/snapshot/chapter01/chapter01008.png)

- 项目文件结构

![](https://github.com/CoderDream/iOS_10_Development_QuickStart_Guide/blob/master/snapshot/chapter01/chapter01009.png)


## 将LeanCloud SDK 集成到 iOS 项目中


### 新增 Podfile

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