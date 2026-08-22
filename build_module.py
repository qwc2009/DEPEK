#!/usr/bin/env python3
"""
KSU 模块打包脚本
运行后会在当前目录生成 NetMonitor.zip
"""

import os
import zipfile
from pathlib import Path

MODULE_DIR = Path(__file__).parent / "NetMonitor"
OUTPUT_ZIP = Path(__file__).parent / "NetMonitor.zip"

def pack_module():
    if not MODULE_DIR.exists():
        print(f"❌ 找不到模块目录: {MODULE_DIR}")
        return False

    with zipfile.ZipFile(OUTPUT_ZIP, 'w', zipfile.ZIP_DEFLATED) as zf:
        for file_path in MODULE_DIR.rglob('*'):
            if file_path.is_file():
                arcname = file_path.relative_to(MODULE_DIR.parent)
                zf.write(file_path, arcname)
                print(f"  📦 {arcname}")

    print(f"\n✅ 打包完成: {OUTPUT_ZIP}")
    print(f"📦 文件大小: {OUTPUT_ZIP.stat().st_size / 1024:.1f} KB")
    return True

if __name__ == "__main__":
    pack_module()
