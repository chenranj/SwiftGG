# SwiftGG iOS App

<p align="center">
<img src="path_to_app_icon" width="120"/>
</p>

<p align="center">
<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/Swift-5.0-orange.svg?style=flat" alt="Swift 5.0"></a>
<a href="https://developer.apple.com/ios"><img src="https://img.shields.io/badge/iOS-15.0%2B-blue.svg" alt="iOS 15.0+"></a>
<a href="https://github.com/your_username/SwiftGG/blob/main/LICENSE"><img src="https://img.shields.io/github/license/your_username/SwiftGG" alt="License"></a>
</p>

SwiftGG iOS客户端是一个优雅的Swift社区阅读应用,为Swift开发者提供高质量的Swift相关文章阅读体验。

## 功能特点

- 📱 原生SwiftUI开发,支持iOS 18.0+
- 🌓 支持浅色/深色模式,可跟随系统或手动切换
- 📖 文章阅读体验优化
  - 可调节字体大小
  - 优化排版与间距
  - 代码块样式优化
- 🔄 文章列表支持下拉刷新
- 💬 评论功能(开发中)
- 🔍 搜索功能(计划中)
- 📱 支持iPhone/iPad自适应布局

## 截图展示

![promotion image](https://swiftgg.org/ios.jpeg)

## 系统要求

- iOS 15.0+
- Xcode 14.0+
- Swift 5.0+

## 安装说明

1. Clone 项目到本地:
```bash
git clone https://github.com/SwiftGGTeam/swiftgg-ios.git
```

2. 打开Xcode, 选择`Open another project` 选择`swiftgg-ios`文件夹

3. 等待Xcode下载依赖, 编译运行即可

## 项目架构

项目采用MVVM架构模式:

```
SwiftGG/
├── Views/ # SwiftUI视图
│ ├── ArticleDetailView.swift # 文章详情页
│ ├── PostListView.swift # 文章列表页
│ ├── SwiftGuideView.swift # Swift手册页
│ ├── SponsorsView.swift # 赞助商页面
│ ├── MeView.swift # 个人中心
│ └── Components/ # 可复用组件
├── ViewModels/ # 视图模型
├── Models/ # 数据模型
├── Services/ # 网络服务
│ ├── SponsorsService.swift # 赞助商数据服务
│ ├── ContributorsService.swift # 贡献者数据服务
│ └── ReadingPreferences.swift # 阅读偏好设置
└── Utilities/ # 工具类
```

### 主要功能模块

#### 1. 文章阅读
- 支持文章列表展示和详情阅读
- 文章内容优化排版
- 代码块样式优化
- 字体大小自定义
- 深浅色模式切换

#### 2. Swift手册
- Swift编程指南
- 常用代码示例
- 开发技巧分享

#### 3. 社区互动
- 赞助商展示
- 贡献者信息
- 评论系统(开发中)

#### 4. 个人中心
- 阅读偏好设置
- 主题切换
- 字体设置

## 技术特点

- **现代化UI框架**
  - 使用SwiftUI构建响应式界面
  - 支持iOS系统原生设计规范
  - 优雅的动画过渡效果

- **优秀的阅读体验**
  - WebKit集成的文章渲染
  - 自适应布局支持
  - 流畅的滚动性能

- **深色模式支持**
  - 完整的深色模式适配
  - 可跟随系统自动切换
  - 支持手动切换主题

- **iPad适配**
  - 支持分屏多任务
  - 自适应布局优化
  - 大屏交互优化

## 上线前需调整的功能

1. 性能优化
- [ ] 优化文章加载速度
- [ ] 添加预加载机制
- [ ] 优化图片加载策略
- [ ] 添加骨架屏加载状态

2. 用户体验
- [ ] 完善错误提示机制
- [ ] 添加加载进度指示
- [ ] 优化页面切换动画
- [ ] 添加手势导航支持

3. 功能完善
- [ ] 实现文章收藏功能
- [ ] 添加阅读历史记录
- [ ] 支持文章分享功能
- [ ] 实现文章搜索功能

4. 界面优化
- [ ] 优化iPad布局
- [ ] 完善深色模式适配
- [ ] 优化代码块显示
- [ ] 添加更多交互动效

## 未来计划 (TODO)

### 近期计划 (v1.1)
- [ ] 评论系统
  - 支持Markdown格式
  - 评论点赞功能
  - 回复提醒
- [ ] 搜索功能
  - 全文搜索
  - 搜索历史记录
  - 搜索建议
- [ ] 个性化推荐
  - 基于阅读历史
  - 兴趣标签
  - 智能推荐算法

### 中期计划 (v1.2)
- [ ] 社区功能
  - 用户登录注册
  - 个人主页
  - 关注机制
- [ ] 内容创作
  - Markdown编辑器
  - 草稿箱
  - 发布管理
- [ ] 学习追踪
  - 学习计划
  - 进度记录
  - 学习统计

### 长期计划 (v2.0)
- [ ] 在线课程
  - 视频课程
  - 互动练习
  - 学习认证
- [ ] AI助手
  - 代码补全
  - 问答系统
  - 智能纠错
- [ ] 跨平台支持
  - macOS版本
  - iPad优化
  - Apple Watch支持

## 贡献指南

1. Fork 项目
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交改动 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 提交Pull Request

## 开源协议

本项目基于 MIT 协议开源。详见 [LICENSE](LICENSE) 文件。

## 联系方式

- Email: your.email@example.com
- Twitter: [@your_twitter](https://twitter.com/your_twitter)
- Blog: [your_blog](https://your_blog.com)

## 致谢

- SwiftGG翻译组的所有成员
- 所有项目贡献者
- 支持这个项目的赞助商

## 更新日志

### [1.0.0] - 2024-03-XX
- 初始版本发布
- 实现基础文章阅读功能
- 支持深色模式
- 支持iPad适配