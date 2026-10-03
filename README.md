# 🎮 Xbox Remote for Linux (niri / Wayland)

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platform: Linux](https://img.shields.io/badge/Platform-Linux%20Wayland-green.svg)](#)
[![Python: 3.8+](https://img.shields.io/badge/Python-3.8+-yellow.svg)](#)
[![Compositor: niri](https://img.shields.io/badge/Compositor-niri-purple.svg)](#)

> **将你的 Xbox 手柄化身为面向 Wayland / niri 桌面环境的终极 PC 无线遥控器。**  
> 纯标准库打造、零外部依赖、施密特滤波抗漂移、三层无缝架构与防误触互锁系统。

---

## ✨ 核心特性

- ⚡ **零外部依赖 (Zero Dependencies)**：纯 Python 标准库编写，直接基于 Linux 原生内核接口 `/dev/input/event*` (evdev) 与 `/dev/uinput` 通信，无需安装任何 pip 第三方库。
- 🛡️ **硬件级防漂移 (Schmitt-Trigger Filtering)**：针对手柄磨损产生的轻微摇杆漂移，内置迟滞双阈值滤波机制（50% 拨动触发、25% 回弹复位），彻底杜绝虚位误触与幽灵滑动。
- 🔒 **智能 LB/RB 防误触互锁 (Interlock & Tap-on-Release)**：创新型修饰键逻辑，按下 LB 时彻底静默 RB 关闭标签页行为，且 RB 仅在独立极速点按抬起时触发，彻底终结组合键误关浏览器标签页的痛点。
- 🔄 **动态套接字自愈 (Self-Healing Wayland Environment)**：自动感知并动态探测最新的 `WAYLAND_DISPLAY` 和 `NIRI_SOCKET`，即便守护进程在开机阶段先于桌面启动、或桌面环境崩溃重启，指令依然百发百中。
- 🖱️ **自适应曲线鼠标与 360° 平滑滚轮**：左摇杆支持指数型平滑光标加速；在二级层提供媲美触控板的 360° 全向连续惯性滚轮。
- 🎛️ **4 维全方位开关**：随时可一键暂停遥控模式以畅玩 Steam 大作，支持手柄快捷键、键盘全局快捷键、桌面应用图标、命令行无缝切换。

---

## 🗺️ 三层功能映射表

### 🌟 Layer 0: 默认基础层（网页浏览 / 影音娱乐 / 鼠标日常）
> **触发方式**：正常握持手柄，无需按住任何修饰键。

| 按键 / 摇杆 | 对应功能 | 底层指令 / 映射 | 说明 |
| :--- | :--- | :--- | :--- |
| **左摇杆 (LS)** | 🖱️ 鼠标光标移动 | `/dev/uinput` REL_X / REL_Y | 带有自适应死区与非线性加速度曲线 |
| **左摇杆下压 (L3)** | 🔗 鼠标中键 (BTN_MIDDLE) | `/dev/uinput` BTN_MIDDLE | 后台新标签页打开链接 / 关闭标签页 |
| **右扳机 (RT)** | 👆 鼠标左键 (BTN_LEFT) | `/dev/uinput` BTN_LEFT | 模拟单击与长按拖拽 |
| **左扳机 (LT)** | 🖐️ 鼠标右键 (BTN_RIGHT) | `/dev/uinput` BTN_RIGHT | 呼出右键上下文菜单 |
| **右摇杆 (RS) 左右** | ↔️ 切换左右窗口列 | `niri msg action focus-column-left/right` | 施密特双阈值迟滞滤波，轻拨丝滑切屏 |
| **右摇杆 (RS) 上下** | 📑 切换上下工作区 | `niri msg action focus-workspace-up/down` | 垂直工作区流畅跳转 |
| **右摇杆下压 (R3)** | 🔄 刷新当前页面 | `Ctrl + R` | 网页重载 |
| **十字键 (D-pad)** | ⬆️⬇️⬅️➡️ 方向键 | `Up / Down / Left / Right` | 浏览网页、滚动文本行 |
| **A 键** | ␣ 空格键 (Space) | `KEY_SPACE` | 视频播放/暂停、网页向下翻页 |
| **B 键** | ⎋ Esc 键 (Escape) | `KEY_ESC` | 退出全屏、关闭模态对话框 |
| **X 键** | ⌫ 退格键 (Backspace) | `KEY_BACKSPACE` | 文本删除 |
| **Y 键** | ⇥ 制表键 (Tab) | `KEY_TAB` | 表单焦点快速切换 |
| **RB 键** | ❌ 关闭当前标签页 | `Ctrl + W` (短按抬起触发) | 搭载防误触互锁：按住 LB 时自动禁用 |
| **Menu 键 (Start ☰)** | 🚀 打开应用启动器 | `noctalia msg panel-toggle launcher` | 呼出桌面应用菜单 |
| **View 键 (Select ⧉)** | 🎙️ 唤醒语音输入法 | `qingyin toggle` | 呼出青音 (Qingyin) 语音打字 |
| **Xbox 西瓜键 (Guide)** | 🪟 全局窗口总览 (Overview) | `niri msg action toggle-overview` | 俯瞰所有工作区与平铺窗口 |

---

### 🚀 Layer 1: 桌面中枢层（窗口流控 / 系统调控 / 影音播放）
> **触发方式**：**按住 LB 键不放**。

| 按键 / 摇杆 | 对应功能 | 底层指令 / 映射 | 说明 |
| :--- | :--- | :--- | :--- |
| **左摇杆 (LS)** | 📜 360° 平滑模拟滚轮 | `REL_WHEEL / REL_HWHEEL` | 支持全向倾斜平滑滚动长页面 |
| **右摇杆 (RS) 左右** | ⏭️ / ⏮️ 上一曲 / 下一曲 | `playerctl previous / next` | 媒体播放控制 |
| **右摇杆 (RS) 上下** | 🔊 音量加 / 减 (5%) | `wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+/-` | 平滑快速调节系统输出音量 |
| **右摇杆下压 (R3)** | ⏯️ 播放 / 暂停 | `playerctl play-pause` | 全局音频/视频播放切换 |
| **十字键 ↑ / ↓** | 📑 切换工作区 (Workspace) | `niri msg action focus-workspace-up/down` | 跨工作区切换 |
| **十字键 ← / →** | ⏮️ / ⏭️ 跳转至首列 / 末列 | `niri msg action focus-column-first/last` | 一键跳至平铺流两端 |
| **RT 扳机** | 🎛️ 呼出控制中心 | `noctalia msg panel-toggle control-center` | 快速查看网络/蓝牙/快捷开关 |
| **LT 扳机** | 🔇 一键静音 / 取消静音 | `wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle` | 紧急静音 |
| **A 键** | ⏎ 回车确认 (Enter) | `KEY_ENTER` | 确认执行 |
| **B 键** | ❌ 关闭当前窗口 | `niri msg action close-window` | 快速关闭激活窗口 |
| **X 键** | 📐 循环切换列预设宽度 | `niri msg action switch-preset-column-width` | 单列 / 双列 / 等比扩展 |
| **Y 键** | 🖥️ 窗口全屏切换 | `niri msg action fullscreen-window` | 深度沉浸模式 |
| **左摇杆下压 (L3)** | ⌨️ 查看 Niri 快捷键面板 | `niri msg action show-hotkey-overlay` | 唤出快捷键帮助卡片 |
| **Menu 键 (Start ☰)** | 💻 打开 Kitty 终端 | `kitty` | 唤出命令行终端 |
| **View 键 (Select ⧉)** | ✂️ 选区截图 | `noctalia msg screenshot-region` | 拖拽框选截图 |

---

### 🛠️ Layer 2: 高级平铺与排版层（窗口归档 / 剪贴板 / 浏览器进退）
> **触发方式**：**同时按住 LB + RB 键不放**。

| 按键 / 摇杆 | 对应功能 | 底层指令 / 映射 | 说明 |
| :--- | :--- | :--- | :--- |
| **十字键 ← / →** | ↔️ 移动窗口列位置 | `niri msg action move-column-left/right` | 调整当前窗口在流中的顺序 |
| **十字键 ↑ / ↓** | ↕️ 将列移至上下工作区 | `niri msg action move-column-to-workspace-up/down`| 将整列窗口抛至邻近工作区 |
| **Y 键** | 🪟 浮动 / 平铺切换 | `niri msg action toggle-window-floating` | 将平铺窗口脱离为浮动窗口 |
| **右摇杆 (RS) 左 / 右** | 🔙 / 🔜 网页后退 / 前进 | `Alt + Left / Right` | 浏览器历史级次后退与前进 |
| **右摇杆下压 (R3)** | 🔒 一键锁屏 | `noctalia msg session lock` | 离开电脑前直接锁屏 |
| **左摇杆下压 (L3)** | 🎯 窗口居中对齐 | `niri msg action center-column` | 将当前长列自动推至屏幕居中 |
| **Menu 键 (Start ☰)** | 📋 复制 (Copy) | `Ctrl + C` | 选中文本复制 |
| **View 键 (Select ⧉)** | 📄 粘贴 (Paste) | `Ctrl + V` | 剪贴板内容直接粘贴 |
| **A 键** | ✂️ 剪切 (Cut) | `Ctrl + X` | 快速剪切文本 |
| **B 键** | ↩️ 撤销 (Undo) | `Ctrl + Z` | 撤销上一步操作 |
| **X 键** | 🔤 全选 (Select All) | `Ctrl + A` | 一键选中全文字符 |
| **LT 扳机** | 📥 吸纳窗口并入当前列 | `niri msg action consume-window-into-column` | 将右侧窗口吸纳并入同一列 |
| **RT 扳机** | 📤 吐出窗口脱离列 | `niri msg action expel-window-from-column` | 将列中最底层窗口推出为新列 |

---

## ⚡ 4 维遥控开关体系

想打游戏时，如何防止误触遥控快捷键？随心选择最顺手的方式一键启闭：

1. **🎮 手柄物理直切**：同时向下深按 **【L3 (左摇杆) + R3 (右摇杆)】**，手柄震动并发送桌面通知，一秒停用/启用。
2. **⌨️ 桌面全局热键**：在 `~/.config/niri/config.kdl` 中绑定 `Mod+X`：
   ```kdl
   Mod+X { spawn "/home/pr/.local/bin/xbox-remote" "toggle"; }
   ```
3. **🖥️ 桌面启动器**：已注册 `.desktop` 快捷方式，在 Noctalia / Rofi / Fuzzel 中搜索 `Xbox 遥控器开关` 点击即可切换。
4. **💻 命令行控制**：
   ```bash
   xbox-remote toggle   # 切换状态
   xbox-remote status   # 查看当前状态与 PID
   ```

---

## 📦 安装与快速开始

### 1. 系统要求
- Linux 系统（已在 Arch Linux 实测）
- Python 3.8+
- Wayland 混成器（如 `niri`）与桌面组件（如 `noctalia`，可选）
- 拥有 `/dev/uinput` 访问权限（通常加入 `input` 用户组即可）

### 2. 一键安装
```bash
git clone https://github.com/pyrider3/xbox-remote.git
cd xbox-remote
./install.sh
```

### 3. 配置权限 (如果需要)
如果运行后提示权限不足，请确保当前用户具有 `input` 组权限：
```bash
sudo usermod -a -G input $USER
# 或者添加 udev 规则：
echo 'KERNEL=="uinput", GROUP="input", MODE="0660"' | sudo tee /etc/udev/rules.d/99-uinput.rules
sudo udevadm trigger
```

### 4. 卸载
```bash
./uninstall.sh
```

---

## 📄 开源许可证

本项目基于 [MIT License](LICENSE) 开源。欢迎提交 PR 与 Issue！
