#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: 2024 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

from extract_utils.fixups_blob import (
    blob_fixup,
    blob_fixups_user_type,
)
from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)

namespace_imports = [
    'vendor/qcom/opensource/display',
    'vendor/sony/tama-common',
]


# Commit df868baf ("Introduce a dependency monitor for fences") added a
# DependencyMonitor member to android::GraphicBuffer, growing the struct
# (arm64: 0x100 -> 0xd30).
#
# libsomc_chokoballpal.so is a 32-bit ARM blob that constructs a GraphicBuffer
# with `new GraphicBuffer(...)`, baking the *old* sizeof(GraphicBuffer) (0xa0)
# into the `operator new` call. With the new (larger) libui the constructor and
# destructor touch members past the allocation, corrupting the heap and
# crashing in ~GraphicBuffer -> ~DependencyMonitor.
#
# We cannot widen the existing 2-byte `movs r0, #0xa0` in place, so we redirect
# the `movs`+`blx operator_new` pair to a trampoline placed in the 12-byte
# alignment padding at the end of .text (0x3ed4..0x3edf, right before .plt),
# which allocates the new, larger size and returns to the original flow.
def blob_fixup_graphic_buffer_size(
    ctx,
    file,
    file_path,
    *args,
    **kwargs,
):
    # movs r0, #0xa0 ; blx <operator new@plt>
    old = bytes.fromhex('a02001f0e8ee')
    # b.w 0x3ed4 ; nop
    new = bytes.fromhex('01f0babe00bf')

    # trampoline @ 0x3ed4:
    #   movw r0, #0x800        ; >= new sizeof(android::GraphicBuffer) (0x6f8)
    #   blx  <operator new@0x3f30>
    #   b.w  0x2162            ; resume after the original call
    trampoline = bytes.fromhex('40f6000000f02ae8fef741b9')
    trampoline_off = 0x3ED4

    with open(file_path, 'rb') as f:
        data = f.read()

    count = data.count(old)
    if count != 1:
        raise RuntimeError(
            f'{file_path}: expected exactly one GraphicBuffer allocation '
            f'site, found {count}'
        )

    if data[trampoline_off:trampoline_off + len(trampoline)] != b'\x00' * len(trampoline):
        raise RuntimeError(
            f'{file_path}: trampoline area at {trampoline_off:#x} is not free'
        )

    out = bytearray(data)
    out[data.index(old):data.index(old) + len(old)] = new
    out[trampoline_off:trampoline_off + len(trampoline)] = trampoline

    with open(file_path, 'wb') as f:
        f.write(out)


blob_fixups: blob_fixups_user_type = {
    'vendor/lib/libsomc_chokoballpal.so': blob_fixup()
        .call(blob_fixup_graphic_buffer_size),
}

module = ExtractUtilsModule(
    'akari',
    'sony',
    blob_fixups=blob_fixups,
    namespace_imports=namespace_imports,
    check_elf=True,
)

if __name__ == '__main__':
    utils = ExtractUtils.device_with_common(
        module, 'tama-common', module.vendor
    )
    utils.run()
