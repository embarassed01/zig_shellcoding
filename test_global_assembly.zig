const std = @import("std");
const expect = std.testing.expect;

comptime {
    // syntax only for x86 artich + linux gcc  
    //      .type my_func, @function;
    asm (
        \\.global my_func;
        \\.type my_func, @function;
        \\my_func:
        \\  lea (%rdi, %rsi, 1), %eax
        \\  retq
    );
}
extern fn my_func(a: i32, b: i32) i32;

test "global assembly" {
    try expect(my_func(12, 34) == 46);
}
