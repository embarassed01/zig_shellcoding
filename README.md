# shellcoding in zig
拷贝自github 
https://github.com/mangrick/shellcoding-in-zig

原理参考 From a C project, to assembly, to shellcode.pdf

## 有稍微的修正，可适用zig最新版本0.13.0
- 修正1:
- - 将loader.zig文件函数extract_shellcode中``const file_size = @as(usize, @truncate((try file.stat()).size));``改为如下，否则会报异常
```zig
const file_size = @as(usize, @truncate(try file.getEndPos()));
try file.seekTo(0);
```
- 修正2:
- - 将.zig文件函数caser_encrypt内容修正为如下，否则会报错``comptime var cannot use as runtime var``
```zig
pub inline fn caeser_encrypt(comptime plaintext: []const u8, comptime shift: u8) *const [plaintext.len]u8 {
    comptime var buf: [plaintext.len]u8 = undefined;
    for (plaintext, 0..) |c, i| {
        const tmp: u8 = c + shift;
        buf[i] = tmp;
    }
    const ret_buf = buf;
    return &ret_buf;
}
```

此外，要注意：
- 生成的32位exe只适用于windows10及以上版本的OS!!

