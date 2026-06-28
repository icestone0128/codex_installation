# 33-Audio-to-Markdown-Skill-安裝

> 來源：`/Users/arrywu/Downloads/audio-to-md-安裝包_v1.2.0.zip`，並補入 Groq 雲端 STT 平行路線。本機 Whisper 與 Groq 是兩個平行選項；執行 Phase 1 前必須先詢問使用者選哪一個，沒有預設引擎。

## 用途

這個 Skill 讓 Codex 協助處理影音轉逐字稿工作流：

- 引導使用者在 Phase 1 前選擇本機 Whisper turbo 或 Groq 雲端 STT，把音訊或影片轉成 Markdown 逐字稿知識庫。
- 明確區分 Phase 1 轉錄與 Phase 2 AI 校稿、摘要、重點整理。
- 對長稿採用分檔與逐段校稿，避免 AI 把逐字稿縮成摘要。
- 支援會議、訪談、podcast、課程、Zoom 錄影與其他影音來源。
- 支援同一音檔的本機 Whisper / Groq 品質比較。
- 內嵌完整 Python 腳本、執行紀錄與踩坑，方便其他人用 LazyPack repo 重建同樣效果。

## 引擎選擇

執行 Phase 1 前必須先詢問使用者：

```text
這次要用哪個轉錄引擎？
1. 本機 Whisper：不上傳、0 API key、適合敏感或大量素材。
2. Groq 雲端 STT：會上傳音檔，通常速度、繁中與標點較好，需要 Groq API key。
```

兩個選項平行，沒有預設值。Groq 需要 `GROQ_API_KEY` 或 `~/.codex/secrets/groq_api_key`，且必須取得使用者同意雲端上傳。兩種引擎只影響 Phase 1；產出 Markdown 後，Phase 2 校稿、摘要、自檢與另存 `_校稿.md` 的流程完全相同。

## 本機引擎安裝狀態

本機引擎由安裝包內的 `install.sh` 安裝，固定路徑如下：

```text
~/.audio-to-md/
~/.audio-to-md/audio-to-md
~/Desktop/轉逐字稿.command
```

安裝器會建立 Python venv、安裝 `faster-whisper`，並下載 `large-v3-turbo` 模型。本機 Whisper 轉錄不需要 API key，也不消耗 LLM token。

Groq 路線使用 Skill package 內的 `scripts/audio_to_md_groq.py`，不取代本機引擎。

## 使用方式

先問使用者選哪個引擎，再執行對應指令。

本機 Whisper：雙擊桌面 `轉逐字稿.command`，把影音檔拖進視窗後按 Enter。輸出會在原始檔旁邊，檔名通常是 `*_逐字稿知識庫.md` 或長稿分段檔。

手動方式：

```bash
~/.audio-to-md/audio-to-md "/path/to/audio-or-video.mp4"
```

Groq 雲端 STT：

```bash
python3 "{{CODEX_HOME}}/skills/audio-to-md/scripts/audio_to_md_groq.py" "/path/to/audio-or-video.mp4" -o "/path/to/output" --language zh
```

拿到 Markdown 後，再交給 Codex 使用 `audio-to-md` skill 做 Phase 2：校稿、段落摘要、全篇重點與自檢。這部分不分本機 Whisper 或 Groq。

## 執行紀錄與踩坑

安裝完成後請閱讀：

```text
{{CODEX_HOME}}/skills/audio-to-md/references/execution-notes.md
```

其中保存：

- `install.sh` 實際安裝過程。
- 本機 Whisper 與 Groq 的實測指令與比較。
- `audio_to_md.py`、`audio_to_md_groq.py` 的 Python 內嵌方式。
- Groq API key、雲端上傳、segments 差異、LazyPack 內嵌與「沒有預設引擎」等踩坑紀錄。

## 注意事項

- Phase 1 執行前必須先問使用者選哪個引擎，且沒有預設引擎。
- 本機 Whisper 不上傳檔案；Groq 會上傳音訊/影片並需要 API key。
- 中文本機 Whisper 建議使用 `large-v3-turbo`，不要降級成 small/base。
- Phase 2 校稿不得刪除、合併或改寫逐字主體；只能做簡繁、確證錯字、標點、斷句與專名查證留痕。
- 長稿一次只處理一個 part 或一個時間段，避免輸出上限造成摘要化。

## 安裝 Codex Skill

先把 `{{CODEX_HOME}}` 替換成自己的 Codex 設定資料夾；預設通常是 `{{HOME}}/.codex`。

<!-- BEGIN EMBEDDED_SKILLS -->

## 內建 Skill 完整安裝內容

本節是自含式安裝區塊，會安裝 `audio-to-md` Skill package；不會安裝本機 Whisper runtime 或模型。若尚未安裝本機引擎，需另外執行安裝包內的 `install.sh`。

````bash
set -e

mkdir -p "{{CODEX_HOME}}/skills/audio-to-md"
# audio-to-md/SKILL.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/audio-to-md/SKILL.md")"
cat > "{{CODEX_HOME}}/skills/audio-to-md/SKILL.md" <<'CODEX_LAZYPACK_AUDIO_TO_MD_SKILL_MD'
---
name: audio-to-md
description: 用本地 Whisper 或 Groq 雲端 STT，把「音訊或影片」轉成帶時間戳的逐字稿 Markdown 知識庫。當需要：(1) 把錄音／podcast／會議／訪談音檔轉成逐字稿 (2) 把影片（演講、課程、Zoom 錄影）抽音軌轉逐字稿 (3) 比較本機 Whisper 與 Groq 轉錄品質 (4) 把逐字稿整理成可檢索、含段落摘要與重點的知識庫 (5) 為 RAG 補上「聲音」這一塊時使用。Phase 1 執行前必須先詢問使用者選擇「本機 Whisper」或「Groq 雲端 STT」，兩者是平行選項，沒有預設引擎。Groq 需要使用者明確接受雲端上傳且有 GROQ_API_KEY 或 ~/.codex/secrets/groq_api_key。Phase 2 由 Codex 校稿（簡繁/錯字/斷句）＋寫摘要與重點，兩種引擎產出文字後的後續流程完全相同。
---

# audio-to-md Skill

把「影音的聲音」變成「可檢索、整理好的文字知識庫」。
**核心理念（指揮 AI 的分工）**：聽打＝機械活 → 執行前先問使用者要用 **本地 Whisper（免費、0 token、不上傳）** 或 **Groq Whisper（通常較快、繁中與標點可能較好、但會上傳音檔且需要 API key）**；兩者是平行選項，沒有預設引擎；
校稿、理解、抓重點＝判斷活 → 交給 **Claude（Phase 2，花少量 token）**。把對的工序派給對的工具。

**和家族的分工：**
- `doc-to-md` → 文字檔的文字 ｜ `vlm-to-md` → 圖的視覺 ｜ **`audio-to-md` → 影音的聲音**

**兩階段架構（與家族一致）：**
- **Phase 1A（本地 Whisper）**：`audio_to_md.py` 用 faster-whisper 把音訊／影片（影片自動抽音軌）轉成**帶時間戳的逐字稿骨架**，留好「校稿、段落摘要、重點」空格。優點是免費、0 token、0 API key、不上傳。
- **Phase 1B（Groq 雲端 STT）**：`audio_to_md_groq.py` 使用 Groq `whisper-large-v3-turbo` 產生同樣的 Markdown 骨架與原始 JSON。只有在使用者接受雲端轉錄、且已設定 `GROQ_API_KEY` 或 `~/.codex/secrets/groq_api_key` 時可選。
- **Phase 2（Claude、花少量 token）**：校稿（簡繁→繁中、錯字、標點、斷句）＋填段落摘要＋抓全篇重點/待辦/金句。**不需要付費 ASR、不需要 API key。**

> **⚠️ 比 doc-to-md 多一步：要先下載 Whisper turbo 模型（約 1.5GB）。** 安裝程式會幫忙預先下載。
> **中文一律用 `large-v3-turbo`，不要降級成 small/base**——小模型中文會糙到連校稿都救不回（這是品質底線）。弱機只是慢一點，照樣用 turbo。
> **安裝建議使用 Python 3.12。** Mac 舊系統上 Python 3.13+ 可能遇到 onnxruntime / faster-whisper wheel 相容性問題；安裝器會自動避開。

## 引擎選擇：本機 Whisper vs Groq

執行 Phase 1 前先詢問使用者要用哪個引擎；不要自行選擇任一引擎，也不要因為某個引擎可用就直接執行。**本機 Whisper 與 Groq 是兩個平行選項，沒有預設值。**

詢問範例：

```text
這次要用哪個轉錄引擎？
1. 本機 Whisper：不上傳、0 API key、適合敏感或大量素材。
2. Groq 雲端 STT：會上傳音檔，通常速度、繁中與標點較好，需要 Groq API key。
```

只有使用者選擇 Groq，且符合下列條件，才使用 Groq：

- 使用者明確接受把音訊/影片上傳到 Groq 做雲端 STT。
- 本機已存在 `GROQ_API_KEY` 或 `~/.codex/secrets/groq_api_key`。
- 使用者重視速度、繁中輸出、標點品質，或想和本機 Whisper 做品質比較。

不要在下列情況使用 Groq；若使用者仍要轉錄，重新詢問是否改選本機 Whisper：

- 音訊含敏感、不可外傳、未授權或使用者不想上傳的內容。
- 沒有 API key，或 key 可能已出現在聊天、log、截圖、repo、Obsidian。
- 使用者明確要求本機、免費、離線或 0 API key。

兩種引擎只影響 Phase 1 的「文字從哪裡來」。一旦產生 Markdown 骨架，Phase 2 的所有後續流程完全相同：逐字主體保留、簡繁/錯字/標點/斷句、段落摘要、全篇重點、自檢、另存 `_校稿.md`，不可因為來源是 Groq 就改成字幕工作流或影片上架工作流。

實測參考（Arry `ref_voice.wav`，14 秒）：本機 Whisper 產生 4 個 segments，內容完整但簡體，且把「清楚發音」誤聽成「清除發音」；Groq 產生 1 個 segment / 55 words，直接繁中且正確輸出「清楚發音」。這段短中文乾淨錄音上，Groq 轉錄品質較優；但這只是比較結果，不代表未來自動選 Groq。每次 Phase 1 都要先由使用者選擇引擎。

## 可攜化與踩坑紀錄

維護、安裝、同步 LazyPack，或需要重現本次本機 Whisper / Groq 比較時，先讀：

- `references/execution-notes.md`

這份文件保存：

- v1.2.0 zip 內 `install.sh` 的實際執行流程。
- `audio_to_md.py` 與 `audio_to_md_groq.py` 的 LazyPack 內嵌方式。
- Arry `ref_voice.wav` 的本機 Whisper / Groq 實測輸出與比較。
- 「兩個平行選項、沒有預設引擎」的設計原因。
- Groq API key、雲端上傳、segments 顆粒度、Python heredoc 內嵌等踩坑。

---

## Phase 1 一定在「使用者自己的電腦」上跑（鐵則，先讀這段）

> **鐵則**：Phase 1 轉錄需要本地 Whisper turbo 模型（約 1.5GB）。**Claude Desktop／網頁的沙箱會封鎖 HuggingFace 模型下載**，所以在 Desktop／網頁裡**永遠**轉不了——**不論使用者是貼本機路徑、還是已經把檔案上傳到對話，答案都一樣：請他在自己的電腦跑 Phase 1。**

**絕對禁止的行為（會讓工具看起來壞掉、白繞一圈，正是 v1.0.3／v1.0.5 學員的鬼打牆）：**
- ❌ 不要在沙箱裡 `pip install faster-whisper` ＋ 跑轉錄 ＋ 下載模型——**幾乎必然卡在 HuggingFace 被封、模型載不下來**。
- ❌ 不要因為「使用者把檔案上傳了」就以為可以在沙箱轉。**上傳到對話 ≠ 能在沙箱做 Phase 1**，模型一樣下載不了。
- ❌ 不要說「我幫你產生 audio_to_md.py」「我重寫一個腳本」——本機已用安裝包裝好引擎，別重造。

**唯一例外**：若你確定當前是 **Claude Code CLI／本機終端環境且有外網**（不是 Desktop／網頁沙箱），才可跑下方「進階：bundled 腳本」。**只要是 Desktop／網頁，跳過這條，直接走下面的本機做法。**

### 該回給使用者什麼（Windows，最重要）

學員多半非技術背景，**首選「拖檔」、不要叫他打指令**。安裝包已在桌面放了一個「🎤 拖檔轉逐字稿」圖示。

例如使用者說：
> 幫我把這段影片轉成逐字稿知識庫：C:\Users\USER\OneDrive\Desktop\meeting.mp4
> （或：直接上傳了影片檔）

應回覆（**繁中、步驟化、首選拖檔**）：
```text
這段轉錄要在你自己的電腦上跑（免費、不花 token），我這邊的沙箱載不到語音模型。最簡單的做法：

【方法一 · 拖檔（推薦，不用打字）】
1. 在桌面找到「🎤 拖檔轉逐字稿」圖示。
2. 把你的影片（meeting.mp4）直接拖到這個圖示上放開。
3. 等它跑完（第一次會久一點），它會自動打開輸出資料夾。
4. 把資料夾裡的「*_逐字稿知識庫.md」拖回來給我，我接著做校稿、段落摘要、全篇重點。

【方法二 · 貼指令（如果找不到圖示）】
開「命令提示字元」貼這行（路徑換成你的影片）：
"%USERPROFILE%\.audio-to-md\audio-to-md.bat" "C:\Users\USER\OneDrive\Desktop\meeting.mp4"

桌面沒有那個圖示，代表本機引擎還沒裝 → 先去你下載的安裝包資料夾，雙擊 install.bat 裝一次（只需一次），再回到方法一。
```

### Mac

