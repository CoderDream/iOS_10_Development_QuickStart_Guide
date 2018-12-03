# 第1章　创建项目并集成LeanCloud SDK #

## 注册LeanCloud并创建项目 ##

- 访问[https://leancloud.cn/](https://leancloud.cn/) 并注册账号

- 登陆并进入控制台，选择【中国华东节点】节点，我的机器其他节点测试连接失败：

![](https://github.com/CoderDream/iOS_10_Development_QuickStart_Guide/blob/master/snapshot/chapter01/chapter01000.png)

- 创建新应用【Instagram】

![](https://github.com/CoderDream/iOS_10_Development_QuickStart_Guide/blob/master/snapshot/chapter01/chapter01001.png)

- 输入新应用名称

![](https://github.com/CoderDream/iOS_10_Development_QuickStart_Guide/blob/master/snapshot/chapter01/chapter01006.png)

- 创建成功后显示应用列表

![](https://github.com/CoderDream/iOS_10_Development_QuickStart_Guide/blob/master/snapshot/chapter01/chapter01002.png)

- 查看应用Key

![](https://github.com/CoderDream/iOS_10_Development_QuickStart_Guide/blob/master/snapshot/chapter01/chapter01003.png)

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