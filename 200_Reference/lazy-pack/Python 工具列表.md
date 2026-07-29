# Python 工具列表

> 三師爸 Sense Bar ・ AI Agent 基本功 EP03
> 用法：每一列都有「痛點 → 套件 → 一句話」。**直接把「一句話」複製貼給你的 AI Agent**，它就會幫你做。
> ✅＝常見環境已內建　🆕＝第一次用要先請 Agent 安裝（它會自己裝）

---

## 📄 Word 篇

| 項目 | 痛點 | 套件 | 一句話（複製給 Agent） |
|------|------|------|------------------------|
| 套印獎狀／通知單／成績單 🏆 | 30 個學生 30 張，手動換名換到崩潰 | `python-docx`＋`openpyxl`🆕 | 「讀這份班級名單 Excel，套進這個獎狀 Word 模板，每人產一份並存成 PDF」 |
| 出考卷（學生卷／教師卷分開） | 出完題還要手動刪答案做另一版 | `python-docx` | 「把這些題目做成 Word，產出『學生卷（無答案）』和『教師卷（含詳解）』兩份」 |
| 講義合併＋批次轉 PDF | 各課 Word 散落，要併本再轉 PDF | `docxcompose`＋`docx2pdf`；Windows Office COM 才加 `pywin32` | 「把這資料夾的 Word 講義依檔名順序合併成一份，再依本機 Office / LibreOffice 能力另存成 PDF」 |

## 📊 Excel 篇

| 項目 | 痛點 | 套件 | 一句話（複製給 Agent） |
|------|------|------|------------------------|
| 成績計算＋排名＋及格標紅 | 平均、加權、排名、標紅，每次段考重來 | `openpyxl`🆕＋`xlsxwriter` | 「讀 grades.xlsx，算總分與排名，不及格標紅，各班平均放最後一列，存成新檔」 |
| 段考成績分析（答對率／落點圖） | 想看哪題全班錯最多，但不會做統計圖 | `pandas`🆕＋`matplotlib` | 「分析這份答題明細，畫出各題答對率長條圖和全班分數分布圖」 |
| 總成績單拆成各班／各生 | 一張大表要拆給各導師、或每生一張 | `openpyxl`🆕 | 「把這份全校成績表，依『班級』欄拆成一個班一個 Excel 檔」 |
| 隨機座位表／分組 | 每次調座位、分組都要手喬 | `xlsxwriter` | 「用這份名單隨機排一張 6×5 座位表，輸出成 Excel」 |

## 📑 PowerPoint 篇

| 項目 | 痛點 | 套件 | 一句話（複製給 Agent） |
|------|------|------|------------------------|
| 教材大綱 → 整份上課簡報 🪄 | 把重點一頁頁貼進 PPT 很花時間 | `python-pptx` | 「把這份教材大綱，每個重點做成一頁投影片，套用這個範本」 |
| 圖片 → 圖卡簡報 | 單字卡、圖鑑要一張張貼 | `python-pptx`＋`pillow` | 「把這資料夾的圖片，每張做成一頁投影片，下方加檔名當標題」 |
| 統一字型／加校徽 | 別人給的 PPT 字體亂，要逐頁改 | `python-pptx` | 「把這份 PPT 全部字型改成標楷體，每頁右下角加上這張校徽」 |

## 📕 PDF 篇

| 項目 | 痛點 | 套件 | 一句話（複製給 Agent） |
|------|------|------|------------------------|
| 考卷合併／拆分／重排 | 考古題、作業散在幾十個 PDF | `pypdf`＋`PyMuPDF` | 「把這些 PDF 合併成一份，並把第 5～8 頁單獨抽出來另存」 |
| PDF 加浮水印（防外流） | 講義想加「僅供 ○ 班使用」 | `pypdf`＋`reportlab` | 「幫這份 PDF 每頁加上淡灰色浮水印『302 班 期中複習』」 |
| 掃描講義 OCR → 可編輯 | 掃描檔是圖片，無法選字、無法餵 AI | `ocrmypdf`🆕＋Tesseract＋Ghostscript | 「把這份掃描 PDF 做 OCR，變成可以複製文字的 PDF」 |
| 抽課本某幾頁轉圖 | 只要課本某張圖貼進學習單 | `PyMuPDF`＋`pdf2image` | 「把這份課本 PDF 第 12 頁轉成圖片，去掉白邊」 |

## 🧰 其他常用小工具