```text
這段轉錄要在你自己的 Mac 上跑（免費、不花 token）。
最簡單：雙擊桌面的「轉逐字稿.command」，把影片拖進視窗按 Enter。
或開 Terminal 貼：~/.audio-to-md/audio-to-md "/Users/你/Desktop/meeting.m4a"
跑完把輸出的「*_逐字稿知識庫.md」傳回來給我做 Phase 2。
桌面沒有那個檔 → 先跑安裝包的 install.sh 裝一次。
```

> 拿到使用者傳回的 `*_逐字稿知識庫.md` 後，直接進 Phase 2（校稿、段落摘要、全篇重點），**不需要原始音訊／影片**。

---

## Step 1 — 找到本機啟動器（Desktop／網頁的唯一正解）

### 本機啟動器（安裝包 install.bat / install.sh 已裝好）
- **Windows 拖檔圖示**：桌面「🎤 拖檔轉逐字稿.bat」（背後是 `%USERPROFILE%\.audio-to-md\轉逐字稿.bat`）
- **Windows 指令啟動器**：`%USERPROFILE%\.audio-to-md\audio-to-md.bat`
- **Mac 拖檔**：桌面「轉逐字稿.command」
- **Mac 指令啟動器**：`~/.audio-to-md/audio-to-md`

都不存在 → 請使用者先跑安裝包的 `install.bat` / `install.sh`（只需一次），**不要在沙箱重新產生腳本**。

### 進階：bundled 腳本（**僅限** Claude Code CLI／本機終端且有外網；Desktop／網頁請跳過）
```bash
pip install -r scripts/requirements.txt          # 裝 faster-whisper
python3 scripts/audio_to_md.py "<音訊或影片>" -o "<輸出資料夾>"
```
> ⚠️ 第一次會下載 turbo 模型（~1.5GB）。**只要在 Desktop／網頁沙箱，這條一定失敗，不要嘗試——改回上面的本機啟動器。**

---

## Step 2 — 執行 Phase 1（本地轉錄）

學員端最簡單就是**桌面拖檔圖示**（Windows「🎤 拖檔轉逐字稿」／Mac「轉逐字稿.command」）。
要手動下指令時（本機啟動器，**不是沙箱**）：

```bat
:: Windows（路徑換成自己的檔；不加 -o 時輸出在影片旁）
"%USERPROFILE%\.audio-to-md\audio-to-md.bat" "<音訊或影片>"
```
```bash
# Mac
~/.audio-to-md/audio-to-md "<音訊或影片>"
```

Groq 雲端路線（執行前必須先詢問並取得使用者同意）：

```bash
python3 "{{CODEX_HOME}}/skills/audio-to-md/scripts/audio_to_md_groq.py" \
  "<音訊或影片>" \
  -o "<輸出資料夾>" \
  --language zh
```

Groq 輸出：

- `*_groq_逐字稿知識庫.md`
- `*_groq.json`
- `*_groq_manifest.json`

若使用者要求比較兩個引擎，對同一個音檔各跑一次本機 Whisper 與 Groq，再對照：

- 是否有漏字或多字。
- 簡繁、標點與錯字數量。
- 時間戳顆粒度是否適合後續校稿。
- 是否可接受雲端上傳與 API 成本。

**輸入**：音訊（mp3/m4a/wav/flac/aac…）或影片（mp4/mov/mts/mkv/webm…，自動抽音軌）。

| 旗標 | 效果 |
|------|------|
| `--model large-v3-turbo` | **預設、且建議固定用這個**（約 1.5GB，中文品質底線）。不要降級成 small/base |
| `--language zh` | 指定語言（預設 `auto` 自動偵測） |
| `--beam-size 1` | 更快（預設 5 品質較好） |
| `--chunk-min 6` | 逐字稿每段約 N 分鐘（每段一個摘要空格） |
| `--device cpu` | 預設 cpu（跨平台）；有 NVIDIA 可 `cuda` |

得到一份 `*_逐字稿知識庫.md`（＋ `*_manifest.json`）。

---

## 長稿自動分檔（v1.2 — 治本「太長被 AI 摘要」）

**為什麼**：長稿一次貼進一則回覆會撞輸出上限，AI 會偷偷改用「摘要」交差（時間戳掉、內文被壓縮）。這是**架構問題、不是提示詞能解**——解法是把「隔離」放在 Phase 1 的輸出。

**行為**：轉錄時長**超過 35 分鐘**（`--split-min`）時，Phase 1 會自動把骨架切成多個 **約 18 分鐘**（`--part-min`）的短檔：`*_逐字稿知識庫_part1ofN.md`、`part2ofN.md`…＋一份 `*_長稿校稿說明.txt`。短稿（≤35 分鐘）維持單檔、流程不變。關閉分檔：`--split-min 0`。

**Phase 2 怎麼校（重點：一檔一次）**：
- 一個 part 檔丟回 Claude 校稿一次（校稿鐵律仍適用），校完**換下一個 part**；**不要一次貼多個 part**。
- 每個 part 都短到能在一則回覆裡完整吐完 → 結構上不會被摘要。
- 全部校完後，依 part 順序首尾相接＝完整逐字稿（時間戳連續，直接接）。

> 這對 Claude Desktop 學員尤其重要：Desktop 沒有 subagent／檔案分段寫入，唯一能做到「物理隔離」的點就是 Phase 1 把長稿切成短檔。

## Step 3 — Claude 做 Phase 2（校稿 ＋ 摘要 ＋ 重點）

> [!danger] 校稿鐵律（最重要，違反就是學員回報的「太長被 AI 摘要、掉時間戳、內文被改寫」）
> 1. **逐字主體 100% 保留**：每個 `**[時間戳]**` 行都要留，內容一字不刪、不合併、不改寫、不潤飾。能動的只有：簡繁、確證錯字、補標點、合理斷句、（多人時）句首標講者。
> 2. **斷句的硬邊界（可機械驗證）**：「合理斷句」＝只能在原句插入標點或換行，**不得增、刪、換任何一個字**。語助詞與口頭禪（嗯、然後、就是、那個、對對對）、重複、口吃、語病一律原樣保留。判準：把校稿後該行的標點與換行全部移除，必須與原稿該行去標點後**逐字相同**（僅簡繁、確證錯字、查證專名例外）。不同＝你刪改字了＝違規。
> 3. **錯字的硬定義**：只限 Whisper 同音／形近誤聽（如 在/再、的/得、企業重心→勤業眾信）。說話者本人的重複、口吃、冗詞**不是錯字**，不得以「修錯字」名義刪改。
> 4. **禁跨行搬移**：斷句／標點只能在同一 `**[時間戳]**` 行內進行，不得把某行的文字移到別的時間戳行底下。
> 5. **🔸 不是刪改許可**：🔸 只代表該行可能有聽寫錯誤、要優先複核用字，處理權限與一般行完全相同——不得因「信心低」而刪除、濃縮或改寫整行；真的聽不清才標「（聽不清）」，不得自行補寫。
> 6. **必須分段、且一次只輸出一段**：用 Edit 逐段填，**一次 Edit／一次回覆只能涵蓋一個 `## ⏱ 時間段`**。嚴禁在同一次輸出裡塞兩個以上時間段的逐字主體（即使你覺得「一次做完比較快」）——一次多段＝撞長度上限＝被截斷成摘要，這就是 bug 根因本身。處理完一段就停下等下一輪。某段單次放不下時，明說「本段過長，拆 a/b 續做」，嚴禁靜默縮寫帶過。
> 7. **完工自檢（雙指標，缺一不可）**：(a) 校稿後 `**[` 開頭行數必須 **≥ 原稿**，並且 **≥ manifest.json 的 `segments` 值**（用 grep 數，低於即有時間戳被吃掉）；(b) 校稿後全文中文字元數必須 **≥ 原稿 ×0.95**（簡繁／標點只會持平或略增）；任一 `## ⏱ 時間段` 內字數較原稿掉 >10% 即視為摘要／縮寫，重做該段。只數行數不數字數＝給自己留縮水後門。
> 8. **逐段四數字回報**：每做完一段，回報該段「原稿行數／校稿後行數／原稿字數／校稿後字數」並確認兩兩 ≥，才進下一段。
> 9. **交付順序鎖**：驗收唯一基準是「逐字主體」，不是摘要欄。必須先逐段完成全部時間段的逐字校稿並通過上述自檢，**最後**才填段落摘要與全篇重點。逐字未全段通過前就填摘要欄＝視為以摘要代替逐字＝未完成。

打開 `*_逐字稿知識庫.md`，依裡面提示完成：

1. **校稿（兩層）**
   - **Layer 1 語感校稿（鐵律不變）**：簡體→繁體（台灣用語）、修錯字、加標點、合理斷句、多人時標講者。**禁止**憑空改寫或新增講者沒說的內容；聽不清標「（聽不清）」，**不要編**。
   - **Layer 2 專名查證（新增）**：語感層抓不到「自信地把生僻專名聽成同音常見詞」——替換後通順但事實錯（如 企業重心→勤業眾信、串上閒絲→川上賢司、Tina Selig→Seelig）。改用**語法角色**而非信心分數篩候選：
     - 句子主語且後接需要行為者的動詞（「XX 觀察到…」）
     - 後接稱謂／類別詞（XX 教授・公司・遊戲・書）
     - 前有「叫做」「就是」等引介
     - 你對其真實性沒高把握的人名/地名/品牌/書名/機構
     - 標了 🔸（Phase 1 低信心）的片段優先複核
     篩出候選（通常 5-20 個）→ 逐一 **WebSearch 查證**：
     - 查到更可信版本 → 修正並**留痕**：`（查證：原聽寫「企業重心」→「勤業眾信」）`
     - 查不到 → 保留原字 + 標 `⚠️ 專名待查證`，交使用者判斷
     - **無 WebSearch 可用 → 全部標 `⚠️ 專名待查證`，不要憑空猜改**
     > 關鍵：修正**必須有外部查證依據＋全程留痕**——不違背「禁止憑空編造」，只是補上「可查證後修正」這一塊。篩選用語法角色避免每個詞都搜尋浪費 token。
2. **段落摘要**：每個 `## ⏱ 時間段` 下的 `段落摘要` 空格，填 2-3 句重點 ＋ 4-8 關鍵字。
3. **全篇重點**：最後的 `重點 / 待辦 / 金句` 空格填好。

只替換 placeholder 內容；時間戳、段落標題不動。**長逐字稿一律分段處理（見上方鐵律），禁止單趟全文重寫。**
🔸 標記 = Phase 1 模型對該片段信心較低，請優先複核（含可能的聽寫錯誤）。
低信心**不是**刪除或精簡的理由——🔸 行同樣適用「逐字主體 100% 保留」，只能改同音錯字／查證專名（留痕），內容一字不可少。

---

## Step 4 — 存檔（不覆寫原檔，保留 ground truth）

校稿輸出到**新檔** `{主題}_逐字稿知識庫_校稿.md`，**不要覆寫 Phase 1 原檔**。原檔（含全部原始時間戳與字數）是自檢的唯一可信對照源——一旦覆寫，「逐字有沒有變少」就永遠驗不出來。完工自檢（時間戳行數 ≥ manifest segments＋每段字數達標）全部通過後，才可由使用者決定是否刪除原檔。

- **自適應專案收納 (Adaptive Project Path Routing)**: 當在標準四盒專案（含有 `100_Todo/`）下執行時：
  - **過程素材與臨時檔** 應置於相對路徑 `100_Todo/drafts/audio-to-md-test/`（或對應任務名稱子目錄）。
  - **產出逐字稿與校稿成品** 應直接置於 `100_Todo/projects/audio-to-md-test/` 底下，**不得建立額外的 `output/` 中間層**。
  - 執行 Phase 1 轉錄時，應指定輸出路徑旗標為 `-o 100_Todo/projects/audio-to-md-test/`。

---

## 和家族串接（完整 RAG 進料）
一場「有投影片＋有講解」的課程錄影：
1. `audio-to-md` → 講解的逐字稿知識庫
2. `vlm-to-md` / `doc-vlm-to-md` → 投影片／文件的圖文
3. 合併 → 聲音＋圖＋文字都進得了 RAG

---

## 疑難排解

| 問題 | 解法 |
|------|------|
| 沙箱裡 `pip install` / 下載模型失敗（HuggingFace 被封） | **預期內，別重試**。Desktop／網頁本來就轉不了。改請使用者在自己電腦用桌面拖檔圖示／本機啟動器跑 Phase 1 |
| 使用者貼了 `C:\...` 或 `/Users/...` 本機路徑，或直接上傳了影音檔 | 兩種都一樣：請他用桌面「🎤 拖檔轉逐字稿.bat」圖示（或本機啟動器）先產生 `*_逐字稿知識庫.md`，再傳回來做 Phase 2。**不要在沙箱嘗試轉錄** |
| 桌面找不到「🎤 拖檔轉逐字稿」圖示 | 代表本機引擎還沒裝。請使用者到下載的安裝包資料夾雙擊 `install.bat`（Mac 跑 `install.sh`）裝一次 |
| 安裝時提示 Python 不相容 | 請安裝 Python 3.12，關閉 Terminal/視窗後重跑 `install.sh` / `install.bat` |
| 第一次很久 | 在下載 turbo 模型（~1.5GB）；之後就快。請耐心等，不要因此改用小模型 |
| 轉錄字有點糙 | 正常，turbo 已是品質底線；剩下交 Phase 2 由 Claude 校稿修正 |
| 本機 Whisper 與 Groq 哪個比較好 | 短中文乾淨錄音常見 Groq 較好，尤其繁中與標點；敏感、離線、批量或不想用 API 時通常本機 Whisper 較合適。實際執行前仍要讓使用者選擇 |
| Groq 找不到 API key | 檢查 `GROQ_API_KEY` 或 `~/.codex/secrets/groq_api_key`；不要把 key 寫進 repo、Obsidian 或聊天 |
| Groq 不能用於這段音訊 | 若內容敏感、未授權或使用者不接受雲端上傳，不使用 Groq；重新詢問是否改選本機 Whisper |
| 機器很慢/記憶體小 | 用 `--beam-size 1` 加速；`--compute-type int8` 已是預設。**仍維持 turbo 模型** |
| 影片轉不出聲音 | 確認影片有音軌；faster-whisper 內含 PyAV 可直接抽，不需系統 ffmpeg |
| 多人對話分不出講者 | Whisper 不做語者分離；Phase 2 由 Claude 依語氣/內容標講者 |

