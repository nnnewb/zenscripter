# zenscripter

> 尝试用 [zig](https://ziglang.org/) 实现 [ONScripter-JH](https://github.com/chf2000/ONScripter-Jh)。

- 项目状态：🚧 开发中
- 授权协议：⚖️ [GPLv2](https://www.gnu.org/licenses/old-licenses/gpl-2.0.html)

see also: [ONScripter](https://onscripter.osdn.jp/onscripter.html), [ONScripter-Jh](https://bitbucket.org/jh10001/onscripter-jh)

## 开发依赖

### 编译工具链

- zig ~0.13.0
- llvm ~18.1.8

### 开发库

| 库            | 版本    | 平台   | 说明     |
| ------------- | ------- | ------ | -------- |
| SDL2          | 2.32.0  | 全平台 | **必须** |
| SDL2_image    | 2.8.5   | 全平台 | **必须** |
| SDL2_ttf      | 2.24.0  | 全平台 | **必须** |
| SDL2_mixer    | 2.8.1   | 全平台 | **必须** |
| bz2           | 1.0.8.0 | 全平台 | **必须** |
| lua           | -       | -      | 待支持   |
| fontconfig    | -       | Linux  | 待确认   |
| smpeg2        | -       | -      | 待支持   |
| libjpeg       | -       | -      | 待确认   |
| libogg        | -       | -      | 待确认   |
| libvorbis-dev | -       | -      | 待确认   |

### 构建

| 平台    | 当前支持 | 备注 |
| ------- | -------- | ---- |
| Windows | WIP      | WIP  |
| Linux   | WIP      | WIP  |
| Android | WIP      | WIP  |
