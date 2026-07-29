# Project Handoff

## Current state

- 共用 `video-tool-evaluation` 已完成 53-route catalog、validator 與 16:9 talking-head 完整範例；影片規劃會評估所有 route，但只執行被選取或備援的工具。
- `video-processing-automation`、`video-creation-automation`、`video-spec-builder`、HyperFrames 相關 Skills 與目前安裝的 plugin adapters 已接入同一個 `TOOL_EVALUATION.md` planning gate。
- STT 固定為 Groq Whisper 優先、faster-whisper 正式備援、whisper.cpp 快速預覽、MacWhisper 最後選項；SenseVoice 只作補充分析。
- TTS 先確認女聲或男聲；女聲為 ElevenLabs Anna Su → Edge HsiaoChen → macOS `say`，男聲跳過 ElevenLabs，使用 Edge YunJhe → macOS `say`；Kokoro 已排除。
- LazyPack Items 26／27／29／30 都各自內嵌完整 `video-tool-evaluation`，Items 33／37 也保留獨立安裝；Item 34 補齊 FFmpeg Full、ImageMagick、Auto-Editor 與 provider packages。
- TTS 比較音檔留在本機 `100_Todo/projects/tts-comparison-20260729/`，不納入 public repo。

## Next action

- 下次執行任何多步驟影片任務時，先由對應影片 Skill 產生並驗證 `TOOL_EVALUATION.md`，再進入剪輯、雲端上傳、旁白或 HyperFrames 實作。
- 新電腦可只安裝所需的 Item 26、27、29 或 30；任一項都會帶入完整 evaluator，不要求同時安裝其他影片 LazyPack。

## Blockers

- 無。ElevenLabs Anna Su 是否能由 API 生成仍受帳號方案與 credits 限制；不可用時會依設定自動切換 Edge HsiaoChen。

## Last verified

- 2026-07-30，Codex App：12 個受影響的共用 Skills 通過 `quick_validate.py`；三 Agent compatibility audit 掃描 582 個檔案、0 findings。
- 2026-07-30，Codex App：53/53 evaluator self-test、完整範例與缺項反向測試通過。
- 2026-07-30，Codex App：LazyPack Items 26／27／29／30／33／37 均在隔離目錄完成獨立安裝與 Skill 驗證。
- 2026-07-30，Codex App：共用 Python runtime imports、FFmpeg／ffprobe／Auto-Editor／ImageMagick、Whisper／SenseVoice／MacWhisper wrappers 與三 Agent bridge 驗證通過。