CODEX_LAZYPACK_AUDIO_TO_MD_SKILL_MD

# audio-to-md/references/usage-guide.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/audio-to-md/references/usage-guide.md")"
cat > "{{CODEX_HOME}}/skills/audio-to-md/references/usage-guide.md" <<'CODEX_LAZYPACK_AUDIO_TO_MD_USAGE_GUIDE_MD'
# audio-to-md 參考：給 Claude 的 Phase 2 指引

逐字稿骨架 `*_逐字稿知識庫.md` 可由本地 Whisper turbo 或 Groq 雲端 STT 產生（帶時間戳）。執行 Phase 1 前必須先詢問使用者要用哪個引擎；本機 Whisper 與 Groq 是平行選項，沒有預設值。Groq 會上傳音檔，必須取得使用者同意。

不論 Phase 1 來源是哪一個，輸出 Markdown 後的 Phase 2 完全相同。Claude 在 Phase 2 做三件事：

## 1. 校稿（兩層；最重要）
### Layer 1 — 語感校稿（鐵律不變）
對每段時間戳逐字做：
- 簡體 → 繁體（台灣用語）。
- 修 Whisper 錯字、加標點、合理斷句；校稿後可把零碎時間戳行整併成通順段落（保留段首時間戳）。
- 多人對話：依語氣／內容標講者（如 **講者A：** / **講者B：**），Whisper 不做語者分離。
- **鐵律**：只做上述。**禁止**憑空改寫語意或新增講者沒說的話；聽不清標「（聽不清）」，**絕不編造**。

### Layer 2 — 專名查證（新增；解決「自信地把生僻專名聽成同音常見詞」）
語感層抓不到「替換後通順但事實錯」的專名（企業重心→勤業眾信、串上閒絲→川上賢司、鬼舞者→鬼武者、Tina Selig→Seelig）。
這是 ASR 機率特性：生僻人名/機構/譯名在模型候選裡沒有正確答案，機率集中到常見同音詞，信心反而很高（avg_logprob 看起來健康）——**不是不確定，是自信地選錯**，所以靠語感與信心分數都抓不到。
做法：用**語法角色**篩候選（與信心分數無關）——
- 句子主語且後接需要行為者的動詞；後接稱謂/類別詞（XX 教授・公司・遊戲・書）；前有「叫做」「就是」引介；你對其真實性沒高把握的人名/地名/品牌/書名/機構；標 🔸 的片段優先。
篩出候選（通常 5-20 個）→ 逐一 **WebSearch 查證**：查到更可信版本→修正並留痕 `（查證：原「企業重心」→「勤業眾信」）`；查不到→保留原字＋標 `⚠️ 專名待查證`；無 WebSearch→全部標 `⚠️ 專名待查證`，不憑空猜改。
**修正必須有外部依據＋留痕**（精細化鐵律而非放寬：使用者隨時看得到「改了什麼、為什麼」）。
🔸 = Phase 1 低信心片段（avg_logprob 偏低），優先複核。

## 2. 段落摘要
每個 `## ⏱ 時間段` 下的 `段落摘要` 空格：填 2-3 句該段重點 ＋ 4-8 個檢索關鍵字。

## 3. 全篇重點
最後 `重點 / 待辦 / 金句` 空格：3-5 個重點、（若有）待辦／行動項、1-3 句可摘金句。

## 規則
- 引擎選擇只影響 Phase 1；文字輸出後不要切換成 video-processing 的字幕工作流。
- 不要自行替使用者選擇引擎；即使其中一個引擎已安裝或曾在測試中較好，仍要在執行前詢問。
- 只替換 placeholder 內容；時間戳、段落標題、frontmatter 不動。
- 長逐字稿分段處理、可多輪。
- 繁中（台灣用語）。
- 校稿是「花少量 token 的判斷活」——轉錄（重活）已由本地 Whisper 免費做掉。

## 引擎比較基準

同一份音檔若需要比較本機 Whisper 與 Groq，依序看：

- 完整性：是否漏字、多字、吞掉語助詞或時間戳行。
- 正確性：是否有同音錯字、簡繁錯誤、專名錯誤。
- 可讀性：標點、斷句、繁中輸出是否接近可校稿狀態。
- 時間戳：segments 是否足夠細，是否適合後續逐段校稿。
- 隱私與成本：是否可接受雲端上傳、API key 與服務成本。

Arry `ref_voice.wav` 實測：本機 Whisper 完整但輸出簡體，且將「清楚發音」聽成「清除發音」；Groq 直接輸出繁中並正確辨識「清楚發音」。在這段短中文乾淨錄音上，Groq 品質較優。這是比較結果，不是預設路由；後續每次執行仍要先詢問使用者。
CODEX_LAZYPACK_AUDIO_TO_MD_USAGE_GUIDE_MD

# audio-to-md/references/execution-notes.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/audio-to-md/references/execution-notes.md")"
cat > "{{CODEX_HOME}}/skills/audio-to-md/references/execution-notes.md" <<'CODEX_LAZYPACK_AUDIO_TO_MD_EXECUTION_NOTES_MD'
# audio-to-md 執行紀錄、Python 內嵌與踩坑

本文件記錄 `audio-to-md` v1.2.0 安裝包在 Codex App / LazyPack 中的實際整合方式。目標是讓其他人使用 `codex_installation` LazyPack repo 時，能重建相同效果：本機 Whisper 與 Groq 雲端 STT 作為 Phase 1 平行選項，產出 Markdown 後共用同一套 Phase 2 校稿流程。

## 目前 Skill Package

全域 skill 實體：

```text
{{CODEX_HOME}}/skills/audio-to-md/
```

必要檔案：

```text
SKILL.md
references/usage-guide.md
references/execution-notes.md
scripts/audio_to_md.py
scripts/audio_to_md_groq.py
scripts/requirements.txt
```

LazyPack 可攜化文件：

```text
{{SETUP_REPO}}/lazy-pack/33-Audio-to-Markdown-Skill-安裝.md
```

## Phase 1 平行選項

執行 Phase 1 前必須先問使用者：

```text
這次要用哪個轉錄引擎？
1. 本機 Whisper：不上傳、0 API key、適合敏感或大量素材。
2. Groq 雲端 STT：會上傳音檔，通常速度、繁中與標點較好，需要 Groq API key。
```

規則：

- 本機 Whisper 和 Groq 是平行選項，沒有預設引擎。
- 不要因為本機引擎已安裝就自動使用本機。
- 不要因為 Groq key 存在或 Groq 實測較好就自動上傳音檔。
- 只有使用者明確選擇 Groq，且接受雲端上傳，才走 Groq。
- 兩種引擎只影響「文字從哪裡來」；Markdown 產出後，Phase 2 完全相同。

## 本機 Whisper 安裝過程

來源 zip：

```text
/Users/arrywu/Downloads/audio-to-md-安裝包_v1.2.0.zip
```

安裝包內容包含：

```text
audio-to-md-installer/install.sh
audio-to-md-installer/skill.zip
audio-to-md-installer/assets/transcribe.command
```

實際執行：

```bash
bash /private/tmp/audio-to-md-installer-check/audio-to-md-installer/install.sh
```

安裝結果：

```text
~/.audio-to-md/
~/.audio-to-md/audio-to-md
~/Desktop/轉逐字稿.command
```

安裝器完成事項：

- 檢查 Python 版本。
- 建立 `~/.audio-to-md/venv`。
- 安裝 `faster-whisper`、`av`、`ctranslate2` 等相依套件。
- 複製 `audio_to_md.py` 與 launcher。
- 建立桌面拖檔啟動器。
- 預先下載 Whisper `large-v3-turbo` 模型。
- 驗證 `faster_whisper`、`av`、`ctranslate2` 可 import。
- 驗證 `~/.audio-to-md/audio-to-md --help` 可執行。

本機驗證指令：

```bash
~/.audio-to-md/audio-to-md --help
```

## 本機 Whisper 實測

測試音檔：

```text
codex_symlink/knowledge/arry-voice-profiles/Arry/ref_voice.wav
```

執行指令：

```bash
~/.audio-to-md/audio-to-md \
  "{{SYNC_ROOT}}/knowledge/arry-voice-profiles/Arry/ref_voice.wav" \
  -o "{{SETUP_REPO}}/100_Todo/projects/audio-to-md-test" \
  --language zh \
  --beam-size 1
```

輸出：

```text
ref_voice_逐字稿知識庫.md
ref_voice_manifest.json
```

實測結果：

```text
時長：00:14
語言：zh
segments：4
低信心：0
```

本機 Whisper 原始逐字：

```text
今天我正在录制一段授权的参考声音
这段录音会用于本机语音合成测试
我会保持自然语速、清除发音
并完整朗读与逐字稿相同的内容
```

觀察：

- 字數完整。
- 輸出是簡體，需要 Phase 2 轉繁中。
- 「清楚發音」被聽成「清除發音」，需要 Phase 2 依原始逐字稿或語意修正。
- 本機輸出 4 個 segments，較適合逐行校稿。

## Groq 雲端 STT 整合

Groq 路線原本存在於 `video-processing-automation` 的 `transcribe_groq.py`，用途是影片字幕 JSON/SRT。這次整合時不要直接把 video-processing 的字幕流程搬進來，而是新增 `audio-to-md` 專用腳本：

```text
scripts/audio_to_md_groq.py
```

這支腳本做三件事：

- 讀取 `GROQ_API_KEY` 或 `~/.codex/secrets/groq_api_key`。
- 上傳音訊/影片到 Groq OpenAI-compatible transcription endpoint。
- 直接輸出 audio-to-md 相同語意的 Markdown 骨架、Groq JSON 與 manifest。

Groq key 規則：

```text
~/.codex/secrets/groq_api_key
```

權限應為：

```text
600
```

不要把 key 寫進 repo、LazyPack、Obsidian、聊天、shell snapshot 或截圖。

Groq 執行指令：

```bash
python3 "{{CODEX_HOME}}/skills/audio-to-md/scripts/audio_to_md_groq.py" \
  "{{SYNC_ROOT}}/assets/arry-voice-profiles/Arry/ref_voice.wav" \
  -o "{{SETUP_REPO}}/100_Todo/projects/audio-to-md-test" \
  --language zh
```

輸出：

```text
ref_voice_groq_逐字稿知識庫.md
ref_voice_groq.json
ref_voice_groq_manifest.json
```

實測中先用 `video-processing-automation/scripts/transcribe_groq.py` 驗證 Groq STT 可用，得到：

```text
55 words / 1 segment / 14.0s
```

Groq 原始逐字：

```text
今天,我正在錄製一段授權的參考聲音。這段錄音會用於本機語音合成測試。我會保持自然語速、清楚發音,並完整朗讀與逐字稿相同的內容。
```

觀察：

- 直接輸出繁中。
- 正確辨識「清楚發音」。
- 標點接近可讀狀態。
- 短音檔只輸出 1 個 segment，逐段校稿顆粒較粗；長音檔可依 chunk 分段或後續再調整。

## 比較結果

測試逐字稿 ground truth：

```text
今天我正在錄製一段授權的參考聲音。這段錄音會用於本機語音合成測試，我會保持自然語速、清楚發音，並完整朗讀與逐字稿相同的內容。
```

比較：

| 項目 | 本機 Whisper | Groq |
| --- | --- | --- |
| 是否完整 | 完整 | 完整 |
| 簡繁 | 簡體 | 繁中 |
| 錯字 | 「清楚」誤成「清除」 | 正確 |
| 標點 | 幾乎無標點 | 有基本標點 |
| segments | 4 | 1 |
| 隱私 | 不上傳 | 會上傳到 Groq |
| API key | 不需要 | 需要 |

結論：

- 在這段 14 秒短中文乾淨錄音上，Groq 產出品質較優。
- 這只是比較結果，不是預設路由。
- 未來每次 Phase 1 仍必須先問使用者選本機 Whisper 或 Groq。

## Phase 2 共用流程

不論 Phase 1 來自本機 Whisper 或 Groq，Markdown 產出後一律走同一套流程：

1. 不覆寫原始骨架，另存 `_校稿.md`。
2. 保留每個 `**[時間戳]**` 行。
3. 只做簡繁、確證錯字、標點、斷句、講者標示與專名查證留痕。
4. 補每段摘要與關鍵字。
5. 補全篇重點、待辦、金句。
6. 自檢時間戳行數：
   - 校稿後行數 >= 原稿行數
   - 校稿後行數 >= manifest `segments`
7. 自檢字數：校稿後中文字數應 >= 原稿 x 0.95。

本次 Phase 2 測試另存：

```text
100_Todo/projects/audio-to-md-test/ref_voice_逐字稿知識庫_校稿.md
```

自檢結果：

```text
raw timestamp lines: 4
edited timestamp lines: 4
manifest segments: 4
```

## LazyPack Python 內嵌方式

`lazy-pack/33-Audio-to-Markdown-Skill-安裝.md` 必須內嵌完整 skill package，讓其他人只靠 LazyPack repo 就能安裝：

```text
SKILL.md
references/usage-guide.md
references/execution-notes.md
scripts/requirements.txt
scripts/audio_to_md.py
scripts/audio_to_md_groq.py
```

內嵌使用 Bash heredoc：

```bash
mkdir -p "{{CODEX_HOME}}/skills/audio-to-md/scripts"
cat > "{{CODEX_HOME}}/skills/audio-to-md/scripts/audio_to_md_groq.py" <<'CODEX_LAZYPACK_AUDIO_TO_MD_GROQ_PY'
# Python source here
CODEX_LAZYPACK_AUDIO_TO_MD_GROQ_PY
```

踩坑：

