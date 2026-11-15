# QuickLauncher 定时提醒

使用 QuickLauncher 安排一次性系统通知，脚本本身不访问网络、不保存或运行后台任务。宿主应用在确认通知权限后创建系统提醒，关闭 QuickLauncher 后提醒仍可由系统投递；实际显示受系统通知权限、专注模式和系统状态影响。

## 安装和使用

在 QuickLauncher 插件设置中搜索 `peiel/quicklauncher-reminder-plugin`，审查发布内容并安装，随后手动启用。需要支持 `arguments` 和 `scheduleReminder` 协议的 QuickLauncher 版本，以及可用的 Ruby 运行环境。

在搜索框输入触发词、等待时间和提醒内容，选中插件并回车，例如：

- `remind 10m 喝水`
- `remind 30秒 检查烤箱`
- `remind 2h 站起来活动`
- `remind 1天 提交报告`

支持整数和单位 `s`、`m`、`h`、`d`，或 `秒`、`分`、`分钟`、`小时`、`天`。最长 30 天；提醒内容为 1–200 个字符，不支持控制字符。可在插件设置中修改 `remind` 触发词。

首次使用时 macOS 可能要求通知权限；如果未授权，QuickLauncher 应提示失败。提醒在用户设备本地设置，不依赖 GitHub 或网络；设备关闭期间不会显示通知。

## 开发

运行 `ruby tests/test_reminder.rb` 执行离线协议和边界测试。通过标准输入读取一行 JSON，输出一行 JSON；所有动态文字由 JSON 编码，不执行输入内容。

MIT 协议，参见 LICENSE。
