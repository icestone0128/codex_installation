#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import shutil
import hashlib
import sys

# 定義路徑
SRC_DIR = "/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/codex_symlink"
DEST_DIR = "/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/secondbrain/專案庫/codex_installation/Arry 助手"

# 同步目標
TARGETS = [
    ("core-rules.md", "core-rules.md"),
    ("automations", "automations"),
    ("knowledge", "knowledge"),
    ("memories", "memories"),
    ("rules", "rules"),
    ("workflows", "workflows")
]

# 排除名單 (子目錄或檔名)
#
# rollout_summaries 可能包含大量 append-only 原始對話摘要與長檔案，
# 收工備份只需要同步核心規則、知識、工作流與 durable memory notes，
# 不應在每次收工時掃完整 rollout 歷史或大型 runtime / artifact。
EXCLUDE_NAMES = {
    ".git",
    ".DS_Store",
    "sync_backup.py",
    "__pycache__",
    "rollout_summaries",
    "runtimes",
}

def get_md5(file_path):
    if not os.path.exists(file_path):
        return None
    hash_md5 = hashlib.md5()
    try:
        with open(file_path, "rb") as f:
            for chunk in iter(lambda: f.read(4096), b""):
                hash_md5.update(chunk)
        return hash_md5.hexdigest()
    except Exception as e:
        print(f"無法讀取檔案 {file_path} 的 MD5: {e}")
        return None

def sync_file(src, dest, dry_run=False):
    """
    同步單個檔案。如果 dest 不存在，或者 md5 不同，則複製。
    返回 (copied, reason)
    """
    if not os.path.exists(src):
        return False, "source_not_found"
    
    src_md5 = get_md5(src)
    dest_md5 = get_md5(dest)
    
    if src_md5 == dest_md5:
        return False, "up_to_date"
    
    if not dry_run:
        os.makedirs(os.path.dirname(dest), exist_ok=True)
        shutil.copy2(src, dest)
    return True, "copied"

def sync_directory(src_dir, dest_dir, dry_run=False):
    """
    遞迴同步目錄，並在 destination 刪除 source 不存在的檔案。
    返回 (copied_count, deleted_count)
    """
    copied_count = 0
    deleted_count = 0
    
    if not os.path.exists(src_dir):
        print(f"來源目錄不存在: {src_dir}")
        return 0, 0
    
    # 1. 同步所有檔案與子目錄
    for root, dirs, files in os.walk(src_dir):
        # 原地過濾 dirs 以免進入排除的目錄
        dirs[:] = [d for d in dirs if d not in EXCLUDE_NAMES]
        
        # 計算相對路徑
        rel_path = os.path.relpath(root, src_dir)
        
        # 對應的 dest 目錄
        target_root = dest_dir if rel_path == "." else os.path.join(dest_dir, rel_path)
        
        # 建立目錄
        if not dry_run:
            os.makedirs(target_root, exist_ok=True)
            
        for file in files:
            if file in EXCLUDE_NAMES:
                continue
            src_file = os.path.join(root, file)
            dest_file = os.path.join(target_root, file)
            
            copied, reason = sync_file(src_file, dest_file, dry_run)
            if copied:
                print(f"[新增/更新] {os.path.relpath(dest_file, DEST_DIR if 'secondbrain' in dest_file else SRC_DIR)}")
                copied_count += 1
                
    # 2. 清理 destination 多餘的檔案 (Mirror 機制)
    for root, dirs, files in os.walk(dest_dir, topdown=False):
        rel_path = os.path.relpath(root, dest_dir)
        
        path_parts = rel_path.split(os.sep)
        if any(part in EXCLUDE_NAMES for part in path_parts):
            continue
            
        source_root = src_dir if rel_path == "." else os.path.join(src_dir, rel_path)
        
        for file in files:
            if file in EXCLUDE_NAMES:
                continue
            dest_file = os.path.join(root, file)
            src_file = os.path.join(source_root, file)
            
            if not os.path.exists(src_file):
                print(f"[刪除多餘] {os.path.relpath(dest_file, DEST_DIR if 'secondbrain' in dest_file else SRC_DIR)}")
                deleted_count += 1
                if not dry_run:
                    try:
                        os.remove(dest_file)
                    except Exception as e:
                        print(f"刪除檔案失敗 {dest_file}: {e}")
                        
        for d in dirs:
            if d in EXCLUDE_NAMES:
                continue
            dest_subdir = os.path.join(root, d)
            src_subdir = os.path.join(source_root, d)
            if not os.path.exists(src_subdir):
                print(f"[刪除多餘目錄] {os.path.relpath(dest_subdir, DEST_DIR if 'secondbrain' in dest_subdir else SRC_DIR)}")
                deleted_count += 1
                if not dry_run:
                    try:
                        shutil.rmtree(dest_subdir)
                    except Exception as e:
                        print(f"刪除目錄失敗 {dest_subdir}: {e}")
                        
    return copied_count, deleted_count

def run_sync(mode):
    if mode == "backup":
        print("=== 執行備份：全域共用層 -> Obsidian ===")
        from_dir, to_dir = SRC_DIR, DEST_DIR
    elif mode == "apply":
        print("=== 執行套用：Obsidian -> 全域共用層 ===")
        from_dir, to_dir = DEST_DIR, SRC_DIR
        
        if "-y" in sys.argv or "--yes" in sys.argv:
            confirm = "y"
        else:
            confirm = input("這將覆蓋全域共用層的檔案，確定要繼續嗎？(y/N): ")
            
        if confirm.lower() != 'y':
            print("取消操作。")
            return
    else:
        print("未知的模式。請使用 'backup' 或 'apply'。")
        return

    total_copied = 0
    total_deleted = 0
    
    for src_name, dest_name in TARGETS:
        src_path = os.path.join(from_dir, src_name)
        dest_path = os.path.join(to_dir, dest_name)
        
        if os.path.isdir(src_path) or (not os.path.exists(src_path) and os.path.isdir(dest_path)):
            copied, deleted = sync_directory(src_path, dest_path)
            total_copied += copied
            total_deleted += deleted
        else:
            copied, reason = sync_file(src_path, dest_path)
            if copied:
                print(f"[更新檔案] {dest_name}")
                total_copied += 1
                
    print(f"\n同步完成！共新增/更新 {total_copied} 個檔案，刪除 {total_deleted} 個檔案/目錄。")

if __name__ == "__main__":
    mode = "backup"
    if len(sys.argv) > 1:
        if sys.argv[1].startswith("-"):
            mode = "backup"
        else:
            mode = sys.argv[1].lower()
    run_sync(mode)