- 新增 Groq 腳本後，若只更新全域 skill、不重建 LazyPack Item 33，第二台電腦安裝時會缺 `audio_to_md_groq.py`。
- Groq 是 cloud route，不能把 API key 寫進 LazyPack；LazyPack 只能寫 key 檔路徑與權限規則。
- 若 top-level 文件中的 shell example 用反斜線續行，產生器字串要避免 Python 把反斜線吃掉；可用獨立 fenced code block 直接寫多行。
- `audio_to_md.py` 內部有模型、beam size、chunk size 的技術預設，這不是「引擎選擇預設」。文件中要明確區分：引擎無預設，單一引擎內部參數可有預設。

## 主要踩坑與固定規則

### 1. 不要把本機 Whisper 當預設

最終規則是本機 Whisper 與 Groq 平行。每次 Phase 1 前都問使用者，沒有預設引擎。

### 2. 不要把 Groq 當預設

即使 Groq 在短中文乾淨錄音上較好，也不能自動上傳使用者音檔。Groq 需要使用者明確選擇與同意雲端上傳。

### 3. 產出文字後流程完全相同

不要因為 Groq 來源來自 `video-processing-automation`，就把後續改成 SRT 清理、影片字幕燒錄或影片上架流程。`audio-to-md` 的後處理永遠是 Markdown 逐字稿知識庫流程。

### 4. Desktop / Web 沙箱不是本機轉錄位置

若使用者在 Claude Desktop 或網頁上傳影音檔，不代表可以在沙箱下載 Whisper 模型。除非是在本機終端環境且有外網，否則本機 Whisper 應由使用者電腦上的 launcher 執行。

### 5. Groq 大檔案需要壓縮或切段

Groq 上傳有大小限制。`audio_to_md_groq.py` 會在超過安全大小時嘗試用 ffmpeg 壓成 16kHz mono 32kbps；壓縮後仍太大時，要手動切段。

### 6. Groq segments 可能比本機少

短檔 Groq 可能回傳 1 個 segment，但 word-level JSON 仍可完整。比較品質時不要只看 segment 數；要同時看完整性、錯字、標點、簡繁和可校稿性。

### 7. 本機 Whisper 可能輸出簡體或常見同音錯字

這是 Phase 2 需要處理的正常情況。不要在 Phase 1 為了追求完美而改成自動使用 Groq。

## 安裝後驗證清單

```bash
test -f "{{CODEX_HOME}}/skills/audio-to-md/SKILL.md"
test -f "{{CODEX_HOME}}/skills/audio-to-md/references/usage-guide.md"
test -f "{{CODEX_HOME}}/skills/audio-to-md/references/execution-notes.md"
test -f "{{CODEX_HOME}}/skills/audio-to-md/scripts/audio_to_md.py"
test -f "{{CODEX_HOME}}/skills/audio-to-md/scripts/audio_to_md_groq.py"
python3 -m py_compile "{{CODEX_HOME}}/skills/audio-to-md/scripts/audio_to_md_groq.py"
~/.audio-to-md/audio-to-md --help
```

Groq route 驗證前先確認：

```bash
test -f ~/.codex/secrets/groq_api_key
stat -f '%Sp %N' ~/.codex/secrets/groq_api_key
```

權限應為 `-rw-------`。
CODEX_LAZYPACK_AUDIO_TO_MD_EXECUTION_NOTES_MD

# audio-to-md/scripts/requirements.txt
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/audio-to-md/scripts/requirements.txt")"
cat > "{{CODEX_HOME}}/skills/audio-to-md/scripts/requirements.txt" <<'CODEX_LAZYPACK_AUDIO_TO_MD_REQUIREMENTS_TXT'
faster-whisper==1.2.1
CODEX_LAZYPACK_AUDIO_TO_MD_REQUIREMENTS_TXT

# audio-to-md/scripts/audio_to_md.py
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/audio-to-md/scripts/audio_to_md.py")"
cat > "{{CODEX_HOME}}/skills/audio-to-md/scripts/audio_to_md.py" <<'CODEX_LAZYPACK_AUDIO_TO_MD_AUDIO_TO_MD_PY'
#!/usr/bin/env python3
"""
audio_to_md.py  v1.2.0 ── audio-to-md｜Phase 1：本地把「影音的聲音」轉成逐字稿骨架
─────────────────────────────────────────────────────────────────────────────
把音訊或影片（直接讀，自動抽音軌）用**本地 Whisper** 轉成一份帶時間戳的
Markdown 逐字稿骨架——留好「校稿、段落摘要、重點」空格，交給 Claude（Phase 2）填。

設計哲學（沿襲 doc-to-md / vlm-to-md 家族）＋ 指揮 AI 的分工：
  • 「聽打」這種機械重活 → 本地 Whisper（免費、離線、0 token、0 API key）
  • 「校稿、理解、抓重點、寫摘要」→ 交給 Claude（Phase 2，花少量 token）
  把對的工序派給對的工具，就是最省 token 的 AI 指揮。

引擎：faster-whisper（跨平台、CPU 友善、內含 PyAV 解碼，不需系統 ffmpeg）。
與家族分工：
  • doc-to-md → 文字檔的文字 ｜ vlm-to-md → 圖的視覺 ｜ audio-to-md → 影音的聲音
─────────────────────────────────────────────────────────────────────────────
"""
import argparse
import datetime
import json
import os
import re
import sys

# === Windows 中文輸出修正（v: cp1252 fix）===
# Windows 預設 stdout 編碼為 cp1252，輸出中文（argparse --help / log 進度）會 UnicodeEncodeError。
# 強制 stdout/stderr 改 UTF-8（被導向 >/dev/null 或檔案時尤其重要）。
for _stream in (sys.stdout, sys.stderr):
    try:
        _stream.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        pass

try:
    from faster_whisper import WhisperModel
    HAS_FW = True
except ImportError:
    HAS_FW = False

AUDIO_EXTS = {".mp3", ".m4a", ".wav", ".flac", ".aac", ".ogg", ".opus", ".wma", ".aiff"}
VIDEO_EXTS = {".mp4", ".mov", ".mts", ".m2ts", ".mkv", ".webm", ".avi", ".flv", ".wmv", ".m4v"}

DEFAULT_MODEL = "large-v3-turbo"   # 對應使用者要的 turbo；弱機可改 small / base
DEFAULT_CHUNK_MIN = 6              # 逐字稿依時間切段，每段約 N 分鐘 + 一個段落摘要空格
LOWCONF_THRESHOLD = -0.8          # 片段 avg_logprob 低於此值 → 標 🔸（模型較不確定，Phase 2 優先複核）
DEFAULT_SPLIT_MIN = 35            # 時長超過 N 分鐘 → 自動切成多個短檔（避免長稿被 AI 摘要）；0 = 不分檔
DEFAULT_PART_MIN = 18             # 分檔時每檔約 N 分鐘（會對齊到 chunk-min 的倍數）


def log(msg: str):
    print(msg, flush=True)


def safe_stem(path: str) -> str:
    stem = os.path.splitext(os.path.basename(path))[0]
    stem = re.sub(r"[^\w一-鿿\-]+", "_", stem).strip("_")
    return stem or "audio"


def fmt_ts(sec: float, with_hour: bool) -> str:
    sec = int(sec)
    h, m, s = sec // 3600, (sec % 3600) // 60, sec % 60
    return f"{h:02d}:{m:02d}:{s:02d}" if with_hour else f"{m:02d}:{s:02d}"


PLACEHOLDER_SUMMARY = (
    "> [!note] 段落摘要\n"
    "> **摘要**：（Claude 將填入這段的 2-3 句重點）\n"
    "> **關鍵字**：（Claude 將填入 4-8 個檢索關鍵字）"
)


