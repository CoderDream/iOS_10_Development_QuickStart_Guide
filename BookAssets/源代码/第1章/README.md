

## 获取 SDK  

获取 SDK 有多种方式，较为推荐的方式是通过包依赖管理工具下载最新版本。

包依赖管理工具安装
CocoaPods 是开发 macOS 和 iOS 应用程序的一个第三方库的依赖管理工具，通过它可以定义自己的依赖关系（称作 pods），并且随着时间的推移，它会让整个开发环境中对第三方库的版本管理变得非常方便。具体可以参考 CocoaPods 安装和使用教程。


在项目根目录下创建一个名为 Podfile 的文件（无扩展名），并添加以下内容：

```
platform :ios, '12.1'
use_frameworks!

target 'Instagram' do
   pod 'LeanCloud'
end
```
使用 pod --version 确认当前 CocoaPods 版本 >= 1.0.0，如果低于这一版本，请执行 $ sudo gem install cocoapods 升级 CocoaPods。最后安装 SDK：
```
pod install --repo-update
```

- 安装Pod
```
CoderDreamdeMac:Instagram coderdream$ pod install
Analyzing dependencies
Downloading dependencies
Using Alamofire (4.8.0)
Using LeanCloud (15.0.0)
Generating Pods project
Integrating client project
Sending stats
Pod installation complete! There is 1 dependency from the Podfile and 2 total pods installed.
CoderDreamdeMac:Instagram coderdream$
```

在 Xcode 中关闭所有与该项目有关的窗口，以后就使用项目根目录下 <项目名称>.xcworkspace 来打开项目。

### 初始化  

首先进入 控制台 > 设置 > 应用 Key 来获取 App ID 以及 App Key。

打开 AppDelegate.swift 文件，添加下列导入语句到头部：

```swift
import LeanCloud
```

然后粘贴下列代码到 application:didFinishLaunchingWithOptions 函数内：

```swift
LCApplication.default.set(
    id:  "d5ML1LvUmHL5i5CT70MwWAfn-9Nh9j0Va", /* Your app ID */
    key: "qeeskxXCy1lrBbl1vrkGgTrp" /* Your app key */
)
```

修改 AppDelegate.swfit 的application(_, didFinishLaunchingWithOptions) 方法，添加如下测试代码：

```swift
let post = LCObject(className: "Post")
post.set("words", value: "Hello World!")

_ = post.save { result in
    switch result {
    case .success:
        break
    case .failure(let error):
        break
    }
}
```

参考文档：
1. [Swift SDK 安装指南](https://tab.leancloud.cn/docs/start.html)