| 項目 | 痛點 | 套件 | 一句話（複製給 Agent） |
|------|------|------|------------------------|
| 連結轉 QR Code | 要學生掃 Padlet/表單，手做 QR 很煩 | `qrcode`＋`pillow` | 「把這 5 個連結各生一張 QR Code，貼到學習單」 |
| 抓 YouTube 現成字幕做逐字稿 | 想要影片逐字稿但不想聽打 | `youtube-transcript-api` | 「抓這支 YouTube 影片的字幕，整理成逐字稿」 |
| 講稿轉語音旁白（免費） | 請人配音或買 AI 語音很貴 | `edge-tts` | 「把這份講稿轉成中文語音 mp3，語速慢一點」 |
| 課本轉乾淨文字（餵 AI 前處理） | 課本格式亂，丟 AI 效果差 | `markitdown[pdf,docx,pptx,xlsx]` | 「把這份 PDF／Word／PPT／Excel 轉成 Markdown」 |
| 自動剪掉停頓 | 口播片停頓多，人工粗剪費時 | Auto-Editor `31.4.0` | 「保留原比例，用智能剪輯去除停頓，先產預覽給我確認」 |
| 字幕硬燒與文字疊圖 | 一般 FFmpeg 缺 `subtitles` / `drawtext` | FFmpeg Full＋libass | 「把這份 SRT 硬燒進影片，不改尺寸、不裁切」 |
| 本機 Whisper 字幕 | 不想上傳音訊到雲端 | faster-whisper、官方 `whisper` 或 whisper.cpp `whisper-cli` | 「用本機 large-v3-turbo 產繁中 SRT」 |
| 快速中文逐字稿 | 想用另一個本機模型交叉確認中文辨識 | SenseVoice q8 | 「用 SenseVoice 產繁中 TXT，保留情緒／事件標籤供檢查」 |
| 本機標題卡 | 不想開剪輯軟體逐張做字卡 | ImageMagick | 「做一張 1920×1080 中文標題卡，不改影片比例」 |
| 雲端高品質旁白 | 需要 ElevenLabs 的指定授權聲線 | ElevenLabs SDK | 「確認成本與隱私後，用這個 voice ID 生成旁白」 |

## 🧩 安裝狀態與按需項

| 項目 | 狀態 | 備註 |
|------|------|------|
| `markitdown[pdf,docx,pptx,xlsx]` | 已納入 Item 34 | 補齊文件格式 extras；本機補裝後新增 `mammoth` 與 `cobble`。 |
| Ghostscript / `gs` | 已納入 Item 34 系統相依 | 搭配 `ocrmypdf` 處理 PDF/A 與部分 OCR 流程；macOS 用 `brew install ghostscript`。 |
| `pywin32` | Windows native bash 自動納入；macOS / Linux / WSL 不裝 | 只服務 Windows Microsoft Office COM 自動化；安裝腳本偵測到 `MINGW` / `MSYS` / `CYGWIN` 才加入同一個 Windows venv。 |
| Auto-Editor `31.4.0` | 已納入 Item 34 | 使用官方 standalone 與固定 SHA-256，避開落後的 user-level Python 版本。 |
| FFmpeg Full / ImageMagick | 已納入 Item 34 系統相依 | FFmpeg Full 透過共用 wrapper 提供 `subtitles`、`ass`、`drawtext`；ImageMagick 提供本機字卡。 |
| `whisper-cli` / SenseVoice / `macwhisper-cli` | 已納入 Item 29 選用工具安裝器 | 模型存在本機 `{{CODEX_HOME}}/whisper-cpp` 與 `{{CODEX_HOME}}/sensevoice`，MacWhisper wrapper 指向本機 App；大型模型不進 Git 或 Google Drive。 |
| Whisper 本機轉文字 | 使用 Item 29／33 | 正式 SRT 用 faster-whisper；Apple Silicon 快速預覽用 whisper.cpp；不重複安裝官方 Python `openai-whisper`。 |
| MacWhisper | Item 29 的 macOS 選項 | 目前本機 14.4.1 已驗證 `mw` CLI；不同版本或授權先跑 `macwhisper-cli --help`，輸出仍需驗證時間碼。 |
| Pexels API | 不收費；需要免費 key | 預設每小時 200 次、每月 20,000 次；下載時保留來源頁與作者資訊。 |
| ElevenLabs API | 有免費 credits，超額或特定功能付費 | 透過本機 secret 與 `--confirm-cloud` 才呼叫，不把 key 寫進專案。 |
| Windows repo-local `.venv` | 不取代本 LazyPack 位置 | 下載來源檔適合 Windows 單 repo 安裝；本 Item 34 維持跨專案共用的 `{{CODEX_HOME}}/python-tools`。 |

---

## 🚀 怎麼一次裝好？

安裝請參考 `34-Python-Tools-全域工具包安裝.md`，跟它說：

> 「讀這份檔案，幫我把裡面的 Python 套件都安裝好。」

它就會自動幫你裝齊。

---

> 製作：三師爸 Sense Bar｜youtube.com/@sensebar
> 本列表為 EP03 隨附參考資料，歡迎自由下載分享。
