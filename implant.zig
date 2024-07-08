const std = @import("std");
const api = @import("implant_structs.zig");
const obf = @import("obfuscation.zig");

/// Win32 API function pointer types
const LoadLibraryA: type = *const fn ([*]const u8) callconv(.Stdcall) *api.IMAGE_DOS_HEADER;
const MessageBoxA: type = *const fn (i32, [*]const u8, [*]const u8, u32) callconv(.Stdcall) i32;

/// Error types that the shellcode can encounter
const ImplantError = error{
    ModuleNotFound,
    FunctionNotFound,
    OutOfMemory,
};

/// Struct representing a function (name + function pointer)
fn Function(comptime T: type) type {
    return struct {
        Name: []const u8,
        call: T,
    };
}

/// Data fields that the implant will need to spawn a message box
const ImplantData: type = struct {
    LoadLibraryA: Function(LoadLibraryA),
    MessageBoxA: Function(MessageBoxA),

    Message: []const u8,
    Caption: []const u8,

    Kernel32_dll: []const u8,
    User32_dll: []const u8,
};

/// Find the memory address of the next instructioin after returning from this function.
/// `noinline` is strictly necessary here to prevent the compiler from optimizing the assembly call as an inline directive.
/// We rely here on the `call` instruction to get the next `EIP` location from the stack pointer
noinline fn get_eip() *usize {
    return asm volatile ("mov (%esp), %eax"
        : [ret] "={eax}" (-> *usize),
    );
}

pub fn main() !void {
    std.debug.print("hello implant\n", .{});
}