def build_scaffold(stem: str, source: str, model: str, language: str,
                   duration: float, segments: list, chunk_min: int,
                   lowconf_threshold: float = LOWCONF_THRESHOLD,
                   part_info: dict = None) -> str:
    now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
    with_hour = duration >= 3600
    dur_str = fmt_ts(duration, duration >= 3600)
    n_words = sum(len(s["text"]) for s in segments)

    yaml = (
        "---\n"
        f'title: "{stem.replace("_", " ")}"\n'
        f'source: "{source}"\n'
        "type: AV-transcript-pending\n"
        f"model: faster-whisper / {model}\n"
        f"language: {language}\n"
        f"duration: \"{dur_str}\"\n"
        f"segments: {len(segments)}\n"
        f'generated_at: "{now}"\n'
        "lang_out: zh-TW\n"
        "---\n\n"
    )

    head = f"# {stem.replace('_', ' ')}｜影音逐字稿知識庫\n\n"
    if part_info:
        head += (
            f"> [!important] 📄 長稿分檔：第 {part_info['idx']} / {part_info['total']} 部分"
            f"（{part_info['start']}–{part_info['end']}）\n"
            f"> **只校「這一個檔」**，校完換下一個 part；最後依 part 順序首尾相接＝完整稿。"
            f"做法見 `{part_info['guide']}`。\n\n"
        )
    head += (
        "> [!danger] 校稿鐵律：逐字主體零刪改、禁摘要（最重要，先讀）\n"
        "> 這份逐字稿可能很長。Phase 2 **只做校稿、不做摘要**——\n"
        "> 1. **逐字主體 100% 保留**：每一個 `**[時間戳]**` 行都必須留著，內容一字不刪、不合併、不改寫、不潤飾成書面語。校稿能動的只有：簡體→繁體、錯字、標點、合理斷句、（多人時）句首標講者。\n"
        "> 2. **禁止用摘要代替逐字**：不可以把一段話濃縮成幾句「代替」原文。摘要只能**額外**寫進每段的「段落摘要」欄，原始逐字照樣全留。\n"
        "> 3. **必須分段處理（否則會自動截斷成摘要）**：一次只處理一個 `## ⏱ 時間段`、用 Edit 逐段填，**禁止一次重寫全文**——長稿單趟輸出會撞長度上限，AI 就會偷偷改用摘要、掉時間戳。\n"
        "> 4. **完工自檢（雙指標）**：(a) 校稿後 `**[` 行數必須 **≥ 原稿、且 ≥ 本檔開頭 YAML 的 `segments` 值**（只會因斷句變多、不該變少）；(b) 校稿後中文字元數必須 **≥ 原稿 ×0.95**（簡繁／標點只增不減）。任一段字數掉 >10%＝摘要了，重做該段。\n"
        "> 5. **一次只輸出一段**：用 Edit 逐段填，同一次回覆只能涵蓋一個 `## ⏱ 時間段`；嚴禁同次塞多段（多段＝撞上限＝被截成摘要）。斷句＝只加標點換行、不增刪換任何一字（語助詞、重複、口頭禪全留）。\n"
        "> 6. **不覆寫原檔**：校稿存到新檔 `_校稿.md`，保留原始骨架供自檢對拍。\n\n"
    )
    head += (
        "> [!info] 這份還沒完成——本地 Whisper 已把「聲音」轉成字，等 Claude 來「理解」\n"
        "> Phase 1（本地、0 token）已完成轉錄。請在 Claude 裡讓它做 Phase 2：\n"
        "> 1) **校稿**：簡體→繁體（台灣用語）、修錯字、加標點、合理斷句（**不要改變語意**）。\n"
        "> 2) 把每段的 `段落摘要` 空格填好。3) 最後補「全篇重點 / 待辦 / 金句」。\n"
        "> 這一步花的 token 很少——重活（聽打）本地免費做掉了。\n\n"
    )
    head += (
        "> [!tip] 兩層校稿（語感層 + 專名查證層）\n"
        "> **Layer 1 語感校稿（鐵律不變）**：簡繁轉換、錯字、標點、斷句、（多人時）標講者。**禁止**憑空改寫或新增講者沒說的內容；聽不清標「（聽不清）」。\n"
        "> **Layer 2 專名查證（解決「自信地把生僻專名聽成同音常見詞」，如 企業重心→勤業眾信、Tina Selig→Seelig）**：\n"
        "> 用**語法角色**而非信心分數篩候選——句子主語且後接需行為者的動詞／後接稱謂類別詞（XX 教授・公司・遊戲・書）／前有「叫做」「就是」引介／你對其真實性沒高把握的人名地名品牌書名機構／標了 🔸 的片段。\n"
        "> 篩出候選（通常 5-20 個）逐一 **WebSearch 查證**：查到更可信版本→修正並**留痕**`（查證：原「企業重心」→「勤業眾信」）`；查不到→保留原字並標 `⚠️ 專名待查證`；無 WebSearch 可用→全部標 `⚠️ 專名待查證`，**不要憑空猜改**。修正必須有外部依據＋留痕。\n"
        "> 🔸 = Phase 1 模型對該片段信心較低（avg_logprob 偏低），請**優先複核**。\n\n"
    )

    # 依時間切段
    body = ""
    chunk_sec = chunk_min * 60
    cur_chunk = -1
    for s in segments:
        idx = int(s["start"] // chunk_sec)
        if idx != cur_chunk:
            cur_chunk = idx
            cstart = fmt_ts(idx * chunk_sec, with_hour)
            cend = fmt_ts(min((idx + 1) * chunk_sec, duration), with_hour)
            body += f"\n## ⏱ {cstart}–{cend}\n\n"
            body += PLACEHOLDER_SUMMARY + "\n\n"
            body += "<!-- 原始逐字：逐行校稿，禁止跨行合併、禁止刪句、禁止跨時間戳搬移文字；每個 **[時間戳]** 行獨立保留 -->\n\n"
        lp = s.get("avg_logprob")
        mark = "🔸" if (lp is not None and lp < lowconf_threshold) else ""
        body += f"**[{fmt_ts(s['start'], with_hour)}]** {mark}{s['text'].strip()}\n\n"

    tail = (
        "\n---\n\n"
        "## 📌 全篇重點（Claude 填）\n\n"
        "> [!note] 重點 / 待辦 / 金句\n"
        "> **3-5 個重點**：（Claude 將填入）\n"
        "> **待辦或行動項**：（若有）\n"
        "> **可摘金句**：（1-3 句）\n"
    )
    return yaml + head + body + tail


def build_guide(stem: str, duration: float, written: list) -> str:
    """長稿分檔後，給學員的純文字操作說明（一檔一貼、最後串接）。"""
    dur_min = int(round(duration / 60))
    lines = [
        "【長稿分檔校稿說明】",
        "",
        f"你的錄音較長（約 {dur_min} 分鐘），已自動切成 {len(written)} 個短檔，",
        "目的是避免「太長 → AI 自行摘要、掉時間戳、內文被改寫」。",
        "",
        "檔案清單（依順序）：",
    ]
    for name, _ns, ps, pe in written:
        lines.append(f"  {name}　（{ps}–{pe}）")
    lines += [
        "",
        "怎麼做（重點：一個檔一次，不要一次貼多個 part）：",
        "  1. 把 part1 檔丟回 Claude，說：",
        "     「幫我校稿這份逐字稿，逐字不要摘要、保留每個時間戳：<part1 路徑>」",
        "  2. 校好後存成 part1 的 _校稿.md。",
        "  3. 換 part2，重複步驟 1–2……直到所有 part 都校完。",
        "  4. 最後把各 part 的校稿版「依 part 順序」首尾接起來＝完整逐字稿。",
        "     （時間戳是連續的，直接相接即可。）",
        "",
        "為什麼要分檔：",
        "  長稿一次塞進一則回覆會超過長度上限，AI 會偷偷改用「摘要」交差，",
        "  於是時間戳掉了、整段被壓縮。切成短檔後，每檔都短到能一次完整校完，",
        "  逐字稿就不會被壓縮——這是架構上的解法，不是靠提示詞硬撐。",
    ]
    return "\n".join(lines) + "\n"


def transcribe(input_path: str, model: str, language: str, device: str,
               compute_type: str, beam_size: int) -> tuple:
    log(f"🎧 載入 Whisper 模型：{model}（device={device}, compute={compute_type}）")
    log("   （第一次使用會自動下載模型，turbo 約 1.5GB，需幾分鐘）")
    if any(m in model.lower() for m in ("tiny", "base", "small")):
        log("⚠ 你指定了較小的模型——中文品質會明顯變差、連校稿都難救回。"
            "強烈建議改用 large-v3-turbo（本工具品質底線）。")
    wm = WhisperModel(model, device=device, compute_type=compute_type)
    log(f"🗣️  開始轉錄：{os.path.basename(input_path)}")
    seg_iter, info = wm.transcribe(
        input_path,
        language=(None if language in ("auto", "", None) else language),
        vad_filter=True,
        beam_size=beam_size,
    )
    segments = []
    for seg in seg_iter:   # 這個迴圈才真正執行轉錄
        segments.append({"start": seg.start, "end": seg.end, "text": seg.text,
                         "avg_logprob": getattr(seg, "avg_logprob", None)})
        if len(segments) % 25 == 0:
            log(f"   …已轉錄到 {fmt_ts(seg.end, info.duration >= 3600)}")
    return segments, info


def process(input_path: str, out_dir: str, model: str, language: str,
            device: str, compute_type: str, beam_size: int, chunk_min: int,
            lowconf_threshold: float = LOWCONF_THRESHOLD,
            split_min: int = DEFAULT_SPLIT_MIN, part_min: int = DEFAULT_PART_MIN) -> int:
    if not os.path.exists(input_path):
        log(f"❌ 找不到輸入：{input_path}")
        return 1
    ext = os.path.splitext(input_path)[1].lower()
    if ext not in AUDIO_EXTS and ext not in VIDEO_EXTS:
        log(f"❌ 不支援的格式：{ext}。支援音訊 {sorted(AUDIO_EXTS)} / 影片 {sorted(VIDEO_EXTS)}")
        return 1
    if not HAS_FW:
        log("❌ 需要 faster-whisper：pip install -r scripts/requirements.txt")
        return 1

    os.makedirs(out_dir, exist_ok=True)
    kind = "影片" if ext in VIDEO_EXTS else "音訊"
    log(f"🎬 輸入：{os.path.basename(input_path)}（{kind}；影片會自動抽音軌）")

    segments, info = transcribe(input_path, model, language, device, compute_type, beam_size)
    if not segments:
        log("❌ 沒有轉錄出任何內容（檔案可能沒有語音或全是靜音）。")
        return 1

    stem = safe_stem(input_path)
    lang = getattr(info, "language", language) or "auto"
    duration = float(getattr(info, "duration", segments[-1]["end"]))
    n_low = sum(1 for s in segments if (s.get("avg_logprob") is not None and s["avg_logprob"] < lowconf_threshold))
    with_hour = duration >= 3600
    src = os.path.basename(input_path)

    def _write(md_text: str, fname: str) -> str:
        p = os.path.join(out_dir, fname)
        with open(p, "w", encoding="utf-8") as f:
            f.write(md_text)
        return p

    # 長稿自動分檔：把「隔離」放在 Phase 1 輸出。每個短檔都能在一次校稿裡完整吐完，
    # 不會撞輸出上限→被 AI 摘要；Desktop 也適用（不需 Claude Code / subagent / API）。
    part_chunks = max(1, round(part_min / chunk_min)) if part_min > 0 else 1
    part_sec = part_chunks * chunk_min * 60
    do_split = split_min > 0 and duration > split_min * 60

    written = []   # [(檔名, 段數, 起, 迄)]
    if do_split:
        parts = {}
        for s in segments:
            parts.setdefault(int(s["start"] // part_sec), []).append(s)
        keys = sorted(parts)
        n = len(keys)
        for i, k in enumerate(keys, 1):
            pseg = parts[k]
            pstart = fmt_ts(pseg[0]["start"], with_hour)
            pend = fmt_ts(pseg[-1]["end"], with_hour)
            part_info = {"idx": i, "total": n, "start": pstart, "end": pend,
                         "guide": f"{stem}_長稿校稿說明.txt"}
            md = build_scaffold(stem, src, model, lang, duration, pseg, chunk_min,
                                lowconf_threshold, part_info)
            name = f"{stem}_逐字稿知識庫_part{i}of{n}.md"
            _write(md, name)
            written.append((name, len(pseg), pstart, pend))
        _write(build_guide(stem, duration, written), f"{stem}_長稿校稿說明.txt")
    else:
        md = build_scaffold(stem, src, model, lang, duration, segments, chunk_min, lowconf_threshold)
        name = f"{stem}_逐字稿知識庫.md"
        _write(md, name)
        written.append((name, len(segments), fmt_ts(0, with_hour), fmt_ts(duration, with_hour)))

    manifest = {
        "source": input_path, "kind": kind, "model": model, "language": lang,
        "duration_sec": round(duration, 1), "segments": len(segments),
        "split": do_split, "parts": [w[0] for w in written],
        "generated_at": datetime.datetime.now().isoformat(),
    }
    with open(os.path.join(out_dir, f"{stem}_manifest.json"), "w", encoding="utf-8") as f:
        json.dump(manifest, f, ensure_ascii=False, indent=2)

    log("")
    log("✅ Phase 1 完成（本地、0 token）")
    log(f"   • 時長：{fmt_ts(duration, with_hour)}　語言：{lang}　段落：{len(segments)}　🔸低信心：{n_low}")
    if do_split:
        log(f"   • 長稿已自動切成 {len(written)} 個短檔（每檔約 {part_chunks * chunk_min} 分鐘），避免被 AI 摘要：")
        for name, ns, ps, pe in written:
            log(f"     - {name}（{ps}–{pe}，{ns} 段）")
        log(f"   • 校稿說明：{stem}_長稿校稿說明.txt")
        log("")
        log("👉 下一步（Phase 2）：一個 part 檔丟回 Claude 校稿一次，校完換下一個，最後依序接起來。")
        log('   對每個檔說：「幫我校稿這份逐字稿，逐字不要摘要、保留每個時間戳：<part 路徑>」')
    else:
        out_path = os.path.join(out_dir, written[0][0])
        log(f"   • 逐字稿骨架：{out_path}")
        log("")
        log("👉 下一步（Phase 2，花少量 token）：在 Claude 裡說")
        log(f'   「幫我校稿並完成這份逐字稿知識庫（逐字不要摘要、保留時間戳）：{out_path}」')
    log(f"[DONE] Phase 1 done. output dir: {out_dir}")
    return 0


def main():
    ap = argparse.ArgumentParser(
        description="audio-to-md Phase 1：本地 Whisper 把影音轉成逐字稿 Markdown 骨架（免費、0 token、0 API key）")
    ap.add_argument("input", help="音訊或影片檔（mp3/m4a/wav/mp4/mov/mts… 影片會自動抽音軌）")
    ap.add_argument("-o", "--output", default=None, help="輸出資料夾（預設：輸入檔所在目錄）")
    ap.add_argument("--auto", action="store_true", help="便捷旗標（與家族一致）")
    ap.add_argument("--model", default=DEFAULT_MODEL,
                    help=f"Whisper 模型（建議固定用預設 {DEFAULT_MODEL}＝中文品質底線；不建議降級成 small/base）")
    ap.add_argument("--language", default="auto", help="語言代碼（預設 auto 自動偵測；中文可指定 zh）")
    ap.add_argument("--device", default="cpu", help="cpu（預設、跨平台）或 cuda")
    ap.add_argument("--compute-type", default="int8", help="int8（預設、省記憶體）/ int8_float16 / float16")
    ap.add_argument("--beam-size", type=int, default=5, help="beam size（預設 5；想更快可設 1）")
    ap.add_argument("--chunk-min", type=int, default=DEFAULT_CHUNK_MIN,
                    help=f"逐字稿依時間切段，每段約 N 分鐘（預設 {DEFAULT_CHUNK_MIN}）")
    ap.add_argument("--lowconf-threshold", type=float, default=LOWCONF_THRESHOLD,
                    help=f"avg_logprob 低於此值的片段標 🔸 供 Phase 2 優先複核（預設 {LOWCONF_THRESHOLD}）")
    ap.add_argument("--split-min", type=int, default=DEFAULT_SPLIT_MIN,
                    help=f"時長超過 N 分鐘 → 自動切成多個短檔避免長稿被 AI 摘要（預設 {DEFAULT_SPLIT_MIN}；0=不分檔）")
    ap.add_argument("--part-min", type=int, default=DEFAULT_PART_MIN,
                    help=f"分檔時每檔約 N 分鐘（會對齊到 chunk-min 倍數；預設 {DEFAULT_PART_MIN}）")
    args = ap.parse_args()

    out_dir = args.output or os.path.dirname(os.path.abspath(args.input))
    sys.exit(process(args.input, out_dir, args.model, args.language,
                     args.device, args.compute_type, args.beam_size, args.chunk_min,
                     args.lowconf_threshold, args.split_min, args.part_min))


if __name__ == "__main__":
    main()
CODEX_LAZYPACK_AUDIO_TO_MD_AUDIO_TO_MD_PY

# audio-to-md/scripts/audio_to_md_groq.py
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/audio-to-md/scripts/audio_to_md_groq.py")"
cat > "{{CODEX_HOME}}/skills/audio-to-md/scripts/audio_to_md_groq.py" <<'CODEX_LAZYPACK_AUDIO_TO_MD_GROQ_PY'
#!/usr/bin/env python3
"""
audio_to_md_groq.py -- Groq cloud STT route for audio-to-md.

This script uploads an audio/video file to Groq's OpenAI-compatible
transcription endpoint and writes the same Markdown knowledge-base scaffold as
the local Whisper route. Use it only when the user accepts cloud transcription.
"""
import argparse
import datetime
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
import urllib.error
import urllib.request
from pathlib import Path

GROQ_URL = "https://api.groq.com/openai/v1/audio/transcriptions"
DEFAULT_MODEL = "whisper-large-v3-turbo"
DEFAULT_CHUNK_MIN = 6
SIZE_LIMIT_MB = 24.0

AUDIO_EXTS = {".mp3", ".m4a", ".wav", ".flac", ".aac", ".ogg", ".opus", ".wma", ".aiff"}
VIDEO_EXTS = {".mp4", ".mov", ".mts", ".m2ts", ".mkv", ".webm", ".avi", ".flv", ".wmv", ".m4v"}

for _stream in (sys.stdout, sys.stderr):
    try:
        _stream.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        pass


def log(msg: str) -> None:
    print(msg, flush=True)


def safe_stem(path: str) -> str:
    stem = os.path.splitext(os.path.basename(path))[0]
    stem = re.sub(r"[^\w一-鿿\-]+", "_", stem).strip("_")
    return stem or "audio"


def fmt_ts(sec: float, with_hour: bool) -> str:
    sec = int(sec)
    h, m, s = sec // 3600, (sec % 3600) // 60, sec % 60
    return f"{h:02d}:{m:02d}:{s:02d}" if with_hour else f"{m:02d}:{s:02d}"


def load_api_key() -> str:
    env_key = os.environ.get("GROQ_API_KEY")
    if env_key:
        return env_key.strip()
    key_file = Path.home() / ".codex" / "secrets" / "groq_api_key"
    if key_file.exists():
        return key_file.read_text(encoding="utf-8").strip()
    sys.exit(
        "[ERR] 找不到 Groq API key：請設定 GROQ_API_KEY，或把 key 存到 "
        "~/.codex/secrets/groq_api_key 並設為 600 權限。"
    )


def compress_audio(src: Path) -> Path:
    if not shutil.which("ffmpeg"):
        sys.exit("[ERR] 檔案超過 Groq 上傳大小，需要 ffmpeg 壓縮，但找不到 ffmpeg。")
    tmp = Path(tempfile.gettempdir()) / f"audio-to-md-groq-{os.getpid()}.mp3"
    cmd = [
        "ffmpeg", "-i", str(src),
        "-vn", "-ac", "1", "-ar", "16000", "-b:a", "32k",
        "-y", str(tmp),
    ]
    log("[INFO] 檔案較大，先壓成 16kHz mono 32kbps...")
    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode != 0:
        sys.exit(f"[ERR] ffmpeg 壓縮失敗：\n{result.stderr[-800:]}")
    size_mb = tmp.stat().st_size / 1024 / 1024
    log(f"[INFO] 壓縮完成：{size_mb:.1f} MB")
    return tmp


def build_multipart(audio_path: Path, model: str, language: str, prompt: str) -> tuple[bytes, str]:
    boundary = "----AudioToMdGroqBoundary7MA4YWxkTrZu0gW"
    crlf = b"\r\n"
    parts: list[bytes] = []

    def add_field(name: str, value: str) -> None:
        parts.append(f"--{boundary}".encode())
        parts.append(f'Content-Disposition: form-data; name="{name}"'.encode())
        parts.append(b"")
        parts.append(value.encode("utf-8"))

    add_field("model", model)
    add_field("response_format", "verbose_json")
    add_field("timestamp_granularities[]", "segment")
    add_field("timestamp_granularities[]", "word")
    if language and language != "auto":
        add_field("language", language)
    if prompt:
        add_field("prompt", prompt)

    safe_name = "audio" + audio_path.suffix.lower()
    parts.append(f"--{boundary}".encode())
    parts.append(
        (
            f'Content-Disposition: form-data; name="file"; '
            f'filename="{safe_name}"'
        ).encode("utf-8")
    )
    parts.append(b"Content-Type: application/octet-stream")
    parts.append(b"")
    parts.append(audio_path.read_bytes())
    parts.append(f"--{boundary}--".encode())
    parts.append(b"")

    return crlf.join(parts), f"multipart/form-data; boundary={boundary}"


def transcribe_groq(input_path: Path, model: str, language: str, prompt: str) -> tuple[dict, Path | None]:
    api_key = load_api_key()
    size_mb = input_path.stat().st_size / 1024 / 1024
    upload_path = input_path
    tmp_path = None
    log(f"[INFO] Groq STT：{input_path.name}，{size_mb:.1f} MB，模型 {model}")
    if size_mb > SIZE_LIMIT_MB:
        tmp_path = compress_audio(input_path)
        upload_path = tmp_path
        if tmp_path.stat().st_size / 1024 / 1024 > SIZE_LIMIT_MB:
            sys.exit("[ERR] 壓縮後仍超過上傳上限，請先手動切段。")

    body, content_type = build_multipart(upload_path, model, language, prompt)
    req = urllib.request.Request(
        GROQ_URL,
        data=body,
        headers={
            "Authorization": f"Bearer {api_key}",
            "Content-Type": content_type,
            "User-Agent": "audio-to-md-groq/1.0",
            "Accept": "application/json",
        },
        method="POST",
    )
    log("[INFO] 上傳到 Groq 轉錄中...")
    try:
        with urllib.request.urlopen(req, timeout=600) as resp:
            return json.loads(resp.read().decode("utf-8")), tmp_path
    except urllib.error.HTTPError as e:
        err_body = e.read().decode("utf-8", errors="replace")
        sys.exit(f"[ERR] Groq API 錯誤 {e.code}：{err_body}")
    except urllib.error.URLError as e:
        sys.exit(f"[ERR] 網路錯誤：{e}")


def normalize_segments(data: dict) -> list[dict]:
    segments = data.get("segments") or []
    if segments:
        return [
            {
                "start": float(s.get("start", 0)),
                "end": float(s.get("end", 0)),
                "text": str(s.get("text", "")).strip(),
            }
            for s in segments
            if str(s.get("text", "")).strip()
        ]
    text = str(data.get("text", "")).strip()
    duration = float(data.get("duration") or 0)
    return [{"start": 0.0, "end": duration, "text": text}] if text else []


def build_scaffold(
    stem: str,
    source: str,
    model: str,
    language: str,
    duration: float,
    segments: list[dict],
    chunk_min: int,
) -> str:
    now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
    with_hour = duration >= 3600
    dur_str = fmt_ts(duration, with_hour)
    yaml = (
        "---\n"
        f'title: "{stem.replace("_", " ")}"\n'
        f'source: "{source}"\n'
        "type: AV-transcript-pending\n"
        f"model: groq / {model}\n"
        f"language: {language}\n"
        f"duration: \"{dur_str}\"\n"
        f"segments: {len(segments)}\n"
        f'generated_at: "{now}"\n'
        "lang_out: zh-TW\n"
        "---\n\n"
    )
    head = (
        f"# {stem.replace('_', ' ')}｜影音逐字稿知識庫\n\n"
        "> [!danger] 校稿鐵律：逐字主體零刪改、禁摘要（最重要，先讀）\n"
        "> Groq 已完成 Phase 1 雲端 STT。從這一刻開始，後續流程與本機 Whisper 產出的骨架完全相同：Phase 2 只做校稿、摘要欄與重點欄；不得用摘要取代時間戳逐字主體。\n"
        "> 1. **逐字主體 100% 保留**：每一個 `**[時間戳]**` 行都必須留著，內容一字不刪、不合併、不改寫、不潤飾成書面語。校稿能動的只有：簡繁、確證錯字、標點、合理斷句、（多人時）句首標講者。\n"
        "> 2. **禁止用摘要代替逐字**：摘要只能額外寫進每段的「段落摘要」欄，原始逐字照樣全留。\n"
        "> 3. **分段處理**：一次只處理一個 `## ⏱ 時間段`，禁止一次重寫長稿全文。\n"
        "> 4. **完工自檢**：校稿後 `**[` 行數必須 >= 原稿、且 >= YAML `segments`；校稿後中文字元數應 >= 原稿 ×0.95。\n"
        "> 5. **不覆寫原檔**：校稿存到新檔 `_校稿.md`，保留原始骨架供自檢對拍。\n\n"
        "> [!warning] 雲端 STT 邊界\n"
        "> 這一路線會把音訊/影片上傳到 Groq。只有在使用者接受雲端轉錄時使用；"
        "敏感、不可外傳、或不想使用 API key 的內容改用本機 Whisper 路線。\n\n"
        "> [!info] 這份還沒完成——Groq 已把「聲音」轉成字，等 Codex 來「理解」\n"
        "> 1) **校稿**：簡繁、修錯字、加標點、合理斷句（不要改變語意）。\n"
        "> 2) 把每段的 `段落摘要` 空格填好。3) 最後補「全篇重點 / 待辦 / 金句」。\n\n"
        "> [!tip] 兩層校稿（語感層 + 專名查證層）\n"
        "> **Layer 1 語感校稿**：簡繁轉換、錯字、標點、斷句、（多人時）標講者。**禁止**憑空改寫或新增講者沒說的內容；聽不清標「（聽不清）」。\n"
        "> **Layer 2 專名查證**：人名、地名、品牌、書名、機構、技術名詞等，若不確定就查證；查到更可信版本才修正並留痕，查不到就標 `⚠️ 專名待查證`。\n\n"
    )
    body = ""
    chunk_sec = chunk_min * 60
    cur_chunk = -1
    placeholder = (
        "> [!note] 段落摘要\n"
        "> **摘要**：（Codex 將填入這段的 2-3 句重點）\n"
        "> **關鍵字**：（Codex 將填入 4-8 個檢索關鍵字）"
    )
    for s in segments:
        idx = int(s["start"] // chunk_sec)
        if idx != cur_chunk:
            cur_chunk = idx
            cstart = fmt_ts(idx * chunk_sec, with_hour)
            cend = fmt_ts(min((idx + 1) * chunk_sec, duration), with_hour)
            body += f"\n## ⏱ {cstart}–{cend}\n\n{placeholder}\n\n"
            body += "<!-- 原始逐字：逐行校稿，禁止刪句或跨時間戳搬移文字 -->\n\n"
        body += f"**[{fmt_ts(s['start'], with_hour)}]** {s['text']}\n\n"
    tail = (
        "\n---\n\n"
        "## 📌 全篇重點（Codex 填）\n\n"
        "> [!note] 重點 / 待辦 / 金句\n"
        "> **3-5 個重點**：（Codex 將填入）\n"
        "> **待辦或行動項**：（若有）\n"
        "> **可摘金句**：（1-3 句）\n"
    )
    return yaml + head + body + tail


def process(args: argparse.Namespace) -> int:
    input_path = Path(args.input).expanduser()
    if not input_path.exists():
        sys.exit(f"[ERR] 找不到輸入檔：{input_path}")
    ext = input_path.suffix.lower()
    if ext not in AUDIO_EXTS and ext not in VIDEO_EXTS:
        sys.exit(f"[ERR] 不支援的格式：{ext}")
    out_dir = Path(args.output).expanduser() if args.output else input_path.parent
    out_dir.mkdir(parents=True, exist_ok=True)

    data, tmp_path = transcribe_groq(input_path, args.model, args.language, args.prompt)
    try:
        stem = safe_stem(str(input_path))
        segments = normalize_segments(data)
        if not segments:
            sys.exit("[ERR] Groq 沒有回傳可用轉錄內容。")
        duration = float(data.get("duration") or max(s["end"] for s in segments))
        lang = args.language if args.language != "auto" else data.get("language", "auto")
        md = build_scaffold(stem, input_path.name, args.model, lang, duration, segments, args.chunk_min)

        md_path = out_dir / f"{stem}_groq_逐字稿知識庫.md"
        json_path = out_dir / f"{stem}_groq.json"
        manifest_path = out_dir / f"{stem}_groq_manifest.json"
        md_path.write_text(md, encoding="utf-8")
        json_path.write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")
        manifest = {
            "source": str(input_path),
            "kind": "影片" if ext in VIDEO_EXTS else "音訊",
            "engine": "groq",
            "model": args.model,
            "language": lang,
            "duration_sec": round(duration, 1),
            "segments": len(segments),
            "words": len(data.get("words") or []),
            "generated_at": datetime.datetime.now().isoformat(),
            "outputs": [md_path.name, json_path.name],
        }
        manifest_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=2), encoding="utf-8")
        log("")
        log("✅ Phase 1 完成（Groq 雲端 STT）")
        log(f"   • 時長：{fmt_ts(duration, duration >= 3600)}　語言：{lang}　段落：{len(segments)}")
        log(f"   • 逐字稿骨架：{md_path}")
        log(f"   • Groq JSON：{json_path}")
        return 0
    finally:
        if tmp_path is not None and tmp_path.exists():
            try:
                tmp_path.unlink()
            except OSError:
                pass


def main() -> None:
    ap = argparse.ArgumentParser(
        description="audio-to-md Phase 1：Groq 雲端 STT 把影音轉成 Markdown 逐字稿骨架。"
    )
    ap.add_argument("input", help="音訊或影片檔")
    ap.add_argument("-o", "--output", default=None, help="輸出資料夾（預設：輸入檔所在目錄）")
    ap.add_argument("--model", default=DEFAULT_MODEL, help=f"Groq STT 模型（預設 {DEFAULT_MODEL}）")
    ap.add_argument("--language", default="zh", help="語言代碼（中文建議 zh；也可 auto）")
    ap.add_argument("--chunk-min", type=int, default=DEFAULT_CHUNK_MIN, help="每段約 N 分鐘")
    ap.add_argument(
        "--prompt",
        default=(
            "以下為繁體中文口語內容。專有名詞：Codex、ChatGPT、OpenAI、"
            "NotebookLM、Gemini、Groq、Whisper、GitHub、Obsidian、"
            "Firebase、Netlify、Python、JavaScript。"
        ),
        help="傳給 Groq Whisper 的詞彙提示。",
    )
    sys.exit(process(ap.parse_args()))


if __name__ == "__main__":
    main()
CODEX_LAZYPACK_AUDIO_TO_MD_GROQ_PY

# audio-to-md/scripts/install.sh
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/audio-to-md/scripts/install.sh")"
cat > "{{CODEX_HOME}}/skills/audio-to-md/scripts/install.sh" <<'CODEX_LAZYPACK_AUDIO_TO_MD_INSTALL_SH'
#!/bin/bash
# ╔════════════════════════════════════════════════╗
# ║   audio-to-md 一鍵安裝器（Mac / Linux）          ║
# ║   本地 Whisper：把影音的聲音轉成 Markdown 逐字稿 ║
# ╚════════════════════════════════════════════════╝
#
# 使用方式：打開 Terminal → 輸入 bash 加空格 → 拖入此檔案 → 按 Enter

set -e
trap 'if [ -n "${EXTRACT_DIR:-}" ]; then rm -rf "$EXTRACT_DIR"; fi' EXIT

INSTALL_DIR="$HOME/.audio-to-md"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
EXTRACT_DIR=""
WHISPER_MODEL="large-v3-turbo"

# 支援自足安裝：偵測是否在技能資料夾中執行
if [ -f "$(dirname "$SCRIPT_DIR")/SKILL.md" ]; then
    SKILL_SRC="$(cd "$SCRIPT_DIR/.." && pwd)"
else
    # Fallback 舊安裝包或解壓縮模式
    if [ ! -f "$SCRIPT_DIR/skill.zip" ] && [ -f "$SCRIPT_DIR/audio_to_md.py" ]; then
        SKILL_SRC="$SCRIPT_DIR"
    else
        if [ ! -f "$SCRIPT_DIR/skill.zip" ]; then
            echo "找不到 skill.zip，請確認安裝包已完整解壓縮。"; exit 1
        fi
        EXTRACT_DIR="$(mktemp -d "${TMPDIR:-/tmp}/audio-to-md-skill.XXXXXX")"
        echo "📦 解壓縮技能檔..."
        unzip -q "$SCRIPT_DIR/skill.zip" -d "$EXTRACT_DIR"
        SKILL_SRC="$EXTRACT_DIR/skill"
    fi
fi

if [ ! -f "$SKILL_SRC/scripts/requirements.txt" ]; then
    echo "找不到 $SKILL_SRC/scripts/requirements.txt，請確認安裝包完整。"; exit 1
fi

echo ""
echo "╔════════════════════════════════════════════╗"
echo "║   audio-to-md 安裝程式 v1.2.0              ║"
echo "║   影音 → 逐字稿知識庫（本地 Whisper turbo）  ║"
echo "╚════════════════════════════════════════════╝"
echo ""

# ── Step 1/4：Python ───────────────────────────────────────────────────────
echo "🔍 Step 1/4：檢查 Python 版本..."
PY=""

OS_NAME="$(uname -s 2>/dev/null || echo unknown)"
MAC_MAJOR=0
if [ "$OS_NAME" = "Darwin" ] && command -v sw_vers >/dev/null 2>&1; then
    MAC_MAJOR="$(sw_vers -productVersion 2>/dev/null | cut -d. -f1)"
fi
MAX_PY_MINOR=14
if [ "$OS_NAME" = "Darwin" ] && [ "${MAC_MAJOR:-0}" -lt 14 ] 2>/dev/null; then
    # onnxruntime/faster-whisper wheels are most reliable on older macOS with Python 3.9-3.12.
    MAX_PY_MINOR=12
fi

supports_python_version() {
    major="$1"
    minor="$2"
    [ "$major" -eq 3 ] 2>/dev/null && [ "$minor" -ge 9 ] 2>/dev/null && [ "$minor" -le "$MAX_PY_MINOR" ] 2>/dev/null
}

for cmd in python3.12 python3.11 python3.10 python3.9 python3.14 python3.13 python3; do
    if command -v "$cmd" &>/dev/null; then
        ver=$("$cmd" -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')" 2>/dev/null)
        major=$(echo "$ver" | cut -d. -f1); minor=$(echo "$ver" | cut -d. -f2)
        if supports_python_version "$major" "$minor"; then
            PY="$cmd"; echo "   ✅ 找到 $cmd (Python $ver)"; break
        else
            echo "   ⏭️  $cmd 版本 $ver 不在本工具支援範圍，跳過"
        fi
    fi
done
if [ -z "$PY" ]; then
    echo "   ❌ 找不到相容的 Python"
    echo "   👉 前往 https://www.python.org/downloads/ 下載 Python 3.12，裝完重開 Terminal 再執行"
    if [ "$OS_NAME" = "Darwin" ] && [ "${MAC_MAJOR:-0}" -lt 14 ] 2>/dev/null; then
        echo "   ℹ️  你的 macOS 較舊，請使用 Python 3.12，避免 3.13+ 的 onnxruntime 相容性問題。"
    fi
    open "https://www.python.org/downloads/" 2>/dev/null || true; exit 1
fi

# ── Step 2/4：venv ─────────────────────────────────────────────────────────
echo ""
echo "📦 Step 2/4：建立虛擬環境..."
mkdir -p "$INSTALL_DIR"
if [ -x "$INSTALL_DIR/venv/bin/python3" ]; then
    venv_ver=$("$INSTALL_DIR/venv/bin/python3" -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')" 2>/dev/null || echo "0.0")
    venv_major=$(echo "$venv_ver" | cut -d. -f1); venv_minor=$(echo "$venv_ver" | cut -d. -f2)
    if supports_python_version "$venv_major" "$venv_minor"; then
        echo "   ⏭️  虛擬環境已存在，跳過"
    else
        echo "   ⚠ 舊虛擬環境 Python $venv_ver 不相容，重新建立..."
        rm -rf "$INSTALL_DIR/venv"
    fi
elif [ -d "$INSTALL_DIR/venv" ]; then
    echo "   ⚠ 舊虛擬環境不完整，重新建立..."
    rm -rf "$INSTALL_DIR/venv"
fi
if [ ! -x "$INSTALL_DIR/venv/bin/python3" ]; then
    "$PY" -m venv "$INSTALL_DIR/venv"
    echo "   ✅ $INSTALL_DIR/venv"
fi

# ── Step 3/4：套件（faster-whisper，內含 PyAV 可直接解影音）──────────────────
echo ""
echo "📥 Step 3/4：安裝 faster-whisper（含影音解碼，可能 1-3 分鐘）..."
"$INSTALL_DIR/venv/bin/pip" install --upgrade pip --quiet 2>/dev/null
if ! "$INSTALL_DIR/venv/bin/pip" install -r "$SKILL_SRC/scripts/requirements.txt" --quiet; then
    echo "   ❌ 套件安裝失敗。請確認 Python 版本為 3.12，或截圖回報老師。"
    exit 1
fi
echo "   ✅ 套件安裝完成"

cp "$SKILL_SRC/scripts/audio_to_md.py" "$INSTALL_DIR/"
cp "$SKILL_SRC/scripts/requirements.txt" "$INSTALL_DIR/"
cat > "$INSTALL_DIR/audio-to-md" << 'LAUNCHER'
#!/bin/bash
DIR="$HOME/.audio-to-md"
"$DIR/venv/bin/python3" "$DIR/audio_to_md.py" "$@"
LAUNCHER
chmod +x "$INSTALL_DIR/audio-to-md"

# 拖檔啟動器放置：自適應專案 reference 目錄，不再強制放桌面
DESKTOP_CMD_SRC="$SKILL_SRC/scripts/transcribe.command"
if [ -f "$DESKTOP_CMD_SRC" ]; then
    if [ -d "$PWD/200_Reference" ]; then
        TARGET_DIR="$PWD/200_Reference/scripts"
        mkdir -p "$TARGET_DIR"
        cp "$DESKTOP_CMD_SRC" "$TARGET_DIR/轉逐字稿.command"
        chmod +x "$TARGET_DIR/轉逐字稿.command"
        echo "   ✅ 偵測到專案目錄，已建立啟動器：200_Reference/scripts/轉逐字稿.command"
    else
        if [ -d "$HOME/Desktop" ]; then
            cp "$DESKTOP_CMD_SRC" "$HOME/Desktop/轉逐字稿.command"
            chmod +x "$HOME/Desktop/轉逐字稿.command"
            echo "   ✅ 偵測非專案目錄，已在桌面建立啟動器：轉逐字稿.command"
        fi
    fi
fi

SHELL_RC=""
if [ -f "$HOME/.zshrc" ]; then SHELL_RC="$HOME/.zshrc"
elif [ -f "$HOME/.bash_profile" ]; then SHELL_RC="$HOME/.bash_profile"
elif [ -f "$HOME/.bashrc" ]; then SHELL_RC="$HOME/.bashrc"; fi
if [ -n "$SHELL_RC" ] && ! grep -q "audio-to-md" "$SHELL_RC" 2>/dev/null; then
    { echo ""; echo '# audio-to-md'; echo 'export PATH="$HOME/.audio-to-md:$PATH"'; } >> "$SHELL_RC"
fi

# ── Step 4/4：預先下載 Whisper turbo 模型（約 1.5GB）─────────────────────────
echo ""
echo "🧠 Step 4/4：下載 Whisper turbo 模型（large-v3-turbo，約 1.5GB）..."
echo "   ⏳ 這是 audio-to-md 比文字工具多的一步，第一次需要幾分鐘，請耐心等。"
echo "      （中文一律用 turbo＝品質底線，不降級成小模型）"
set +e   # 模型下載失敗（網路中斷）不應中止整個安裝；第一次使用時會自動補下載
"$INSTALL_DIR/venv/bin/python3" - "$WHISPER_MODEL" << 'PYDL'
import sys
from faster_whisper import WhisperModel
WhisperModel(sys.argv[1], device="cpu", compute_type="int8")
print("   ✅ 模型已就緒：" + sys.argv[1])
PYDL
DL_RC=$?
set -e
if [ "$DL_RC" -ne 0 ]; then
    echo "   ⚠ 模型這次沒下載完（多半是網路）——不影響安裝，第一次轉檔時會自動補下載，或重跑本安裝程式。"
fi

# ── 驗證 ────────────────────────────────────────────────────────────────────
echo ""
echo "🧪 驗證安裝..."
"$INSTALL_DIR/venv/bin/python3" -c "import faster_whisper, av, ctranslate2; print('   核心套件 OK')"
"$INSTALL_DIR/venv/bin/python3" "$INSTALL_DIR/audio_to_md.py" --help >/dev/null 2>&1 && echo "   ✅ 驗證通過！"

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                      🎉 安裝完成！                          ║"
echo "╠══════════════════════════════════════════════════════════════╣"
echo "║  在 Claude Desktop 加入技能：                                ║"
echo "║  1. Customize → Skills → + 號 → Create Skill → Upload       ║"
echo "║  2. 上傳此技能目錄即可使用                                   ║"
echo "║                                                            ║"
echo "║  最簡單用法：                                               ║"
echo "║  雙擊 200_Reference/scripts/轉逐字稿.command 啟動器         ║"
echo "║  把影音拖進去按 Enter。輸出的 md 會在原始檔旁邊。            ║"
╚══════════════════════════════════════════════════════════════╝
echo ""
echo "  拿到 .md 後拖回 Claude，說「幫我校稿並完成這份逐字稿知識庫」。"
echo "  🔧 也可手動：$INSTALL_DIR/audio-to-md ~/Desktop/錄音.m4a"
echo ""
CODEX_LAZYPACK_AUDIO_TO_MD_INSTALL_SH

# audio-to-md/scripts/install.bat
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/audio-to-md/scripts/install.bat")"
cat > "{{CODEX_HOME}}/skills/audio-to-md/scripts/install.bat" <<'CODEX_LAZYPACK_AUDIO_TO_MD_INSTALL_BAT'
@echo off
chcp 65001 >nul 2>nul
setlocal EnableExtensions EnableDelayedExpansion
rem ASCII-ONLY: a .bat with Chinese bytes mis-parses on Big5/zh-TW (DBCS) consoles.
rem PYTHONUTF8 so embedded python -c Chinese output won't UnicodeEncodeError on cp1252.
set "PYTHONUTF8=1"
set "PYTHONIOENCODING=utf-8"
title audio-to-md installer v1.2.0

echo.
echo ============================================================
echo   audio-to-md installer v1.2.0
echo   audio/video -^> transcript knowledge base (local Whisper)
echo ============================================================
echo.

set "INSTALL_DIR=%USERPROFILE%\.audio-to-md"
set "SCRIPT_DIR=%~dp0"
set "EXTRACT_DIR="
set "VENV_PY=%INSTALL_DIR%\venv\Scripts\python.exe"
set "WHISPER_MODEL=large-v3-turbo"

rem 支援自足安裝：偵測是否在技能資料夾中執行
set "SKILL_SRC=%SCRIPT_DIR%.."
if not exist "%SKILL_SRC%\SKILL.md" (
    if exist "%SCRIPT_DIR%audio_to_md.py" (
        set "SKILL_SRC=%SCRIPT_DIR%"
    ) else (
        if not exist "%SCRIPT_DIR%skill.zip" (
            echo skill.zip not found. Please extract the whole installer package first.
            pause & exit /b 1
        )
        set "EXTRACT_DIR=%TEMP%\audio-to-md-skill-%RANDOM%%RANDOM%"
        set "ATM_ZIP=%SCRIPT_DIR%skill.zip"
        set "ATM_EXTRACT=!EXTRACT_DIR!"
        echo [prep] extracting skill files...
        powershell -NoProfile -ExecutionPolicy Bypass -Command "Expand-Archive -LiteralPath $env:ATM_ZIP -DestinationPath $env:ATM_EXTRACT -Force" >nul
        if errorlevel 1 ( echo Failed to extract skill.zip. Extract the whole package first. & pause & exit /b 1 )
        set "SKILL_SRC=!EXTRACT_DIR!\skill"
    )
)
if not exist "%SKILL_SRC%\scripts\requirements.txt" (
    echo Not found: %SKILL_SRC%\scripts\requirements.txt . Package incomplete.
    pause & exit /b 1
)

echo [Step 1/4] Checking Python...
set "PY_CMD="
set "PY_VER="
call :try_python py -3.12
call :try_python py -3.11
call :try_python py -3.10
call :try_python py -3.9
call :try_python py -3.14
call :try_python py -3.13
call :try_python py -3
call :try_python python
call :try_python python3
if "%PY_CMD%"=="" (
    echo No compatible Python found. Install Python 3.12 from https://www.python.org/downloads/
    echo Tick "Add Python to PATH", reopen this window, then run again.
    start https://www.python.org/downloads/
    pause & exit /b 1
)
echo    Found Python %PY_VER%: %PY_CMD%

echo.
echo [Step 2/4] Creating virtual environment...
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"
if exist "%VENV_PY%" (
    "%VENV_PY%" -c "import sys; raise SystemExit(0 if (3,9) <= sys.version_info[:2] <= (3,14) else 1)" >nul 2>nul
    if errorlevel 1 ( echo    old env invalid, rebuilding... & rmdir /S /Q "%INSTALL_DIR%\venv" >nul 2>nul ) else ( echo    exists, skip )
)
if not exist "%VENV_PY%" (
    %PY_CMD% -m venv "%INSTALL_DIR%\venv"
    if errorlevel 1 ( echo    venv creation failed, screenshot for teacher. & pause & exit /b 1 )
)

echo.
echo [Step 3/4] Installing faster-whisper (may take 1-3 min)...
"%VENV_PY%" -m pip install --upgrade pip --quiet
"%VENV_PY%" -m pip install -r "%SKILL_SRC%\scripts\requirements.txt" --quiet
if errorlevel 1 ( echo    install failed, screenshot for teacher. & pause & exit /b 1 )
echo    packages installed

copy /Y "%SKILL_SRC%\scripts\audio_to_md.py" "%INSTALL_DIR%\" >nul
if errorlevel 1 ( echo    copy audio_to_md.py failed, screenshot for teacher. & pause & exit /b 1 )
copy /Y "%SKILL_SRC%\scripts\requirements.txt" "%INSTALL_DIR%\" >nul
if errorlevel 1 ( echo    copy requirements.txt failed, screenshot for teacher. & pause & exit /b 1 )
if not exist "%INSTALL_DIR%\audio_to_md.py" ( echo    installed audio_to_md.py missing, screenshot for teacher. & pause & exit /b 1 )
(
echo @echo off
echo "%VENV_PY%" "%INSTALL_DIR%\audio_to_md.py" %%*
) > "%INSTALL_DIR%\audio-to-md.bat"

rem -- drag-and-drop launcher + reference scripts copy --
set "DND_OK="
set "CP_RC=2"
if exist "%SKILL_SRC%\scripts\transcribe.bat" (
    set "CP_RC=0"
    copy /Y "%SKILL_SRC%\scripts\transcribe.bat" "%INSTALL_DIR%\" >nul
    if errorlevel 1 set "CP_RC=1"
)
if "%CP_RC%"=="2" echo    scripts\transcribe.bat missing - skipping drag launcher; audio-to-md.bat still works
if "%CP_RC%"=="1" echo    WARN: copy drag launcher failed - antivirus or permission or sync; audio-to-md.bat still works.
if "%CP_RC%"=="0" if exist "%INSTALL_DIR%\transcribe.bat" set "DND_OK=1"

if defined DND_OK (
    if exist "%CD%\200_Reference" (
        if not exist "%CD%\200_Reference\scripts" mkdir "%CD%\200_Reference\scripts"
        copy /Y "%INSTALL_DIR%\transcribe.bat" "%CD%\200_Reference\scripts\轉逐字稿.bat" >nul
        echo    Found project workspace. Placed drag launcher at: 200_Reference\scripts\轉逐字稿.bat
    ) else (
        if exist "%SKILL_SRC%\scripts\place_desktop_launcher.ps1" (
            echo    placing desktop drag launcher...
            powershell -NoProfile -ExecutionPolicy Bypass -File "%SKILL_SRC%\scripts\place_desktop_launcher.ps1"
        )
    )
)

echo.
echo [Step 4/4] Downloading Whisper turbo model (large-v3-turbo, ~1.5GB)...
echo    First time takes a few minutes, please wait.
"%VENV_PY%" -c "from faster_whisper import WhisperModel; WhisperModel('%WHISPER_MODEL%', device='cpu', compute_type='int8'); print('   model ready: %WHISPER_MODEL%')"
if errorlevel 1 ( echo    model download failed - network issue? will auto-download on first use. )

echo.
echo Verifying...
"%VENV_PY%" -c "import faster_whisper, av, ctranslate2; print('   core packages OK')"
if errorlevel 1 ( echo    package import failed, screenshot for teacher. & pause & exit /b 1 )
"%VENV_PY%" "%INSTALL_DIR%\audio_to_md.py" --help >nul
if errorlevel 1 ( echo    audio_to_md.py verify failed, screenshot for teacher. & pause & exit /b 1 )
if defined EXTRACT_DIR rmdir /S /Q "%EXTRACT_DIR%" >nul 2>nul

echo    Verified!
echo.
echo ============================================================
echo   Installation complete!
echo ============================================================
echo.
echo This install has TWO parts (both needed):
echo.
echo [Part 1 - local engine] Done (this is what install.bat did).
echo    Easiest use: drag a video/audio file onto the launcher.
echo    If installed inside a project, it's at: 200_Reference\scripts\轉逐字稿.bat
echo    Otherwise, check Desktop for the bat launcher.
echo.
echo [Part 2 - Claude skill] Add it in Claude Desktop:
echo    1. Customize - Skills - + - Create Skill - Upload a skill
echo    2. upload this skill directory
echo    3. confirm "audio-to-md" appears in Skills
echo.
pause
exit /b 0

:try_python
if defined PY_CMD exit /b 0
for /f "usebackq tokens=1,2 delims=|" %%v in (`%* -c "import sys; exe=sys.executable; ok=(3,9) <= sys.version_info[:2] <= (3,14) and 'WindowsApps' not in exe; print(f'{sys.version_info.major}.{sys.version_info.minor}|{exe}' if ok else '')" 2^>nul`) do (
    set "PY_CMD=%*"
    set "PY_VER=%%v"
)
exit /b 0
CODEX_LAZYPACK_AUDIO_TO_MD_INSTALL_BAT

# audio-to-md/scripts/transcribe.command
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/audio-to-md/scripts/transcribe.command")"
cat > "{{CODEX_HOME}}/skills/audio-to-md/scripts/transcribe.command" <<'CODEX_LAZYPACK_AUDIO_TO_MD_TRANSCRIBE_COMMAND'
#!/bin/bash
# audio-to-md｜雙擊我，把影片/錄音檔拖進視窗按 Enter，就會轉成逐字稿知識庫。
DIR="$HOME/.audio-to-md"

if [ ! -x "$DIR/venv/bin/python3" ] || [ ! -f "$DIR/audio_to_md.py" ]; then
    echo "找不到本機引擎（$DIR）。"
    echo "請先跑安裝包的 install.sh 安裝一次，再用這個檔。"
    read -r -p "按 Enter 關閉..." _
    exit 1
fi

echo "============================================================"
echo " audio-to-md 拖檔轉逐字稿"
echo "============================================================"
echo "把影片或錄音檔『拖進這個視窗』，然後按 Enter："
read -r -e f

# 去掉拖檔可能帶上的外層引號；否則把反斜線跳脫（空格/括號/&/'…）還原
f="${f# }"; f="${f% }"
if [ "${f#\"}" != "$f" ] && [ "${f%\"}" != "$f" ]; then
    f="${f#\"}"; f="${f%\"}"
elif [ "${f#\'}" != "$f" ] && [ "${f%\'}" != "$f" ]; then
    f="${f#\'}"; f="${f%\'}"
else
    # Terminal 拖檔會把空格、括號、&、單引號等用反斜線跳脫 → 一律還原
    f="$(printf '%s' "$f" | sed -E 's/\\(.)/\1/g')"
fi

if [ -z "$f" ] || [ ! -f "$f" ]; then
    echo "沒有收到有效的檔案路徑。"
    read -r -p "按 Enter 關閉..." _
    exit 1
fi

outdir="$(dirname "$f")"
echo ""
echo "轉錄中：$(basename "$f")"
echo "（第一次會下載語音模型約 1.5GB，需幾分鐘，請耐心等；之後就快）"
"$DIR/venv/bin/python3" "$DIR/audio_to_md.py" "$f" -o "$outdir"
rc=$?
echo ""
if [ "$rc" -eq 0 ]; then
    open "$outdir" 2>/dev/null
    echo "✅ 完成。輸出的『*_逐字稿知識庫.md』就在原始檔旁邊。"
    echo "下一步：把那個 .md 拖回 Claude，說"
    echo "「幫我校稿並完成這份逐字稿知識庫（簡繁/錯字/斷句＋段落摘要＋重點）」"
else
    echo "⚠ 轉檔沒成功，請截圖這個視窗回報老師。"
fi
echo ""
read -r -p "按 Enter 關閉..." _
CODEX_LAZYPACK_AUDIO_TO_MD_TRANSCRIBE_COMMAND

# audio-to-md/scripts/transcribe.bat
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/audio-to-md/scripts/transcribe.bat")"
cat > "{{CODEX_HOME}}/skills/audio-to-md/scripts/transcribe.bat" <<'CODEX_LAZYPACK_AUDIO_TO_MD_TRANSCRIBE_BAT'
@echo off
chcp 65001 >nul 2>nul
setlocal EnableExtensions
title Drag-to-Transcribe (audio-to-md)

rem ASCII-ONLY on purpose. A .bat that contains Chinese bytes mis-parses on Big5/zh-TW
rem (DBCS codepage) consoles: cmd reads the file under the system codepage and the
rem multibyte sequences desync line parsing (setlocal -> "tlocal", echo -> "ho", etc).
rem Rich Chinese guidance is printed by audio_to_md.py (UTF-8 safe). chcp 65001 here is
rem only so Python's Chinese OUTPUT displays correctly; this .bat itself stays ASCII.

set "DIR=%USERPROFILE%\.audio-to-md"
set "PY=%DIR%\venv\Scripts\python.exe"
set "LOG=%DIR%\last_run.log"
set "FAIL=0"
set "DONE=0"
>"%LOG%" echo [start] %DATE% %TIME% first="%~1" 2>nul

if not exist "%PY%" (
    call :logf "[error] engine-missing" "%PY%"
    echo.
    echo Engine not found at: %DIR%
    echo Please run install.bat once first, then use this launcher.
    echo.
    pause
    exit /b 1
)

if "%~1"=="" (
    >>"%LOG%" echo [info] no file dropped 2>nul
    echo.
    echo HOW TO USE: drag a video/audio file ONTO this file and release.
    echo Use drag-and-drop. Double-click does NOT pass a file.
    echo.
    pause
    exit /b 0
)

:loop
if "%~1"=="" goto done
call :logf "[file]" "%~nx1"
echo.
echo ============================================================
call :show "Transcribing" "%~nx1"
echo (First run downloads the speech model ~1.5GB; please wait.)
echo ============================================================
rem Strip trailing backslash from %~dp1: otherwise -o "C:\folder\" makes \" an escaped
rem quote and Python gets an invalid path (Windows C-runtime quoting trap).
set "ODIR=%~dp1"
if "%ODIR:~-1%"=="\" set "ODIR=%ODIR:~0,-1%"
"%PY%" "%DIR%\audio_to_md.py" "%~1" -o "%ODIR%"
if errorlevel 1 (
    call :logf "[fail]" "%~nx1"
    call :show "[X] FAILED" "%~nx1"
    set /a FAIL+=1
) else (
    call :logf "[ok]" "%~nx1"
    call :show "[OK] done" "%~nx1"
    set /a DONE+=1
    start "" "%ODIR%"
)
shift
goto loop

:done
>>"%LOG%" echo [done] DONE=%DONE% FAIL=%FAIL% 2>nul
echo.
echo ------------------------------------------------------------
if %FAIL% gtr 0 (
    echo Done %DONE%, failed %FAIL%. Please screenshot this window for your teacher.
    echo Details: %LOG%
) else (
    echo All done ^(%DONE% file^(s^)^).
)
echo The transcript .md is saved NEXT TO your original file.
echo Next step: drag that .md back into Claude to proofread/summarize.
echo ------------------------------------------------------------
echo.
pause
exit /b 0

rem -- safe display of "label: name" (name may contain & ^| ^< ^>) --
:show
setlocal EnableDelayedExpansion
set "label=%~1"
set "name=%~2"
echo !label!: !name!
endlocal
goto :eof

rem -- safe log append (caller quotes the name; safe even inside () blocks / names with ) ) --
:logf
>>"%LOG%" echo %~1 %~2 2>nul
goto :eof
CODEX_LAZYPACK_AUDIO_TO_MD_TRANSCRIBE_BAT

# audio-to-md/scripts/place_desktop_launcher.ps1
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/audio-to-md/scripts/place_desktop_launcher.ps1")"
cat > "{{CODEX_HOME}}/skills/audio-to-md/scripts/place_desktop_launcher.ps1" <<'CODEX_LAZYPACK_AUDIO_TO_MD_PLACE_DESKTOP_LAUNCHER_PS1'
# 把拖檔啟動器「直接放到桌面」成一個可拖放的 .bat（不用捷徑 .lnk）。
# 為什麼不用捷徑：把檔案拖到「.bat 本體」上，Windows 才會可靠地把它當 %1 參數傳入；
# 拖到「指向 .bat 的捷徑」在實機上不一定會傳參數（學員回報：視窗一閃就關、沒輸出）。
# 本檔以 UTF-8 (含 BOM) 儲存，讓 Windows PowerShell 5.1 也能正確讀中文/emoji。
# 用 GetFolderPath('Desktop') 取正確桌面（含 OneDrive 重新導向）；Copy-Item 為 Unicode-safe。
$ErrorActionPreference = 'Stop'
$installDir = Join-Path $env:USERPROFILE '.audio-to-md'
$src        = Join-Path $installDir 'transcribe.bat'
try {
    if (-not (Test-Path $src)) {
        Write-Host "   找不到 $src，略過放桌面啟動器。"
        exit 0
    }
    $desktop = [Environment]::GetFolderPath('Desktop')
    if ([string]::IsNullOrEmpty($desktop)) { $desktop = Join-Path $env:USERPROFILE 'Desktop' }
    # 清掉舊版留下的壞捷徑(.lnk)：否則桌面會同時有 .lnk 和 .bat，隱藏副檔名時看起來一樣、學員會點到壞的那個。
    $oldLnk = Join-Path $desktop '🎤 拖檔轉逐字稿.lnk'
    if (Test-Path -LiteralPath $oldLnk) { Remove-Item -LiteralPath $oldLnk -Force -ErrorAction SilentlyContinue; Write-Host "   （已移除舊版桌面捷徑 .lnk）" }
    $dest = Join-Path $desktop '🎤 拖檔轉逐字稿.bat'
    Copy-Item -LiteralPath $src -Destination $dest -Force
    Write-Host "   ✅ 桌面已放可拖放啟動器：🎤 拖檔轉逐字稿.bat"
} catch {
    Write-Host "   （桌面啟動器沒放成功，不影響使用：$($_.Exception.Message)）"
    Write-Host "   你仍可用：$src（把檔案拖上去）"
    exit 0
}
CODEX_LAZYPACK_AUDIO_TO_MD_PLACE_DESKTOP_LAUNCHER_PS1

echo "audio-to-md skill installed at {{CODEX_HOME}}/skills/audio-to-md"
````

<!-- END EMBEDDED_SKILLS -->

## 驗證

```bash
test -f "{{CODEX_HOME}}/skills/audio-to-md/SKILL.md"
test -f "{{CODEX_HOME}}/skills/audio-to-md/references/usage-guide.md"
test -f "{{CODEX_HOME}}/skills/audio-to-md/references/execution-notes.md"
test -f "{{CODEX_HOME}}/skills/audio-to-md/scripts/audio_to_md.py"
test -f "{{CODEX_HOME}}/skills/audio-to-md/scripts/audio_to_md_groq.py"
python3 -m py_compile "{{CODEX_HOME}}/skills/audio-to-md/scripts/audio_to_md_groq.py"
```

本機引擎驗證：

```bash
~/.audio-to-md/audio-to-md --help
```
