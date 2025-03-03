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

| 库            | 版本    | 平台   | 说明                               |
| ------------- | ------- | ------ | ---------------------------------- |
| SDL2          | 2.32.0  | 全平台 | <font color="red">**必须**</font>  |
| SDL2_image    | 2.8.5   | 全平台 | <font color="red">**必须**</font>  |
| SDL2_ttf      | 2.24.0  | 全平台 | <font color="red">**必须**</font>  |
| SDL2_mixer    | 2.8.1   | 全平台 | <font color="red">**必须**</font>  |
| bz2           | 1.0.8.0 | 全平台 | <font color="red">**必须**</font>  |
| lua           | -       | -      | <font color="yellow">待支持</font> |
| fontconfig    | -       | Linux  | <font color="yellow">待确认</font> |
| smpeg2        | -       | -      | <font color="yellow">待支持</font> |
| libjpeg       | -       | -      | <font color="yellow">待确认</font> |
| libogg        | -       | -      | <font color="yellow">待确认</font> |
| libvorbis-dev | -       | -      | <font color="yellow">待确认</font> |

### 构建

| 平台    | 当前支持                        | 备注                            |
| ------- | ------------------------------- | ------------------------------- |
| Windows | <font color="yellow">WIP</font> | <font color="yellow">WIP</font> |
| Linux   | <font color="yellow">WIP</font> | <font color="yellow">WIP</font> |
| Android | <font color="yellow">WIP</font> | <font color="yellow">WIP</font> |
