# Arry 助手資料層已移出本 repo

`codex_installation` 是 public repo，只保留安裝規則、LazyPack、模板與指向說明，不存放 Arry 助手真實記憶或個人偏好。

Arry 助手全域資料層已移到 Google Drive 的 `codex_symlink`：

```text
/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/codex_symlink/
  skills/      # Codex 全域 skills；/Users/arrywu/.codex/skills 指向這裡
  memories/    # Arry 助手跨專案記憶、個人偏好、踩坑
  workflows/   # 跨專案 workflow 草稿，成熟後升級成全域 skill
  knowledge/   # Arry 助手跨專案知識清單與工具清單
```

目前正式記憶檔：

```text
/Users/arrywu/Library/CloudStorage/GoogleDrive-icestone0128@gmail.com/我的雲端硬碟/codex_symlink/memories/MEMORY.md
```

本資料夾不再作為資料來源；若未來需要專案本地 assistant 記憶或 skill，請在各專案自己的 `<project-root>/000_Agent/` 下建立。
