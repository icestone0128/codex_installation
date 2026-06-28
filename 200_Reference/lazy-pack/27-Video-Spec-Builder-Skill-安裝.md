# 27-Video-Spec-Builder-Skill-安裝

> 版本：2026-06-01 Codex App 版
> 用途：安裝 `video-spec-builder` 全域 skill，讓 Codex 像影片編導一樣追問需求，產出可交給 HyperFrames 的 `video-spec.md` 分鏡腳本。
> 成品：下載者可直接使用本文文末「內建 Skill 完整安裝內容」建立 `{{CODEX_HOME}}/skills/video-spec-builder/`。

## 來源與歷史紀錄

- 初次同步日期：2026-06-01。
- 來源 repo：https://github.com/feicaiclub/video-spec-builder
- 來源 commit：`9e73275` / `9e73275b35e827b8f7af4bca900790909d86e63e`。
- 授權：MIT。
- 內嵌檔案數：33 個。
- Codex 全域 skill：`{{CODEX_HOME}}/skills/video-spec-builder/SKILL.md`。

## Codex 相容化調整

- 保留來源的追問工作流、模板、references、Spec Mono theme 與 Full Code 範例。
- 已移除 slash-command、非 Codex agent delegation、non-Codex path / file name / frontmatter 相關敘述。
- 所有可攜路徑一律使用 `{{CODEX_HOME}}/skills/video-spec-builder`。
- 不自動安裝 HyperFrames、Node.js、FFmpeg 或 npm package；實際 render 仍由 HyperFrames skill / CLI 處理。

## 本機補充：照片紀念影片 Spec 規則

2026-06-14 依實際畢業紀念影片製作流程，已在全域 `video-spec-builder/SKILL.md` 補入：

- 家庭、畢業、典禮、旅行等照片為主的影片，要先列總分鏡，再讓使用者逐鏡指定或確認照片。
- 若使用者要求先確認，正式生成前要輸出完整預覽圖，包含實際取景、文字框、順序與代表性轉場狀態。
- Spec 需記錄取景優先級：人臉、頭頂空間、上半身優先；花束、證書、物件與場景資訊盡量保留。
- 使用者指定每張照片固定停留秒數時，重新計算總長，不要偷改單張秒數來貼近舊總長。
- 文案不可直接使用資料夾名稱，需依照片內容與敘事脈絡重寫；同類連續照片保持文字框樣式與語氣一致。
- 若插入原始影片或現場人聲，Spec 需記錄音樂起點、ducking 區間、目標音量 dB、淡入淡出時間與是否只重混音軌。

## 安裝內容

- `SKILL.md`：video-spec-builder 主要工作流。
- `references/`：0-1 模式、迭代模式、追問題庫、分鏡拆解、組件目錄、節奏規則、spec 規則與對話風格。
- `templates/video-spec-template.md`：`video-spec.md` 輸出模板。
- `examples/video-spec-spacex.md`：完整範例。
- `spec-mono/`：Spec Mono 自訂 HyperFrames theme。
- `Full Code/`：來源 repo 附帶的完整實作參考碼。

## 前置條件

- Codex App 可讀取 `{{CODEX_HOME}}/skills`。
- 建議先安裝 LazyPack Item 26 的 HyperFrames skill suite；`video-spec-builder` 是上游分鏡規格產生器，HyperFrames 是下游渲染器。
- 若要實際 render MP4，HyperFrames 端仍需要 Node.js 22+ 與 FFmpeg。

## 安裝方式

1. 打開本文文末「內建 Skill 完整安裝內容」。
2. 把整段安裝腳本複製到自己的環境執行。
3. 執行前先把 `{{CODEX_HOME}}` 替換成自己的 Codex 設定資料夾，例如 `{{HOME}}/.codex`。
4. 安裝後開新 Codex 對話或重啟 Codex App，讓新的全域 skill metadata 被重新載入。

## 使用方式

- 「我想做一支產品介紹影片」
- 「幫我把這個想法拆成 video-spec.md」
- 「幫我改 video-spec 的第三個鏡頭」
- 「這支短影音節奏太慢，幫我重拆分鏡」
- 「我要做一支可以交給 HyperFrames render 的影片腳本」

## 驗證

```bash
test -f "{{CODEX_HOME}}/skills/video-spec-builder/SKILL.md" && echo "video-spec-builder SKILL.md ok"
test -f "{{CODEX_HOME}}/skills/video-spec-builder/templates/video-spec-template.md" && echo "video-spec-builder template ok"
test -f "{{CODEX_HOME}}/skills/video-spec-builder/references/question-bank.md" && echo "video-spec-builder references ok"
test -f "{{CODEX_HOME}}/skills/video-spec-builder/spec-mono/design.md" && echo "Spec Mono theme ok"
```

## 最終檢查清單

- [ ] `{{CODEX_HOME}}/skills/video-spec-builder/SKILL.md` 存在。
- [ ] `templates/video-spec-template.md` 存在。
- [ ] `references/` 內 8 個主要參考檔存在。
- [ ] `spec-mono/design.md` 與 `spec-mono/tokens.css` 存在。
- [ ] 開新 Codex 對話後，說「我想做一支影片」會觸發 video-spec-builder。
- [ ] 若要接著 render，HyperFrames skill suite 也已安裝。

## 官方參考

- [video-spec-builder GitHub](https://github.com/feicaiclub/video-spec-builder)

<!-- BEGIN EMBEDDED_SKILLS -->

## 內建 Skill 完整安裝內容

本節會安裝：`video-spec-builder`。

使用方式：把下方整段安裝腳本複製到自己的環境執行。執行前請先把 `{{CODEX_HOME}}` 替換成自己的 Codex 設定資料夾，例如 `{{HOME}}/.codex`。

````bash
set -e

decode_base64() {
  if command -v base64 >/dev/null 2>&1; then
    base64 --decode 2>/dev/null || base64 -D
  else
    python3 -c 'import base64,sys; sys.stdout.buffer.write(base64.b64decode(sys.stdin.buffer.read()))'
  fi
}

# ---- video-spec-builder ----
mkdir -p "{{CODEX_HOME}}/skills/video-spec-builder"
# video-spec-builder/.gitignore
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/video-spec-builder/.gitignore")"
cat > "{{CODEX_HOME}}/skills/video-spec-builder/.gitignore" <<'CODEX_LAZYPACK_0C92DB9EB3BAD4C662B0CE059E6FBFE33E1C9F5B'
.DS_Store
node_modules/
skills-lock.json
.agents/
CODEX_LAZYPACK_0C92DB9EB3BAD4C662B0CE059E6FBFE33E1C9F5B

# video-spec-builder/Full Code/app.jsx
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/video-spec-builder/Full Code/app.jsx")"
cat > "{{CODEX_HOME}}/skills/video-spec-builder/Full Code/app.jsx" <<'CODEX_LAZYPACK_DBAD1E0B71238365867C3827310880D3C7F94DEF'
/* ================================================================
   app.jsx — composition root
   ================================================================ */

const { useState, useEffect, useRef } = React;

const SECTIONS = [
  { id: 'foundation', num: '00', name: '视觉地基', Comp: () => <FoundationSection /> },
  { id: 'aroll',      num: '01', name: 'A-roll',  Comp: () => <ARollSection /> },
  { id: 'structure',  num: '02', name: '结构图',  Comp: () => <StructureSection /> },
  { id: 'ui',         num: '03', name: '仿真 UI', Comp: () => <FakeUISection /> },
  { id: 'hero',       num: '04', name: '重锤',    Comp: () => <HeroSection /> },
  { id: 'abstract',   num: '05', name: '抽象兜底', Comp: () => <AbstractSection /> },
  { id: 'charts',     num: '06', name: '数据图表', Comp: () => <ChartsSection /> },
  { id: 'flows',      num: '07', name: '流程图',   Comp: () => <FlowsSection /> },
  { id: 'structures2',num: '08', name: '关系结构', Comp: () => <Structures2Section /> },
  { id: 'thinking',   num: '09', name: '结构化思考', Comp: () => <ThinkingSection /> },
  { id: 'illustrations', num: '10', name: '插画',  Comp: () => <IllustrationsSection /> },
];

/* ---------- Tweaks defaults ---------- */
const TWEAK_DEFAULTS = /*EDITMODE-BEGIN*/{
  "accent": "#FFFFFF",
  "density": "comfortable",
  "showDeco": true
}/*EDITMODE-END*/;

/* ---------- side nav ---------- */
function Nav({ active }) {
  return (
    <nav className="nav">
      {SECTIONS.map(s => (
        <a key={s.id} href={`#${s.id}`}
           className={`nav__item ${active === s.id ? 'is-active' : ''}`}>
          {s.num} · <span className="cn">{s.name}</span>
        </a>
      ))}
    </nav>
  );
}

/* ---------- hero ---------- */
function Hero() {
  return (
    <header className="hero">
      <div className="hero__left">
        <div className="hero__brand">VIDEO / COMPONENT LIBRARY / v2.0 — SPACE × GROK × X</div>
        <h1 className="hero__title">
          A SYSTEM<br/>FOR <span className="hero__accent">VIDEO</span><span style={{ color: 'var(--accent)' }}>.</span>
        </h1>
        <div className="hero__sub cn">
          为 AI 教程视频量身打造 · <span style={{ color: 'var(--accent)' }}>极简 / 几何 / 单色</span> · 上镜可读 · 单 accent 可调
        </div>
      </div>
      <div className="hero__meta">
        <div><span>FRAME</span><b>3840 × 2160</b></div>
        <div><span>RATIO</span><b>16 / 9</b></div>
        <div><span>STACK</span><b>SPACE GROTESK · BARLOW · MONO</b></div>
        <div><span>WEIGHTS</span><b>400 / 600 / 700</b></div>
        <div><span>BUILD</span><b>2026.05 · v2</b></div>
        <div><span>T-MINUS</span><b style={{ color: 'var(--accent)' }}>LIVE</b></div>
      </div>
    </header>
  );
}

/* ---------- section frame ---------- */
function Section({ id, num, title, desc, children }) {
  return (
    <section className="section" id={id} data-screen-label={`${num} ${title}`}>
      <div className="section__num"><span>SECTION {num}</span></div>
      <h2 className="section__title cn">{title}</h2>
      <p className="section__desc cn" dangerouslySetInnerHTML={{ __html: desc }} />
      {children}
    </section>
  );
}

function SubSec({ name, tag, children }) {
  return (
    <div className="subsec">
      <div className="subsec__head">
        <div className="subsec__name cn">{name}</div>
        <div className="subsec__tag">{tag}</div>
      </div>
      {children}
    </div>
  );
}

/* ---------- params table ---------- */
function Params({ rows }) {
  return (
    <div className="params">
      {rows.map((r, i) => (
        <div className="param" key={i}>
          <div className="param__k">{r.k}</div>
          <div className="param__v" dangerouslySetInnerHTML={{ __html: r.v }} />
        </div>
      ))}
    </div>
  );
}

/* ---------- stage ---------- */
function Stage({ pattern = 'plain', label, labelR, labelB, labelBR, children, style }) {
  return (
    <div className={`stage ${pattern === 'dot' ? 'stage--dotgrid' : pattern === 'graph' ? 'stage--graph' : ''}`} style={style}>
      {label && <div className="stage__corner">{label}</div>}
      {labelR && <div className="stage__corner stage__corner--r">{labelR}</div>}
      {labelB && <div className="stage__corner stage__corner--b">{labelB}</div>}
      {labelBR && <div className="stage__corner stage__corner--br">{labelBR}</div>}
      {children}
    </div>
  );
}

/* ---------- App ---------- */
function App() {
  const [t, setTweak] = useTweaks(TWEAK_DEFAULTS);
  const [active, setActive] = useState('foundation');

  // apply accent
  useEffect(() => {
    document.documentElement.style.setProperty('--accent', t.accent);
  }, [t.accent]);

  // active section observer
  useEffect(() => {
    const obs = new IntersectionObserver((entries) => {
      entries.forEach(e => {
        if (e.isIntersecting) setActive(e.target.id);
      });
    }, { rootMargin: '-40% 0px -50% 0px' });
    SECTIONS.forEach(s => {
      const el = document.getElementById(s.id);
      if (el) obs.observe(el);
    });
    return () => obs.disconnect();
  }, []);

  return (
    <div className="shell">
      <Nav active={active} />
      <Hero />
      {SECTIONS.map(s => (
        <s.Comp key={s.id} />
      ))}
      <footer className="outro">
        <div className="outro__copy">
          PURE BLACK.<br/>
          PURE GEOMETRY.<br/>
          <span style={{ color: 'var(--accent)' }}>PURE SIGNAL.</span>
        </div>
        <div className="outro__meta">
          <div>v2 · 2026.05</div>
          <div>FOR YOUTUBE · 4K · 16:9</div>
          <div style={{ marginTop: 14, color: 'var(--accent)' }}>END / TRANSMISSION</div>
        </div>
      </footer>

      <TweaksPanel title="Tweaks">
        <TweakSection title="Accent">
          <TweakColor
            label="主色"
            value={t.accent}
            onChange={(v) => setTweak('accent', v)}
            options={['#FFFFFF', '#FF6B3D', '#1D9BF0', '#E8C547', '#00E0FF', '#FF3333']}
          />
        </TweakSection>
        <TweakSection title="Layout">
          <TweakToggle
            label="装饰元素（角标·tick·grid）"
            value={t.showDeco}
            onChange={(v) => setTweak('showDeco', v)}
          />
        </TweakSection>
      </TweaksPanel>
    </div>
  );
}

/* expose for inter-script use */
Object.assign(window, { Section, SubSec, Params, Stage });

ReactDOM.createRoot(document.getElementById('root')).render(<App />);
CODEX_LAZYPACK_DBAD1E0B71238365867C3827310880D3C7F94DEF

# video-spec-builder/Full Code/sections/aroll.jsx
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/video-spec-builder/Full Code/sections/aroll.jsx")"
cat > "{{CODEX_HOME}}/skills/video-spec-builder/Full Code/sections/aroll.jsx" <<'CODEX_LAZYPACK_FAA6EC17DADCD4B3D7464BA419875D38D9241790'
/* ================================================================
   sections/aroll.jsx — 01 · A-roll 出镜讲解（v3.1 编辑感升级）
   "克制" 版：hairline + 字号悬崖 + 0 阴影 + ornament 而非装饰
   ================================================================ */

function ARollSection() {
  return (
    <Section
      id="aroll"
      num="01"
      title="A-roll · 出镜讲解"
      desc="出镜时叠在画面上的三大件：<b>字幕高亮</b>、<b>关键词贴纸</b>、<b>概念卡</b>。<em>每个组件只做一件事</em> —— 不堆装饰、不加阴影、不层叠卡片。"
    >
      <SubtitleHighlight />
      <KeywordSticker />
      <ConceptCard />
    </Section>
  );
}

/* ---------- 字幕高亮 ---------- */
function SubtitleHighlight() {
  const tokens = ['让我们聊聊', '上下文', '工程', '不是', '提示词', '魔法'];
  const highlighted = [1, 2, 4];
  const [active, setActive] = React.useState(2);
  React.useEffect(() => {
    const id = setInterval(() => setActive(a => (a + 1) % tokens.length), 900);
    return () => clearInterval(id);
  }, []);

  return (
    <SubSec name="A · 字幕高亮 · Subtitle Highlight" tag="SPOKEN-WORD CAPTIONS">
      <Stage pattern="dot" label="● A-ROLL · LIVE" labelR="01.A">
        {/* 左上：讲者标签 */}
        <div style={{ position: 'absolute', top: '8%', left: '6%', display: 'flex', alignItems: 'center', gap: 10 }}>
          <span className="dot-pulse" />
          <span className="mono" style={{ fontSize: 11, letterSpacing: '0.2em', color: 'var(--fg-3)' }}>SPEAKER · LIVE</span>
        </div>
        {/* 右上：时间码 */}
        <div className="mono" style={{ position: 'absolute', top: '8%', right: '6%', fontSize: 11, letterSpacing: '0.2em', color: 'var(--fg-3)' }}>
          00:14:22 · CC ON
        </div>

        {/* 字幕主体 */}
        <div style={{
          position: 'absolute', left: '8%', right: '8%', bottom: '14%',
          display: 'flex', flexWrap: 'wrap', gap: '0 18px',
          fontSize: 'clamp(28px, 4.4vw, 56px)', fontWeight: 800,
          letterSpacing: '-0.018em', lineHeight: 1.1,
        }}>
          {tokens.map((tk, i) => {
            const isHot = highlighted.includes(i) && i === active;
            const isPast = highlighted.includes(i) && i < active;
            return (
              <span key={i} className="cn" style={{
                color: isHot ? 'var(--accent)' : isPast ? 'var(--fg)' : 'var(--fg-3)',
                position: 'relative',
                transition: 'color 280ms var(--ease-out)',
              }}>
                {tk}
                {isHot && (
                  <span style={{
                    position: 'absolute', left: 0, right: 0, bottom: '-12px',
                    height: 3, background: 'var(--accent)',
                    animation: 'lineIn 280ms var(--ease-out) forwards',
                    transformOrigin: 'left',
                  }} />
                )}
              </span>
            );
          })}
        </div>

        {/* 底部 hairline */}
        <div style={{ position: 'absolute', bottom: '8%', left: '8%', right: '8%', display: 'flex', alignItems: 'center', gap: 12 }}>
          <span className="mono" style={{ fontSize: 10, letterSpacing: '0.2em', color: 'var(--fg-3)' }}>EN / CN</span>
          <span style={{ flex: 1, height: 1, background: 'var(--line)' }} />
          <span className="mono" style={{ fontSize: 10, letterSpacing: '0.2em', color: 'var(--fg-3)' }}>3 / 6 WORDS HOT</span>
        </div>

        <style>{`@keyframes lineIn { from { transform: scaleX(0) } to { transform: scaleX(1) } }`}</style>
      </Stage>

      <Params rows={[
        { k: 'FONT',     v: '思源黑体 800 · clamp 28-56px' },
        { k: 'COLOR',    v: '默认 fg-3 · 念到 accent · 念过 fg' },
        { k: 'ACCENT',   v: '<b>仅 3px 底线</b> · 无底色块 · scaleX in' },
        { k: 'CHROME',   v: '左讲者 · 右时码 · 底 hairline + 计数' },
        { k: 'POSITION', v: '下 14% · 左右 8% padding' },
      ]} />
    </SubSec>
  );
}

/* ---------- 关键词贴纸 ---------- */
function KeywordSticker() {
  const items = [
    { txt: 'Context',          en: true,  pos: { top: '20%', left: '8%' },   tilt: -1.5 },
    { txt: '不是魔法',          en: false, pos: { top: '34%', right: '12%' }, tilt: 1 },
    { txt: '✱ Engineering',    en: true,  pos: { top: '62%', left: '14%' },  tilt: -0.5 },
  ];
  const [shown, setShown] = React.useState([0]);
  React.useEffect(() => {
    const id = setInterval(() => {
      setShown(s => {
        const next = (s[s.length - 1] + 1) % items.length;
        if (s.length >= items.length) return [next];
        return [...s, next];
      });
    }, 1100);
    return () => clearInterval(id);
  }, []);

  return (
    <SubSec name="B · 关键词贴纸 · Keyword Sticker" tag="POP-IN LABELS">
      <Stage pattern="dot" label="● A-ROLL · STICKER" labelR="01.B">
        {/* 左上 eyebrow */}
        <div className="mono" style={{ position: 'absolute', top: '8%', left: '6%', fontSize: 11, letterSpacing: '0.2em', color: 'var(--accent)' }}>● KEYWORDS · 3</div>

        {items.map((it, i) => {
          if (!shown.includes(i)) return null;
          const isLast = shown[shown.length - 1] === i;
          return (
            <div key={i} className={it.en ? '' : 'cn'} style={{
              position: 'absolute', ...it.pos,
              padding: '14px 22px',
              background: isLast ? 'var(--fg)' : 'var(--bg-card)',
              color: isLast ? 'var(--bg)' : 'var(--fg)',
              border: isLast ? 'none' : '1px solid var(--line-2)',
              fontFamily: it.en ? 'var(--f-sans)' : 'var(--f-cn)',
              fontWeight: it.en ? 600 : 700,
              fontSize: 22, letterSpacing: it.en ? '-0.005em' : '0.01em',
              borderRadius: 6,
              animation: `stickIn 320ms var(--ease-spring) forwards`,
              transform: `rotate(${it.tilt}deg)`,
              transformOrigin: it.pos.left ? 'left center' : 'right center',
            }}>{it.txt}</div>
          );
        })}

        {/* 右下：scrollback meta */}
        <div className="mono" style={{ position: 'absolute', bottom: '8%', right: '6%', fontSize: 11, letterSpacing: '0.2em', color: 'var(--fg-3)' }}>
          DUR · 320ms · SPRING
        </div>

        <style>{`
          @keyframes stickIn {
            from { opacity: 0; transform: scale(0.92) rotate(-1.5deg); }
            to   { opacity: 1; transform: scale(1) rotate(0); }
          }
        `}</style>
      </Stage>

      <Params rows={[
        { k: 'BG',       v: '反白 fg / 卡 bg-card · 二选一' },
        { k: 'BORDER',   v: '1px line-2 · 或无' },
        { k: 'PADDING',  v: '14 / 22px' },
        { k: 'RADIUS',   v: '6px · tilt ±1.5°' },
        { k: 'ENTER',    v: 'scale .92→1 + tilt 1.5°→0 · 320ms spring' },
        { k: 'RULE',     v: '<b>同屏 ≤ 3 个 · 至少 200px 间距</b>' },
      ]} />
    </SubSec>
  );
}

/* ---------- 概念卡 · 升级版 ---------- */
function ConceptCard() {
  return (
    <SubSec name="C · 概念卡 · Concept Card" tag="EXPLAINER CARD · REFINED">
      <Stage pattern="dot" label="● A-ROLL · CARD" labelR="01.C">

        {/* 左侧：模拟讲者侧 / 空白 — 让卡片"贴右" */}
        <div className="mono" style={{ position: 'absolute', top: '14%', left: '6%', fontSize: 11, letterSpacing: '0.2em', color: 'var(--fg-3)' }}>
          ← SPEAKER FRAME
        </div>

        {/* 概念卡主体 */}
        <div style={{
          position: 'absolute', top: '12%', right: '6%',
          width: '50%',
        }}>
          {/* 头部：编号 + 时间码 */}
          <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', marginBottom: 14 }}>
            <div style={{ display: 'flex', alignItems: 'baseline', gap: 14 }}>
              <span className="mono" style={{ fontSize: 11, letterSpacing: '0.2em', color: 'var(--accent)' }}>● CONCEPT</span>
              <span className="mono" style={{ fontSize: 11, letterSpacing: '0.2em', color: 'var(--fg-3)' }}>02 / 12</span>
            </div>
            <span className="mono" style={{ fontSize: 11, letterSpacing: '0.2em', color: 'var(--fg-3)' }}>00:14:22</span>
          </div>

          {/* 主卡片 */}
          <div className="frame" style={{
            background: 'var(--bg-card)',
            border: '1px solid var(--line)',
            borderRadius: 8,
            padding: '32px 36px',
            position: 'relative',
          }}>
            <Crosses />
            {/* 标题 */}
            <div className="cn" style={{ fontSize: 38, fontWeight: 800, letterSpacing: '-0.015em', lineHeight: 1.12, marginBottom: 14 }}>
              Context 是<span style={{ color: 'var(--accent)' }}>材料</span>，
              <br />不是<span className="serif" style={{ fontWeight: 400, fontStyle: 'italic', color: 'var(--fg-2)' }}>提示</span>。
            </div>
            {/* 分隔 */}
            <div style={{ width: 28, height: 2, background: 'var(--accent)', marginBottom: 14 }} />
            {/* 正文 */}
            <div className="cn" style={{ fontSize: 16, fontWeight: 400, color: 'var(--fg-2)', lineHeight: 1.65 }}>
              把"足够相关"的资料喂给模型，比把"足够聪明"的提示给模型更有效。
            </div>
            {/* 底部：来源 */}
            <div style={{ marginTop: 22, paddingTop: 14, borderTop: '1px solid var(--line)', display: 'flex', alignItems: 'baseline', justifyContent: 'space-between' }}>
              <span className="mono" style={{ fontSize: 10, letterSpacing: '0.2em', color: 'var(--fg-3)' }}>REF · AI ENGINEERING BLOG</span>
              <span className="mono" style={{ fontSize: 10, letterSpacing: '0.2em', color: 'var(--fg-3)' }}>HOLD · 4S</span>
            </div>
          </div>
        </div>
      </Stage>

      {/* 用法说明 */}
      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: 16, marginBottom: 16 }}>
        <UseCase label="01 · USE WHEN" body="抛出一个名词的<em>新定义</em>，需要在画面驻留 3-5s" />
        <UseCase label="02 · DON'T" body="不要叠加 glow / 阴影 / 渐变 · 不要双卡同屏" />
        <UseCase label="03 · ENTER" body="opacity 0→1 + y 12→0 · 700ms ease-out · 出场反向" />
      </div>

      <Params rows={[
        { k: 'BG',       v: 'var(--bg-card) #111114' },
        { k: 'BORDER',   v: '1px hairline + 4× 角十字针脚' },
        { k: 'RADIUS',   v: '8px' },
        { k: 'PADDING',  v: '32 / 36px · 宽度 50% 画面' },
        { k: 'TYPE',     v: 'mono 11 caps · cn 38/800 · cn 16/400 · 一字 serif italic' },
        { k: 'RULE',     v: '一卡只讲一个概念 · 不超过 3 行正文' },
        { k: 'SHADOW',   v: '<b>0</b> · 强调靠换色与字号悬崖' },
        { k: 'ENTER',    v: '700ms ease-out · 卡 + 角标错峰 80ms' },
      ]} />
    </SubSec>
  );
}

/* ---------- helpers ---------- */
function Crosses() {
  return (
    <>
      <span className="cross cross--tl" />
      <span className="cross cross--tr" />
      <span className="cross cross--bl" />
      <span className="cross cross--br" />
    </>
  );
}

function UseCase({ label, body }) {
  return (
    <div style={{
      background: 'var(--bg-card)', border: '1px solid var(--line)',
      borderRadius: 8, padding: '18px 20px',
    }}>
      <div className="mono" style={{ fontSize: 11, letterSpacing: '0.2em', color: 'var(--accent)', marginBottom: 10 }}>{label}</div>
      <div className="cn" style={{ fontSize: 13, color: 'var(--fg-2)', lineHeight: 1.6 }} dangerouslySetInnerHTML={{ __html: body.replace(/<em>(.*?)<\/em>/g, '<em style="color:var(--accent);font-style:normal">$1</em>') }} />
    </div>
  );
}

Object.assign(window, { ARollSection });
CODEX_LAZYPACK_FAA6EC17DADCD4B3D7464BA419875D38D9241790

# video-spec-builder/Full Code/sections/broll-abstract.jsx
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/video-spec-builder/Full Code/sections/broll-abstract.jsx")"
cat > "{{CODEX_HOME}}/skills/video-spec-builder/Full Code/sections/broll-abstract.jsx" <<'CODEX_LAZYPACK_246F60220C619A67935553BE4BE75DCC7A002237'
/* ================================================================
   sections/broll-abstract.jsx — 05 · B-roll · 抽象兜底
   讲 AI 时多数概念没有具象图标 —— 这里是"以形会意"的通用版式
   ================================================================ */

function AbstractSection() {
  return (
    <Section id="abstract" num="05" title="B-roll · 抽象兜底"
      desc="当概念<em>没有具象图标</em>可用时的通用版式 —— <b>类比</b>、<b>黑盒</b>、<b>等式</b>、<b>光谱</b>、<b>冰山</b>、<b>对照</b>、<b>占位</b>。这是讲 AI 时最常用的一类，因为<em>抽象概念远多于具象图标</em>。">
      <Analogy />
      <BlackBox />
      <Equation />
      <AbstractSpectrum />
      <Iceberg />
      <Versus />
      <Placeholder />
    </Section>
  );
}

/* ---------- A · Analogy ---------- */
function Analogy() {
  return (
    <SubSec name="类比框 · Analogy" tag="UNFAMILIAR ≈ FAMILIAR">
      <Stage pattern="dot" label="● B-ROLL" labelR="05.A">
        <div style={{ position: 'absolute', inset: '16% 6%', display: 'grid', gridTemplateColumns: '1fr 80px 1fr', alignItems: 'center', gap: 0 }}>
          <AnalogyCard side="未知" tone="accent" big="RAG" sub="检索增强生成 · 模型 + 外挂资料库" />
          <div style={{ textAlign: 'center' }}>
            <div className="serif" style={{ fontSize: 76, color: 'var(--accent)', lineHeight: 1 }}>≈</div>
            <div className="meta" style={{ marginTop: 6 }}>就像</div>
          </div>
          <AnalogyCard side="熟悉" big="开卷考试" sub="不用背 · 翻书查 · 临场组织答案" />
        </div>
      </Stage>
      <Params rows={[
        { k: 'LAYOUT', v: '左 = 未知 · 右 = 熟悉' },
        { k: 'CONNECTOR', v: '≈ · Instrument Serif italic · 76px · accent' },
        { k: 'SUB-LABEL', v: '"就像" 在 ≈ 下方做语义提示' },
        { k: 'CARDS', v: '完全对称 hairline 卡 · 左卡 accent 标签强化区分' },
      ]} />
    </SubSec>
  );
}
function AnalogyCard({ side, tone, big, sub }) {
  return (
    <div style={{ background: 'var(--bg-card)', border: '1px solid var(--line)', borderRadius: 8, padding: '36px 36px', position: 'relative' }}>
      <Bracket size={18} color="var(--line-3)" thick={1} />
      <div className="meta" style={{ color: tone === 'accent' ? 'var(--accent)' : 'var(--fg-3)', marginBottom: 18 }}>{side}</div>
      <div className="cn" style={{ fontSize: 44, fontWeight: 800, letterSpacing: '-0.018em', lineHeight: 1, marginBottom: 14 }}>{big}</div>
      <div className="cn" style={{ fontSize: 26, color: 'var(--fg-2)', lineHeight: 1.5 }}>{sub}</div>
    </div>
  );
}

/* ---------- B · Black Box ---------- */
function BlackBox() {
  return (
    <SubSec name="黑盒图 · Black Box" tag="INPUT → ? → OUTPUT">
      <Stage pattern="dot" label="● B-ROLL" labelR="05.B">
        <div style={{ position: 'absolute', inset: '24% 6%', display: 'grid', gridTemplateColumns: '1fr 56px 1.5fr 56px 1fr', alignItems: 'center', gap: 0 }}>
          <Slot label="INPUT" cn="提示词" />
          <Arrow />
          <div style={{ position: 'relative', background: 'var(--bg-card)', border: '1px dashed var(--accent)', borderRadius: 8, padding: '36px 32px', textAlign: 'center' }}>
            <Bracket size={14} color="var(--accent)" thick={1} />
            <div className="meta" style={{ color: 'var(--accent)', marginBottom: 14 }}>BLACK BOX</div>
            <div className="big-num" style={{ fontSize: 84, color: 'var(--accent)', lineHeight: 0.85 }}>?</div>
            <div className="cn" style={{ fontSize: 26, color: 'var(--fg-2)', marginTop: 14 }}>175B 参数 · 不可解释</div>
          </div>
          <Arrow />
          <Slot label="OUTPUT" cn="回答" />
        </div>
      </Stage>
      <Params rows={[
        { k: 'BOX', v: 'dashed accent 描边（区别 hairline）+ 四角 bracket' },
        { k: '?', v: '84px · big-num · accent' },
        { k: 'USE', v: '讲"内部不可知"型概念' },
        { k: 'ARROW', v: 'hairline + 锐角三角 · line-3' },
      ]} />
    </SubSec>
  );
}
function Slot({ label, cn }) {
  return (
    <div style={{ background: 'var(--bg-card)', border: '1px solid var(--line)', borderRadius: 8, padding: '30px 32px', textAlign: 'center' }}>
      <div className="meta" style={{ marginBottom: 12 }}>{label}</div>
      <div className="cn" style={{ fontSize: 38, fontWeight: 800, letterSpacing: '-0.012em' }}>{cn}</div>
    </div>
  );
}
function Arrow() {
  return (
    <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
      <div style={{ height: 1, flex: 1, background: 'var(--line-3)' }} />
      <div style={{ width: 0, height: 0, borderLeft: '8px solid var(--line-3)', borderTop: '5px solid transparent', borderBottom: '5px solid transparent' }} />
    </div>
  );
}

/* ---------- C · Equation ---------- */
function Equation() {
  return (
    <SubSec name="概念等式 · Concept Equation" tag="A + B = C">
      <Stage pattern="dot" label="● B-ROLL" labelR="05.C">
        <div style={{ position: 'absolute', inset: 0, display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 24, padding: '0 6%' }}>
          <EqBox big="模型" sub="reasoning" />
          <EqOp ch="+" />
          <EqBox big="资料" sub="context" accent />
          <EqOp ch="=" />
          <EqBox big="可靠回答" sub="output" />
        </div>
        {/* 顶部细注释线，提升"教科书等式"感 */}
        <div style={{ position: 'absolute', top: '22%', left: '6%', right: '6%', display: 'flex', alignItems: 'center' }}>
          <span className="meta" style={{ color: 'var(--fg-3)' }}>EQ · 概念组合</span>
          <span style={{ flex: 1, height: 1, background: 'var(--line)', marginLeft: 12 }} />
        </div>
      </Stage>
      <Params rows={[
        { k: 'LAYOUT', v: '横向居中 · 等距' },
        { k: 'OPERATOR', v: 'serif italic · 56px · accent' },
        { k: 'EMPHASIS', v: '关键项 accent 边框' },
        { k: 'HEADER', v: '顶部 EQ · hairline 注释栏（教科书味）' },
      ]} />
    </SubSec>
  );
}
function EqBox({ big, sub, accent }) {
  return (
    <div style={{ background: 'var(--bg-card)', border: `1px solid ${accent ? 'var(--accent)' : 'var(--line)'}`, borderRadius: 8, padding: '30px 36px', textAlign: 'center', minWidth: 160 }}>
      <div className="cn" style={{ fontSize: 38, fontWeight: 800, letterSpacing: '-0.012em', marginBottom: 8 }}>{big}</div>
      <div className="meta" style={{ color: accent ? 'var(--accent)' : 'var(--fg-3)' }}>{sub}</div>
    </div>
  );
}
function EqOp({ ch }) {
  return <div className="serif" style={{ fontSize: 56, color: 'var(--accent)', lineHeight: 1 }}>{ch}</div>;
}

/* ---------- D · Spectrum ---------- */
function AbstractSpectrum() {
  return (
    <SubSec name="光谱 · Spectrum" tag="ONE AXIS · TWO POLES">
      <Stage pattern="dot" label="● B-ROLL" labelR="05.D">
        <div style={{ position: 'absolute', inset: '24% 8%', display: 'flex', flexDirection: 'column', justifyContent: 'center', gap: 18 }}>
          {/* 左右极标签 */}
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
            <div>
              <div className="meta" style={{ marginBottom: 6 }}>左极</div>
              <div className="cn" style={{ fontSize: 34, fontWeight: 800, letterSpacing: '-0.012em' }}>纯背诵</div>
            </div>
            <div style={{ textAlign: 'right' }}>
              <div className="meta" style={{ marginBottom: 6, color: 'var(--accent)' }}>右极</div>
              <div className="cn" style={{ fontSize: 34, fontWeight: 800, letterSpacing: '-0.012em' }}>纯检索</div>
            </div>
          </div>
          {/* 轴 */}
          <div style={{ position: 'relative', height: 24, display: 'flex', alignItems: 'center' }}>
            {/* ticks */}
            <div style={{ position: 'absolute', inset: 0, display: 'flex', justifyContent: 'space-between' }}>
              {Array.from({ length: 11 }).map((_, i) => (
                <span key={i} style={{ width: 1, height: i % 5 === 0 ? 12 : 6, background: 'var(--line-3)', alignSelf: 'flex-end' }} />
              ))}
            </div>
            {/* main rule */}
            <div style={{ position: 'absolute', left: 0, right: 0, height: 1, background: 'var(--fg-3)', bottom: 0 }} />
            {/* marker */}
            <div style={{ position: 'absolute', left: '68%', bottom: -8, display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 4 }}>
              <span className="meta" style={{ color: 'var(--accent)', whiteSpace: 'nowrap' }}>RAG · 0.68</span>
              <div style={{ width: 0, height: 0, borderLeft: '7px solid transparent', borderRight: '7px solid transparent', borderTop: '10px solid var(--accent)' }} />
            </div>
          </div>
          {/* legend */}
          <div style={{ display: 'flex', justifyContent: 'space-between', color: 'var(--fg-3)', marginTop: 28 }}>
            <span className="cn" style={{ fontSize: 18 }}>fine-tuning</span>
            <span className="cn" style={{ fontSize: 18 }}>vector search</span>
          </div>
        </div>
      </Stage>
      <Params rows={[
        { k: 'AXIS', v: '0 – 1 · 11 个 tick · 5n 主刻度' },
        { k: 'MARKER', v: '倒三角 · accent · 上方 mono 标签' },
        { k: 'POLES', v: '左 fg · 右 accent meta · 强调右极' },
        { k: 'USE', v: '"X 在 A 和 B 之间偏哪边" 类概念' },
      ]} />
    </SubSec>
  );
}

/* ---------- E · Iceberg ---------- */
function Iceberg() {
  return (
    <SubSec name="冰山 · Iceberg" tag="VISIBLE / HIDDEN">
      <Stage pattern="dot" label="● B-ROLL" labelR="05.E">
        <div style={{ position: 'absolute', inset: '12% 8%', display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 32, alignItems: 'stretch' }}>
          {/* 左侧 SVG 冰山 */}
          <div style={{ position: 'relative', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
            <svg viewBox="0 0 200 200" width="100%" style={{ maxWidth: 320 }}>
              {/* 水面线 */}
              <line x1="0" y1="80" x2="200" y2="80" stroke="var(--accent)" strokeWidth="1" strokeDasharray="3 3" />
              <text x="2" y="76" fontSize="6" fill="var(--accent)" fontFamily="var(--f-mono)" letterSpacing="1">— WATERLINE</text>
              {/* 上半（可见） */}
              <polygon points="100,30 130,80 70,80" fill="none" stroke="var(--fg)" strokeWidth="1.2" />
              {/* 下半（隐藏） */}
              <polygon points="55,80 145,80 165,160 130,185 70,185 35,160" fill="rgba(255,255,255,0.04)" stroke="var(--fg-3)" strokeWidth="1" strokeDasharray="2 3" />
              {/* 指引线 */}
              <line x1="120" y1="55" x2="185" y2="40" stroke="var(--fg-3)" strokeWidth="0.6" />
              <line x1="135" y1="140" x2="190" y2="155" stroke="var(--fg-3)" strokeWidth="0.6" />
              <circle cx="120" cy="55" r="1.2" fill="var(--fg)" />
              <circle cx="135" cy="140" r="1.2" fill="var(--fg-3)" />
            </svg>
          </div>
          {/* 右侧文字标注 */}
          <div style={{ display: 'flex', flexDirection: 'column', justifyContent: 'center', gap: 28 }}>
            <div>
              <div className="meta" style={{ color: 'var(--accent)', marginBottom: 10 }}>● 可见 · 10%</div>
              <div className="cn" style={{ fontSize: 32, fontWeight: 800, letterSpacing: '-0.012em', marginBottom: 8 }}>对话界面</div>
              <div className="cn" style={{ fontSize: 22, color: 'var(--fg-2)', lineHeight: 1.5 }}>你看到的输入框和回答</div>
            </div>
            <div style={{ height: 1, background: 'var(--line)' }} />
            <div>
              <div className="meta" style={{ marginBottom: 10 }}>○ 隐藏 · 90%</div>
              <div className="cn" style={{ fontSize: 32, fontWeight: 800, letterSpacing: '-0.012em', marginBottom: 8, color: 'var(--fg-2)' }}>权重 · 训练数据 · RLHF · 推理基建</div>
              <div className="cn" style={{ fontSize: 22, color: 'var(--fg-3)', lineHeight: 1.5 }}>真正决定回答质量的部分</div>
            </div>
          </div>
        </div>
      </Stage>
      <Params rows={[
        { k: 'WATERLINE', v: 'accent 虚线 + WATERLINE 标签' },
        { k: 'ABOVE', v: '实线 · 10% 标注 · accent' },
        { k: 'BELOW', v: '虚线 + 轻填充 · 90% · 灰阶' },
        { k: 'USE', v: '"看得见 / 看不见" 比例悬殊型概念' },
      ]} />
    </SubSec>
  );
}

/* ---------- F · Versus ---------- */
function Versus() {
  return (
    <SubSec name="对照 · Versus" tag="A vs B · DELTA">
      <Stage pattern="dot" label="● B-ROLL" labelR="05.F">
        <div style={{ position: 'absolute', inset: '14% 8%', display: 'grid', gridTemplateColumns: '1fr 100px 1fr', alignItems: 'stretch', gap: 0 }}>
          <VsCard side="A" big="预训练" rows={[
            { k: '数据', v: '海量公开语料' },
            { k: '时长', v: '数月 · 数千卡' },
            { k: '产出', v: '通用基础模型' },
          ]} />
          <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', gap: 8 }}>
            <div style={{ height: '100%', width: 1, background: 'var(--line)', position: 'absolute', top: 0 }} />
            <div className="serif" style={{ fontSize: 56, color: 'var(--accent)', background: 'var(--bg)', padding: '4px 12px', position: 'relative', zIndex: 1 }}>vs</div>
          </div>
          <VsCard side="B" accent big="微调" rows={[
            { k: '数据', v: '少量任务数据' },
            { k: '时长', v: '小时 · 单卡' },
            { k: '产出', v: '专业化变体' },
          ]} />
        </div>
      </Stage>
      <Params rows={[
        { k: 'LAYOUT', v: '左右等宽 · 中竖线 + vs serif' },
        { k: 'ROWS', v: '同序键值 · 行行对齐（方便逐行对比）' },
        { k: 'SIDE LABEL', v: '左 fg-3 · 右 accent · A / B' },
        { k: 'USE', v: '两个方案 / 两种概念逐项对比' },
      ]} />
    </SubSec>
  );
}
function VsCard({ side, accent, big, rows }) {
  return (
    <div style={{ background: 'var(--bg-card)', border: `1px solid ${accent ? 'var(--accent)' : 'var(--line)'}`, borderRadius: 8, padding: '28px 32px' }}>
      <div className="meta" style={{ color: accent ? 'var(--accent)' : 'var(--fg-3)', marginBottom: 14 }}>{side}</div>
      <div className="cn" style={{ fontSize: 38, fontWeight: 800, letterSpacing: '-0.012em', marginBottom: 18 }}>{big}</div>
      <div style={{ display: 'flex', flexDirection: 'column', gap: 10 }}>
        {rows.map(r => (
          <div key={r.k} style={{ display: 'grid', gridTemplateColumns: '70px 1fr', gap: 16, alignItems: 'baseline', paddingBottom: 8, borderBottom: '1px solid var(--line)' }}>
            <span className="meta">{r.k}</span>
            <span className="cn" style={{ fontSize: 22, color: 'var(--fg-2)' }}>{r.v}</span>
          </div>
        ))}
      </div>
    </div>
  );
}

/* ---------- G · Placeholder ---------- */
function Placeholder() {
  return (
    <SubSec name="占位框 · Placeholder" tag="WHEN YOU LACK AN ASSET">
      <Stage pattern="dot" label="● B-ROLL" labelR="05.G">
        <div style={{ position: 'absolute', inset: '18% 18%', background: 'transparent', border: '1px solid var(--line-2)', borderRadius: 8, display: 'flex', alignItems: 'center', justifyContent: 'center', flexDirection: 'column', backgroundImage: 'repeating-linear-gradient(-45deg, transparent 0, transparent 14px, rgba(255,255,255,0.04) 14px, rgba(255,255,255,0.04) 15px)', position: 'relative' }}>
          <Bracket size={20} color="var(--line-3)" thick={1} />
          <div className="meta" style={{ color: 'var(--accent)', marginBottom: 14 }}>[ DROP HERE ]</div>
          <div className="cn" style={{ fontSize: 38, fontWeight: 800, letterSpacing: '-0.012em' }}>GPT-4 屏幕录像</div>
          <div className="mono" style={{ fontSize: 22, color: 'var(--fg-3)', marginTop: 10 }}>1920 × 1080 · ≤ 8s · prores</div>
        </div>
      </Stage>
      <Params rows={[
        { k: 'BG', v: '45° 斜条纹（4% 白）' },
        { k: 'BORDER', v: '1px line-2 + 四角 bracket' },
        { k: 'LABEL', v: '[ DROP HERE ] mono caps · accent' },
        { k: 'SPEC', v: '尺寸 · 时长 · 编码格式' },
      ]} />
    </SubSec>
  );
}

Object.assign(window, { AbstractSection });
CODEX_LAZYPACK_246F60220C619A67935553BE4BE75DCC7A002237

# video-spec-builder/Full Code/sections/broll-charts.jsx
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/video-spec-builder/Full Code/sections/broll-charts.jsx")"
cat > "{{CODEX_HOME}}/skills/video-spec-builder/Full Code/sections/broll-charts.jsx" <<'CODEX_LAZYPACK_8D6F08783166ED32F96C30691E1C007155B698E2'
/* ================================================================
   sections/broll-charts.jsx — 06 · A 类 · 数据图表 12 款
   line / multi-line / bar / hbar / stacked / area / donut /
   scatter / heatmap / gauge / sparkline / sankey
   ================================================================ */

function ChartsSection() {
  return (
    <Section id="charts" num="06" title="B-roll · 数据图表"
      desc="讲<b>数字 · 趋势 · 占比 · 流量</b>时用。所有图共用一套渲染语法：<em>hairline 坐标轴 · mono 数字 · 单 accent 高亮关键点</em>。每屏最多 1 个主信息 + 2-3 个数据点。">
      <LineChart /><MultiLine /><BarChart /><HBarChart />
      <StackedBar /><AreaChart /><Donut /><Scatter />
      <Heatmap /><Gauge /><Sparkline /><Sankey />
    </Section>
  );
}

/* ── shared axis ── */
function Axis({ xLabels, yMax = 100, yStep = 25, padX = 80, padY = 60, w = 1000, h = 500 }) {
  const ys = [];
  for (let v = 0; v <= yMax; v += yStep) ys.push(v);
  const innerH = h - padY * 2;
  const innerW = w - padX * 2;
  return (
    <g>
      {/* y grid + labels */}
      {ys.map(v => {
        const y = h - padY - (v / yMax) * innerH;
        return (
          <g key={v}>
            <line x1={padX} x2={w - padX} y1={y} y2={y} stroke="rgba(255,255,255,.06)" strokeWidth="1" />
            <text x={padX - 14} y={y + 6} textAnchor="end" fontSize="16" fontFamily="var(--f-mono)" fill="rgba(255,255,255,.42)">{v}</text>
          </g>
        );
      })}
      {/* x labels */}
      {xLabels.map((l, i) => {
        const x = padX + (i / (xLabels.length - 1)) * innerW;
        return <text key={i} x={x} y={h - padY + 30} textAnchor="middle" fontSize="16" fontFamily="var(--f-mono)" letterSpacing="0.08em" fill="rgba(255,255,255,.42)">{l}</text>;
      })}
    </g>
  );
}

/* ── A1 · 折线图 ── */
function LineChart() {
  const pts = [12, 28, 22, 45, 38, 62, 78, 71, 88];
  const labels = ['W1','W2','W3','W4','W5','W6','W7','W8','W9'];
  const padX = 80, padY = 60, w = 1000, h = 500;
  const innerW = w - padX * 2, innerH = h - padY * 2;
  const path = pts.map((v, i) => `${i === 0 ? 'M' : 'L'} ${padX + (i / (pts.length - 1)) * innerW} ${h - padY - (v / 100) * innerH}`).join(' ');
  return (
    <SubSec name="A1 · 折线图 · Line Chart" tag="TREND OVER TIME">
      <Stage pattern="graph" label="● B-ROLL · DATA" labelR="06.A1">
        <div style={{ position: 'absolute', top: '8%', left: '6%' }}>
          <div className="meta" style={{ color: 'var(--accent)' }}>WEEKLY · ACTIVE USERS</div>
          <div className="cn" style={{ fontSize: 32, fontWeight: 800, marginTop: 6 }}>9 周增长 +633%</div>
        </div>
        <svg viewBox={`0 0 ${w} ${h}`} preserveAspectRatio="xMidYMid meet" style={{ position: 'absolute', inset: 0, width: '100%', height: '100%' }}>
          <Axis xLabels={labels} />
          <path d={path} fill="none" stroke="var(--accent)" strokeWidth="3" strokeLinejoin="round" strokeLinecap="round" />
          {pts.map((v, i) => {
            const x = padX + (i / (pts.length - 1)) * innerW;
            const y = h - padY - (v / 100) * innerH;
            const last = i === pts.length - 1;
            return <g key={i}>
              <circle cx={x} cy={y} r={last ? 8 : 4} fill={last ? 'var(--accent)' : 'var(--bg)'} stroke="var(--accent)" strokeWidth="2" />
              {last && <text x={x + 16} y={y + 6} fontSize="20" fontWeight="800" fontFamily="var(--f-mono)" fill="var(--accent)">{v}</text>}
            </g>;
          })}
        </svg>
      </Stage>
      <Params rows={[
        { k: 'AXIS', v: '1px rgba(255,255,255,.06) hairline' },
        { k: 'LINE', v: '3px accent · round join' },
        { k: 'POINT', v: '4px (常规) · 8px (端点高亮)' },
        { k: 'LABEL', v: '末端标数字 + mono 字体' },
      ]} />
    </SubSec>
  );
}

/* ── A2 · 多线对比 ── */
function MultiLine() {
  const series = [
    { name: 'GPT-4',     data: [22, 38, 45, 58, 64, 71, 78, 82, 86], color: 'var(--accent)' },
    { name: 'GPT-4o', data: [18, 32, 41, 52, 60, 68, 74, 79, 83], color: 'rgba(255,255,255,.7)' },
    { name: 'Gemini',    data: [15, 24, 30, 38, 44, 50, 55, 58, 62], color: 'rgba(255,255,255,.35)' },
  ];
  const labels = ['1','2','3','4','5','6','7','8','9'];
  const padX = 80, padY = 60, w = 1000, h = 500;
  const innerW = w - padX * 2, innerH = h - padY * 2;
  return (
    <SubSec name="A2 · 多线对比 · Multi-line" tag="MODEL COMPARISON">
      <Stage pattern="graph" label="● B-ROLL · DATA" labelR="06.A2">
        <div style={{ position: 'absolute', top: '8%', left: '6%' }}>
          <div className="meta" style={{ color: 'var(--accent)' }}>BENCHMARK · MMLU SCORE</div>
          <div className="cn" style={{ fontSize: 32, fontWeight: 800, marginTop: 6 }}>三家模型 9 月成绩</div>
        </div>
        <div style={{ position: 'absolute', top: '8%', right: '6%', display: 'flex', flexDirection: 'column', gap: 10 }}>
          {series.map(s => (
            <div key={s.name} style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
              <span style={{ width: 18, height: 3, background: s.color }} />
              <span className="mono" style={{ fontSize: 16, color: s.color }}>{s.name}</span>
            </div>
          ))}
        </div>
        <svg viewBox={`0 0 ${w} ${h}`} preserveAspectRatio="xMidYMid meet" style={{ position: 'absolute', inset: 0, width: '100%', height: '100%' }}>
          <Axis xLabels={labels} />
          {series.map((s, si) => {
            const path = s.data.map((v, i) => `${i === 0 ? 'M' : 'L'} ${padX + (i / (s.data.length - 1)) * innerW} ${h - padY - (v / 100) * innerH}`).join(' ');
            return <path key={si} d={path} fill="none" stroke={s.color} strokeWidth={si === 0 ? 3 : 2} strokeLinejoin="round" />;
          })}
        </svg>
      </Stage>
      <Params rows={[
        { k: 'HIERARCHY', v: '主线 accent 3px · 次线 70% 白 2px · 三线 35% 白 2px' },
        { k: 'LEGEND', v: '右上角 · 18px 横杠 + mono 名' },
        { k: 'RULE', v: '<b>最多 3 条线</b> · 4 条以上拆图' },
      ]} />
    </SubSec>
  );
}

/* ── A3 · 柱形图 ── */
function BarChart() {
  const data = [
    { l: 'JAN', v: 38 }, { l: 'FEB', v: 52 }, { l: 'MAR', v: 41 },
    { l: 'APR', v: 67 }, { l: 'MAY', v: 84 }, { l: 'JUN', v: 72 },
  ];
  const max = 100;
  return (
    <SubSec name="A3 · 柱形图 · Bar Chart" tag="DISCRETE QUANTITIES">
      <Stage pattern="graph" label="● B-ROLL · DATA" labelR="06.A3">
        <div style={{ position: 'absolute', top: '8%', left: '6%' }}>
          <div className="meta" style={{ color: 'var(--accent)' }}>MONTHLY · API CALLS (M)</div>
          <div className="cn" style={{ fontSize: 32, fontWeight: 800, marginTop: 6 }}>5 月峰值 84M</div>
        </div>
        <div style={{ position: 'absolute', inset: '34% 8% 14% 8%', display: 'flex', alignItems: 'flex-end', gap: 24 }}>
          {data.map((d, i) => {
            const hot = d.v === Math.max(...data.map(x => x.v));
            return (
              <div key={i} style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', height: '100%' }}>
                <div className="mono" style={{ fontSize: 18, fontWeight: 600, color: hot ? 'var(--accent)' : 'var(--fg-2)', marginBottom: 8 }}>{d.v}</div>
                <div style={{ width: '100%', flex: 1, display: 'flex', alignItems: 'flex-end' }}>
                  <div style={{ width: '100%', height: `${(d.v / max) * 100}%`, background: hot ? 'var(--accent)' : 'rgba(255,255,255,.18)', borderRadius: '2px 2px 0 0' }} />
                </div>
                <div className="meta" style={{ marginTop: 14, color: hot ? 'var(--accent)' : 'var(--fg-3)' }}>{d.l}</div>
              </div>
            );
          })}
        </div>
      </Stage>
      <Params rows={[
        { k: 'BAR', v: '默认 18% 白 · 峰值 accent' },
        { k: 'GAP', v: '24px · 不超过柱宽 50%' },
        { k: 'VALUE', v: '柱顶 mono · 峰值字色 accent' },
        { k: 'RADIUS', v: '顶部 2px (柔化)' },
      ]} />
    </SubSec>
  );
}

/* ── A4 · 横向条形 ── */
function HBarChart() {
  const data = [
    { l: 'GitHub Copilot', v: 92 },
    { l: 'ChatGPT',        v: 88 },
    { l: 'Cursor',         v: 74 },
    { l: 'Codex App',    v: 68 },
    { l: 'Windsurf',       v: 41 },
  ];
  return (
    <SubSec name="A4 · 横向条形 · H-Bar" tag="RANKING">
      <Stage pattern="graph" label="● B-ROLL · DATA" labelR="06.A4">
        <div style={{ position: 'absolute', top: '8%', left: '6%' }}>
          <div className="meta" style={{ color: 'var(--accent)' }}>2025 DEV TOOL ADOPTION %</div>
          <div className="cn" style={{ fontSize: 32, fontWeight: 800, marginTop: 6 }}>开发者用得最多的 AI 工具</div>
        </div>
        <div style={{ position: 'absolute', inset: '30% 8% 10% 8%', display: 'flex', flexDirection: 'column', gap: 18 }}>
          {data.map((d, i) => (
            <div key={i} style={{ display: 'grid', gridTemplateColumns: '180px 1fr 60px', alignItems: 'center', gap: 18 }}>
              <div className="cn" style={{ fontSize: 18, fontWeight: 600, color: i === 0 ? 'var(--fg)' : 'var(--fg-2)' }}>{d.l}</div>
              <div style={{ height: 18, background: 'rgba(255,255,255,.05)', position: 'relative' }}>
                <div style={{ width: `${d.v}%`, height: '100%', background: i === 0 ? 'var(--accent)' : 'rgba(255,255,255,.22)' }} />
              </div>
              <div className="mono" style={{ fontSize: 18, fontWeight: 600, color: i === 0 ? 'var(--accent)' : 'var(--fg-2)', textAlign: 'right' }}>{d.v}%</div>
            </div>
          ))}
        </div>
      </Stage>
      <Params rows={[
        { k: 'LAYOUT', v: '3 列：标签 / 条 / 数值' },
        { k: 'SORT', v: '降序 · 第一名 accent' },
        { k: 'BAR HEIGHT', v: '18px (粗壮便于看清)' },
        { k: 'TRACK', v: '5% 白底打底 (空槽可见)' },
      ]} />
    </SubSec>
  );
}

/* ── A5 · 堆叠条/柱 ── */
function StackedBar() {
  const months = [
    { l: 'Q1', segs: [42, 28, 18] },
    { l: 'Q2', segs: [58, 31, 22] },
    { l: 'Q3', segs: [71, 38, 27] },
    { l: 'Q4', segs: [88, 42, 34] },
  ];
  const colors = ['var(--accent)', 'rgba(255,255,255,.55)', 'rgba(255,255,255,.22)'];
  const names = ['Inference', 'Training', 'Storage'];
  return (
    <SubSec name="A5 · 堆叠柱 · Stacked" tag="COMPOSITION OVER TIME">
      <Stage pattern="graph" label="● B-ROLL · DATA" labelR="06.A5">
        <div style={{ position: 'absolute', top: '8%', left: '6%' }}>
          <div className="meta" style={{ color: 'var(--accent)' }}>COMPUTE COST · $M</div>
          <div className="cn" style={{ fontSize: 32, fontWeight: 800, marginTop: 6 }}>四季度构成变化</div>
        </div>
        <div style={{ position: 'absolute', top: '8%', right: '6%', display: 'flex', flexDirection: 'column', gap: 10 }}>
          {names.map((n, i) => (
            <div key={n} style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
              <span style={{ width: 14, height: 14, background: colors[i] }} />
              <span className="mono" style={{ fontSize: 16, color: 'var(--fg-2)' }}>{n}</span>
            </div>
          ))}
        </div>
        <div style={{ position: 'absolute', inset: '36% 8% 14% 8%', display: 'flex', alignItems: 'flex-end', gap: 36 }}>
          {months.map((m, i) => {
            const total = m.segs.reduce((s, v) => s + v, 0);
            const max = 180;
            return (
              <div key={i} style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center' }}>
                <div className="mono" style={{ fontSize: 18, fontWeight: 600, color: 'var(--fg)', marginBottom: 8 }}>${total}</div>
                <div style={{ width: '100%', height: 220, display: 'flex', flexDirection: 'column-reverse' }}>
                  {m.segs.map((s, si) => (
                    <div key={si} style={{ height: `${(s / max) * 100}%`, background: colors[si] }} />
                  ))}
                </div>
                <div className="meta" style={{ marginTop: 14 }}>{m.l}</div>
              </div>
            );
          })}
        </div>
      </Stage>
      <Params rows={[
        { k: 'COLOR ORDER', v: '主项 accent · 次项 55% 白 · 三项 22% 白' },
        { k: 'TOTAL', v: '柱顶 mono · 累计值' },
        { k: 'STACK', v: '主项<b>放底部</b>视觉锚定' },
      ]} />
    </SubSec>
  );
}

/* ── A6 · 面积图 ── */
function AreaChart() {
  const pts = [10, 18, 28, 22, 38, 52, 48, 68, 84];
  const labels = ['1','2','3','4','5','6','7','8','9'];
  const padX = 80, padY = 60, w = 1000, h = 500;
  const innerW = w - padX * 2, innerH = h - padY * 2;
  const pathLine = pts.map((v, i) => `${i === 0 ? 'M' : 'L'} ${padX + (i / (pts.length - 1)) * innerW} ${h - padY - (v / 100) * innerH}`).join(' ');
  const pathFill = pathLine + ` L ${w - padX} ${h - padY} L ${padX} ${h - padY} Z`;
  return (
    <SubSec name="A6 · 面积图 · Area" tag="ACCUMULATED VOLUME">
      <Stage pattern="graph" label="● B-ROLL · DATA" labelR="06.A6">
        <div style={{ position: 'absolute', top: '8%', left: '6%' }}>
          <div className="meta" style={{ color: 'var(--accent)' }}>CONTEXT WINDOW · K TOKENS</div>
          <div className="cn" style={{ fontSize: 32, fontWeight: 800, marginTop: 6 }}>模型上下文增长曲线</div>
        </div>
        <svg viewBox={`0 0 ${w} ${h}`} preserveAspectRatio="xMidYMid meet" style={{ position: 'absolute', inset: 0, width: '100%', height: '100%' }}>
          <Axis xLabels={labels} />
          <defs>
            <linearGradient id="areaGrad" x1="0" x2="0" y1="0" y2="1">
              <stop offset="0%" stopColor="var(--accent)" stopOpacity="0.42" />
              <stop offset="100%" stopColor="var(--accent)" stopOpacity="0" />
            </linearGradient>
          </defs>
          <path d={pathFill} fill="url(#areaGrad)" />
          <path d={pathLine} fill="none" stroke="var(--accent)" strokeWidth="3" />
        </svg>
      </Stage>
      <Params rows={[
        { k: 'FILL', v: 'accent 42% → 0% 渐变 (唯一允许的渐变)' },
        { k: 'STROKE', v: '顶线 3px accent' },
        { k: 'USE', v: '强调"累积量 / 容量"' },
      ]} />
    </SubSec>
  );
}

/* ── A7 · 环形图 ── */
function Donut() {
  const data = [
    { l: 'Retrieval', v: 52, c: 'var(--accent)' },
    { l: 'Generate',  v: 28, c: 'rgba(255,255,255,.65)' },
    { l: 'Rank',      v: 14, c: 'rgba(255,255,255,.32)' },
    { l: 'Other',     v: 6,  c: 'rgba(255,255,255,.14)' },
  ];
  const r = 140, cx = 160, cy = 160, stroke = 36;
  const C = 2 * Math.PI * r;
  let acc = 0;
  return (
    <SubSec name="A7 · 环形图 · Donut" tag="PROPORTION (≤ 4 SLICES)">
      <Stage pattern="graph" label="● B-ROLL · DATA" labelR="06.A7">
        <div style={{ position: 'absolute', inset: 0, display: 'grid', gridTemplateColumns: '1fr 1fr', alignItems: 'center', padding: '6% 8%' }}>
          <div style={{ position: 'relative', width: 320, height: 320 }}>
            <svg viewBox="0 0 320 320">
              {data.map((d, i) => {
                const len = (d.v / 100) * C;
                const dasharray = `${len} ${C - len}`;
                const offset = -acc;
                acc += len;
                return <circle key={i} cx={cx} cy={cy} r={r} fill="none" stroke={d.c} strokeWidth={stroke} strokeDasharray={dasharray} strokeDashoffset={offset} transform={`rotate(-90 ${cx} ${cy})`} />;
              })}
            </svg>
            <div style={{ position: 'absolute', inset: 0, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center' }}>
              <div className="mono" style={{ fontSize: 56, fontWeight: 800, color: 'var(--accent)' }}>52%</div>
              <div className="meta" style={{ marginTop: 6 }}>RETRIEVAL</div>
            </div>
          </div>
          <div style={{ display: 'flex', flexDirection: 'column', gap: 18 }}>
            <div className="meta" style={{ color: 'var(--accent)', marginBottom: 6 }}>LATENCY BUDGET BREAKDOWN</div>
            {data.map((d, i) => (
              <div key={i} style={{ display: 'grid', gridTemplateColumns: '24px 1fr 60px', alignItems: 'center', gap: 14 }}>
                <span style={{ width: 18, height: 18, background: d.c }} />
                <div className="cn" style={{ fontSize: 20, fontWeight: i === 0 ? 800 : 400, color: i === 0 ? 'var(--fg)' : 'var(--fg-2)' }}>{d.l}</div>
                <div className="mono" style={{ fontSize: 20, fontWeight: 600, color: i === 0 ? 'var(--accent)' : 'var(--fg-2)', textAlign: 'right' }}>{d.v}%</div>
              </div>
            ))}
          </div>
        </div>
      </Stage>
      <Params rows={[
        { k: 'RING', v: '36px stroke · 半径 140' },
        { k: 'CENTER', v: '主项数字 mono 800 · 56px · accent' },
        { k: 'LEGEND', v: '右栏 3 列：色块 / 名 / 数值' },
        { k: 'RULE', v: '<b>≤ 4 块</b>，多了换柱形' },
      ]} />
    </SubSec>
  );
}

/* ── A8 · 散点图 ── */
function Scatter() {
  // x = cost (0-100), y = quality (0-100), size = adoption
  const pts = [
    { x: 22, y: 38, r: 10, l: 'A', dim: true },
    { x: 35, y: 56, r: 14, l: 'B', dim: true },
    { x: 48, y: 72, r: 22, l: 'C', dim: true },
    { x: 68, y: 88, r: 28, l: 'D' }, // hot
    { x: 82, y: 78, r: 16, l: 'E', dim: true },
    { x: 28, y: 22, r: 8,  l: 'F', dim: true },
    { x: 58, y: 48, r: 12, l: 'G', dim: true },
  ];
  const padX = 90, padY = 70, w = 1000, h = 500;
  const innerW = w - padX * 2, innerH = h - padY * 2;
  return (
    <SubSec name="A8 · 散点图 · Scatter" tag="CORRELATION / DISTRIBUTION">
      <Stage pattern="graph" label="● B-ROLL · DATA" labelR="06.A8">
        <div style={{ position: 'absolute', top: '8%', left: '6%' }}>
          <div className="meta" style={{ color: 'var(--accent)' }}>COST × QUALITY · MODEL LANDSCAPE</div>
          <div className="cn" style={{ fontSize: 32, fontWeight: 800, marginTop: 6 }}>模型 D 是甜蜜点</div>
        </div>
        <svg viewBox={`0 0 ${w} ${h}`} preserveAspectRatio="xMidYMid meet" style={{ position: 'absolute', inset: 0, width: '100%', height: '100%' }}>
          <Axis xLabels={['LOW','','','MID','','','HIGH']} />
          <text x={padX - 50} y={h / 2} fontSize="14" fontFamily="var(--f-mono)" letterSpacing="0.16em" fill="rgba(255,255,255,.42)" transform={`rotate(-90 ${padX - 50} ${h / 2})`}>QUALITY →</text>
          {pts.map((p, i) => {
            const cx = padX + (p.x / 100) * innerW;
            const cy = h - padY - (p.y / 100) * innerH;
            return (
              <g key={i}>
                <circle cx={cx} cy={cy} r={p.r} fill={p.dim ? 'rgba(255,255,255,.14)' : 'var(--accent)'} stroke={p.dim ? 'rgba(255,255,255,.32)' : 'var(--accent)'} strokeWidth="1.5" />
                <text x={cx} y={cy + 5} textAnchor="middle" fontSize="14" fontFamily="var(--f-mono)" fontWeight="800" fill={p.dim ? 'var(--fg)' : 'var(--bg)'}>{p.l}</text>
              </g>
            );
          })}
        </svg>
      </Stage>
      <Params rows={[
        { k: 'AXES', v: '双坐标 · 角落注 LOW/HIGH' },
        { k: 'POINT SIZE', v: '映射第三维度（如采用量）' },
        { k: 'HIGHLIGHT', v: '主点 accent · 其余 14% 白填' },
      ]} />
    </SubSec>
  );
}

/* ── A9 · 热力图 ── */
function Heatmap() {
  const rows = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
  const cols = ['0','3','6','9','12','15','18','21'];
  // 7x8 grid intensity 0-100
  const grid = rows.map((_, r) => cols.map((_, c) => {
    // peak around Tue-Thu / 9-15
    const dr = Math.abs(r - 2.5), dc = Math.abs(c - 4);
    const base = Math.max(0, 100 - dr * 18 - dc * 14);
    return Math.min(100, Math.round(base + (Math.sin(r * c) * 12)));
  }));
  return (
    <SubSec name="A9 · 热力图 · Heatmap" tag="2D INTENSITY">
      <Stage pattern="graph" label="● B-ROLL · DATA" labelR="06.A9">
        <div style={{ position: 'absolute', top: '6%', left: '6%' }}>
          <div className="meta" style={{ color: 'var(--accent)' }}>API USAGE · WEEKDAY × HOUR</div>
          <div className="cn" style={{ fontSize: 28, fontWeight: 800, marginTop: 6 }}>工作日中午为高峰</div>
        </div>
        <div style={{ position: 'absolute', inset: '32% 8% 10% 8%', display: 'grid', gridTemplateRows: 'repeat(7, 1fr)', gap: 4 }}>
          {grid.map((row, ri) => (
            <div key={ri} style={{ display: 'grid', gridTemplateColumns: '40px repeat(8, 1fr)', gap: 4, alignItems: 'center' }}>
              <div className="meta" style={{ color: 'var(--fg-3)' }}>{rows[ri]}</div>
              {row.map((v, ci) => (
                <div key={ci} title={`${rows[ri]} ${cols[ci]}: ${v}`} style={{
                  aspectRatio: '1.6 / 1',
                  background: v > 70 ? 'var(--accent)' : `rgba(255,255,255,${Math.max(0.04, v / 200)})`,
                  borderRadius: 2,
                }} />
              ))}
            </div>
          ))}
          <div style={{ display: 'grid', gridTemplateColumns: '40px repeat(8, 1fr)', gap: 4, marginTop: 4 }}>
            <div />
            {cols.map(c => <div key={c} className="meta" style={{ textAlign: 'center', color: 'var(--fg-3)' }}>{c}</div>)}
          </div>
        </div>
      </Stage>
      <Params rows={[
        { k: 'CELL', v: '阶梯填色：< 70 灰阶 · ≥ 70 accent' },
        { k: 'GAP', v: '4px · 让格子边界清晰' },
        { k: 'LABELS', v: '行 · 列 mono caps 14px' },
      ]} />
    </SubSec>
  );
}

/* ── A10 · 仪表盘 ── */
function Gauge() {
  const value = 73;
  const startA = -200, endA = 20;  // sweep 220°
  const r = 130, cx = 160, cy = 170, stroke = 22;
  const C = (220 / 360) * 2 * Math.PI * r;
  const filled = (value / 100) * C;
  const arc = (a) => {
    const rad = (a * Math.PI) / 180;
    return [cx + r * Math.cos(rad), cy + r * Math.sin(rad)];
  };
  const [x1, y1] = arc(startA), [x2, y2] = arc(endA);
  return (
    <SubSec name="A10 · 仪表盘 · Gauge" tag="SINGLE METRIC">
      <Stage pattern="graph" label="● B-ROLL · DATA" labelR="06.A10">
        <div style={{ position: 'absolute', inset: 0, display: 'grid', gridTemplateColumns: '1fr 1fr', alignItems: 'center', padding: '6% 10%' }}>
          <div style={{ position: 'relative', width: 340, height: 240 }}>
            <svg viewBox="0 0 340 240">
              <path d={`M ${x1} ${y1} A ${r} ${r} 0 1 1 ${x2} ${y2}`} fill="none" stroke="rgba(255,255,255,.1)" strokeWidth={stroke} strokeLinecap="round" />
              <path d={`M ${x1} ${y1} A ${r} ${r} 0 1 1 ${x2} ${y2}`} fill="none" stroke="var(--accent)" strokeWidth={stroke} strokeLinecap="round" strokeDasharray={`${filled} ${C}`} />
            </svg>
            <div style={{ position: 'absolute', inset: 0, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'flex-end', paddingBottom: 14 }}>
              <div className="mono" style={{ fontSize: 72, fontWeight: 800, color: 'var(--accent)', lineHeight: 1 }}>73<span style={{ fontSize: 28, color: 'var(--fg-2)' }}>%</span></div>
              <div className="meta" style={{ marginTop: 8 }}>HEALTHY · TARGET 80%</div>
            </div>
          </div>
          <div>
            <div className="meta" style={{ color: 'var(--accent)', marginBottom: 10 }}>RAG · ANSWER FIDELITY</div>
            <div className="cn" style={{ fontSize: 30, fontWeight: 800, lineHeight: 1.2, marginBottom: 14 }}>距离目标还差 <span style={{ color: 'var(--accent)' }}>7 个点</span></div>
            <div className="cn" style={{ fontSize: 18, color: 'var(--fg-2)', lineHeight: 1.6 }}>本周新版 retrieval 上线后从 64 → 73。<br/>计划下周做 reranker 验证。</div>
          </div>
        </div>
      </Stage>
      <Params rows={[
        { k: 'SWEEP', v: '220° · 起始 -200° → 终止 20°' },
        { k: 'STROKE', v: '22px round cap · 留底色 10% 白' },
        { k: 'NUMBER', v: '72px mono 800 · accent' },
      ]} />
    </SubSec>
  );
}

/* ── A11 · 迷你图 ── */
function Sparkline() {
  const cards = [
    { l: 'DAU',    v: '12.4K', d: '+8.2%', up: true,  pts: [40, 38, 52, 48, 62, 70, 78] },
    { l: 'LATENCY', v: '342ms', d: '-12.4%', up: true,  pts: [78, 82, 70, 58, 52, 48, 42] },
    { l: 'ERROR', v: '0.42%', d: '+0.08', up: false, pts: [22, 18, 28, 32, 28, 38, 42] },
    { l: 'COST',  v: '$3.8K', d: '+2.1%', up: false, pts: [42, 48, 44, 52, 50, 58, 62] },
  ];
  return (
    <SubSec name="A11 · 迷你图 · Sparkline" tag="DENSE METRIC CARDS">
      <Stage pattern="graph" label="● B-ROLL · DATA" labelR="06.A11">
        <div style={{ position: 'absolute', top: '8%', left: '6%' }}>
          <div className="meta" style={{ color: 'var(--accent)' }}>WEEKLY DASHBOARD</div>
          <div className="cn" style={{ fontSize: 28, fontWeight: 800, marginTop: 6 }}>4 项关键指标</div>
        </div>
        <div style={{ position: 'absolute', inset: '32% 6% 12% 6%', display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 16 }}>
          {cards.map((c, i) => {
            const max = Math.max(...c.pts), min = Math.min(...c.pts);
            const W = 200, H = 60;
            const path = c.pts.map((v, j) => `${j === 0 ? 'M' : 'L'} ${(j / (c.pts.length - 1)) * W} ${H - ((v - min) / (max - min)) * H}`).join(' ');
            return (
              <div key={i} style={{ background: 'var(--bg-card)', border: '1px solid var(--line)', borderRadius: 6, padding: 22 }}>
                <div className="meta" style={{ marginBottom: 10 }}>{c.l}</div>
                <div className="mono" style={{ fontSize: 30, fontWeight: 800, color: 'var(--fg)', marginBottom: 4 }}>{c.v}</div>
                <div className="mono" style={{ fontSize: 14, color: c.up ? 'var(--green)' : 'var(--accent)', marginBottom: 14 }}>{c.d}</div>
                <svg viewBox={`0 0 ${W} ${H}`} width="100%" height="60" preserveAspectRatio="none">
                  <path d={path} fill="none" stroke={c.up ? 'var(--green)' : 'var(--accent)'} strokeWidth="2.5" />
                </svg>
              </div>
            );
          })}
        </div>
      </Stage>
      <Params rows={[
        { k: 'CARD', v: '1px hairline · 22px padding · 6px radius' },
        { k: 'METRIC', v: 'mono 30/800 主数 + 14px delta' },
        { k: 'LINE', v: '2.5px · 颜色映射趋势 (绿=好 / 橙=糟)' },
      ]} />
    </SubSec>
  );
}

/* ── A12 · Sankey 流图 ── */
function Sankey() {
  // 3 sources -> 2 mid -> 1 sink, simplified rectangles + bezier
  const w = 1000, h = 460;
  const cols = [
    { x: 80,  nodes: [{ y: 80, h: 140, l: '搜索 · 56%' }, { y: 240, h: 80, l: '社交 · 24%' }, { y: 340, h: 60, l: '直接 · 20%' }] },
    { x: 470, nodes: [{ y: 80, h: 180, l: '试用 · 65%' }, { y: 280, h: 120, l: '流失 · 35%' }] },
    { x: 860, nodes: [{ y: 80, h: 220, l: '留存 · 28%' }] },
  ];
  const flows = [
    { a: [0, 0], b: [1, 0], w: 100, hot: true },
    { a: [0, 0], b: [1, 1], w: 40 },
    { a: [0, 1], b: [1, 0], w: 50, hot: true },
    { a: [0, 1], b: [1, 1], w: 30 },
    { a: [0, 2], b: [1, 0], w: 30, hot: true },
    { a: [0, 2], b: [1, 1], w: 30 },
    { a: [1, 0], b: [2, 0], w: 180, hot: true },
  ];
  const NW = 18;
  const flowPath = (f) => {
    const A = cols[f.a[0]].nodes[f.a[1]];
    const B = cols[f.b[0]].nodes[f.b[1]];
    const x1 = cols[f.a[0]].x + NW, x2 = cols[f.b[0]].x;
    const y1 = A.y + A.h / 2, y2 = B.y + B.h / 2;
    const mx = (x1 + x2) / 2;
    return `M ${x1} ${y1 - f.w / 2} C ${mx} ${y1 - f.w / 2}, ${mx} ${y2 - f.w / 2}, ${x2} ${y2 - f.w / 2} L ${x2} ${y2 + f.w / 2} C ${mx} ${y2 + f.w / 2}, ${mx} ${y1 + f.w / 2}, ${x1} ${y1 + f.w / 2} Z`;
  };
  return (
    <SubSec name="A12 · Sankey 流图" tag="FLOW DISTRIBUTION">
      <Stage pattern="graph" label="● B-ROLL · DATA" labelR="06.A12">
        <div style={{ position: 'absolute', top: '6%', left: '6%' }}>
          <div className="meta" style={{ color: 'var(--accent)' }}>USER ACQUISITION FUNNEL</div>
          <div className="cn" style={{ fontSize: 28, fontWeight: 800, marginTop: 6 }}>10,000 流量到 28% 留存</div>
        </div>
        <svg viewBox={`0 0 ${w} ${h}`} preserveAspectRatio="xMidYMid meet" style={{ position: 'absolute', inset: '26% 0 0 0', width: '100%', height: '74%' }}>
          {flows.map((f, i) => (
            <path key={i} d={flowPath(f)} fill={f.hot ? 'var(--accent)' : 'rgba(255,255,255,.12)'} opacity={f.hot ? 0.32 : 0.42} />
          ))}
          {cols.map((c, ci) => c.nodes.map((n, ni) => {
            const hot = ci === 2 || (ci === 0) || (ci === 1 && ni === 0);
            return (
              <g key={ci + '-' + ni}>
                <rect x={c.x} y={n.y} width={NW} height={n.h} fill={hot ? 'var(--accent)' : 'var(--fg-2)'} />
                <text x={ci === 2 ? c.x - 14 : c.x + NW + 14} y={n.y + n.h / 2 + 6} fontSize="18" fontWeight="600" fontFamily="var(--f-cn)" fill={hot ? 'var(--accent)' : 'var(--fg)'} textAnchor={ci === 2 ? 'end' : 'start'}>{n.l}</text>
              </g>
            );
          }))}
        </svg>
      </Stage>
      <Params rows={[
        { k: 'NODE', v: '18px 宽矩形 · accent / 62% 白' },
        { k: 'FLOW', v: 'bezier · accent 32% / 白 42% opacity' },
        { k: 'WIDTH', v: '映射流量大小' },
        { k: 'USE', v: '讲漏斗 / 转化 / 资源分配' },
      ]} />
    </SubSec>
  );
}

Object.assign(window, { ChartsSection });
CODEX_LAZYPACK_8D6F08783166ED32F96C30691E1C007155B698E2

# video-spec-builder/Full Code/sections/broll-flows.jsx
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/video-spec-builder/Full Code/sections/broll-flows.jsx")"
cat > "{{CODEX_HOME}}/skills/video-spec-builder/Full Code/sections/broll-flows.jsx" <<'CODEX_LAZYPACK_F4109629204EE1D8F417CD325F8AE6CB3F1C93A5'
/* ================================================================
   sections/broll-flows.jsx — 07 · B 类 · 流程图 8 款
   branching · decision-tree · state-machine · sequence ·
   swimlane · fork-join · loop · complex-flow
   ================================================================ */

function FlowsSection() {
  return (
    <Section id="flows" num="07" title="B-roll · 流程图"
      desc="讲<b>步骤 · 决策 · 状态 · 协同</b>时用。共用语法：<em>hairline 1px 连线 · 12px 端三角箭头 · 节点 6px 圆角 · mono 标签 caps</em>。复杂度递增：单线 → 分支 → 状态 → 多角色。">
      <ComplexFlow /><Branching /><DecisionTree /><StateMachine />
      <Sequence /><Swimlane /><ForkJoin /><LoopFlow />
    </Section>
  );
}

/* shared atoms */
function FNode({ x, y, w = 200, h = 72, label, sub, hot, kind = 'rect' }) {
  const fill = hot ? 'var(--accent)' : 'var(--bg-card)';
  const stroke = hot ? 'var(--accent)' : 'var(--line-2)';
  const tColor = hot ? 'var(--bg)' : 'var(--fg)';
  const sColor = hot ? 'rgba(0,0,0,.55)' : 'var(--fg-3)';
  const fontFamily = 'var(--f-cn)';
  if (kind === 'diamond') {
    return (
      <g>
        <polygon points={`${x + w / 2},${y} ${x + w},${y + h / 2} ${x + w / 2},${y + h} ${x},${y + h / 2}`} fill={fill} stroke={stroke} strokeWidth="1.25" />
        <text x={x + w / 2} y={y + h / 2 + 6} textAnchor="middle" fontFamily={fontFamily} fontSize="18" fontWeight="700" fill={tColor}>{label}</text>
      </g>
    );
  }
  if (kind === 'circle') {
    const r = h / 2;
    return (
      <g>
        <circle cx={x + w / 2} cy={y + r} r={r} fill={fill} stroke={stroke} strokeWidth="1.25" />
        <text x={x + w / 2} y={y + r + 6} textAnchor="middle" fontFamily={fontFamily} fontSize="18" fontWeight="700" fill={tColor}>{label}</text>
      </g>
    );
  }
  return (
    <g>
      <rect x={x} y={y} width={w} height={h} rx="4" fill={fill} stroke={stroke} strokeWidth="1.25" />
      {/* 左侧 accent rail (仅非 hot) */}
      {!hot && <rect x={x} y={y} width="3" height={h} fill="var(--accent)" opacity="0.4" />}
      {sub && <text x={x + 16} y={y + 24} fontFamily="var(--f-mono)" fontSize="11" letterSpacing="0.18em" fill={sColor}>{sub}</text>}
      <text x={x + 16} y={y + (sub ? 56 : h / 2 + 7)} fontFamily={fontFamily} fontSize="19" fontWeight="700" fill={tColor} letterSpacing="-0.005em">{label}</text>
    </g>
  );
}

function FArrow({ x1, y1, x2, y2, hot, dashed, label }) {
  const c = hot ? 'var(--accent)' : 'var(--line-3)';
  const dx = x2 - x1, dy = y2 - y1;
  const len = Math.sqrt(dx * dx + dy * dy);
  const ux = dx / len, uy = dy / len;
  const tipX = x2 - ux * 10, tipY = y2 - uy * 10;
  // 10px triangle arrow at tip (open V-style)
  const ax1 = tipX - uy * 4, ay1 = tipY + ux * 4;
  const ax2 = tipX + uy * 4, ay2 = tipY - ux * 4;
  return (
    <g>
      <line x1={x1} y1={y1} x2={tipX} y2={tipY} stroke={c} strokeWidth="1.25" strokeDasharray={dashed ? '4 4' : undefined} />
      <polygon points={`${x2},${y2} ${ax1},${ay1} ${ax2},${ay2}`} fill={c} />
      {label && (
        <g>
          <rect x={(x1 + x2) / 2 - 28} y={(y1 + y2) / 2 - 18} width="56" height="16" fill="var(--bg)" rx="2" />
          <text x={(x1 + x2) / 2} y={(y1 + y2) / 2 - 6} textAnchor="middle" fontFamily="var(--f-mono)" fontSize="11" letterSpacing="0.18em" fill={hot ? 'var(--accent)' : 'var(--fg-3)'}>{label}</text>
        </g>
      )}
    </g>
  );
}

/* ── B1 · 复杂流程图（showcase 升级版） ── */
function ComplexFlow() {
  const stages = [
    { x: 60,   l: '用户提问',   s: '01 QUERY',    t: '12 ms' },
    { x: 250,  l: '改写检索词', s: '02 REWRITE',  t: '48 ms' },
    { x: 440,  l: '向量检索',   s: '03 RETRIEVE', t: '220 ms', hot: true },
    { x: 630,  l: '重排筛选',   s: '04 RERANK',   t: '180 ms', hot: true },
    { x: 820,  l: '组装上下文', s: '05 COMPOSE',  t: '8 ms' },
    { x: 1010, l: '生成答案',   s: '06 GENERATE', t: '1.2 s' },
    { x: 1200, l: '引用对齐',   s: '07 CITE',     t: '34 ms' },
  ];
  return (
    <SubSec name="B1 · 复杂流程 · Multi-step" tag="EXTENDED LINEAR FLOW">
      <Stage pattern="dot" label="● B-ROLL · FLOW" labelR="07.B1">
        {/* 头部：左标题 / 右元数据 */}
        <div style={{ position: 'absolute', top: '6%', left: '5%', right: '5%', display: 'flex', alignItems: 'baseline', justifyContent: 'space-between' }}>
          <div>
            <div className="mono" style={{ fontSize: 11, letterSpacing: '0.2em', color: 'var(--accent)' }}>● PIPELINE · 7 STAGES</div>
            <div className="cn" style={{ fontSize: 30, fontWeight: 800, marginTop: 6, letterSpacing: '-0.01em' }}>
              RAG · 从问题到<span className="serif" style={{ fontWeight: 400, fontStyle: 'italic', color: 'var(--accent)' }}>引用</span>对齐
            </div>
          </div>
          <div style={{ textAlign: 'right' }}>
            <div className="mono" style={{ fontSize: 11, letterSpacing: '0.2em', color: 'var(--fg-3)' }}>P50 LATENCY · 1.7 S</div>
            <div className="mono" style={{ fontSize: 11, letterSpacing: '0.2em', color: 'var(--fg-3)', marginTop: 4 }}>CORE · STAGE 03-04</div>
          </div>
        </div>
        <svg viewBox="0 0 1400 700" preserveAspectRatio="xMidYMid meet" style={{ position: 'absolute', inset: 0, width: '100%', height: '100%' }}>
          {/* 上下导轨 */}
          <line x1="60" y1="260" x2="1340" y2="260" stroke="var(--line)" strokeWidth="1" strokeDasharray="2 6" />
          <line x1="60" y1="480" x2="1340" y2="480" stroke="var(--line)" strokeWidth="1" strokeDasharray="2 6" />
          {/* 节点 */}
          {stages.map((n, i, a) => (
            <g key={i}>
              <FNode x={n.x} y={310} w={170} h={108} label={n.l} sub={n.s} hot={n.hot} />
              {/* 上方 tick + 编号 */}
              <line x1={n.x + 85} y1={260} x2={n.x + 85} y2={300} stroke={n.hot ? 'var(--accent)' : 'var(--line-2)'} strokeWidth="1.5" />
              <text x={n.x + 85} y={244} textAnchor="middle" fontFamily="var(--f-mono)" fontSize="11" letterSpacing="0.2em" fill="var(--fg-3)">T+{i + 1}</text>
              {/* 下方耗时 */}
              <text x={n.x + 85} y={448} textAnchor="middle" fontFamily="var(--f-mono)" fontSize="13" fontWeight="600" fill={n.hot ? 'var(--accent)' : 'var(--fg-2)'}>{n.t}</text>
              <text x={n.x + 85} y={466} textAnchor="middle" fontFamily="var(--f-mono)" fontSize="10" letterSpacing="0.16em" fill="var(--fg-3)">LAT</text>
              {i < a.length - 1 && <FArrow x1={n.x + 170} y1={364} x2={a[i + 1].x} y2={364} hot={n.hot && a[i + 1].hot} />}
            </g>
          ))}
          {/* 高亮 cluster */}
          <rect x="430" y="288" width="380" height="152" rx="8" fill="none" stroke="var(--accent)" strokeWidth="1.5" strokeDasharray="3 5" opacity="0.7" />
          <rect x="535" y="278" width="170" height="20" fill="var(--bg)" />
          <text x="620" y="292" textAnchor="middle" fontFamily="var(--f-mono)" fontSize="12" letterSpacing="0.2em" fill="var(--accent)">★ CORE RETRIEVAL</text>
          {/* 底部 hairline */}
          <line x1="60" y1="620" x2="1340" y2="620" stroke="var(--line)" strokeWidth="1" />
          <text x="60"   y="650" fontFamily="var(--f-mono)" fontSize="11" letterSpacing="0.2em" fill="var(--fg-3)">SOLID = SYNC</text>
          <text x="260"  y="650" fontFamily="var(--f-mono)" fontSize="11" letterSpacing="0.2em" fill="var(--fg-3)">DASHED = ASYNC</text>
          <text x="1340" y="650" textAnchor="end" fontFamily="var(--f-mono)" fontSize="11" letterSpacing="0.2em" fill="var(--fg-3)">FIG · 07.B1</text>
        </svg>
      </Stage>
      <Params rows={[
        { k: 'NODE',    v: '170×108 · mono sub + 中文 label · hairline' },
        { k: 'CHROME',  v: '上 tick+T+N · 下 latency · 双虚线导轨' },
        { k: 'CLUSTER', v: '虚线框 + 反白标签 (圈出重点段)' },
        { k: 'HOT',     v: '高亮段 fill accent · 同时点亮 tick / latency' },
      ]} />
    </SubSec>
  );
}

/* ── B2 · 分支流程 ── */
function Branching() {
  return (
    <SubSec name="B2 · 分支流程 · Branching" tag="IF / ELSE">
      <Stage pattern="dot" label="● B-ROLL · FLOW" labelR="07.B2">
        <svg viewBox="0 0 1200 620" preserveAspectRatio="xMidYMid meet" style={{ position: 'absolute', inset: 0, width: '100%', height: '100%' }}>
          <FNode x={500} y={40}  w={200} h={72} label="收到请求" sub="START" />
          <FNode x={460} y={210} w={280} h={88} label="缓存命中？" kind="diamond" />
          <FNode x={120} y={400} w={240} h={72} label="返回缓存" sub="HIT · YES" hot />
          <FNode x={840} y={400} w={240} h={72} label="调用模型" sub="MISS · NO" />
          <FNode x={840} y={530} w={240} h={64} label="写入缓存" sub="UPDATE" />
          <FArrow x1={600} y1={112} x2={600} y2={210} />
          <FArrow x1={460} y1={254} x2={240} y2={400} label="YES" hot />
          <FArrow x1={740} y1={254} x2={960} y2={400} label="NO" />
          <FArrow x1={960} y1={472} x2={960} y2={530} />
        </svg>
      </Stage>
      <Params rows={[
        { k: 'DECISION', v: '菱形节点 · 中心问句' },
        { k: 'LABEL', v: 'YES / NO 标在线中点 mono caps' },
        { k: 'PATH', v: '主路径 (常态/成功) accent' },
      ]} />
    </SubSec>
  );
}

/* ── B3 · 决策树 ── */
function DecisionTree() {
  return (
    <SubSec name="B3 · 决策树 · Decision Tree" tag="MULTI-LEVEL JUDGMENT">
      <Stage pattern="dot" label="● B-ROLL · FLOW" labelR="07.B3">
        <div style={{ position: 'absolute', top: '6%', left: '6%' }}>
          <div className="meta" style={{ color: 'var(--accent)' }}>SHOULD I USE RAG?</div>
        </div>
        <svg viewBox="0 0 1400 640" preserveAspectRatio="xMidYMid meet" style={{ position: 'absolute', inset: 0, width: '100%', height: '100%' }}>
          {/* root */}
          <FNode x={580} y={50}  w={240} h={80} label="数据私有？" kind="diamond" />
          {/* level 2 */}
          <FNode x={280} y={240} w={240} h={80} label="更新频繁？" kind="diamond" />
          <FNode x={880} y={240} w={240} h={80} label="知识截止够？" kind="diamond" />
          {/* leaves */}
          <FNode x={40}  y={460} w={200} h={64} label="RAG ✓" hot />
          <FNode x={300} y={460} w={200} h={64} label="微调" />
          <FNode x={620} y={460} w={200} h={64} label="联网检索" />
          <FNode x={900} y={460} w={200} h={64} label="原生 LLM" />
          {/* arrows */}
          <FArrow x1={700} y1={130} x2={400} y2={240} label="YES" hot />
          <FArrow x1={700} y1={130} x2={1000} y2={240} label="NO" />
          <FArrow x1={360} y1={320} x2={140} y2={460} label="YES" hot />
          <FArrow x1={440} y1={320} x2={400} y2={460} label="NO" />
          <FArrow x1={960} y1={320} x2={720} y2={460} label="NO" />
          <FArrow x1={1040} y1={320} x2={1000} y2={460} label="YES" />
        </svg>
      </Stage>
      <Params rows={[
        { k: 'TREE', v: '根 → 决策菱形 → 叶矩形' },
        { k: 'LEAF', v: '终端节点宽 200 矮 · 推荐项 accent' },
        { k: 'EDGE', v: '主推荐路径 全程 accent 高亮' },
      ]} />
    </SubSec>
  );
}

/* ── B4 · 状态机 ── */
function StateMachine() {
  return (
    <SubSec name="B4 · 状态机 · State Machine" tag="STATES WITH TRANSITIONS">
      <Stage pattern="dot" label="● B-ROLL · FLOW" labelR="07.B4">
        <div style={{ position: 'absolute', top: '6%', left: '6%' }}>
          <div className="meta" style={{ color: 'var(--accent)' }}>AGENT STATE MACHINE</div>
        </div>
        <svg viewBox="0 0 1300 640" preserveAspectRatio="xMidYMid meet" style={{ position: 'absolute', inset: 0, width: '100%', height: '100%' }}>
          <FNode x={100} y={260} w={180} h={120} label="IDLE" kind="circle" />
          <FNode x={500} y={120} w={180} h={120} label="THINKING" kind="circle" hot />
          <FNode x={1000} y={260} w={180} h={120} label="ACTING" kind="circle" />
          <FNode x={500} y={420} w={180} h={120} label="WAITING" kind="circle" />
          <FArrow x1={280} y1={320} x2={500} y2={180} label="INVOKE" hot />
          <FArrow x1={680} y1={180} x2={1000} y2={320} label="PLAN" hot />
          <FArrow x1={1000} y1={320} x2={680} y2={480} label="CALL" />
          <FArrow x1={680} y1={480} x2={500} y2={480} dashed label="RESULT" />
          <FArrow x1={500} y1={480} x2={280} y2={320} label="DONE" />
          {/* self-loop on THINKING */}
          <path d="M 590 120 C 550 60, 650 60, 590 120" fill="none" stroke="var(--accent)" strokeWidth="1.5" />
          <text x="590" y="48" textAnchor="middle" fontFamily="var(--f-mono)" fontSize="12" letterSpacing="0.16em" fill="var(--accent)">REFLECT</text>
        </svg>
      </Stage>
      <Params rows={[
        { k: 'STATE', v: '圆形节点 · 名字 mono caps' },
        { k: 'TRANSITION', v: '箭头上方标事件名' },
        { k: 'SELF-LOOP', v: '弧形 · 表示自循环 (reflect / retry)' },
      ]} />
    </SubSec>
  );
}

/* ── B5 · 时序图 ── */
function Sequence() {
  const actors = ['用户', 'Frontend', 'API', 'LLM', 'DB'];
  const aw = 1300, ah = 640;
  const step = aw / (actors.length + 1);
  const calls = [
    { from: 0, to: 1, y: 130, l: 'submit(query)' },
    { from: 1, to: 2, y: 200, l: 'POST /chat' },
    { from: 2, to: 4, y: 270, l: 'embed + search', hot: true },
    { from: 4, to: 2, y: 320, l: 'chunks', dashed: true },
    { from: 2, to: 3, y: 390, l: 'complete()', hot: true },
    { from: 3, to: 2, y: 440, l: 'stream', dashed: true },
    { from: 2, to: 1, y: 500, l: 'SSE response', dashed: true },
    { from: 1, to: 0, y: 560, l: 'render', dashed: true },
  ];
  return (
    <SubSec name="B5 · 时序图 · Sequence" tag="API / INTERACTION TIMELINE">
      <Stage pattern="grid" label="● B-ROLL · FLOW" labelR="07.B5">
        <svg viewBox={`0 0 ${aw} ${ah}`} preserveAspectRatio="xMidYMid meet" style={{ position: 'absolute', inset: 0, width: '100%', height: '100%' }}>
          {actors.map((a, i) => {
            const x = (i + 1) * step;
            return (
              <g key={i}>
                <rect x={x - 70} y={40} width={140} height={48} rx="6" fill="var(--bg-card)" stroke="var(--line-2)" strokeWidth="1.5" />
                <text x={x} y={70} textAnchor="middle" fontFamily="var(--f-cn)" fontSize="18" fontWeight="600" fill="var(--fg)">{a}</text>
                <line x1={x} x2={x} y1={88} y2={ah - 20} stroke="var(--line)" strokeWidth="1" strokeDasharray="4 4" />
              </g>
            );
          })}
          {calls.map((c, i) => {
            const x1 = (c.from + 1) * step;
            const x2 = (c.to + 1) * step;
            return <FArrow key={i} x1={x1} y1={c.y} x2={x2} y2={c.y} hot={c.hot} dashed={c.dashed} label={c.l} />;
          })}
        </svg>
      </Stage>
      <Params rows={[
        { k: 'ACTOR', v: '顶部矩形 · 下垂虚线为生命线' },
        { k: 'CALL', v: '实线 = 同步请求 · 虚线 = 响应 / 异步' },
        { k: 'HOT', v: '关键调用 accent (主路径)' },
      ]} />
    </SubSec>
  );
}

/* ── B6 · 泳道图 ── */
function Swimlane() {
  const lanes = ['用户', 'AI', '人工'];
  const w = 1300, h = 580;
  const laneH = (h - 60) / lanes.length;
  const steps = [
    { lane: 0, x: 60,   l: '上传图片', s: 'INPUT' },
    { lane: 1, x: 280,  l: '自动标注', s: 'AUTO-LABEL', hot: true },
    { lane: 1, x: 500,  l: '置信度<0.7?', s: 'CHECK', kind: 'diamond' },
    { lane: 2, x: 760,  l: '人工复核', s: 'REVIEW', hot: true },
    { lane: 1, x: 1000, l: '回流训练', s: 'FEEDBACK' },
  ];
  const edges = [
    { a: 0, b: 1 }, { a: 1, b: 2 }, { a: 2, b: 3, label: 'YES', hot: true }, { a: 2, b: 4, label: 'NO' }, { a: 3, b: 4 },
  ];
  const cx = (s) => s.x + 100;
  const cy = (s) => 60 + s.lane * laneH + laneH / 2;
  return (
    <SubSec name="B6 · 泳道图 · Swimlane" tag="MULTI-ROLE PROCESS">
      <Stage pattern="dot" label="● B-ROLL · FLOW" labelR="07.B6">
        <svg viewBox={`0 0 ${w} ${h}`} preserveAspectRatio="xMidYMid meet" style={{ position: 'absolute', inset: 0, width: '100%', height: '100%' }}>
          {lanes.map((name, i) => (
            <g key={i}>
              <rect x={0} y={60 + i * laneH} width={w} height={laneH} fill={i % 2 ? 'rgba(255,255,255,.015)' : 'transparent'} stroke="var(--line)" strokeWidth="1" />
              <text x={20} y={60 + i * laneH + 24} fontFamily="var(--f-mono)" fontSize="12" letterSpacing="0.16em" fill="var(--accent)">LANE 0{i + 1}</text>
              <text x={20} y={60 + i * laneH + 50} fontFamily="var(--f-cn)" fontSize="22" fontWeight="800" fill="var(--fg)">{name}</text>
            </g>
          ))}
          {steps.map((s, i) => (
            <FNode key={i} x={s.x + 100} y={cy(s) - 36} w={180} h={72} label={s.l} sub={s.s} hot={s.hot} kind={s.kind} />
          ))}
          {edges.map((e, i) => {
            const sa = steps[e.a], sb = steps[e.b];
            const x1 = sa.x + 100 + 180, y1 = cy(sa);
            const x2 = sb.x + 100, y2 = cy(sb);
            return <FArrow key={i} x1={x1} y1={y1} x2={x2} y2={y2} label={e.label} hot={e.hot} />;
          })}
        </svg>
      </Stage>
      <Params rows={[
        { k: 'LANE', v: '横条 · 左侧 mono 标号 + 中文角色名' },
        { k: 'NODE', v: '位置编码角色 (在哪条泳道 = 谁来做)' },
        { k: 'HANDOFF', v: '跨泳道箭头 = 责任移交' },
      ]} />
    </SubSec>
  );
}

/* ── B7 · 并行 / 汇合 ── */
function ForkJoin() {
  return (
    <SubSec name="B7 · 并行 / 汇合 · Fork-Join" tag="PARALLEL EXECUTION">
      <Stage pattern="dot" label="● B-ROLL · FLOW" labelR="07.B7">
        <svg viewBox="0 0 1300 600" preserveAspectRatio="xMidYMid meet" style={{ position: 'absolute', inset: 0, width: '100%', height: '100%' }}>
          <FNode x={40} y={260} w={200} h={80} label="主控 Agent" sub="ORCHESTRATOR" hot />
          {/* fork bar */}
          <rect x={320} y={290} width={6} height={20} fill="var(--accent)" />
          <line x1={326} y1={300} x2={420} y2={120} stroke="var(--accent)" strokeWidth="1.5" />
          <line x1={326} y1={300} x2={420} y2={300} stroke="var(--accent)" strokeWidth="1.5" />
          <line x1={326} y1={300} x2={420} y2={480} stroke="var(--accent)" strokeWidth="1.5" />
          <text x={300} y={285} fontFamily="var(--f-mono)" fontSize="12" letterSpacing="0.16em" fill="var(--accent)" textAnchor="end">FORK</text>
          {/* parallel workers */}
          <FNode x={440} y={80} w={240} h={80} label="搜索 Agent" sub="WORKER 01" />
          <FNode x={440} y={260} w={240} h={80} label="计算 Agent" sub="WORKER 02" />
          <FNode x={440} y={440} w={240} h={80} label="检索 Agent" sub="WORKER 03" />
          {/* join bar */}
          <line x1={760} y1={120} x2={860} y2={300} stroke="var(--accent)" strokeWidth="1.5" />
          <line x1={760} y1={300} x2={860} y2={300} stroke="var(--accent)" strokeWidth="1.5" />
          <line x1={760} y1={480} x2={860} y2={300} stroke="var(--accent)" strokeWidth="1.5" />
          <rect x={860} y={290} width={6} height={20} fill="var(--accent)" />
          <text x={880} y={285} fontFamily="var(--f-mono)" fontSize="12" letterSpacing="0.16em" fill="var(--accent)">JOIN</text>
          <FArrow x1={866} y1={300} x2={1040} y2={300} />
          <FNode x={1040} y={260} w={220} h={80} label="合并结果" sub="MERGE" hot />
        </svg>
      </Stage>
      <Params rows={[
        { k: 'FORK BAR', v: '6×20 实心条 · accent 表示分发' },
        { k: 'WORKERS', v: '并排堆叠 · 数量 = 并发度' },
        { k: 'JOIN', v: '镜像 fork · 等所有 worker 完成' },
      ]} />
    </SubSec>
  );
}

/* ── B8 · 循环流程 ── */
function LoopFlow() {
  return (
    <SubSec name="B8 · 循环流程 · Loop" tag="ITERATIVE OPTIMIZATION">
      <Stage pattern="dot" label="● B-ROLL · FLOW" labelR="07.B8">
        <div style={{ position: 'absolute', top: '8%', left: '6%' }}>
          <div className="meta" style={{ color: 'var(--accent)' }}>RLHF · 4-STEP LOOP</div>
          <div className="cn" style={{ fontSize: 26, fontWeight: 800, marginTop: 4 }}>训练 → 推理 → 评估 → 再训练</div>
        </div>
        <svg viewBox="0 0 1200 640" preserveAspectRatio="xMidYMid meet" style={{ position: 'absolute', inset: 0, width: '100%', height: '100%' }}>
          {/* 4 nodes in a square */}
          <FNode x={420} y={120} w={220} h={80} label="生成响应" sub="01 · GENERATE" />
          <FNode x={780} y={260} w={220} h={80} label="人工评分" sub="02 · LABEL" hot />
          <FNode x={420} y={420} w={220} h={80} label="奖励模型" sub="03 · REWARD" />
          <FNode x={120} y={260} w={220} h={80} label="策略更新" sub="04 · UPDATE" hot />
          {/* curved arrows around */}
          <path d="M 640 160 C 760 160, 830 200, 830 260" fill="none" stroke="var(--line-3)" strokeWidth="1.5" markerEnd="" />
          <path d="M 890 340 C 890 400, 760 460, 640 460" fill="none" stroke="var(--accent)" strokeWidth="1.5" />
          <path d="M 420 460 C 300 460, 230 400, 230 340" fill="none" stroke="var(--line-3)" strokeWidth="1.5" />
          <path d="M 290 260 C 290 200, 360 160, 420 160" fill="none" stroke="var(--accent)" strokeWidth="1.5" />
          {/* arrow tips */}
          <polygon points="830,260 822,250 838,250" fill="var(--line-3)" />
          <polygon points="640,460 650,452 650,468" fill="var(--accent)" />
          <polygon points="230,340 222,330 238,330" fill="var(--line-3)" />
          <polygon points="420,160 410,152 410,168" fill="var(--accent)" />
          {/* center label */}
          <text x="600" y="310" textAnchor="middle" fontFamily="var(--f-mono)" fontSize="14" letterSpacing="0.2em" fill="var(--accent)">∞ ITERATE</text>
          <text x="600" y="340" textAnchor="middle" fontFamily="var(--f-cn)" fontSize="18" fontWeight="600" fill="var(--fg-2)">直到指标收敛</text>
        </svg>
      </Stage>
      <Params rows={[
        { k: 'LAYOUT', v: '4 节点环形排列 · 不要堆成线' },
        { k: 'EDGE', v: '弧线 · 形成闭环视觉' },
        { k: 'CENTER', v: '中心写 ∞ + 退出条件' },
      ]} />
    </SubSec>
  );
}

Object.assign(window, { FlowsSection });
CODEX_LAZYPACK_F4109629204EE1D8F417CD325F8AE6CB3F1C93A5

# video-spec-builder/Full Code/sections/broll-hero.jsx
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/video-spec-builder/Full Code/sections/broll-hero.jsx")"
cat > "{{CODEX_HOME}}/skills/video-spec-builder/Full Code/sections/broll-hero.jsx" <<'CODEX_LAZYPACK_921159C2B90B746E3C944BEB4E1B13AEB41D6713'
/* ================================================================
   sections/broll-hero.jsx — 04 · B-roll · 重锤（v3.1 编辑感升级）
   ================================================================ */

function HeroSection() {
  return (
    <Section id="hero" num="04" title="B-roll · 重锤"
      desc="撑满全屏的<b>重击</b>版式 —— 在 B-roll 段落之间制造节奏对比。<em>稀少 · 不堆叠</em>，一支视频用 2-3 次足够。">
      <BigType /><BigNumber /><PullQuote /><FlashCard />
    </Section>
  );
}

/* 通用：四角十字针脚 */
function Crosses({ accent = false }) {
  const cls = accent ? 'cross cross--accent' : 'cross';
  return (
    <>
      <span className={`${cls} cross--tl`} />
      <span className={`${cls} cross--tr`} />
      <span className={`${cls} cross--bl`} />
      <span className={`${cls} cross--br`} />
    </>
  );
}

/* ============== A · 大字海报 ============== */
function BigType() {
  return (
    <SubSec name="A · 大字海报 · Big Type" tag="TYPOGRAPHIC POSTER">
      <Stage pattern="dot" label="● B-ROLL · CHAPTER" labelR="04.A">
        {/* 左上：序号标记 */}
        <div style={{ position: 'absolute', top: '8%', left: '6%', display: 'flex', alignItems: 'baseline', gap: 14 }}>
          <span className="mono" style={{ fontSize: 11, letterSpacing: '0.2em', color: 'var(--fg-3)' }}>CHAPTER</span>
          <span className="mono" style={{ fontSize: 72, fontWeight: 800, color: 'var(--accent)', lineHeight: 1, letterSpacing: '-0.04em' }}>03</span>
        </div>
        {/* 右上：guide rule */}
        <div style={{ position: 'absolute', top: '8%', right: '6%', display: 'flex', alignItems: 'center', gap: 12 }}>
          <span className="mono" style={{ fontSize: 11, letterSpacing: '0.2em', color: 'var(--fg-3)' }}>CONTEXT IS EVERYTHING</span>
          <span style={{ width: 60, height: 1, background: 'var(--accent)' }} />
        </div>
        {/* 主标 */}
        <div style={{ position: 'absolute', inset: '32% 6% 18%', display: 'flex', flexDirection: 'column', justifyContent: 'flex-end' }}>
          <div className="cn" style={{ fontSize: 'clamp(64px, 9vw, 124px)', fontWeight: 800, letterSpacing: '-0.03em', lineHeight: 0.92 }}>
            模型不缺<br />
            <span className="serif" style={{ fontWeight: 400, fontStyle: 'italic', color: 'var(--accent)' }}>聪明，</span>
            缺材料。
          </div>
        </div>
        {/* 底栏：刻度 + 元信息 */}
        <div style={{ position: 'absolute', bottom: '8%', left: '6%', right: '6%', display: 'flex', alignItems: 'flex-end', justifyContent: 'space-between' }}>
          <div className="tick-rule" style={{ color: 'var(--fg-3)' }}>
            {Array.from({ length: 26 }).map((_, i) => <i key={i} />)}
          </div>
          <span className="mono" style={{ fontSize: 11, letterSpacing: '0.2em', color: 'var(--fg-3)' }}>01 / 12 · 03:42</span>
        </div>
      </Stage>
      <Params rows={[
        { k: 'SIZE @4K', v: '180-220px · 800' },
        { k: 'ACCENT',   v: '其中一字换 Instrument Serif italic' },
        { k: 'CHROME',   v: '左上 idx + 右上 rule + 底刻度 + 时码' },
        { k: 'ENTER',    v: '主字 1100ms · 角标 280ms 延迟' },
      ]} />
    </SubSec>
  );
}

/* ============== B · 大数字 ============== */
function BigNumber() {
  return (
    <SubSec name="B · 大数字 · Big Stat" tag="STATISTIC HERO">
      <Stage pattern="graph" label="● B-ROLL · STAT" labelR="04.B">
        {/* 左上 eyebrow */}
        <div style={{ position: 'absolute', top: '8%', left: '6%' }}>
          <div className="mono" style={{ fontSize: 11, letterSpacing: '0.2em', color: 'var(--accent)' }}>● FINDING / 2024Q4</div>
          <div className="serif" style={{ fontSize: 26, color: 'var(--fg-2)', fontStyle: 'italic', marginTop: 6 }}>State of AI Survey</div>
        </div>
        {/* 右上 source */}
        <div style={{ position: 'absolute', top: '8%', right: '6%', textAlign: 'right' }}>
          <div className="mono" style={{ fontSize: 11, letterSpacing: '0.2em', color: 'var(--fg-3)' }}>N = 2,840 · 12 COUNTRIES</div>
          <div className="mono" style={{ fontSize: 11, letterSpacing: '0.2em', color: 'var(--fg-3)', marginTop: 4 }}>METHOD · STRATIFIED · ±2.1%</div>
        </div>
        {/* 巨大数字 */}
        <div style={{ position: 'absolute', inset: '24% 6% 24%', display: 'flex', alignItems: 'center', justifyContent: 'flex-start' }}>
          <div className="big-num" style={{ fontSize: 'clamp(180px, 28vw, 360px)', color: 'var(--accent)' }}>
            87<span style={{ fontSize: '0.32em', color: 'var(--fg)', verticalAlign: '0.6em' }}>%</span>
          </div>
        </div>
        {/* 右侧 caption */}
        <div style={{ position: 'absolute', right: '6%', top: '38%', bottom: '24%', width: '38%', display: 'flex', flexDirection: 'column', justifyContent: 'center' }}>
          <div style={{ width: 32, height: 2, background: 'var(--accent)', marginBottom: 14 }} />
          <div className="cn" style={{ fontSize: 28, fontWeight: 800, lineHeight: 1.25, letterSpacing: '-0.01em' }}>
            of developers expect <span style={{ color: 'var(--accent)' }}>prompt engineering</span> to be replaced by <span className="serif" style={{ fontStyle: 'italic', fontWeight: 400 }}>context engineering</span>
          </div>
        </div>
        {/* 底部 dashed connector */}
        <div style={{ position: 'absolute', bottom: '10%', left: '6%', right: '6%', display: 'flex', alignItems: 'center', gap: 12 }}>
          <span className="mono" style={{ fontSize: 11, letterSpacing: '0.2em', color: 'var(--fg-3)' }}>STATUS · LIVE</span>
          <span style={{ flex: 1, height: 0, borderTop: '1px dashed var(--line-2)' }} />
          <span className="mono" style={{ fontSize: 11, letterSpacing: '0.2em', color: 'var(--fg-3)' }}>FIG. 04.B</span>
        </div>
      </Stage>
      <Params rows={[
        { k: 'NUMBER',  v: '280-360px · mono · accent · tabular-nums' },
        { k: 'UNIT',    v: '0.32em · fg · 上偏 0.6em' },
        { k: 'CAPTION', v: '28 / 800 · 32×2 accent rule' },
        { k: 'CHROME',  v: 'left finding · right method · footer dashed' },
      ]} />
    </SubSec>
  );
}

/* ============== C · 引用块 ============== */
function PullQuote() {
  return (
    <SubSec name="C · 引用块 · Pull Quote" tag="EDITORIAL MOMENT">
      <Stage label="● B-ROLL · QUOTE" labelR="04.C">
        {/* 左上分类 */}
        <div style={{ position: 'absolute', top: '8%', left: '6%', display: 'flex', alignItems: 'center', gap: 10 }}>
          <span style={{ width: 18, height: 1, background: 'var(--accent)' }} />
          <span className="mono" style={{ fontSize: 11, letterSpacing: '0.2em', color: 'var(--accent)' }}>ON CRAFT</span>
        </div>
        {/* 巨型左引号（装饰）*/}
        <div className="serif" style={{ position: 'absolute', top: '14%', left: '6%', fontSize: 280, fontStyle: 'italic', color: 'var(--accent)', opacity: 0.18, lineHeight: 0.7, fontWeight: 400 }}>"</div>
        {/* 引文主体 */}
        <div style={{ position: 'absolute', inset: '24% 10% 22% 10%', display: 'flex', flexDirection: 'column', justifyContent: 'center' }}>
          <div className="serif" style={{ fontSize: 'clamp(40px, 6vw, 76px)', lineHeight: 1.12, letterSpacing: '-0.01em', color: 'var(--fg)', fontStyle: 'italic', fontWeight: 400 }}>
            The model is a <span style={{ color: 'var(--accent)' }}>compiler,</span>
            <br />not an oracle.
            <br /><span style={{ color: 'var(--fg-2)' }}>You still own the spec.</span>
          </div>
        </div>
        {/* byline */}
        <div style={{ position: 'absolute', bottom: '10%', left: '10%', right: '10%', display: 'flex', alignItems: 'baseline', gap: 14 }}>
          <span style={{ width: 36, height: 1, background: 'var(--fg-3)' }} />
          <div>
            <div className="mono" style={{ fontSize: 12, letterSpacing: '0.2em', color: 'var(--fg)' }}>ANDREJ KARPATHY</div>
            <div className="mono" style={{ fontSize: 10, letterSpacing: '0.2em', color: 'var(--fg-3)', marginTop: 4 }}>FORMER TESLA AI · 2023</div>
          </div>
        </div>
      </Stage>
      <Params rows={[
        { k: 'FONT',   v: 'Instrument Serif italic · 76px' },
        { k: 'ACCENT', v: '一个关键词换 accent · 一句弱化 fg-2' },
        { k: 'MARK',   v: '巨型左引号 · opacity 0.18 装饰' },
        { k: 'BYLINE', v: 'mono caps + 36px rule' },
      ]} />
    </SubSec>
  );
}

/* ============== D · 反白闪屏 ============== */
function FlashCard() {
  const [flip, setFlip] = React.useState(false);
  React.useEffect(() => {
    const id = setInterval(() => setFlip(f => !f), 1400);
    return () => clearInterval(id);
  }, []);
  const inverted = flip;
  return (
    <SubSec name="D · 反白闪屏 · Inversion Flash" tag="CUT-IN TRANSITION">
      <Stage label="● B-ROLL · FLASH" labelR="04.D">
        <div style={{ position: 'absolute', inset: 0, background: inverted ? 'var(--bg-flash)' : 'var(--bg)', transition: 'background 200ms steps(1)' }}>
          {/* 四角十字 */}
          <span className="cross cross--tl" style={{ color: inverted ? 'rgba(0,0,0,0.4)' : 'var(--line)', top: '5%', left: '5%' }} />
          <span className="cross cross--tr" style={{ color: inverted ? 'rgba(0,0,0,0.4)' : 'var(--line)', top: '5%', right: '5%' }} />
          <span className="cross cross--bl" style={{ color: inverted ? 'rgba(0,0,0,0.4)' : 'var(--line)', bottom: '5%', left: '5%' }} />
          <span className="cross cross--br" style={{ color: inverted ? 'rgba(0,0,0,0.4)' : 'var(--line)', bottom: '5%', right: '5%' }} />
          {/* 左上小标 */}
          <div className="mono" style={{ position: 'absolute', top: '8%', left: '8%', fontSize: 11, letterSpacing: '0.2em', color: inverted ? 'var(--bg)' : 'var(--fg-3)' }}>● BEAT · STOP</div>
          {/* 主字 */}
          <div style={{ position: 'absolute', inset: 0, display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 32 }}>
            <span className="cn" style={{ fontSize: 'clamp(56px, 9vw, 112px)', fontWeight: 800, color: inverted ? 'var(--bg)' : 'var(--fg)', letterSpacing: '-0.03em' }}>
              等一下。
            </span>
          </div>
          {/* 右下时间码 */}
          <div className="mono" style={{ position: 'absolute', bottom: '8%', right: '8%', fontSize: 11, letterSpacing: '0.2em', color: inverted ? 'var(--bg)' : 'var(--fg-3)' }}>06 FR · 240 MS</div>
        </div>
      </Stage>
      <Params rows={[
        { k: 'USE',      v: '段落切换 · 修辞停顿 · 抛出问题前' },
        { k: 'DURATION', v: '6-12 帧（200-400ms）· 不超过 1s' },
        { k: 'SWAP',     v: 'bg ↔ bg-flash · steps(1) 瞬切' },
        { k: 'RULE',     v: '<b>每支视频 ≤ 2 次</b> · 不要连续' },
      ]} />
    </SubSec>
  );
}

Object.assign(window, { HeroSection });
CODEX_LAZYPACK_921159C2B90B746E3C944BEB4E1B13AEB41D6713

# video-spec-builder/Full Code/sections/broll-structure.jsx
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/video-spec-builder/Full Code/sections/broll-structure.jsx")"
cat > "{{CODEX_HOME}}/skills/video-spec-builder/Full Code/sections/broll-structure.jsx" <<'CODEX_LAZYPACK_9C8736BD574E3A2FD68D4BDC24224ACA987EB6F0'
/* ================================================================
   sections/broll-structure.jsx — 02 · 结构图
   ================================================================ */

function StructureSection() {
  return (
    <Section id="structure" num="02" title="B-roll · 结构图"
      desc="讲<b>流程 · 层级 · 收敛 · 包含</b>关系时用。每张图遵守同一条：<em>一根 hairline · 一个 mono 标签 · 一种强调色</em>。">
      <FlowChart />
      <Pyramid />
      <Funnel />
      <Concentric />
      <NodeGraph />
      <Spectrum />
    </Section>
  );
}

/* ---------- 流程图 ---------- */
function FlowChart() {
  const [hot, setHot] = React.useState(0);
  React.useEffect(() => {
    const id = setInterval(() => setHot(h => (h + 1) % 4), 900);
    return () => clearInterval(id);
  }, []);
  const steps = [
    { en: 'COLLECT', cn: '收集证据' },
    { en: 'ANALYZE', cn: '分析模式' },
    { en: 'LOCATE',  cn: '定位根因' },
    { en: 'VERIFY',  cn: '验证修复' },
  ];
  return (
    <SubSec name="流程图 · Flow Chart" tag="LINEAR PROCESS">
      <Stage pattern="dot" label="● B-ROLL" labelR="02.A">
        <div style={{
          position: 'absolute', inset: '20% 6%',
          display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 0,
          alignItems: 'center',
        }}>
          {steps.map((s, i) => (
            <React.Fragment key={i}>
              <div style={{
                padding: '28px 32px',
                background: i === hot ? 'var(--bg-card)' : 'transparent',
                border: i === hot ? '1px solid var(--accent)' : '1px solid var(--line)',
                borderRadius: 8,
                transition: 'all 400ms var(--ease-out)',
                opacity: i === hot ? 1 : i < hot ? 1 : 0.5,
              }}>
                <div className="meta" style={{ marginBottom: 14, color: i === hot ? 'var(--accent)' : 'var(--fg-3)' }}>
                  {String(i + 1).padStart(2, '0')} · {s.en}
                </div>
                <div className="cn" style={{ fontSize: 44, fontWeight: 800, letterSpacing: '-0.005em' }}>{s.cn}</div>
              </div>
              {i < 3 && (
                <div style={{ height: 1, background: i < hot ? 'var(--accent)' : 'var(--line-2)', width: '100%', position: 'relative', transition: 'background 400ms' }}>
                  <div style={{ position: 'absolute', right: -1, top: -3, width: 0, height: 0, borderLeft: '7px solid', borderLeftColor: i < hot ? 'var(--accent)' : 'var(--line-3)', borderTop: '4px solid transparent', borderBottom: '4px solid transparent', transition: 'border-left-color 400ms' }} />
                </div>
              )}
            </React.Fragment>
          ))}
        </div>
      </Stage>
      <Params rows={[
        { k: 'NODE', v: 'hairline → solid accent (hot)' },
        { k: 'ARROW', v: '1px line + 7px 三角箭头' },
        { k: 'RHYTHM', v: '900ms / step' },
        { k: 'PAST', v: '线 / 箭头变 accent · 节点正常' },
        { k: 'FUTURE', v: '透明度 0.5' },
      ]} />
    </SubSec>
  );
}

/* ---------- 金字塔 ---------- */
function Pyramid() {
  const layers = [
    { w: '32%', en: 'PEAK',   cn: '顶层 · 战略',  sub: '少而决定性' },
    { w: '52%', en: 'BRIDGE', cn: '中层 · 方法', sub: '可复用模式' },
    { w: '72%', en: 'BASE',   cn: '底层 · 执行', sub: '大量 / 重复' },
  ];
  return (
    <SubSec name="金字塔 · Pyramid" tag="HIERARCHY">
      <Stage pattern="dot" label="● B-ROLL" labelR="02.B">
        <div style={{ position: 'absolute', inset: '12% 8%', display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', gap: 8 }}>
          {layers.map((l, i) => (
            <div key={i} style={{
              width: l.w,
              border: '1px solid var(--line-2)',
              padding: '28px 32px',
              display: 'flex', justifyContent: 'space-between', alignItems: 'center',
              background: 'var(--bg-card)',
              borderRadius: 4,
            }}>
              <div>
                <div className="meta" style={{ marginBottom: 4, color: i === 0 ? 'var(--accent)' : 'var(--fg-3)' }}>{String(i + 1).padStart(2, '0')} · {l.en}</div>
                <div className="cn" style={{ fontSize: 40, fontWeight: 800, letterSpacing: '-0.005em' }}>{l.cn}</div>
              </div>
              <div className="cn" style={{ fontSize: 40, color: 'var(--fg-3)' }}>{l.sub}</div>
            </div>
          ))}
        </div>
      </Stage>
      <Params rows={[
        { k: 'WIDTHS', v: '32% / 52% / 72% — 黄金比' },
        { k: 'GAP', v: '8px · 不重叠' },
        { k: 'TOP HIGHLIGHT', v: '顶层 mono 标签 accent · 其余 fg-3' },
      ]} />
    </SubSec>
  );
}

/* ---------- 漏斗 ---------- */
function Funnel() {
  const stages = [
    { w: '80%', en: 'AWARE',    cn: '看见',   stat: '10,000' },
    { w: '58%', en: 'TRY',      cn: '试用',   stat: '1,800' },
    { w: '40%', en: 'COMMIT',   cn: '留存',   stat: '420' },
    { w: '22%', en: 'EVANGELIZE', cn: '传播', stat: '38' },
  ];
  return (
    <SubSec name="漏斗 · Funnel" tag="CONVERSION">
      <Stage pattern="dot" label="● B-ROLL" labelR="02.C">
        <div style={{ position: 'absolute', inset: '10% 8%', display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 6, justifyContent: 'center' }}>
          {stages.map((s, i) => (
            <div key={i} style={{
              width: s.w,
              border: '1px solid var(--line-2)',
              background: i === stages.length - 1 ? 'var(--bg-card)' : 'transparent',
              borderColor: i === stages.length - 1 ? 'var(--accent)' : 'var(--line-2)',
              padding: '28px 32px',
              display: 'flex', justifyContent: 'space-between', alignItems: 'center',
              borderRadius: 4,
            }}>
              <div>
                <div className="meta" style={{ color: i === stages.length - 1 ? 'var(--accent)' : 'var(--fg-3)' }}>{s.en}</div>
                <div className="cn" style={{ fontSize: 44, fontWeight: 800 }}>{s.cn}</div>
              </div>
              <div className="mono" style={{ fontSize: 40, fontWeight: 600, color: i === stages.length - 1 ? 'var(--accent)' : 'var(--fg-2)' }}>{s.stat}</div>
            </div>
          ))}
        </div>
      </Stage>
      <Params rows={[
        { k: 'WIDTHS', v: '80 → 58 → 40 → 22%' },
        { k: 'BOTTOM', v: 'accent 边框 · 最终留存' },
        { k: 'DATA COL', v: '右对齐 mono 数字' },
      ]} />
    </SubSec>
  );
}

/* ---------- 同心圆 ---------- */
function Concentric() {
  const rings = [
    { r: 240, en: 'BUSINESS',   cn: '业务' },
    { r: 180, en: 'PRODUCT',    cn: '产品' },
    { r: 120, en: 'EXPERIENCE', cn: '体验' },
    { r:  60, en: 'CORE',       cn: '核心' },
  ];
  return (
    <SubSec name="同心圆 · Concentric" tag="NESTED SCOPE">
      <Stage pattern="dot" label="● B-ROLL" labelR="02.D">
        <svg viewBox="-300 -200 600 400" style={{ position: 'absolute', inset: 0, width: '100%', height: '100%' }}>
          {rings.map((r, i) => (
            <g key={i}>
              <circle cx="0" cy="0" r={r.r} fill={i === rings.length - 1 ? 'var(--bg-card)' : 'transparent'} stroke={i === rings.length - 1 ? 'var(--accent)' : 'var(--line-2)'} strokeWidth="1" />
              <text x={r.r - 8} y="-4" textAnchor="end" fontSize="10" fontFamily="var(--f-mono)" letterSpacing="2" fill={i === rings.length - 1 ? 'var(--accent)' : 'var(--fg-3)'}>{r.en}</text>
              <text x={r.r - 8} y="12" textAnchor="end" fontSize="13" fontWeight="700" fontFamily="var(--f-cn)" fill="var(--fg-2)">{r.cn}</text>
            </g>
          ))}
        </svg>
      </Stage>
      <Params rows={[
        { k: 'RADII', v: '60 · 120 · 180 · 240' },
        { k: 'LABELS', v: '环顶部 · 右对齐 · mono + cn 双行' },
        { k: 'CORE', v: '填 bg-card + accent 描边' },
      ]} />
    </SubSec>
  );
}

/* ---------- 节点图 ---------- */
function NodeGraph() {
  const nodes = [
    { id: 'input',  x: 12, y: 50, en: 'INPUT',  cn: '输入',  hot: false },
    { id: 'router', x: 36, y: 50, en: 'ROUTER', cn: '路由',  hot: true },
    { id: 'a',      x: 64, y: 28, en: 'TOOL A', cn: '搜索',  hot: false },
    { id: 'b',      x: 64, y: 72, en: 'TOOL B', cn: '生成',  hot: false },
    { id: 'out',    x: 88, y: 50, en: 'OUTPUT', cn: '输出',  hot: false },
  ];
  const edges = [
    ['input', 'router'], ['router', 'a'], ['router', 'b'], ['a', 'out'], ['b', 'out'],
  ];
  const find = (id) => nodes.find(n => n.id === id);
  return (
    <SubSec name="节点图 · Node Graph" tag="ROUTING / WORKFLOW">
      <Stage pattern="dot" label="● B-ROLL" labelR="02.E">
        <svg viewBox="0 0 100 100" preserveAspectRatio="none" style={{ position: 'absolute', inset: 0, width: '100%', height: '100%' }}>
          {edges.map(([a, b], i) => {
            const A = find(a), B = find(b);
            return <line key={i} x1={A.x} y1={A.y} x2={B.x} y2={B.y} stroke="var(--line-2)" strokeWidth="0.2" vectorEffect="non-scaling-stroke" />;
          })}
        </svg>
        {nodes.map(n => (
          <div key={n.id} style={{
            position: 'absolute', left: `${n.x}%`, top: `${n.y}%`, transform: 'translate(-50%, -50%)',
            background: n.hot ? 'var(--bg-card)' : 'var(--bg)',
            border: n.hot ? '1px solid var(--accent)' : '1px solid var(--line-2)',
            borderRadius: 6, padding: '28px 32px', minWidth: 86, textAlign: 'center',
          }}>
            <div className="meta" style={{ color: n.hot ? 'var(--accent)' : 'var(--fg-3)', marginBottom: 2 }}>{n.en}</div>
            <div className="cn" style={{ fontSize: 44, fontWeight: 800 }}>{n.cn}</div>
          </div>
        ))}
      </Stage>
      <Params rows={[
        { k: 'EDGE', v: '1px line-2 · 不加箭头美化' },
        { k: 'NODE', v: '6px radius · padding 8/14' },
        { k: 'HOT', v: 'accent 描边 + bg-card 填充' },
      ]} />
    </SubSec>
  );
}

/* ---------- 谱系图 ---------- */
function Spectrum() {
  return (
    <SubSec name="谱系图 · Spectrum" tag="OPPOSITE AXIS">
      <Stage pattern="dot" label="● B-ROLL" labelR="02.F">
        <div style={{ position: 'absolute', inset: '32% 8%', display: 'flex', flexDirection: 'column' }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', marginBottom: 22 }}>
            <div>
              <div className="meta" style={{ marginBottom: 4 }}>← LEFT POLE</div>
              <div className="cn" style={{ fontSize: 44, fontWeight: 800 }}>规则驱动</div>
            </div>
            <div className="meta">SPECTRUM</div>
            <div style={{ textAlign: 'right' }}>
              <div className="meta" style={{ marginBottom: 4 }}>RIGHT POLE →</div>
              <div className="cn" style={{ fontSize: 44, fontWeight: 800 }}>智能体驱动</div>
            </div>
          </div>
          <div style={{ position: 'relative', height: 1, background: 'var(--line-2)' }}>
            <div style={{ position: 'absolute', left: 0, top: -3, width: 7, height: 7, background: 'var(--fg-2)', borderRadius: '50%', transform: 'translateY(-50%)' }} />
            <div style={{ position: 'absolute', right: 0, top: -3, width: 7, height: 7, background: 'var(--fg-2)', borderRadius: '50%', transform: 'translateY(-50%)' }} />
            <div style={{ position: 'absolute', left: '68%', top: -7, width: 14, height: 14, background: 'var(--accent)', borderRadius: '50%' }} />
          </div>
          <div style={{ position: 'relative', height: 24, marginTop: 12 }}>
            <div className="meta" style={{ position: 'absolute', left: '68%', transform: 'translateX(-50%)', color: 'var(--accent)' }}>当前 · CURRENT</div>
          </div>
        </div>
      </Stage>
      <Params rows={[
        { k: 'AXIS', v: '1px line-2 · 全宽' },
        { k: 'POLE DOTS', v: '7px 圆 · fg-2' },
        { k: 'MARKER', v: '14px 圆 · accent' },
        { k: 'USE', v: '讲对立 / 演进位置' },
      ]} />
    </SubSec>
  );
}

Object.assign(window, { StructureSection });
CODEX_LAZYPACK_9C8736BD574E3A2FD68D4BDC24224ACA987EB6F0

# video-spec-builder/Full Code/sections/broll-structures2.jsx
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/video-spec-builder/Full Code/sections/broll-structures2.jsx")"
cat > "{{CODEX_HOME}}/skills/video-spec-builder/Full Code/sections/broll-structures2.jsx" <<'CODEX_LAZYPACK_3813E6B1361EBDE31A865CAECEEE81A2BD6C2B0B'
/* ================================================================
   sections/broll-structures2.jsx — 08 · C 类 · 关系结构 7 款
   tree · mindmap · matrix-2x2 · venn · layered-stack ·
   hub-spoke · grid-map
   ================================================================ */

function Structures2Section() {
  return (
    <Section id="structures2" num="08" title="B-roll · 关系结构"
      desc="讲<b>层级 · 分类 · 定位 · 重叠</b>时用。共用语法：<em>hairline 边 + 形状即语义</em>（树=层级 / 矩阵=定位 / Venn=交集 / Stack=堆叠）。">
      <TreeChart /><MindMap /><Matrix2x2 /><VennDiagram />
      <LayeredStack /><HubSpoke /><GridMap />
    </Section>
  );
}

/* ── C6 · 树 / 组织图 ── */
function TreeChart() {
  return (
    <SubSec name="C6 · 树 · Tree / Taxonomy" tag="HIERARCHICAL CLASSIFICATION">
      <Stage pattern="dot" label="● B-ROLL · STRUCT" labelR="08.C6">
        <div style={{ position: 'absolute', top: '6%', left: '6%' }}>
          <div className="meta" style={{ color: 'var(--accent)' }}>LLM TAXONOMY</div>
          <div className="cn" style={{ fontSize: 26, fontWeight: 800, marginTop: 4 }}>生成式模型的分类</div>
        </div>
        <svg viewBox="0 0 1400 580" preserveAspectRatio="xMidYMid meet" style={{ position: 'absolute', inset: 0, width: '100%', height: '100%' }}>
          <FNode x={600} y={120} w={200} h={64} label="LLM" sub="ROOT" hot />
          {[
            { x: 120,  l: 'Encoder',    s: 'BERT 类' },
            { x: 460,  l: 'Decoder',    s: 'GPT 类', hot: true },
            { x: 800,  l: 'Encoder-Decoder', s: 'T5 类' },
            { x: 1140, l: 'MoE',        s: '稀疏激活' },
          ].map((n, i) => (
            <React.Fragment key={i}>
              <line x1={700} y1={184} x2={n.x + 140} y2={300} stroke={n.hot ? 'var(--accent)' : 'var(--line-2)'} strokeWidth="1.5" />
              <FNode x={n.x + 20} y={300} w={240} h={72} label={n.l} sub={n.s} hot={n.hot} />
            </React.Fragment>
          ))}
          {[
            { px: 480, x: 280, l: 'GPT-4' },
            { px: 480, x: 460, l: 'Codex' },
            { px: 480, x: 640, l: 'LLaMA' },
          ].map((n, i) => (
            <React.Fragment key={i}>
              <line x1={n.px + 120} y1={372} x2={n.x + 80} y2={460} stroke="var(--line-3)" strokeWidth="1" />
              <FNode x={n.x} y={460} w={160} h={56} label={n.l} />
            </React.Fragment>
          ))}
        </svg>
      </Stage>
      <Params rows={[
        { k: 'LAYOUT', v: '上下三层 · 根 → 类 → 实例' },
        { k: 'EDGE', v: '直线连接 · 主分支 accent' },
        { k: 'NODE', v: '层级越深 · 矩形越小' },
      ]} />
    </SubSec>
  );
}

/* ── C7 · 思维导图 ── */
function MindMap() {
  const branches = [
    { angle: -150, l: '数据准备', sub: ['清洗', '标注', '增广'] },
    { angle:  -90, l: '模型训练', sub: ['超参', '损失', '调度'], hot: true },
    { angle:  -30, l: '评估', sub: ['离线', '在线', 'A/B'] },
    { angle:   30, l: '部署', sub: ['编排', '监控'] },
    { angle:   90, l: '反馈', sub: ['用户', '指标', '回流'], hot: true },
    { angle:  150, l: '安全', sub: ['对齐', '红队'] },
  ];
  const cx = 700, cy = 320, r1 = 220, r2 = 360;
  const polar = (a, r) => [cx + r * Math.cos(a * Math.PI / 180), cy + r * Math.sin(a * Math.PI / 180)];
  return (
    <SubSec name="C7 · 思维导图 · Mind Map" tag="RADIAL DECOMPOSITION">
      <Stage pattern="dot" label="● B-ROLL · STRUCT" labelR="08.C7">
        <svg viewBox="0 0 1400 640" preserveAspectRatio="xMidYMid meet" style={{ position: 'absolute', inset: 0, width: '100%', height: '100%' }}>
          {/* center */}
          <circle cx={cx} cy={cy} r="64" fill="var(--accent)" />
          <text x={cx} y={cy + 6} textAnchor="middle" fontFamily="var(--f-cn)" fontSize="20" fontWeight="800" fill="var(--bg)">ML 系统</text>
          {branches.map((b, i) => {
            const [x1, y1] = polar(b.angle, r1);
            return (
              <g key={i}>
                <line x1={cx} y1={cy} x2={x1} y2={y1} stroke={b.hot ? 'var(--accent)' : 'var(--line-2)'} strokeWidth="1.5" />
                <circle cx={x1} cy={y1} r="8" fill={b.hot ? 'var(--accent)' : 'var(--fg-2)'} />
                <text x={x1 + (Math.cos(b.angle * Math.PI / 180) > 0 ? 18 : -18)} y={y1 + 6} textAnchor={Math.cos(b.angle * Math.PI / 180) > 0 ? 'start' : 'end'} fontFamily="var(--f-cn)" fontSize="20" fontWeight="800" fill={b.hot ? 'var(--accent)' : 'var(--fg)'}>{b.l}</text>
                {b.sub.map((s, si) => {
                  const a2 = b.angle + (si - (b.sub.length - 1) / 2) * 8;
                  const [x2, y2] = polar(a2, r2);
                  return (
                    <g key={si}>
                      <line x1={x1} y1={y1} x2={x2} y2={y2} stroke="var(--line-3)" strokeWidth="1" />
                      <text x={x2 + (Math.cos(a2 * Math.PI / 180) > 0 ? 12 : -12)} y={y2 + 4} textAnchor={Math.cos(a2 * Math.PI / 180) > 0 ? 'start' : 'end'} fontFamily="var(--f-cn)" fontSize="14" fill="var(--fg-2)">{s}</text>
                    </g>
                  );
                })}
              </g>
            );
          })}
        </svg>
      </Stage>
      <Params rows={[
        { k: 'CENTER', v: '实心 accent 圆 · 主题字反色' },
        { k: 'BRANCH', v: '一级文字粗 800 · 二级 14px' },
        { k: 'ANGLE', v: '主分支均匀放射 · 子分支微角度偏移' },
      ]} />
    </SubSec>
  );
}

/* ── C8 · 2x2 矩阵 ── */
function Matrix2x2() {
  const items = [
    { qx: 0, qy: 0, x: 22, y: 28, l: '研究模型' },
    { qx: 1, qy: 0, x: 78, y: 22, l: 'GPT-4', hot: true },
    { qx: 1, qy: 0, x: 68, y: 38, l: 'Codex', hot: true },
    { qx: 0, qy: 1, x: 28, y: 72, l: 'GPT-3.5' },
    { qx: 1, qy: 1, x: 72, y: 78, l: 'Sonnet' },
    { qx: 1, qy: 1, x: 82, y: 62, l: 'Gemini' },
  ];
  return (
    <SubSec name="C8 · 2x2 矩阵 · Matrix" tag="POSITIONING / QUADRANTS">
      <Stage pattern="grid" label="● B-ROLL · STRUCT" labelR="08.C8">
        <div style={{ position: 'absolute', inset: '8% 8% 8% 8%' }}>
          {/* axes */}
          <div style={{ position: 'absolute', inset: 0 }}>
            <div style={{ position: 'absolute', left: '50%', top: 0, bottom: 0, width: 1, background: 'var(--line-2)' }} />
            <div style={{ position: 'absolute', top: '50%', left: 0, right: 0, height: 1, background: 'var(--line-2)' }} />
          </div>
          {/* quadrant labels */}
          <div className="meta" style={{ position: 'absolute', top: 8, left: 16, color: 'var(--fg-3)' }}>LOW COST · LOW QUALITY</div>
          <div className="meta" style={{ position: 'absolute', top: 8, right: 16, color: 'var(--accent)' }}>★ HIGH COST · HIGH QUALITY</div>
          <div className="meta" style={{ position: 'absolute', bottom: 8, left: 16, color: 'var(--fg-3)' }}>SWEET SPOT (TARGET)</div>
          <div className="meta" style={{ position: 'absolute', bottom: 8, right: 16, color: 'var(--fg-3)' }}>OVERSPEND</div>
          {/* axis labels */}
          <div className="mono" style={{ position: 'absolute', left: '-3%', top: '50%', transform: 'rotate(-90deg) translateX(50%)', fontSize: 14, color: 'var(--fg-2)' }}>↑ QUALITY</div>
          <div className="mono" style={{ position: 'absolute', right: '46%', bottom: '-6%', fontSize: 14, color: 'var(--fg-2)' }}>COST →</div>
          {/* dots */}
          {items.map((it, i) => (
            <div key={i} style={{ position: 'absolute', left: `${it.x}%`, top: `${it.y}%`, transform: 'translate(-50%,-50%)', display: 'flex', alignItems: 'center', gap: 8 }}>
              <div style={{ width: it.hot ? 18 : 12, height: it.hot ? 18 : 12, borderRadius: '50%', background: it.hot ? 'var(--accent)' : 'rgba(255,255,255,.22)', border: '1.5px solid', borderColor: it.hot ? 'var(--accent)' : 'var(--fg-2)' }} />
              <span className="cn" style={{ fontSize: 16, fontWeight: it.hot ? 800 : 500, color: it.hot ? 'var(--accent)' : 'var(--fg-2)' }}>{it.l}</span>
            </div>
          ))}
        </div>
      </Stage>
      <Params rows={[
        { k: 'AXES', v: '十字 hairline · 四角注象限名' },
        { k: 'POINT', v: '色块 + 标签 · 重点项 accent + 800' },
        { k: 'STAR', v: '理想象限角落加 ★ 提示' },
      ]} />
    </SubSec>
  );
}

/* ── C9 · Venn 图 ── */
function VennDiagram() {
  return (
    <SubSec name="C9 · Venn 图" tag="INTERSECTION / UNION">
      <Stage pattern="dot" label="● B-ROLL · STRUCT" labelR="08.C9">
        <div style={{ position: 'absolute', top: '8%', left: '6%' }}>
          <div className="meta" style={{ color: 'var(--accent)' }}>AI ENGINEER · SKILL OVERLAP</div>
          <div className="cn" style={{ fontSize: 26, fontWeight: 800, marginTop: 4 }}>三角交集即"AI 工程师"</div>
        </div>
        <svg viewBox="0 0 1200 620" preserveAspectRatio="xMidYMid meet" style={{ position: 'absolute', inset: 0, width: '100%', height: '100%' }}>
          <circle cx="500" cy="340" r="200" fill="var(--accent)" fillOpacity="0.18" stroke="var(--accent)" strokeWidth="1.5" />
          <circle cx="700" cy="340" r="200" fill="rgba(255,255,255,.06)" stroke="rgba(255,255,255,.35)" strokeWidth="1.5" />
          <circle cx="600" cy="180" r="200" fill="rgba(255,255,255,.06)" stroke="rgba(255,255,255,.35)" strokeWidth="1.5" />
          <text x="600" y="80" textAnchor="middle" fontFamily="var(--f-cn)" fontSize="22" fontWeight="800" fill="var(--fg)">软件工程</text>
          <text x="340" y="380" textAnchor="middle" fontFamily="var(--f-cn)" fontSize="22" fontWeight="800" fill="var(--accent)">ML 知识</text>
          <text x="860" y="380" textAnchor="middle" fontFamily="var(--f-cn)" fontSize="22" fontWeight="800" fill="var(--fg)">产品直觉</text>
          {/* center intersection */}
          <circle cx="600" cy="300" r="6" fill="var(--accent)" />
          <text x="600" y="290" textAnchor="middle" fontFamily="var(--f-mono)" fontSize="12" letterSpacing="0.16em" fill="var(--accent)">★ INTERSECTION</text>
          <text x="600" y="330" textAnchor="middle" fontFamily="var(--f-cn)" fontSize="20" fontWeight="800" fill="var(--fg)">AI 工程师</text>
        </svg>
      </Stage>
      <Params rows={[
        { k: 'CIRCLE', v: '半透明填充 · hairline 描边' },
        { k: 'HIGHLIGHT', v: '主圈 accent 18% · 其它白 6%' },
        { k: 'INTERSECT', v: '交集中心 ★ + 名词 (整图灵魂)' },
      ]} />
    </SubSec>
  );
}

/* ── C10 · 分层堆栈 ── */
function LayeredStack() {
  const layers = [
    { l: 'L7 · UI',       sub: 'React · Vue', },
    { l: 'L6 · API',      sub: 'REST · GraphQL · WS' },
    { l: 'L5 · 业务',     sub: '编排 / Agent / 工作流', hot: true },
    { l: 'L4 · 模型',     sub: 'LLM · Vision · Audio', hot: true },
    { l: 'L3 · 数据',     sub: 'Vector / Cache / DB' },
    { l: 'L2 · 计算',     sub: 'GPU · CPU · K8s' },
    { l: 'L1 · 硬件',     sub: 'H100 / TPU / 网络' },
  ];
  return (
    <SubSec name="C10 · 分层堆栈 · Layered Stack" tag="ARCHITECTURE LAYERS">
      <Stage pattern="dot" label="● B-ROLL · STRUCT" labelR="08.C10">
        <div style={{ position: 'absolute', top: '6%', left: '6%' }}>
          <div className="meta" style={{ color: 'var(--accent)' }}>AI APP · 7-LAYER STACK</div>
        </div>
        <div style={{ position: 'absolute', inset: '18% 10% 6% 10%', display: 'flex', flexDirection: 'column', gap: 6 }}>
          {layers.map((L, i) => (
            <div key={i} style={{
              flex: 1,
              display: 'grid',
              gridTemplateColumns: '180px 1fr 200px',
              alignItems: 'center',
              padding: '0 28px',
              background: L.hot ? 'var(--bg-card)' : 'transparent',
              border: '1px solid',
              borderColor: L.hot ? 'var(--accent)' : 'var(--line)',
              borderRadius: 6,
            }}>
              <div className="mono" style={{ fontSize: 14, letterSpacing: '0.16em', color: L.hot ? 'var(--accent)' : 'var(--fg-3)' }}>{L.l}</div>
              <div className="cn" style={{ fontSize: 22, fontWeight: 800, color: L.hot ? 'var(--fg)' : 'var(--fg-2)' }}>{L.sub}</div>
              <div className="mono" style={{ fontSize: 12, letterSpacing: '0.16em', color: 'var(--fg-3)', textAlign: 'right' }}>{L.hot ? '★ FOCUS' : ''}</div>
            </div>
          ))}
        </div>
      </Stage>
      <Params rows={[
        { k: 'STACK', v: '上窄下宽视觉错觉 · 实际等高更稳' },
        { k: 'L 编号', v: '左侧 mono · 从上往下递减' },
        { k: 'FOCUS', v: '当前讨论层 · 边框 accent' },
      ]} />
    </SubSec>
  );
}

/* ── C11 · Hub & Spoke ── */
function HubSpoke() {
  const spokes = [
    { angle: 0,    l: 'GitHub', s: 'CODE' },
    { angle: 60,   l: 'Slack', s: 'COMM' },
    { angle: 120,  l: 'Notion', s: 'DOCS', hot: true },
    { angle: 180,  l: 'Calendar', s: 'TIME' },
    { angle: 240,  l: 'Linear', s: 'TASK', hot: true },
    { angle: 300,  l: 'Email', s: 'INBOX' },
  ];
  const cx = 700, cy = 320, r = 240;
  return (
    <SubSec name="C11 · Hub & Spoke" tag="CENTRALIZED SYSTEM">
      <Stage pattern="dot" label="● B-ROLL · STRUCT" labelR="08.C11">
        <svg viewBox="0 0 1400 640" preserveAspectRatio="xMidYMid meet" style={{ position: 'absolute', inset: 0, width: '100%', height: '100%' }}>
          {spokes.map((s, i) => {
            const x = cx + r * Math.cos(s.angle * Math.PI / 180);
            const y = cy + r * Math.sin(s.angle * Math.PI / 180);
            return (
              <g key={i}>
                <line x1={cx} y1={cy} x2={x} y2={y} stroke={s.hot ? 'var(--accent)' : 'var(--line-2)'} strokeWidth="1.5" strokeDasharray={s.hot ? undefined : '4 4'} />
                <FNode x={x - 100} y={y - 36} w={200} h={72} label={s.l} sub={s.s} hot={s.hot} />
              </g>
            );
          })}
          {/* hub */}
          <circle cx={cx} cy={cy} r="80" fill="var(--accent)" />
          <text x={cx} y={cy - 4} textAnchor="middle" fontFamily="var(--f-mono)" fontSize="13" letterSpacing="0.2em" fill="rgba(0,0,0,.55)">HUB</text>
          <text x={cx} y={cy + 24} textAnchor="middle" fontFamily="var(--f-cn)" fontSize="22" fontWeight="800" fill="var(--bg)">AI Agent</text>
        </svg>
      </Stage>
      <Params rows={[
        { k: 'HUB', v: '中心实心 accent 圆 80px' },
        { k: 'SPOKE', v: '6 个方向 · 主连虚线 + 重点实线' },
        { k: 'RULE', v: 'Hub 永远在视觉中心' },
      ]} />
    </SubSec>
  );
}

/* ── C12 · 网格地图 ── */
function GridMap() {
  // 8x5 cluster grid with active/idle/error states
  const cols = 12, rows = 6;
  const cells = [];
  for (let r = 0; r < rows; r++) for (let c = 0; c < cols; c++) {
    const seed = (r * 7 + c * 13) % 11;
    let state = 'idle';
    if (seed < 5) state = 'active';
    else if (seed === 7) state = 'error';
    cells.push({ r, c, state });
  }
  const colorMap = { active: 'var(--accent)', idle: 'rgba(255,255,255,.16)', error: 'var(--red)' };
  return (
    <SubSec name="C12 · 网格地图 · Grid Map" tag="CLUSTER TOPOLOGY">
      <Stage pattern="grid" label="● B-ROLL · STRUCT" labelR="08.C12">
        <div style={{ position: 'absolute', top: '6%', left: '6%' }}>
          <div className="meta" style={{ color: 'var(--accent)' }}>GPU CLUSTER · 72 NODES</div>
          <div className="cn" style={{ fontSize: 26, fontWeight: 800, marginTop: 4 }}>实时拓扑视图</div>
        </div>
        <div style={{ position: 'absolute', top: '6%', right: '6%', display: 'flex', gap: 18 }}>
          {[{ s: 'ACTIVE', c: colorMap.active, n: 32 }, { s: 'IDLE', c: colorMap.idle, n: 38 }, { s: 'ERROR', c: colorMap.error, n: 2 }].map(L => (
            <div key={L.s} style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
              <span style={{ width: 12, height: 12, background: L.c }} />
              <span className="mono" style={{ fontSize: 13, color: 'var(--fg-2)' }}>{L.s} · {L.n}</span>
            </div>
          ))}
        </div>
        <div style={{ position: 'absolute', inset: '30% 6% 8% 6%', display: 'grid', gridTemplateColumns: `repeat(${cols}, 1fr)`, gridTemplateRows: `repeat(${rows}, 1fr)`, gap: 8 }}>
          {cells.map((cell, i) => (
            <div key={i} style={{
              background: colorMap[cell.state],
              borderRadius: 2,
              animation: cell.state === 'active' ? 'pulse 2.4s ease-in-out infinite' : undefined,
              animationDelay: `${(cell.r + cell.c) * 0.08}s`,
            }} />
          ))}
        </div>
      </Stage>
      <Params rows={[
        { k: 'GRID', v: '12×6 单元格 · 间距 8px' },
        { k: 'STATE', v: '色映射：active accent · idle 16%白 · error red' },
        { k: 'ANIM', v: 'active 单元呼吸 pulse · 错位 delay' },
      ]} />
    </SubSec>
  );
}

Object.assign(window, { Structures2Section });
CODEX_LAZYPACK_3813E6B1361EBDE31A865CAECEEE81A2BD6C2B0B

# video-spec-builder/Full Code/sections/broll-thinking.jsx
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/video-spec-builder/Full Code/sections/broll-thinking.jsx")"
cat > "{{CODEX_HOME}}/skills/video-spec-builder/Full Code/sections/broll-thinking.jsx" <<'CODEX_LAZYPACK_25D0AF4670545E0ECB866A56085EF6A39FF81311'
/* ================================================================
   sections/broll-thinking.jsx — 09 · D 类 · 结构化思考 7 款
   compare-table · swot · fishbone · timeline · gantt · kanban · card-grid
   ================================================================ */

function ThinkingSection() {
  return (
    <Section id="thinking" num="09" title="B-roll · 结构化思考"
      desc="讲<b>比较 · 分析 · 时间 · 待办</b>时用。共用语法：<em>网格 + hairline 边框 + mono 表头</em>。模版化最强 → 直接套数据。">
      <CompareTable /><SWOT /><Fishbone /><TimelineRow />
      <Gantt /><KanbanBoard /><CardGrid />
    </Section>
  );
}

/* ── D1 · 对比表 ── */
function CompareTable() {
  const rows = [
    { k: '上下文长度',  vals: ['200K', '128K', '1M'],     winIdx: 2 },
    { k: '价格 / 1M',    vals: ['$3.00', '$2.50', '$1.25'], winIdx: 2 },
    { k: '中文表现',    vals: ['★★★★★', '★★★★☆', '★★★★☆'], winIdx: 0 },
    { k: '函数调用',    vals: ['原生', '原生', '原生'],     winIdx: null },
    { k: '视觉理解',    vals: ['支持', '支持', '支持'],     winIdx: null },
    { k: '免费层',      vals: ['—',    '—',    '✓'],        winIdx: 2 },
  ];
  const cols = ['GPT-4o', 'GPT-4o', 'Gemini 1.5'];
  return (
    <SubSec name="D1 · 对比表 · Comparison Table" tag="A VS B VS C">
      <Stage pattern="grid" label="● B-ROLL · THINK" labelR="09.D1">
        <div style={{ position: 'absolute', top: '6%', left: '6%' }}>
          <div className="meta" style={{ color: 'var(--accent)' }}>MODEL COMPARISON · 6 DIMENSIONS</div>
        </div>
        <div style={{ position: 'absolute', inset: '18% 6% 6% 6%' }}>
          {/* header */}
          <div style={{ display: 'grid', gridTemplateColumns: '1.2fr 1fr 1fr 1fr', borderBottom: '1px solid var(--line-2)', paddingBottom: 14, marginBottom: 14 }}>
            <div className="meta" style={{ color: 'var(--fg-3)' }}>DIMENSION</div>
            {cols.map((c, i) => (
              <div key={i} className="cn" style={{ fontSize: 20, fontWeight: 800, color: 'var(--fg)' }}>{c}</div>
            ))}
          </div>
          {/* rows */}
          {rows.map((r, ri) => (
            <div key={ri} style={{ display: 'grid', gridTemplateColumns: '1.2fr 1fr 1fr 1fr', alignItems: 'center', padding: '14px 0', borderBottom: '1px solid var(--line)' }}>
              <div className="cn" style={{ fontSize: 18, color: 'var(--fg-2)' }}>{r.k}</div>
              {r.vals.map((v, vi) => (
                <div key={vi} className="mono" style={{ fontSize: 18, fontWeight: vi === r.winIdx ? 800 : 400, color: vi === r.winIdx ? 'var(--accent)' : 'var(--fg)' }}>
                  {vi === r.winIdx && <span style={{ marginRight: 6, color: 'var(--accent)' }}>★</span>}
                  {v}
                </div>
              ))}
            </div>
          ))}
        </div>
      </Stage>
      <Params rows={[
        { k: 'HEADER', v: '左 mono caps 维度 · 右 cn 800 候选名' },
        { k: 'WIN', v: '该行最优 accent + ★ 前缀' },
        { k: 'ROW', v: 'hairline 分隔 · 不画竖线' },
      ]} />
    </SubSec>
  );
}

/* ── D2 · SWOT ── */
function SWOT() {
  const quads = [
    { k: 'S', name: 'STRENGTHS',     cn: '优势', tone: 'accent', items: ['模型质量行业第一', '中文语料丰富', '安全对齐扎实'] },
    { k: 'W', name: 'WEAKNESSES',    cn: '劣势', tone: 'fg',     items: ['推理成本偏高', '上下文短于竞品'] },
    { k: 'O', name: 'OPPORTUNITIES', cn: '机会', tone: 'accent', items: ['企业 RAG 市场', 'Agent 标准化', '端侧推理'] },
    { k: 'T', name: 'THREATS',       cn: '威胁', tone: 'fg',     items: ['开源追赶速度', '价格战', '监管不确定'] },
  ];
  return (
    <SubSec name="D2 · SWOT 四宫格" tag="STRATEGIC ANALYSIS">
      <Stage pattern="grid" label="● B-ROLL · THINK" labelR="09.D2">
        <div style={{ position: 'absolute', inset: '6%', display: 'grid', gridTemplateColumns: '1fr 1fr', gridTemplateRows: '1fr 1fr', gap: 16 }}>
          {quads.map((q, i) => (
            <div key={i} style={{
              border: '1px solid',
              borderColor: q.tone === 'accent' ? 'var(--accent)' : 'var(--line-2)',
              background: q.tone === 'accent' ? 'rgba(255,107,61,.04)' : 'transparent',
              padding: '28px 32px',
              display: 'flex',
              flexDirection: 'column',
              gap: 18,
            }}>
              <div style={{ display: 'flex', alignItems: 'baseline', gap: 14, borderBottom: '1px solid var(--line)', paddingBottom: 14 }}>
                <div className="mono" style={{ fontSize: 56, fontWeight: 800, color: q.tone === 'accent' ? 'var(--accent)' : 'var(--fg-3)', lineHeight: 1 }}>{q.k}</div>
                <div>
                  <div className="meta" style={{ color: q.tone === 'accent' ? 'var(--accent)' : 'var(--fg-3)' }}>{q.name}</div>
                  <div className="cn" style={{ fontSize: 24, fontWeight: 800 }}>{q.cn}</div>
                </div>
              </div>
              <ul style={{ listStyle: 'none', padding: 0, margin: 0, display: 'flex', flexDirection: 'column', gap: 10 }}>
                {q.items.map((it, ii) => (
                  <li key={ii} className="cn" style={{ fontSize: 17, color: 'var(--fg-2)', position: 'relative', paddingLeft: 18 }}>
                    <span style={{ position: 'absolute', left: 0, top: 9, width: 8, height: 1, background: q.tone === 'accent' ? 'var(--accent)' : 'var(--fg-3)' }} />
                    {it}
                  </li>
                ))}
              </ul>
            </div>
          ))}
        </div>
      </Stage>
      <Params rows={[
        { k: 'QUAD', v: '2×2 等宽 · S/O 同色 (正向) · W/T 中性' },
        { k: 'LETTER', v: 'mono 800 · 56px · 整格视觉锚' },
        { k: 'ITEM', v: '8px 横杠 + 中文项 (不用圆点)' },
      ]} />
    </SubSec>
  );
}

/* ── D3 · 鱼骨图 ── */
function Fishbone() {
  const causes = [
    { side: 'top',    x: 220, l: '人员',  items: ['经验不足', '沟通不畅'] },
    { side: 'top',    x: 460, l: '方法',  items: ['流程缺失', '复审跳过'], hot: true },
    { side: 'top',    x: 700, l: '工具',  items: ['监控缺失'] },
    { side: 'bottom', x: 340, l: '环境',  items: ['代码冻结期'] },
    { side: 'bottom', x: 580, l: '数据',  items: ['训练集偏斜', '冷启动'] },
    { side: 'bottom', x: 820, l: '反馈',  items: ['延迟过长'], hot: true },
  ];
  return (
    <SubSec name="D3 · 鱼骨图 · Fishbone" tag="ROOT CAUSE ANALYSIS">
      <Stage pattern="dot" label="● B-ROLL · THINK" labelR="09.D3">
        <svg viewBox="0 0 1200 520" preserveAspectRatio="xMidYMid meet" style={{ position: 'absolute', inset: 0, width: '100%', height: '100%' }}>
          {/* spine */}
          <line x1="80" y1="260" x2="1040" y2="260" stroke="var(--line-2)" strokeWidth="2" />
          <polygon points="1040,260 1028,252 1028,268" fill="var(--accent)" />
          {/* head */}
          <rect x="1040" y="220" width="120" height="80" rx="6" fill="var(--accent)" />
          <text x="1100" y="248" textAnchor="middle" fontFamily="var(--f-mono)" fontSize="11" letterSpacing="0.16em" fill="rgba(0,0,0,.55)">PROBLEM</text>
          <text x="1100" y="276" textAnchor="middle" fontFamily="var(--f-cn)" fontSize="18" fontWeight="800" fill="var(--bg)">线上事故</text>
          {/* bones */}
          {causes.map((c, i) => {
            const yEnd = c.side === 'top' ? 80 : 440;
            const y0 = 260;
            const c0 = c.hot ? 'var(--accent)' : 'var(--line-2)';
            return (
              <g key={i}>
                <line x1={c.x} y1={y0} x2={c.x - (c.side === 'top' ? 80 : -80)} y2={yEnd} stroke={c0} strokeWidth="1.5" />
                <text x={c.x - (c.side === 'top' ? 90 : -90)} y={yEnd + (c.side === 'top' ? -8 : 18)} textAnchor={c.side === 'top' ? 'end' : 'start'} fontFamily="var(--f-cn)" fontSize="18" fontWeight="800" fill={c.hot ? 'var(--accent)' : 'var(--fg)'}>{c.l}</text>
                {c.items.map((it, ii) => {
                  const dy = c.side === 'top' ? -50 - ii * 32 : 50 + ii * 32;
                  const xMid = c.x + (c.side === 'top' ? -40 : 40) - (c.side === 'top' ? 80 : -80) * (Math.abs(dy) / 180);
                  return (
                    <g key={ii}>
                      <line x1={xMid} y1={y0 + dy} x2={xMid + (c.side === 'top' ? -30 : 30)} y2={y0 + dy} stroke="var(--line-3)" strokeWidth="1" />
                      <text x={xMid + (c.side === 'top' ? -38 : 38)} y={y0 + dy + 5} textAnchor={c.side === 'top' ? 'end' : 'start'} fontFamily="var(--f-cn)" fontSize="14" fill="var(--fg-2)">{it}</text>
                    </g>
                  );
                })}
              </g>
            );
          })}
        </svg>
      </Stage>
      <Params rows={[
        { k: 'SPINE', v: '主干水平 · 头为问题 · 尾向左' },
        { k: 'BONES', v: '6 类成因斜插 · 主因 accent' },
        { k: 'SUB', v: '小刺横向 · 14px 细节因素' },
      ]} />
    </SubSec>
  );
}

/* ── D4 · 时间线 ── */
function TimelineRow() {
  const events = [
    { d: '2017',  l: 'Attention Is All You Need', s: 'TRANSFORMER' },
    { d: '2020',  l: 'GPT-3 · 175B 参数',         s: 'SCALING LAW', hot: true },
    { d: '2022',  l: 'ChatGPT 发布',              s: 'PUBLIC AI', hot: true },
    { d: '2023',  l: 'GPT-4 · 多模态',            s: 'MULTIMODAL' },
    { d: '2024',  l: 'GPT-4o · Agent',        s: 'TOOL USE', hot: true },
    { d: '2025+', l: '?',                          s: 'AGI?' },
  ];
  return (
    <SubSec name="D4 · 时间线 · Timeline" tag="HISTORICAL EVOLUTION">
      <Stage pattern="grid" label="● B-ROLL · THINK" labelR="09.D4">
        <div style={{ position: 'absolute', top: '8%', left: '6%' }}>
          <div className="meta" style={{ color: 'var(--accent)' }}>LLM HISTORY · 8 YEARS</div>
          <div className="cn" style={{ fontSize: 28, fontWeight: 800, marginTop: 4 }}>从 Transformer 到 Agent</div>
        </div>
        <div style={{ position: 'absolute', inset: '36% 4% 14% 4%' }}>
          {/* line */}
          <div style={{ position: 'absolute', top: '50%', left: 0, right: 0, height: 1, background: 'var(--line-2)' }} />
          {/* events */}
          <div style={{ position: 'absolute', inset: 0, display: 'grid', gridTemplateColumns: `repeat(${events.length}, 1fr)` }}>
            {events.map((e, i) => (
              <div key={i} style={{ position: 'relative', display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center' }}>
                {/* dot */}
                <div style={{ position: 'absolute', top: '50%', left: '50%', transform: 'translate(-50%,-50%)', width: e.hot ? 18 : 10, height: e.hot ? 18 : 10, borderRadius: '50%', background: e.hot ? 'var(--accent)' : 'var(--fg-2)', border: '2px solid var(--bg)' }} />
                {/* upper card */}
                {i % 2 === 0 && (
                  <div style={{ position: 'absolute', bottom: 'calc(50% + 24px)', textAlign: 'center', width: '90%' }}>
                    <div className="meta" style={{ color: e.hot ? 'var(--accent)' : 'var(--fg-3)' }}>{e.s}</div>
                    <div className="cn" style={{ fontSize: 18, fontWeight: 800, marginTop: 4, color: e.hot ? 'var(--fg)' : 'var(--fg-2)' }}>{e.l}</div>
                  </div>
                )}
                {/* date */}
                <div className="mono" style={{ position: 'absolute', top: 'calc(50% + 20px)', fontSize: 22, fontWeight: 800, color: e.hot ? 'var(--accent)' : 'var(--fg-2)' }}>{e.d}</div>
                {/* lower card */}
                {i % 2 === 1 && (
                  <div style={{ position: 'absolute', top: 'calc(50% + 56px)', textAlign: 'center', width: '90%' }}>
                    <div className="meta" style={{ color: e.hot ? 'var(--accent)' : 'var(--fg-3)' }}>{e.s}</div>
                    <div className="cn" style={{ fontSize: 18, fontWeight: 800, marginTop: 4, color: e.hot ? 'var(--fg)' : 'var(--fg-2)' }}>{e.l}</div>
                  </div>
                )}
              </div>
            ))}
          </div>
        </div>
      </Stage>
      <Params rows={[
        { k: 'AXIS', v: '水平 hairline · 等距分布' },
        { k: 'EVENT', v: '上下交错卡片 · 减少拥挤' },
        { k: 'DOT', v: '关键事件 accent + 大尺寸' },
      ]} />
    </SubSec>
  );
}

/* ── D5 · 甘特图 ── */
function Gantt() {
  const tasks = [
    { l: '需求评审',     start: 0,  dur: 1, color: 'fg-2' },
    { l: '架构设计',     start: 1,  dur: 2, color: 'fg-2' },
    { l: '模型训练',     start: 2,  dur: 4, color: 'accent' },
    { l: '联调测试',     start: 5,  dur: 2, color: 'fg-2' },
    { l: '灰度上线',     start: 7,  dur: 1, color: 'accent' },
    { l: '复盘',         start: 8,  dur: 1, color: 'fg-2' },
  ];
  const weeks = 10;
  return (
    <SubSec name="D5 · 甘特图 · Gantt" tag="PROJECT TIMELINE">
      <Stage pattern="grid" label="● B-ROLL · THINK" labelR="09.D5">
        <div style={{ position: 'absolute', top: '6%', left: '6%' }}>
          <div className="meta" style={{ color: 'var(--accent)' }}>RAG V2 · Q1 ROADMAP</div>
        </div>
        <div style={{ position: 'absolute', inset: '16% 4% 6% 4%' }}>
          {/* week header */}
          <div style={{ display: 'grid', gridTemplateColumns: `200px repeat(${weeks}, 1fr)`, borderBottom: '1px solid var(--line-2)', paddingBottom: 10, marginBottom: 14 }}>
            <div />
            {Array.from({ length: weeks }, (_, i) => (
              <div key={i} className="meta" style={{ textAlign: 'center', color: 'var(--fg-3)' }}>W{i + 1}</div>
            ))}
          </div>
          {/* rows */}
          <div style={{ display: 'flex', flexDirection: 'column', gap: 14 }}>
            {tasks.map((t, i) => (
              <div key={i} style={{ display: 'grid', gridTemplateColumns: `200px repeat(${weeks}, 1fr)`, alignItems: 'center', gap: 0 }}>
                <div className="cn" style={{ fontSize: 17, fontWeight: 600, color: 'var(--fg)' }}>{t.l}</div>
                {Array.from({ length: weeks }, (_, ci) => {
                  const active = ci >= t.start && ci < t.start + t.dur;
                  return (
                    <div key={ci} style={{
                      height: 26,
                      margin: '0 2px',
                      background: active ? (t.color === 'accent' ? 'var(--accent)' : 'rgba(255,255,255,.22)') : 'transparent',
                      borderRadius: 2,
                    }} />
                  );
                })}
              </div>
            ))}
          </div>
        </div>
      </Stage>
      <Params rows={[
        { k: 'GRID', v: '左列任务名 · 右侧周柱' },
        { k: 'BAR', v: '高 26px · 2px 圆角 · 关键里程碑 accent' },
        { k: 'HEADER', v: 'W1-W10 mono caps · hairline 分隔' },
      ]} />
    </SubSec>
  );
}

/* ── D6 · Kanban ── */
function KanbanBoard() {
  const cols = [
    { l: 'BACKLOG',     cn: '待办',  items: [
      { t: '调研 Embedding v3', tag: 'RESEARCH' },
      { t: '修复缓存 TTL', tag: 'BUG' },
      { t: '文档更新', tag: 'DOC' },
    ] },
    { l: 'IN PROGRESS', cn: '进行中', hot: true, items: [
      { t: 'Reranker 训练', tag: 'ML', hot: true },
      { t: 'Agent 工具集成', tag: 'FEATURE', hot: true },
    ] },
    { l: 'REVIEW',      cn: '复审',  items: [
      { t: '提示词模板库', tag: 'DESIGN' },
    ] },
    { l: 'DONE',        cn: '完成',  items: [
      { t: '上线 v2.3', tag: 'RELEASE' },
      { t: '性能基线建立', tag: 'INFRA' },
      { t: '团队培训', tag: 'OPS' },
    ] },
  ];
  return (
    <SubSec name="D6 · Kanban 看板" tag="STATUS COLUMNS">
      <Stage pattern="dot" label="● B-ROLL · THINK" labelR="09.D6">
        <div style={{ position: 'absolute', top: '6%', left: '6%' }}>
          <div className="meta" style={{ color: 'var(--accent)' }}>TEAM SPRINT · WEEK 24</div>
        </div>
        <div style={{ position: 'absolute', inset: '16% 4% 6% 4%', display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 16 }}>
          {cols.map((c, i) => (
            <div key={i} style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
              <div style={{ paddingBottom: 12, borderBottom: '1px solid', borderColor: c.hot ? 'var(--accent)' : 'var(--line-2)' }}>
                <div className="meta" style={{ color: c.hot ? 'var(--accent)' : 'var(--fg-3)' }}>{c.l} · {c.items.length}</div>
                <div className="cn" style={{ fontSize: 20, fontWeight: 800, marginTop: 4, color: c.hot ? 'var(--accent)' : 'var(--fg)' }}>{c.cn}</div>
              </div>
              {c.items.map((it, ii) => (
                <div key={ii} style={{
                  background: 'var(--bg-card)',
                  border: '1px solid',
                  borderColor: it.hot ? 'var(--accent)' : 'var(--line)',
                  borderRadius: 6,
                  padding: 16,
                }}>
                  <div className="meta" style={{ marginBottom: 8, color: it.hot ? 'var(--accent)' : 'var(--fg-3)' }}>{it.tag}</div>
                  <div className="cn" style={{ fontSize: 16, fontWeight: 600, color: 'var(--fg)' }}>{it.t}</div>
                </div>
              ))}
            </div>
          ))}
        </div>
      </Stage>
      <Params rows={[
        { k: 'COL', v: '4 列等宽 · 当前列 accent 头' },
        { k: 'CARD', v: '上 mono 标签 · 下 中文 任务' },
        { k: 'COUNT', v: '列头跟数量 · 一眼看负载' },
      ]} />
    </SubSec>
  );
}

/* ── D7 · 卡片网格 ── */
function CardGrid() {
  const items = [
    { n: '01', l: 'Chain-of-Thought', s: '让模型分步推理' },
    { n: '02', l: 'Few-Shot', s: '示例引导格式', hot: true },
    { n: '03', l: 'ReAct', s: '思考 + 行动循环' },
    { n: '04', l: 'Self-Consistency', s: '采样多次取多数' },
    { n: '05', l: 'Tree of Thoughts', s: '搜索式推理树' },
    { n: '06', l: 'Reflexion', s: '失败后自我反思', hot: true },
    { n: '07', l: 'RAG', s: '检索增强生成' },
    { n: '08', l: 'Function Call', s: '工具调用结构化' },
  ];
  return (
    <SubSec name="D7 · 卡片网格 · Card Grid" tag="CONCEPT GALLERY">
      <Stage pattern="dot" label="● B-ROLL · THINK" labelR="09.D7">
        <div style={{ position: 'absolute', top: '6%', left: '6%' }}>
          <div className="meta" style={{ color: 'var(--accent)' }}>PROMPTING TECHNIQUES · 8 PATTERNS</div>
        </div>
        <div style={{ position: 'absolute', inset: '18% 4% 6% 4%', display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gridTemplateRows: 'repeat(2, 1fr)', gap: 16 }}>
          {items.map((it, i) => (
            <div key={i} style={{
              background: it.hot ? 'var(--bg-card)' : 'transparent',
              border: '1px solid',
              borderColor: it.hot ? 'var(--accent)' : 'var(--line)',
              borderRadius: 6,
              padding: 22,
              display: 'flex',
              flexDirection: 'column',
              justifyContent: 'space-between',
            }}>
              <div className="mono" style={{ fontSize: 14, letterSpacing: '0.2em', color: it.hot ? 'var(--accent)' : 'var(--fg-3)' }}>{it.n}</div>
              <div>
                <div className="cn" style={{ fontSize: 22, fontWeight: 800, color: 'var(--fg)', marginBottom: 6 }}>{it.l}</div>
                <div className="cn" style={{ fontSize: 14, color: 'var(--fg-2)' }}>{it.s}</div>
              </div>
            </div>
          ))}
        </div>
      </Stage>
      <Params rows={[
        { k: 'GRID', v: '4×2 · 等宽等高 · 16px gap' },
        { k: 'CARD', v: '左上编号 + 左下标题 + 副标' },
        { k: 'HOT', v: '推荐项整张 fill bg-card + accent 边' },
      ]} />
    </SubSec>
  );
}

Object.assign(window, { ThinkingSection });
CODEX_LAZYPACK_25D0AF4670545E0ECB866A56085EF6A39FF81311

# video-spec-builder/Full Code/sections/broll-ui.jsx
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/video-spec-builder/Full Code/sections/broll-ui.jsx")"
cat > "{{CODEX_HOME}}/skills/video-spec-builder/Full Code/sections/broll-ui.jsx" <<'CODEX_LAZYPACK_A506CA78530ACBA0A5A45F4FED388B94EB89A311'
/* ================================================================
   sections/broll-ui.jsx — 03 · B-roll · 仿真 UI
   终端 · 浏览器 · 对话 · 代码 · API · 仪表盘
   ================================================================ */
function FakeUISection() {
  return (
    <Section id="ui" num="03" title="B-roll · 仿真 UI"
      desc="讲 AI 教程必备：<b>终端 · 浏览器 · 对话 · 代码 · API · 仪表盘</b>。所有 UI mock 共享同一规则 —— <em>极简</em>、<em>真实可信</em>、<em>不要拟物窗口</em>。窗口装饰只保留三个灰点 + 一条 hairline 头。">
      <Terminal />
      <Chat />
      <Browser />
      <CodeEditor />
      <ApiCall />
      <Dashboard />
    </Section>
  );
}

/* ---------- A · Terminal ---------- */
function Terminal() {
  const [chars, setChars] = React.useState(0);
  const cmd = '$ codex run "explain RAG in one line"';
  React.useEffect(() => {
    const id = setInterval(() => setChars(c => (c >= cmd.length ? 0 : c + 1)), 60);
    return () => clearInterval(id);
  }, []);
  return (
    <SubSec name="终端 · Terminal" tag="CLI MOCK">
      <Stage pattern="dot" label="● B-ROLL" labelR="03.A">
        <WindowChrome title="~/projects/rag-demo · zsh">
          <div className="mono" style={{ padding: '28px 32px', fontSize: 30, lineHeight: 1.75, color: 'var(--fg)' }}>
            <span style={{ color: 'var(--accent)' }}>{cmd.slice(0, chars)}</span>
            <span style={{ display: 'inline-block', width: 10, height: 18, background: 'var(--accent)', verticalAlign: '-3px', animation: 'cb 1s steps(2) infinite' }} />
            <div style={{ color: 'var(--fg-2)', marginTop: 14 }}>→ Retrieval-Augmented Generation: 给模型外接资料库再生成。</div>
            <div style={{ color: 'var(--fg-3)', marginTop: 6, fontSize: 22 }}>↳ tokens 23 · 412ms · $0.0008</div>
          </div>
        </WindowChrome>
        <style>{`@keyframes cb { 50% { opacity: 0 } }`}</style>
      </Stage>
      <Params rows={[
        { k: 'FONT', v: 'Geist Mono 30px (within stage)' },
        { k: 'BG', v: 'var(--bg-card) · hairline border' },
        { k: 'CURSOR', v: '10×18 实块 · 1s blink · accent' },
        { k: 'TYPE SPEED', v: '60ms / char' },
        { k: 'META TAIL', v: 'tokens · 延迟 · $ 成本（fg-3）' },
      ]} />
    </SubSec>
  );
}

/* ---------- B · Chat ---------- */
function Chat() {
  return (
    <SubSec name="对话流 · Chat Thread" tag="LLM CONVERSATION">
      <Stage pattern="dot" label="● B-ROLL" labelR="03.B">
        <div style={{ position: 'absolute', inset: '10% 16%', display: 'flex', flexDirection: 'column', gap: 14 }}>
          <Bubble role="user">RAG 跟 fine-tuning 啥区别？</Bubble>
          <Bubble role="ai">RAG 是<span style={{ color: 'var(--accent)' }}>开卷考试</span>—— 临时查资料。fine-tuning 是<span style={{ color: 'var(--accent)' }}>背书</span>—— 把知识焊进模型权重。</Bubble>
          <Bubble role="user" pending>那我应该选哪个 ▍</Bubble>
        </div>
      </Stage>
      <Params rows={[
        { k: 'USER BUBBLE', v: '右对齐 · accent 描边 · bg 透明' },
        { k: 'AI BUBBLE', v: '左对齐 · bg-card 填充 · 无边' },
        { k: 'TYPING', v: '末尾光标 ▍' },
        { k: 'MAX WIDTH', v: '70% · 留出对侧呼吸' },
      ]} />
    </SubSec>
  );
}
function Bubble({ role, pending, children }) {
  const isUser = role === 'user';
  return (
    <div style={{ alignSelf: isUser ? 'flex-end' : 'flex-start', maxWidth: '70%' }}>
      <div className="meta" style={{ marginBottom: 4, textAlign: isUser ? 'right' : 'left', color: isUser ? 'var(--accent)' : 'var(--fg-3)' }}>{isUser ? 'YOU' : 'ASSISTANT'}</div>
      <div className="cn" style={{
        padding: '24px 30px',
        background: isUser ? 'transparent' : 'var(--bg-card)',
        border: isUser ? '1px solid var(--accent)' : '1px solid var(--line)',
        borderRadius: 10, fontSize: 30, fontWeight: 400, lineHeight: 1.45,
        opacity: pending ? 0.7 : 1,
      }}>{children}</div>
    </div>
  );
}

/* ---------- C · Browser ---------- */
function Browser() {
  return (
    <SubSec name="浏览器 · Browser" tag="URL + VIEWPORT">
      <Stage pattern="dot" label="● B-ROLL" labelR="03.C">
        <WindowChrome
          tabs={['chat.openai.com', 'docs · arxiv', '+']}
          urlMode
          url="chatgpt.com/?q=rag"
        >
          <div style={{ padding: '24px 32px' }}>
            <div className="meta" style={{ color: 'var(--accent)', marginBottom: 12 }}>● LIVE</div>
            <div className="cn" style={{ fontSize: 44, fontWeight: 800, letterSpacing: '-0.018em', lineHeight: 1.1, marginBottom: 14 }}>
              問 AI 助手 任何关于 RAG 的问题
            </div>
            <div style={{ display: 'flex', gap: 10, alignItems: 'center' }}>
              <div style={{ flex: 1, height: 56, border: '1px solid var(--line-2)', borderRadius: 6, display: 'flex', alignItems: 'center', padding: '0 16px' }}>
                <span className="cn" style={{ fontSize: 22, color: 'var(--fg-3)' }}>How does retrieval work?</span>
              </div>
              <div style={{ width: 56, height: 56, background: 'var(--accent)', borderRadius: 6, display: 'flex', alignItems: 'center', justifyContent: 'center', fontFamily: 'var(--f-mono)', fontWeight: 800, color: 'var(--bg)', fontSize: 22 }}>↑</div>
            </div>
          </div>
        </WindowChrome>
      </Stage>
      <Params rows={[
        { k: 'CHROME', v: '三点 + tab 行 + URL 框 · 全部 hairline' },
        { k: 'URL', v: 'Geist Mono · 不显示 https:// 前缀' },
        { k: 'CTA', v: '正方形 accent 按钮 · 单字符' },
        { k: 'NO FAVICON', v: '保持极简' },
      ]} />
    </SubSec>
  );
}

/* ---------- D · Code Editor ---------- */
function CodeEditor() {
  return (
    <SubSec name="代码 · Code Editor" tag="SYNTAX HIGHLIGHTED">
      <Stage pattern="dot" label="● B-ROLL" labelR="03.D">
        <WindowChrome title="rag.py · python 3.12" sideBar>
          <pre className="mono" style={{ margin: 0, padding: '24px 28px', fontSize: 22, lineHeight: 1.55, color: 'var(--fg)' }}>
<Ln n={1}><Kw>from</Kw> codex <Kw>import</Kw> retrieve, ask</Ln>
<Ln n={2}> </Ln>
<Ln n={3}>docs <Op>=</Op> retrieve(<Str>"vector_db"</Str>, q<Op>=</Op>question)</Ln>
<Ln n={4}>answer <Op>=</Op> ask(question, context<Op>=</Op>docs)</Ln>
<Ln n={5}> </Ln>
<Ln n={6} hot><Co># ← grounded in real sources</Co></Ln>
          </pre>
        </WindowChrome>
      </Stage>
      <Params rows={[
        { k: 'PALETTE', v: 'keyword=accent · string=fg-2 · comment=fg-3 italic' },
        { k: 'GUTTER', v: '行号 mono · fg-3 · 1ch 右对齐' },
        { k: 'HOT LINE', v: '当前讲解行：左侧 2px accent 竖条' },
        { k: 'SIDEBAR', v: '可选文件树 · 32px 宽' },
      ]} />
    </SubSec>
  );
}
function Ln({ n, hot, children }) {
  return (
    <div style={{ display: 'grid', gridTemplateColumns: '32px 1fr', alignItems: 'baseline', gap: 12, position: 'relative', padding: '2px 0' }}>
      {hot && <span style={{ position: 'absolute', left: -28, top: 4, bottom: 4, width: 2, background: 'var(--accent)' }} />}
      <span style={{ color: 'var(--fg-3)', textAlign: 'right' }}>{n}</span>
      <span>{children}</span>
    </div>
  );
}
function Kw({ children }) { return <span style={{ color: 'var(--accent)' }}>{children}</span>; }
function Str({ children }) { return <span style={{ color: 'var(--fg-2)' }}>{children}</span>; }
function Op({ children }) { return <span style={{ color: 'var(--fg-3)' }}>{children}</span>; }
function Co({ children }) { return <span style={{ color: 'var(--fg-3)', fontStyle: 'italic' }}>{children}</span>; }

/* ---------- E · API call ---------- */
function ApiCall() {
  return (
    <SubSec name="API 调用 · Request / Response" tag="REST · JSON">
      <Stage pattern="dot" label="● B-ROLL" labelR="03.E">
        <div style={{ position: 'absolute', inset: '12% 8%', display: 'grid', gridTemplateColumns: '1fr 40px 1fr', alignItems: 'stretch', gap: 0 }}>
          <Panel verb="POST" path="/v1/messages" tone="req">
            <PanelLine k='"model"'    v='"gpt-4.1-mini"' />
            <PanelLine k='"messages"' v='[ … ]' />
            <PanelLine k='"max_tokens"' v='1024' />
          </Panel>
          <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', gap: 8 }}>
            <div className="meta" style={{ color: 'var(--accent)' }}>312ms</div>
            <div style={{ width: 0, height: 0, borderLeft: '8px solid var(--accent)', borderTop: '5px solid transparent', borderBottom: '5px solid transparent' }} />
          </div>
          <Panel verb="200" path="ok · 1.2KB" tone="res">
            <PanelLine k='"id"'      v='"msg_01H…"' />
            <PanelLine k='"content"' v='"RAG = 开卷考试 …"' accent />
            <PanelLine k='"stop"'    v='"end_turn"' />
          </Panel>
        </div>
      </Stage>
      <Params rows={[
        { k: 'LAYOUT', v: '左请求 · 中延迟 · 右响应' },
        { k: 'VERB', v: 'POST = accent · 200 = green · err = red' },
        { k: 'KEY-VAL', v: '键 fg-3 · 值 fg / accent' },
        { k: 'LATENCY', v: '中间显示真实毫秒数（教学可信感）' },
      ]} />
    </SubSec>
  );
}
function Panel({ verb, path, tone, children }) {
  const isReq = tone === 'req';
  return (
    <div style={{ background: 'var(--bg-card)', border: '1px solid var(--line)', borderRadius: 8, overflow: 'hidden', display: 'flex', flexDirection: 'column' }}>
      <div style={{ padding: '12px 18px', borderBottom: '1px solid var(--line)', display: 'flex', alignItems: 'center', gap: 12 }}>
        <span className="mono" style={{ fontSize: 18, fontWeight: 800, color: isReq ? 'var(--accent)' : 'var(--green)', letterSpacing: 0.5 }}>{verb}</span>
        <span className="mono" style={{ fontSize: 18, color: 'var(--fg-2)' }}>{path}</span>
      </div>
      <div className="mono" style={{ padding: '16px 18px', fontSize: 22, lineHeight: 1.7, flex: 1 }}>{children}</div>
    </div>
  );
}
function PanelLine({ k, v, accent }) {
  return (
    <div style={{ display: 'flex', gap: 12, whiteSpace: 'nowrap', overflow: 'hidden' }}>
      <span style={{ color: 'var(--fg-3)' }}>{k}:</span>
      <span style={{ color: accent ? 'var(--accent)' : 'var(--fg)' }}>{v}</span>
    </div>
  );
}

/* ---------- F · Dashboard ---------- */
function Dashboard() {
  return (
    <SubSec name="仪表盘 · Dashboard" tag="LIVE METRICS">
      <Stage pattern="graph" label="● B-ROLL" labelR="03.F">
        <div style={{ position: 'absolute', inset: '12% 6%', display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gridTemplateRows: 'auto 1fr', gap: 14 }}>
          <KPI label="LATENCY · p50" v="312" unit="ms" />
          <KPI label="TOKENS / S" v="84.2" unit="t/s" hot />
          <KPI label="COST · 1k req" v="$2.40" unit="" />
          <div style={{ gridColumn: '1 / -1', background: 'var(--bg-card)', border: '1px solid var(--line)', borderRadius: 8, padding: '18px 22px', display: 'flex', flexDirection: 'column' }}>
            <div className="meta" style={{ marginBottom: 12, display: 'flex', justifyContent: 'space-between' }}>
              <span>REQUESTS · LAST 24H</span>
              <span style={{ color: 'var(--accent)' }}>● LIVE</span>
            </div>
            <Sparkline />
          </div>
        </div>
      </Stage>
      <Params rows={[
        { k: 'KPI CARD', v: '巨数字 + 单位 + 标签三件套' },
        { k: 'HOT CARD', v: '一张卡左上 accent 角标（讲解焦点）' },
        { k: 'SPARKLINE', v: 'hairline · 单 accent 高亮点' },
        { k: 'LIVE TAG', v: '右上 accent 圆点 + LIVE caps' },
      ]} />
    </SubSec>
  );
}
function KPI({ label, v, unit, hot }) {
  return (
    <div style={{ position: 'relative', background: 'var(--bg-card)', border: `1px solid ${hot ? 'var(--accent)' : 'var(--line)'}`, borderRadius: 8, padding: '18px 22px' }}>
      {hot && <span style={{ position: 'absolute', top: -1, left: -1, width: 10, height: 10, background: 'var(--accent)' }} />}
      <div className="meta" style={{ marginBottom: 10 }}>{label}</div>
      <div style={{ display: 'flex', alignItems: 'baseline', gap: 6 }}>
        <span className="big-num" style={{ fontSize: 48 }}>{v}</span>
        <span className="mono" style={{ fontSize: 18, color: 'var(--fg-3)' }}>{unit}</span>
      </div>
    </div>
  );
}
function Sparkline() {
  // 24 points, one peak emphasized
  const pts = [12, 14, 13, 18, 22, 19, 17, 20, 24, 28, 32, 30, 36, 42, 38, 48, 55, 62, 58, 64, 70, 68, 74, 80];
  const max = 80;
  const w = 100, h = 100;
  const path = pts.map((p, i) => `${i === 0 ? 'M' : 'L'} ${(i / (pts.length - 1)) * w} ${h - (p / max) * h}`).join(' ');
  const peakX = ((pts.length - 1) / (pts.length - 1)) * w;
  const peakY = h - (pts[pts.length - 1] / max) * h;
  return (
    <svg viewBox={`0 0 ${w} ${h}`} preserveAspectRatio="none" style={{ width: '100%', flex: 1, minHeight: 80 }}>
      <path d={path} fill="none" stroke="var(--fg-2)" strokeWidth="0.6" vectorEffect="non-scaling-stroke" />
      <circle cx={peakX} cy={peakY} r="1.6" fill="var(--accent)" />
    </svg>
  );
}

/* ---------- shared window chrome ---------- */
function WindowChrome({ title, tabs, urlMode, url, sideBar, children }) {
  return (
    <div style={{ position: 'absolute', inset: '12% 8%', background: 'var(--bg-card)', border: '1px solid var(--line)', borderRadius: 8, overflow: 'hidden', display: 'flex', flexDirection: 'column' }}>
      <div style={{ padding: '14px 18px', borderBottom: '1px solid var(--line)', display: 'flex', alignItems: 'center', gap: 10 }}>
        <span style={{ width: 8, height: 8, borderRadius: '50%', background: 'var(--fg-3)' }} />
        <span style={{ width: 8, height: 8, borderRadius: '50%', background: 'var(--fg-3)' }} />
        <span style={{ width: 8, height: 8, borderRadius: '50%', background: 'var(--fg-3)' }} />
        {tabs ? (
          <div style={{ display: 'flex', gap: 14, marginLeft: 16 }}>
            {tabs.map((t, i) => (
              <span key={i} className="mono" style={{ fontSize: 16, color: i === 0 ? 'var(--fg)' : 'var(--fg-3)', paddingBottom: 4, borderBottom: i === 0 ? '1px solid var(--accent)' : 'none' }}>{t}</span>
            ))}
          </div>
        ) : (
          <span className="meta" style={{ marginLeft: 8, fontSize: 13 }}>{title}</span>
        )}
      </div>
      {urlMode && (
        <div style={{ padding: '10px 18px', borderBottom: '1px solid var(--line)', display: 'flex', alignItems: 'center', gap: 10 }}>
          <span className="mono" style={{ fontSize: 16, color: 'var(--fg-3)' }}>◐</span>
          <span className="mono" style={{ fontSize: 16, color: 'var(--fg-2)' }}>{url}</span>
        </div>
      )}
      <div style={{ flex: 1, display: 'flex', minHeight: 0 }}>
        {sideBar && (
          <div style={{ width: 90, borderRight: '1px solid var(--line)', padding: '14px 10px', display: 'flex', flexDirection: 'column', gap: 6 }}>
            {['rag.py', 'utils.py', 'README'].map((f, i) => (
              <span key={i} className="mono" style={{ fontSize: 13, color: i === 0 ? 'var(--fg)' : 'var(--fg-3)', padding: '4px 6px', borderRadius: 3, background: i === 0 ? 'var(--bg-elev)' : 'transparent' }}>{f}</span>
            ))}
          </div>
        )}
        <div style={{ flex: 1, minWidth: 0 }}>{children}</div>
      </div>
    </div>
  );
}

Object.assign(window, { FakeUISection });
CODEX_LAZYPACK_A506CA78530ACBA0A5A45F4FED388B94EB89A311

# video-spec-builder/Full Code/sections/foundation.jsx
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/video-spec-builder/Full Code/sections/foundation.jsx")"
cat > "{{CODEX_HOME}}/skills/video-spec-builder/Full Code/sections/foundation.jsx" <<'CODEX_LAZYPACK_AC2EBECDA770AB573F868910E611A89B68135ECE'
/* ================================================================
   sections/foundation.jsx — 00 · 视觉地基 (SpaceX × Grok × X)
   ================================================================ */

function FoundationSection() {
  return (
    <Section
      id="foundation"
      num="00"
      title="VISUAL FOUNDATION · 视觉地基"
      desc='这套系统的视觉原则借鉴 <b>SpaceX × Grok × X</b> —— <em>纯黑底</em>、<em>纯白字</em>、<em>几何 sans</em>、<em>condensed 数字</em>。<b>0 阴影 · 0 渐变 · 0 装饰插画 · 单 accent 制</b>。所有信息靠字重悬崖、留白、hairline 与 mono caps 注脚说话。'
    >
      <FoundColors />
      <FoundType />
      <FoundSpace />
      <FoundMotion />
      <FoundDeco />
    </Section>
  );
}

/* ---------- Color ---------- */
function FoundColors() {
  const swatches = [
    { k: '--bg',       v: '#000000', note: '纯黑底 · 0,0,0 太空黑' },
    { k: '--bg-card',  v: '#0A0A0A', note: '卡片表面' },
    { k: '--bg-elev',  v: '#141414', note: '抬起层' },
    { k: '--fg',       v: '#FFFFFF', note: '纯白主前景' },
    { k: '--fg-2',     v: 'rgba(255,255,255,.66)', note: '次级文字' },
    { k: '--fg-3',     v: 'rgba(255,255,255,.42)', note: 'meta · caption' },
    { k: '--line',     v: 'rgba(255,255,255,.08)', note: 'hairline 边线' },
    { k: '--accent',   v: 'var(--accent)', note: '单 accent · Tweaks 可换' },
  ];
  return (
    <SubSec name="色彩 · Color" tag="PURE BLACK + PURE WHITE">
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 12, marginBottom: 16 }}>
        {swatches.map(s => (
          <div key={s.k} style={{
            background: 'var(--bg-card)', border: '1px solid var(--line)',
            borderRadius: 2, padding: 16,
          }}>
            <div style={{
              width: '100%', height: 88, marginBottom: 14,
              background: s.v,
              border: s.k === '--bg' || s.v === '#000000' ? '1px solid var(--line)' : 'none',
              borderRadius: 0,
            }} />
            <div className="mono" style={{ fontSize: 11, color: 'var(--fg)', marginBottom: 4 }}>{s.k}</div>
            <div className="mono" style={{ fontSize: 10, color: 'var(--fg-3)', marginBottom: 8 }}>{s.v}</div>
            <div className="cn" style={{ fontSize: 12, color: 'var(--fg-2)', lineHeight: 1.5 }}>{s.note}</div>
          </div>
        ))}
      </div>
      <Params rows={[
        { k: 'CONTRAST', v: 'FG / BG = 21.0 : 1 (AAA · 纯黑白)' },
        { k: 'ACCENT RULE', v: '一屏最多 1 处用色 · 默认 white (Grok-style)' },
        { k: 'BORDER', v: '1px solid rgba(255,255,255,.08)' },
        { k: 'SHADOW', v: '<b style="color: var(--accent)">0 · 不使用</b>' },
        { k: 'GRADIENT', v: '<b style="color: var(--accent)">0 · 唯一例外: area chart fill</b>' },
        { k: 'INSPIRED BY', v: 'SpaceX · xAI/Grok · X (Twitter)' },
      ]} />
    </SubSec>
  );
}

/* ---------- Type ---------- */
function FoundType() {
  return (
    <SubSec name="字体 · Type" tag="SPACE GROTESK · BARLOW COND · MONO">
      <div style={{
        display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 1,
        background: 'var(--line)', border: '1px solid var(--line)', borderRadius: 2,
        overflow: 'hidden', marginBottom: 16,
      }}>
        <div style={{ background: 'var(--bg-card)', padding: 28 }}>
          <div className="meta" style={{ marginBottom: 14 }}>SANS · SPACE GROTESK</div>
          <div style={{ fontFamily: 'var(--f-sans)', fontSize: 56, fontWeight: 700, letterSpacing: '-0.025em', lineHeight: 1, marginBottom: 10 }}>Aa Bb 01</div>
          <div style={{ fontSize: 14, color: 'var(--fg-2)', lineHeight: 1.5 }}>主力 sans · 几何 grotesque · 替代 Brandon Grotesque<br/>weights = <span className="mono">400 / 500 / 600 / 700</span></div>
        </div>
        <div style={{ background: 'var(--bg-card)', padding: 28 }}>
          <div className="meta" style={{ marginBottom: 14 }}>COND · BARLOW SEMI</div>
          <div className="cond" style={{ fontSize: 64, fontWeight: 700, letterSpacing: '-0.03em', lineHeight: 0.9, marginBottom: 10 }}>96 / T-0</div>
          <div className="cn" style={{ fontSize: 14, color: 'var(--fg-2)', lineHeight: 1.5 }}>condensed 数字 · 海报大字 · 替代 Pragmatica Cond (SpaceX 发射页)</div>
        </div>
        <div style={{ background: 'var(--bg-card)', padding: 28 }}>
          <div className="meta" style={{ marginBottom: 14 }}>CJK · 思源黑体</div>
          <div className="cn" style={{ fontSize: 56, fontWeight: 700, letterSpacing: '-0.02em', lineHeight: 1, marginBottom: 10 }}>视频组件</div>
          <div className="cn" style={{ fontSize: 14, color: 'var(--fg-2)', lineHeight: 1.5 }}>中文主力<br/>weights = <span className="mono">400 / 500 / 700 / 900</span></div>
        </div>
      </div>

      {/* type ramp */}
      <div style={{
        background: 'var(--bg-card)', border: '1px solid var(--line)',
        borderRadius: 2, padding: '32px 36px', marginBottom: 16,
      }}>
        <div className="meta" style={{ marginBottom: 24 }}>TYPE RAMP · 字号悬崖</div>
        <Ramp size={96} weight={700} ls="-0.03em" font="cond" label="HERO · COND 96 / 700">A SYSTEM FOR VIDEO</Ramp>
        <Ramp size={64} weight={700} ls="-0.025em" font="cond" label="DISPLAY · COND 64 / 700">SECTION TITLE</Ramp>
        <Ramp size={48} weight={700} ls="-0.018em" font="cond" label="H1 · COND 48 / 700">BIG STAT · 312ms</Ramp>
        <Ramp size={32} weight={700} ls="-0.012em" label="H2 · SANS 32 / 700">章节标题 · sans 800</Ramp>
        <Ramp size={22} weight={600} ls="-0.005em" label="H3 · SANS 22 / 600">卡片标题 · sans 600</Ramp>
        <Ramp size={15} weight={400} ls="0" label="BODY · SANS 15 / 400">正文段落。保持轻盈，让黑色背景与白色文字之间的对比承担层级。</Ramp>
        <Ramp size={11} weight={500} ls="0.22em" caps label="MONO · 11 / 0.22em">SPEC · MISSION · T-MINUS</Ramp>
      </div>

      <Params rows={[
        { k: 'WEIGHT RULE', v: '只用 <b style="color: var(--accent)">400 / 600 / 700</b>，跳过 500' },
        { k: 'TRACKING', v: 'cond -0.03em · sans -0.025 → 0 · mono caps 0.22em' },
        { k: 'LINE HEIGHT', v: '标题 0.86-1.0 · 正文 1.55-1.7' },
        { k: 'MONO USAGE', v: '编号 · 时间戳 · 任务码 · T-MINUS' },
        { k: 'COND USAGE', v: '海报大字 · 大数字 · 章节大标题' },
        { k: 'CJK STACK', v: '思源黑体 → 苹方 → 鸿蒙' },
      ]} />
    </SubSec>
  );
}

function Ramp({ size, weight, ls, label, caps, font, children }) {
  const family = caps ? 'var(--f-mono)' : font === 'cond' ? 'var(--f-cond)' : undefined;
  return (
    <div style={{ display: 'grid', gridTemplateColumns: '160px 1fr', alignItems: 'baseline', gap: 32, padding: '14px 0', borderBottom: '1px solid var(--line)' }}>
      <div className="meta" style={{ fontSize: 10 }}>{label}</div>
      <div className="cn" style={{
        fontSize: size, fontWeight: weight, letterSpacing: ls, lineHeight: 1.05,
        textTransform: caps || font === 'cond' ? 'uppercase' : 'none',
        fontFamily: family,
      }}>{children}</div>
    </div>
  );
}

/* ---------- Spacing / radii ---------- */
function FoundSpace() {
  const spaces = [
    { k: '--space-1', v: 8,  use: 'icon · meta gap' },
    { k: '--space-2', v: 16, use: '行间 · 卡片内' },
    { k: '--space-3', v: 24, use: '卡内段落' },
    { k: '--space-4', v: 40, use: '组件间' },
    { k: '--space-5', v: 64, use: '小节间' },
    { k: '--space-6', v: 96, use: '章节间' },
  ];
  const radii = [
    { k: '--r-0', v: 0, use: 'wordmark · plate' },
    { k: '--r-1', v: 2, use: '默认 (SpaceX 极简)' },
    { k: '--r-2', v: 4, use: '柔化 · tag' },
    { k: '--r-3', v: 8, use: '大模块 (谨慎)' },
  ];
  return (
    <SubSec name="间距 & 圆角 · Spacing" tag="8-PT GRID · MINIMAL RADII">
      <div style={{ display: 'grid', gridTemplateColumns: '2fr 1fr', gap: 16, marginBottom: 16 }}>
        <div style={{ background: 'var(--bg-card)', border: '1px solid var(--line)', borderRadius: 2, padding: '28px 32px' }}>
          <div className="meta" style={{ marginBottom: 22 }}>SPACE SCALE · 8-pt</div>
          <div style={{ display: 'flex', flexDirection: 'column', gap: 14 }}>
            {spaces.map(s => (
              <div key={s.k} style={{ display: 'grid', gridTemplateColumns: '110px 70px 1fr', alignItems: 'center', gap: 16 }}>
                <span className="mono" style={{ fontSize: 11, color: 'var(--fg)' }}>{s.k}</span>
                <span className="mono" style={{ fontSize: 11, color: 'var(--fg-3)', textAlign: 'right' }}>{s.v}px</span>
                <div style={{ position: 'relative', height: 10, background: 'rgba(255,255,255,0.04)' }}>
                  <div style={{ position: 'absolute', left: 0, top: 0, bottom: 0, width: `${(s.v / 96) * 100}%`, background: 'var(--accent)' }} />
                  <span className="cn" style={{ position: 'absolute', left: `calc(${(s.v / 96) * 100}% + 10px)`, top: -5, fontSize: 12, color: 'var(--fg-2)', whiteSpace: 'nowrap' }}>{s.use}</span>
                </div>
              </div>
            ))}
          </div>
        </div>
        <div style={{ background: 'var(--bg-card)', border: '1px solid var(--line)', borderRadius: 2, padding: '28px 32px' }}>
          <div className="meta" style={{ marginBottom: 22 }}>RADII · 4 档</div>
          <div style={{ display: 'flex', flexDirection: 'column', gap: 14 }}>
            {radii.map(r => (
              <div key={r.k} style={{ display: 'flex', alignItems: 'center', gap: 16 }}>
                <div style={{ width: 56, height: 56, background: 'var(--bg)', border: '1px solid var(--line-2)', borderRadius: r.v, flexShrink: 0 }} />
                <div>
                  <div className="mono" style={{ fontSize: 11, color: 'var(--fg)', marginBottom: 4 }}>{r.k} · {r.v}px</div>
                  <div className="cn" style={{ fontSize: 12, color: 'var(--fg-2)' }}>{r.use}</div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
      <Params rows={[
        { k: 'GRID', v: '8-pt 基 · 跳过 32/48/56（避免节奏混乱）' },
        { k: 'DEFAULT RADIUS', v: '<b style="color: var(--accent)">2px</b> · SpaceX 几何感' },
        { k: 'BORDER WIDTH', v: '永远 1px · 不用 2px 描边' },
        { k: 'NO PILL', v: '不使用胶囊 / 完全圆角（除 KPI 圆环）' },
      ]} />
    </SubSec>
  );
}

/* ---------- Motion ---------- */
function FoundMotion() {
  const [trig, setTrig] = useState(0);
  const durs = [
    { k: '--d-1', v: '200ms', use: '微状态（hover · focus）' },
    { k: '--d-2', v: '400ms', use: 'hot 高亮态' },
    { k: '--d-3', v: '700ms', use: '卡片入场' },
    { k: '--d-4', v: '1100ms', use: 'hero 入场' },
  ];
  return (
    <SubSec name="动效 · Motion" tag="LONG EASE-OUT · NO BOUNCE">
      <div style={{
        background: 'var(--bg-card)', border: '1px solid var(--line)',
        borderRadius: 2, padding: 32, marginBottom: 16,
      }}>
        <button onClick={() => setTrig(t => t + 1)} style={{
          marginBottom: 28, padding: '10px 16px', background: 'var(--fg)',
          border: '0', color: 'var(--bg)',
          fontFamily: 'var(--f-mono)', fontSize: 11, letterSpacing: '0.22em',
          textTransform: 'uppercase', cursor: 'pointer', borderRadius: 2, fontWeight: 600,
        }}>▶ REPLAY MOTION</button>

        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 24 }}>
          {durs.map((d, i) => (
            <div key={d.k}>
              <div className="meta" style={{ marginBottom: 10 }}>{d.k} · {d.v}</div>
              <div style={{ height: 56, position: 'relative', background: 'var(--bg)', borderRadius: 2, marginBottom: 10, overflow: 'hidden', border: '1px solid var(--line)' }}>
                <div key={trig + '-' + i}
                  style={{
                    position: 'absolute', top: 4, left: 4, bottom: 4, width: 48,
                    background: 'var(--accent)',
                    animation: `slide ${d.v} var(--ease-out) forwards`,
                  }}
                />
              </div>
              <div className="cn" style={{ fontSize: 12, color: 'var(--fg-2)' }}>{d.use}</div>
            </div>
          ))}
        </div>
        <style>{`
          @keyframes slide {
            from { transform: translateX(0); opacity: 0; }
            to   { transform: translateX(calc(100% + 240%)); opacity: 1; }
          }
        `}</style>
      </div>
      <Params rows={[
        { k: 'EASING · DEFAULT', v: 'cubic-bezier(.22, 1, .36, 1) · ease-out' },
        { k: 'EASING · SOFT', v: 'cubic-bezier(.4, 0, .2, 1)' },
        { k: 'EASING · SPRING', v: '仅在弹出/弹入时少量使用' },
        { k: 'DISPLACEMENT', v: '8-16px · 不大幅滑动' },
        { k: 'BOUNCE', v: '<b style="color: var(--accent)">禁用</b>（除非 sticker）' },
        { k: 'ENTER PATTERN', v: 'opacity 0→1 + translateY 8→0' },
      ]} />
    </SubSec>
  );
}

/* ---------- Decoration / patterns ---------- */
function FoundDeco() {
  return (
    <SubSec name="装饰元素 · Decoration" tag="HAIRLINE · TICK · MISSION CODE">
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 12, marginBottom: 16 }}>
        <DecoBlock name="DOT GRID" desc="HUD 风环境感">
          <div style={{ width: '100%', height: 96, backgroundImage: 'radial-gradient(rgba(255,255,255,0.22) 1px, transparent 1.2px)', backgroundSize: '12px 12px' }} />
        </DecoBlock>
        <DecoBlock name="HAIRLINE GRID" desc="工程图味">
          <div style={{ width: '100%', height: 96, backgroundImage: 'linear-gradient(rgba(255,255,255,0.1) 1px, transparent 1px), linear-gradient(90deg, rgba(255,255,255,0.1) 1px, transparent 1px)', backgroundSize: '24px 24px' }} />
        </DecoBlock>
        <DecoBlock name="SCAN LINES" desc="CRT 复古">
          <div style={{ width: '100%', height: 96, backgroundImage: 'repeating-linear-gradient(0deg, rgba(255,255,255,0.12) 0, rgba(255,255,255,0.12) 1px, transparent 1px, transparent 4px)' }} />
        </DecoBlock>
        <DecoBlock name="CORNER CROSS" desc="十字针脚">
          <div style={{ width: '100%', height: 96, position: 'relative', padding: 14 }}>
            <span className="cross cross--tl" />
            <span className="cross cross--tr" />
            <span className="cross cross--bl" />
            <span className="cross cross--br" />
          </div>
        </DecoBlock>
        <DecoBlock name="TICK ROW" desc="信号 / 时码">
          <div style={{ width: '100%', height: 96, display: 'flex', alignItems: 'center', gap: 6, padding: '0 12px' }}>
            <span className="meta" style={{ color: 'var(--accent)' }}>● 00:14:22</span>
            <div style={{ flex: 1, height: 1, background: 'var(--line-2)' }} />
            <span className="meta">CH—01</span>
          </div>
        </DecoBlock>
        <DecoBlock name="MISSION CODE" desc="任务编号">
          <div style={{ width: '100%', height: 96, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
            <div className="mission" style={{ fontSize: 16, fontWeight: 600, color: 'var(--accent)' }}>SCN-03 / FRAME 0142</div>
          </div>
        </DecoBlock>
        <DecoBlock name="T-MINUS" desc="倒计时大字">
          <div style={{ width: '100%', height: 96, display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 10 }}>
            <span className="meta" style={{ color: 'var(--fg-3)' }}>T-</span>
            <span className="t-minus" style={{ fontSize: 44, color: 'var(--accent)' }}>00:42</span>
          </div>
        </DecoBlock>
        <DecoBlock name="BRACKET WRAP" desc="术语高亮">
          <div style={{ width: '100%', height: 96, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
            <span className="cn bracket" style={{ fontSize: 22, fontWeight: 600 }}>CONTEXT</span>
          </div>
        </DecoBlock>
      </div>
      <Params rows={[
        { k: 'CORNER CROSS', v: '12px arm · 1px stroke · 4 角对称' },
        { k: 'DOT GRID', v: '12px spacing · rgba(255,255,255,.22)' },
        { k: 'MISSION CODE', v: 'mono caps 0.32em letter-spacing' },
        { k: 'USAGE', v: '场景背景 1 种 + 边角 1 种 · 不叠加' },
      ]} />
    </SubSec>
  );
}

function DecoBlock({ name, desc, children }) {
  return (
    <div style={{ background: 'var(--bg-card)', border: '1px solid var(--line)', borderRadius: 2, overflow: 'hidden' }}>
      <div style={{ background: 'var(--bg)', borderBottom: '1px solid var(--line)' }}>{children}</div>
      <div style={{ padding: 14 }}>
        <div className="meta" style={{ marginBottom: 6 }}>{name}</div>
        <div className="cn" style={{ fontSize: 12, color: 'var(--fg-2)' }}>{desc}</div>
      </div>
    </div>
  );
}

/* legacy Bracket — kept for broll-abstract */
function Bracket({ size = 20, color = 'currentColor', thick = 1 }) {
  const c = { position: 'absolute', width: size, height: size };
  const arm = { background: color };
  return (
    <>
      <span style={{ ...c, top: 8, left: 8 }}>
        <span style={{ position: 'absolute', top: 0, left: 0, width: size, height: thick, ...arm }} />
        <span style={{ position: 'absolute', top: 0, left: 0, height: size, width: thick, ...arm }} />
      </span>
      <span style={{ ...c, top: 8, right: 8 }}>
        <span style={{ position: 'absolute', top: 0, right: 0, width: size, height: thick, ...arm }} />
        <span style={{ position: 'absolute', top: 0, right: 0, height: size, width: thick, ...arm }} />
      </span>
      <span style={{ ...c, bottom: 8, left: 8 }}>
        <span style={{ position: 'absolute', bottom: 0, left: 0, width: size, height: thick, ...arm }} />
        <span style={{ position: 'absolute', bottom: 0, left: 0, height: size, width: thick, ...arm }} />
      </span>
      <span style={{ ...c, bottom: 8, right: 8 }}>
        <span style={{ position: 'absolute', bottom: 0, right: 0, width: size, height: thick, ...arm }} />
        <span style={{ position: 'absolute', bottom: 0, right: 0, height: size, width: thick, ...arm }} />
      </span>
    </>
  );
}

Object.assign(window, { FoundationSection, Bracket });
CODEX_LAZYPACK_AC2EBECDA770AB573F868910E611A89B68135ECE

# video-spec-builder/Full Code/sections/illustrations.jsx
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/video-spec-builder/Full Code/sections/illustrations.jsx")"
cat > "{{CODEX_HOME}}/skills/video-spec-builder/Full Code/sections/illustrations.jsx" <<'CODEX_LAZYPACK_250F2AA7496D5DDEC2CFEE16D18FEE717BE9803D'
/* ================================================================
   sections/illustrations.jsx — 10 · 图标系统 · ICON SYSTEM
   v3.2 · 删除场景插画 · 只留 Lucide 图标
   ================================================================ */

/* ---------- Lucide React wrapper ---------- */
function L({ name, size = 24, sw = 1.5, style, className }) {
  const ref = React.useRef();
  React.useEffect(() => {
    if (!ref.current || !window.lucide) return;
    ref.current.innerHTML = '';
    const i = document.createElement('i');
    i.setAttribute('data-lucide', name);
    ref.current.appendChild(i);
    window.lucide.createIcons({
      attrs: { 'stroke-width': sw, width: size, height: size, 'stroke-linecap': 'round', 'stroke-linejoin': 'round' },
      nameAttr: 'data-lucide',
    });
  }, [name, size, sw]);
  return <span ref={ref} className={className} style={{ display: 'inline-flex', lineHeight: 0, color: 'currentColor', ...style }} />;
}

function IconCell({ name, label }) {
  const [hover, setHover] = React.useState(false);
  return (
    <div
      onMouseEnter={() => setHover(true)}
      onMouseLeave={() => setHover(false)}
      style={{
        display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 10,
        padding: '22px 8px',
        border: `1px solid ${hover ? 'var(--accent)' : 'var(--line)'}`,
        borderRadius: 2,
        color: hover ? 'var(--accent)' : 'var(--fg-2)',
        transition: 'color 240ms var(--ease-out), border-color 240ms var(--ease-out)',
        background: hover ? 'rgba(255,255,255,.04)' : 'transparent',
      }}
    >
      <L name={name} size={28} sw={1.5} />
      <div className="mono" style={{ fontSize: 10, letterSpacing: '0.18em', color: 'var(--fg-3)' }}>{label}</div>
    </div>
  );
}

/* ============== I-0 · 规范 ============== */
function IllRules() {
  const rules = [
    ['LIBRARY', 'Lucide Icons · 1500+ · 开源 ISC · 行业标准'],
    ['STROKE',  '1 / 1.5 / 2 px · 默认 1.5 · 同屏统一'],
    ['SIZE',    '14 / 18 / 24 / 32 · 大于 48 → 改用大字'],
    ['COLOR',   '继承 currentColor · 默认 fg-2 · 强调 accent'],
    ['SPACING', '与字基线对齐 · 前后 8px gap'],
    ['POLICY',  '不要混入其他 icon set · 不要手绘 · 不要装饰插画'],
  ];
  const policy = [
    ['NO ILLUSTRATION', '本系统禁止使用场景插画 / 卡通人物'],
    ['NO ICON SHADOW',  '禁止描边外的阴影 / glow / 渐变'],
    ['NO HUE',          '禁止主题色之外的颜色，单 accent 制'],
    ['NO ROUND CORNER', '图标容器仅 0 / 2 / 4px radius'],
    ['NO EMOJI',        '禁止 emoji / 表情 / 表情字符'],
    ['SLASH MOTIF',     '允许使用 / · X · △ 等几何字符作 motif'],
  ];
  const Row = ({ k, v }) => (
    <div style={{ display: 'grid', gridTemplateColumns: '120px 1fr', alignItems: 'baseline', borderBottom: '1px solid var(--line)', padding: '10px 0' }}>
      <div className="mono" style={{ fontSize: 11, letterSpacing: '0.18em', color: 'var(--fg-3)' }}>{k}</div>
      <div className="cn" style={{ fontSize: 14, color: 'var(--fg)' }}>{v}</div>
    </div>
  );
  return (
    <SubSec name="I-0 · 系统规范 · Rules" tag="HOW WE USE ICONS">
      <Stage pattern="grid" label="● ICON · SYSTEM RULES" labelR="10.I0">
        <div style={{ position: 'absolute', inset: '6% 5%', display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 28 }}>
          <div>
            <div className="meta" style={{ color: 'var(--accent)' }}>USE · LUCIDE</div>
            <div className="cn" style={{ fontSize: 20, fontWeight: 700, marginTop: 6 }}>UI 信息层 · 注脚 · 节点 · 状态</div>
            <div style={{ marginTop: 18, display: 'flex', flexDirection: 'column' }}>
              {rules.map(([k, v]) => <Row key={k} k={k} v={v} />)}
            </div>
          </div>
          <div>
            <div className="meta" style={{ color: 'var(--accent)' }}>POLICY · WHAT WE DON'T DO</div>
            <div className="cn" style={{ fontSize: 20, fontWeight: 700, marginTop: 6 }}>克制 · 几何 · 单色</div>
            <div style={{ marginTop: 18, display: 'flex', flexDirection: 'column' }}>
              {policy.map(([k, v]) => <Row key={k} k={k} v={v} />)}
            </div>
          </div>
        </div>
      </Stage>
    </SubSec>
  );
}

/* ============== I-1 · Stroke 对比 ============== */
function StrokeShowcase() {
  const sample = 'rocket';
  const variants = [
    { sw: 1,    size: 84, label: 'STROKE 1',    note: '极细 · 注脚 / 弱化' },
    { sw: 1.5,  size: 84, label: 'STROKE 1.5',  note: '默认 · 90% 场景', active: true },
    { sw: 2,    size: 84, label: 'STROKE 2',    note: '粗 · 强调 / 标题' },
    { sw: 2.5,  size: 84, label: 'STROKE 2.5',  note: '重锤 · 慎用' },
  ];
  return (
    <SubSec name="I-1 · 描边粗细 · 4 档" tag="STROKE WEIGHTS">
      <Stage pattern="dot" label="● ICONS · STROKES" labelR="10.I1">
        <div style={{ position: 'absolute', inset: '12% 5%', display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 18 }}>
          {variants.map(v => (
            <div key={v.sw} style={{
              display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center',
              gap: 22, padding: '40px 18px',
              border: '1px solid ' + (v.active ? 'var(--accent)' : 'var(--line-2)'),
              background: v.active ? 'var(--bg-card)' : 'transparent',
              borderRadius: 2,
            }}>
              <L name={sample} size={v.size} sw={v.sw} style={{ color: v.active ? 'var(--accent)' : 'var(--fg-2)' }} />
              <div style={{ textAlign: 'center' }}>
                <div className="mono" style={{ fontSize: 12, letterSpacing: '0.22em', color: v.active ? 'var(--accent)' : 'var(--fg-3)' }}>{v.label}</div>
                <div className="cn" style={{ fontSize: 13, color: 'var(--fg-3)', marginTop: 4 }}>{v.note}</div>
              </div>
            </div>
          ))}
        </div>
      </Stage>
      <Params rows={[
        { k: 'DEFAULT', v: '1.5px · 与 hairline 边框视觉等重' },
        { k: 'ACCENT',  v: '2px · 当图标自身是"被强调"的元素' },
        { k: 'AVOID',   v: '同一屏混用 3 档以上 stroke' },
      ]} />
    </SubSec>
  );
}

/* ============== I-2 · 图标库 ============== */
const LU_ICONS = [
  ['user',           '用户'],   ['users',          '团队'],   ['message-circle','对话'],   ['mic',           '语音'],
  ['mail',           '邮件'],   ['phone',          '电话'],   ['hand',           '提示'],   ['user-cog',      '账户'],
  ['database',       '数据库'], ['cloud',          '云'],     ['cpu',            '算力'],   ['hard-drive',    '存储'],
  ['network',        '图谱'],   ['git-branch',     '层级'],   ['workflow',       '流程'],   ['layers',        '栈'],
  ['bot',            'AI'],     ['brain',          '推理'],   ['wand-sparkles',  '生成'],   ['zap',           '快速'],
  ['terminal',       '终端'],   ['code',           '代码'],   ['function-square','函数'],   ['plug',          '集成'],
  ['file-text',      '文档'],   ['book-open',      '阅读'],   ['notebook-pen',   '笔记'],   ['bookmark',      '收藏'],
  ['quote',          '引用'],   ['list-checks',    '清单'],   ['tag',            '标签'],   ['folder-open',   '目录'],
  ['rocket',         '发布'],   ['target',         '目标'],   ['compass',        '探索'],   ['search',        '搜索'],
  ['check-circle-2', '通过'],   ['triangle-alert', '警示'],   ['x-circle',       '失败'],   ['help-circle',   '疑问'],
  ['line-chart',     '增长'],   ['bar-chart-3',    '柱图'],   ['pie-chart',      '环图'],   ['timer',         '计时'],
  ['calendar',       '日历'],   ['gauge',          '仪表'],   ['trending-up',    '趋势'],   ['shield-check',  '安全'],
];

function IconGallery() {
  return (
    <SubSec name="I-2 · 常用图标库 · 48 个" tag="CURATED SET">
      <Stage pattern="dot" label="● ICONS · GALLERY" labelR="10.I2">
        <div style={{ position: 'absolute', top: '5%', left: '4%', right: '4%' }}>
          <div className="meta" style={{ color: 'var(--accent)' }}>CURATED · 48 ICONS · HOVER → ACCENT</div>
          <div className="cn" style={{ fontSize: 13, color: 'var(--fg-3)', marginTop: 4 }}>Lucide 官方 id · 用法 <span className="mono" style={{ color: 'var(--fg-2)' }}>{'<L name="zap" />'}</span></div>
        </div>
        <div style={{ position: 'absolute', inset: '16% 4% 4%', display: 'grid', gridTemplateColumns: 'repeat(8, 1fr)', gridAutoRows: '1fr', gap: 10 }}>
          {LU_ICONS.map(([id, cn]) => (
            <IconCell key={id} name={id} label={id.toUpperCase().replace(/-/g, '·').slice(0, 11)} />
          ))}
        </div>
      </Stage>
      <Params rows={[
        { k: 'COUNT', v: '48 个 / 6 组：人·数据·AI·文档·行动·度量' },
        { k: 'POOL',  v: '不够用 → lucide.dev 现搜 · 直接 name 传入' },
        { k: 'COLOR', v: '默认 fg-2 · hover accent · 不要主动上色' },
      ]} />
    </SubSec>
  );
}

/* ============== I-3 · 应用示范 ============== */
function IconApplications() {
  return (
    <SubSec name="I-3 · 应用示范 · 6 种用法" tag="WHERE TO PLACE">
      <Stage pattern="grid" label="● ICON · USAGE" labelR="10.I3">
        <div style={{ position: 'absolute', inset: '5% 4%', display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gridTemplateRows: '1fr 1fr', gap: 14 }}>
          {/* 1 卡片标题 */}
          <div style={{ border: '1px solid var(--line-2)', borderRadius: 2, padding: 22, display: 'flex', flexDirection: 'column', justifyContent: 'space-between' }}>
            <div className="meta" style={{ color: 'var(--accent)' }}>USE 01 · CARD HEADER</div>
            <div>
              <L name="brain" size={32} sw={1.5} style={{ color: 'var(--accent)' }} />
              <div className="cn" style={{ fontSize: 20, fontWeight: 700, marginTop: 10 }}>推理质量</div>
              <div className="cn" style={{ fontSize: 13, color: 'var(--fg-2)', marginTop: 4 }}>Chain-of-Thought 提升 23%</div>
            </div>
          </div>
          {/* 2 列表前缀 */}
          <div style={{ border: '1px solid var(--line-2)', borderRadius: 2, padding: 22 }}>
            <div className="meta" style={{ color: 'var(--accent)' }}>USE 02 · LIST PREFIX</div>
            <div style={{ marginTop: 14, display: 'flex', flexDirection: 'column', gap: 12 }}>
              {[
                ['check-circle-2', '通过 12 项测试',  'var(--accent)'],
                ['triangle-alert',  '3 项需复审',     'var(--fg-2)'],
                ['x-circle',       '1 项失败',       'var(--fg-3)'],
              ].map(([n, t, c]) => (
                <div key={n} style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
                  <L name={n} size={18} sw={2} style={{ color: c }} />
                  <div className="cn" style={{ fontSize: 15, color: 'var(--fg)' }}>{t}</div>
                </div>
              ))}
            </div>
          </div>
          {/* 3 装饰角 */}
          <div style={{ position: 'relative', border: '1px solid var(--accent)', borderRadius: 2, padding: 22, overflow: 'hidden' }}>
            <div className="meta" style={{ color: 'var(--accent)' }}>USE 03 · ORNAMENT</div>
            <div className="cn" style={{ fontSize: 22, fontWeight: 700, marginTop: 12 }}>第 04 章</div>
            <div className="cn" style={{ fontSize: 15, color: 'var(--fg-2)', marginTop: 6 }}>从原型到生产</div>
            <div style={{ position: 'absolute', right: -16, bottom: -24, color: 'var(--accent)', opacity: 0.18 }}>
              <L name="rocket" size={180} sw={1.2} />
            </div>
          </div>
          {/* 4 节点 */}
          <div style={{ border: '1px solid var(--line-2)', borderRadius: 2, padding: 22, display: 'flex', flexDirection: 'column', justifyContent: 'space-between' }}>
            <div className="meta" style={{ color: 'var(--accent)' }}>USE 04 · NODE BADGE</div>
            <div style={{ display: 'flex', alignItems: 'center', gap: 14, marginTop: 14 }}>
              {['user', 'cpu', 'database', 'cloud'].map((c, i, arr) => (
                <React.Fragment key={c}>
                  <div style={{ width: 44, height: 44, borderRadius: '50%', border: '1.5px solid var(--accent)', display: 'flex', alignItems: 'center', justifyContent: 'center', color: 'var(--accent)' }}>
                    <L name={c} size={20} sw={1.75} />
                  </div>
                  {i < arr.length - 1 && <div style={{ flex: 1, height: 1, background: 'var(--line-2)' }} />}
                </React.Fragment>
              ))}
            </div>
            <div className="cn" style={{ fontSize: 13, color: 'var(--fg-3)', marginTop: 8 }}>圆形 hairline + Lucide 1.75 stroke</div>
          </div>
          {/* 5 KPI */}
          <div style={{ border: '1px solid var(--line-2)', borderRadius: 2, padding: 22, display: 'flex', flexDirection: 'column', justifyContent: 'space-between' }}>
            <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
              <div className="meta" style={{ color: 'var(--accent)' }}>USE 05 · KPI TILE</div>
              <L name="trending-up" size={22} sw={2} style={{ color: 'var(--accent)' }} />
            </div>
            <div>
              <div className="cond" style={{ fontSize: 64, fontWeight: 800, color: 'var(--fg)', lineHeight: 1, letterSpacing: '-0.02em' }}>+42<span style={{ fontSize: 30, color: 'var(--accent)' }}>%</span></div>
              <div className="cn" style={{ fontSize: 13, color: 'var(--fg-2)', marginTop: 6 }}>检索召回率 · vs 基线</div>
            </div>
          </div>
          {/* 6 输入框 */}
          <div style={{ border: '1px solid var(--line-2)', borderRadius: 2, padding: 22, display: 'flex', flexDirection: 'column', justifyContent: 'space-between' }}>
            <div className="meta" style={{ color: 'var(--accent)' }}>USE 06 · INPUT AFFIX</div>
            <div style={{ display: 'flex', alignItems: 'center', gap: 10, padding: '14px 16px', border: '1px solid var(--line-2)', borderRadius: 2, background: 'var(--bg)' }}>
              <L name="search" size={18} sw={1.5} style={{ color: 'var(--fg-3)' }} />
              <div className="cn" style={{ fontSize: 14, color: 'var(--fg-3)', flex: 1 }}>搜索文档、片段、模型...</div>
              <span className="mono" style={{ fontSize: 11, letterSpacing: '0.18em', color: 'var(--fg-3)', border: '1px solid var(--line-2)', padding: '2px 6px', borderRadius: 2 }}>⌘ K</span>
            </div>
            <div className="cn" style={{ fontSize: 12, color: 'var(--fg-3)' }}>前缀 search · 后缀快捷键</div>
          </div>
        </div>
      </Stage>
    </SubSec>
  );
}

/* ============== 主入口 ============== */
function IllustrationsSection() {
  return (
    <Section id="illustrations" num="10" title="图标系统 · Iconography"
      desc='全库统一用 <b>Lucide Icons</b>（开源 · 1500+ · stroke-based · 行业标准）。<em>不使用场景插画 / 卡通人物 / 装饰图形</em>，与 SpaceX × Grok × X 的视觉原则一致 —— <b>纯几何、纯单色、零装饰</b>。'>
      <IllRules />
      <StrokeShowcase />
      <IconGallery />
      <IconApplications />
    </Section>
  );
}

Object.assign(window, { IllustrationsSection, LucideIcon: L });
CODEX_LAZYPACK_250F2AA7496D5DDEC2CFEE16D18FEE717BE9803D

# video-spec-builder/Full Code/styles.css
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/video-spec-builder/Full Code/styles.css")"
cat > "{{CODEX_HOME}}/skills/video-spec-builder/Full Code/styles.css" <<'CODEX_LAZYPACK_A012D4E5422871166D4B606982C6F2B68D13C0E8'
/* ================================================================
   styles.css — 视频组件库 v2 · SpaceX × Grok × X 视觉语言
   纯黑底 · 几何字体 · spec-sheet 装饰
   ================================================================ */

/* ---------- page shell ---------- */
.shell {
  max-width: 1320px;
  margin: 0 auto;
  padding: 80px 56px 240px;
}

/* ---------- top hero · SPEC SHEET ---------- */
.hero {
  display: grid;
  grid-template-columns: 1.6fr 1fr;
  align-items: stretch;
  gap: 64px;
  border-top: 1px solid var(--line-2);
  border-bottom: 1px solid var(--line-2);
  padding: 56px 0;
  margin-bottom: 96px;
  position: relative;
}
.hero::before, .hero::after {
  content: ""; position: absolute; left: 0; right: 0;
  height: 1px; background: var(--line);
}
.hero::before { top: 8px; }
.hero::after  { bottom: 8px; }

.hero__left { display: flex; flex-direction: column; justify-content: space-between; gap: 40px; }
.hero__brand {
  font-family: var(--f-mono);
  font-size: 11px;
  letter-spacing: var(--ls-mission);
  text-transform: uppercase;
  color: var(--fg-3);
}
.hero__title {
  font-family: var(--f-cond);
  font-size: clamp(64px, 9.5vw, 156px);
  font-weight: 700;
  letter-spacing: -0.04em;
  line-height: 0.86;
  margin: 0;
  text-transform: uppercase;
}
.hero__title .hero__accent { color: var(--accent); }
.hero__sub {
  font-family: var(--f-sans);
  font-size: 18px;
  font-weight: 400;
  color: var(--fg-2);
  letter-spacing: -0.005em;
  max-width: 540px;
}
.hero__meta {
  display: flex;
  flex-direction: column;
  justify-content: flex-end;
  gap: 0;
  border-left: 1px solid var(--line-2);
  padding-left: 32px;
}
.hero__meta > div {
  display: grid;
  grid-template-columns: 100px 1fr;
  align-items: baseline;
  gap: 18px;
  padding: 10px 0;
  border-bottom: 1px solid var(--line);
  font-family: var(--f-mono);
  font-size: 11px;
  letter-spacing: var(--ls-caps);
  text-transform: uppercase;
  white-space: nowrap;
}
.hero__meta > div > span { color: var(--fg-3); }
.hero__meta > div > b { color: var(--fg); font-weight: 600; }

/* ---------- section ---------- */
.section { margin-bottom: 120px; scroll-margin-top: 40px; }
.section__num {
  font-family: var(--f-mono);
  font-size: 11px;
  letter-spacing: var(--ls-mission);
  text-transform: uppercase;
  color: var(--accent);
  margin-bottom: 14px;
  display: flex; align-items: center; gap: 16px;
}
.section__num::after {
  content: ""; flex: 1; height: 1px; background: var(--line);
}
.section__title {
  font-family: var(--f-cond);
  font-size: 64px;
  font-weight: 700;
  letter-spacing: -0.025em;
  line-height: 0.92;
  text-transform: uppercase;
  margin: 0 0 18px;
}
.section__desc {
  font-size: var(--t-body);
  color: var(--fg-2);
  max-width: 720px;
  line-height: 1.7;
  margin-bottom: 56px;
  font-family: var(--f-cn);
}
.section__desc em { color: var(--accent); font-style: normal; }
.section__desc b { color: var(--fg); font-weight: 600; }

.subsec { margin-bottom: 72px; }
.subsec__head {
  display: flex;
  align-items: baseline;
  justify-content: space-between;
  margin-bottom: 22px;
  padding-bottom: 14px;
  border-bottom: 1px solid var(--line);
}
.subsec__name {
  font-family: var(--f-cond);
  font-size: 24px;
  font-weight: 600;
  letter-spacing: -0.008em;
  text-transform: uppercase;
}
.subsec__tag {
  font-family: var(--f-mono);
  font-size: 11px;
  letter-spacing: var(--ls-caps);
  text-transform: uppercase;
  color: var(--fg-3);
}

/* ---------- stage (16:9 preview canvas) ---------- */
.stage {
  position: relative;
  width: 100%;
  aspect-ratio: 16 / 9;
  background: var(--bg);
  border: 1px solid var(--line-2);
  border-radius: 2px;
  overflow: hidden;
  margin-bottom: 16px;
}
.stage .meta { font-size: 13px; letter-spacing: 0.16em; }
.stage .mono { font-size: 16px; }
.stage .cn   { line-height: 1.35; }
.stage--dotgrid {
  background-image: radial-gradient(rgba(255,255,255,0.07) 1px, transparent 1.2px);
  background-size: 22px 22px;
}
.stage--graph {
  background-image:
    linear-gradient(to right, rgba(255,255,255,0.05) 1px, transparent 1px),
    linear-gradient(to bottom, rgba(255,255,255,0.05) 1px, transparent 1px);
  background-size: 44px 44px;
}
.stage__corner {
  position: absolute;
  top: 14px; left: 14px;
  font-family: var(--f-mono);
  font-size: 11px;
  letter-spacing: var(--ls-mission);
  text-transform: uppercase;
  color: var(--fg-3);
  z-index: 5;
}
.stage__corner--r  { left: auto; right: 14px; }
.stage__corner--b  { top: auto; bottom: 14px; }
.stage__corner--br { top: auto; bottom: 14px; left: auto; right: 14px; }

/* ---------- params grid ---------- */
.params {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(190px, 1fr));
  gap: 1px;
  background: var(--line);
  border: 1px solid var(--line);
  border-radius: 2px;
  overflow: hidden;
}
.param { background: var(--bg-card); padding: 16px 18px; }
.param__k {
  font-family: var(--f-mono);
  font-size: 10px;
  letter-spacing: var(--ls-mission);
  text-transform: uppercase;
  color: var(--fg-3);
  margin-bottom: 8px;
}
.param__v {
  font-family: var(--f-mono);
  font-size: 13px;
  color: var(--fg);
  letter-spacing: 0;
}
.param__v .sw { display: inline-block; width: 10px; height: 10px; margin-right: 6px; vertical-align: -1px; border-radius: 0; }

/* ---------- card ---------- */
.card {
  background: var(--bg-card);
  border: 1px solid var(--line);
  border-radius: 2px;
  padding: 20px;
}

/* ---------- nav · sticky top ---------- */
.nav {
  position: sticky;
  top: 0;
  z-index: 50;
  margin: -80px -56px 56px;
  padding: 14px 56px;
  display: flex;
  gap: 28px;
  background: rgba(0,0,0,0.86);
  backdrop-filter: blur(14px) saturate(140%);
  -webkit-backdrop-filter: blur(14px) saturate(140%);
  border-bottom: 1px solid var(--line-2);
  overflow-x: auto;
  scrollbar-width: none;
}
.nav::-webkit-scrollbar { display: none; }
.nav__item {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  white-space: nowrap;
  flex-shrink: 0;
  font-family: var(--f-mono);
  font-size: 10px;
  letter-spacing: var(--ls-mission);
  text-transform: uppercase;
  color: var(--fg-3);
  text-decoration: none;
  cursor: pointer;
  padding: 6px 0;
  transition: color var(--d-1);
}
.nav__item::before {
  content: "/";
  color: var(--fg-3);
  transition: color var(--d-2) var(--ease-out);
}
.nav__item:hover, .nav__item.is-active { color: var(--fg); }
.nav__item:hover::before, .nav__item.is-active::before { color: var(--accent); }

/* ---------- footer ---------- */
.outro {
  margin-top: 120px;
  padding: 56px 0 24px;
  border-top: 1px solid var(--line-2);
  display: grid;
  grid-template-columns: 1fr auto;
  align-items: baseline;
  gap: 32px;
}
.outro__copy {
  font-family: var(--f-cond);
  font-size: 40px;
  font-weight: 700;
  color: var(--fg);
  letter-spacing: -0.02em;
  text-transform: uppercase;
  max-width: 720px;
  line-height: 0.95;
}
.outro__meta {
  font-family: var(--f-mono);
  font-size: 11px;
  letter-spacing: var(--ls-mission);
  text-transform: uppercase;
  color: var(--fg-3);
  text-align: right;
  line-height: 1.9;
}

/* ================================================================
   v3 · 工具类（spec-sheet flourishes）
   ================================================================ */

.cross {
  position: absolute;
  width: 12px; height: 12px;
  color: var(--accent);
  pointer-events: none;
}
.cross::before, .cross::after { content: ""; position: absolute; background: currentColor; }
.cross::before { left: 5px; top: 0; width: 1px; height: 100%; }
.cross::after  { top: 5px; left: 0; width: 100%; height: 1px; }
.cross--tl { top: -6px; left: -6px; }
.cross--tr { top: -6px; right: -6px; }
.cross--bl { bottom: -6px; left: -6px; }
.cross--br { bottom: -6px; right: -6px; }

.tick-rule { display: flex; gap: 4px; align-items: flex-end; height: 14px; }
.tick-rule i { display: block; width: 1px; background: var(--fg-3); opacity: 0.5; }
.tick-rule i:nth-child(5n+1) { height: 14px; opacity: 1; }
.tick-rule i:nth-child(5n+2), .tick-rule i:nth-child(5n+3),
.tick-rule i:nth-child(5n+4), .tick-rule i:nth-child(5n+5) { height: 7px; }

.idx {
  font-family: var(--f-mono); font-size: 11px; letter-spacing: var(--ls-mission);
  color: var(--fg-3); text-transform: uppercase;
  display: inline-flex; align-items: center; gap: 10px;
}
.idx::before { content: ""; width: 22px; height: 1px; background: var(--accent); }

.slash { color: var(--accent); margin: 0 8px; font-family: var(--f-mono); }

.big-num {
  font-family: var(--f-cond);
  font-weight: 700;
  line-height: 0.86;
  letter-spacing: -0.04em;
  font-variant-numeric: tabular-nums;
  font-feature-settings: "tnum" 1;
}

.eyebrow {
  font-family: var(--f-mono);
  font-size: 11px;
  letter-spacing: var(--ls-mission);
  text-transform: uppercase;
  color: var(--accent);
  display: inline-flex; align-items: center; gap: 8px;
}
.eyebrow::before { content: "●"; font-size: 8px; }

.rule-label {
  display: flex; align-items: center; gap: 12px;
  font-family: var(--f-mono); font-size: 11px;
  letter-spacing: var(--ls-caps); color: var(--fg-3);
}
.rule-label::before, .rule-label::after {
  content: ""; flex: 1; height: 1px; background: var(--line);
}

.kbd {
  display: inline-flex; align-items: center; justify-content: center;
  min-width: 22px; height: 22px; padding: 0 6px;
  font-family: var(--f-mono); font-size: 11px;
  color: var(--fg-2);
  border: 1px solid var(--line-2);
  border-radius: 2px;
  background: rgba(255,255,255,0.02);
}

.dot-pulse { position: relative; width: 8px; height: 8px; border-radius: 50%; background: var(--accent); }
.dot-pulse::after {
  content: ""; position: absolute; inset: -4px;
  border-radius: 50%;
  border: 1px solid var(--accent);
  animation: dot-pulse 2.4s ease-out infinite;
  opacity: 0;
}
@keyframes dot-pulse {
  0%   { transform: scale(0.6); opacity: 0.8; }
  100% { transform: scale(2.0); opacity: 0; }
}

.under-accent {
  background-image: linear-gradient(to bottom, transparent 88%, var(--accent) 88%, var(--accent) 100%);
  background-repeat: no-repeat;
  padding: 0 2px;
}

.frame { position: relative; }

/* spec-sheet row · 仿 SpaceX 发射页 */
.spec-row {
  display: flex; align-items: center; gap: 14px;
  font-family: var(--f-mono); font-size: 11px;
  letter-spacing: var(--ls-mission); color: var(--fg-3);
  text-transform: uppercase;
}
.spec-row b { color: var(--fg); font-weight: 600; }
.spec-row .accent { color: var(--accent); }

/* T-MINUS countdown block */
.t-minus {
  font-family: var(--f-cond);
  font-weight: 700;
  letter-spacing: -0.03em;
  line-height: 0.9;
  font-variant-numeric: tabular-nums;
}

/* coordinate block — 32°N 117°E */
.coord {
  font-family: var(--f-mono);
  font-size: 11px;
  letter-spacing: var(--ls-caps);
  color: var(--fg-3);
  text-transform: uppercase;
}

/* bracket wrap · [KEYWORD] */
.bracket::before { content: "["; color: var(--accent); margin-right: 6px; }
.bracket::after  { content: "]"; color: var(--accent); margin-left: 6px; }
CODEX_LAZYPACK_A012D4E5422871166D4B606982C6F2B68D13C0E8

# video-spec-builder/Full Code/tokens.css
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/video-spec-builder/Full Code/tokens.css")"
cat > "{{CODEX_HOME}}/skills/video-spec-builder/Full Code/tokens.css" <<'CODEX_LAZYPACK_37D7A2B7EEFD2244E93383635DC770E916D6094C'
/* ================================================================
   tokens.css — 视频组件库 v2 · SpaceX × Grok × X 视觉语言
   纯黑 / 纯白 · 几何 sans · condensed 数字 · spec-sheet 美学
   ================================================================ */
:root {
  /* ---------- color · pure mono ---------- */
  --bg:        #000000;          /* pure black · 太空黑 */
  --bg-card:   #0A0A0A;          /* 卡片层 */
  --bg-elev:   #141414;          /* 抬起层 */
  --bg-flash:  #FFFFFF;          /* 反白 cut-in */

  --fg:        #FFFFFF;          /* pure white */
  --fg-2:      rgba(255,255,255,0.66);
  --fg-3:      rgba(255,255,255,0.42);
  --fg-4:      rgba(255,255,255,0.18);

  --line:      rgba(255,255,255,0.08);
  --line-2:    rgba(255,255,255,0.16);
  --line-3:    rgba(255,255,255,0.28);

  /* single accent — Tweaks 可换 · 默认就是白 (Grok-style mono) */
  --accent:    #FFFFFF;
  --accent-2:  color-mix(in oklab, var(--accent) 40%, transparent);
  --accent-3:  color-mix(in oklab, var(--accent) 14%, transparent);

  /* status · 极少使用 · 仅图表 */
  --green:     #00E07A;          /* SpaceX 仪表绿 */
  --red:       #FF3333;          /* abort red */
  --yellow:    #FFC700;          /* caution yellow */

  /* ---------- type · SpaceX × X × Grok stack ---------- */
  --f-sans:    "Space Grotesk", "Inter Tight", "PingFang SC", "Noto Sans SC", -apple-system, sans-serif;
  --f-cond:    "Barlow Semi Condensed", "Oswald", "Space Grotesk", sans-serif;  /* big numbers / display */
  --f-mono:    "JetBrains Mono", "IBM Plex Mono", "Geist Mono", ui-monospace, monospace;
  --f-cn:      "Noto Sans SC", "PingFang SC", "HarmonyOS Sans SC", sans-serif;

  /* type ramp — half-scale of 4K target */
  --t-display: 96px;   /* hero · spec sheet hero */
  --t-h1:      56px;   /* big numbers */
  --t-h2:      32px;
  --t-h3:      22px;
  --t-h4:      17px;
  --t-body:    15px;
  --t-small:   13px;
  --t-cap:     11px;
  --t-meta:    10px;

  /* weights — 跳过 500/700，对比悬崖 */
  --w-reg:  400;
  --w-mid:  600;
  --w-bold: 700;
  --w-heavy: 800;

  /* letter-spacing — SpaceX 偏紧 + caps 偏松 */
  --ls-display: -0.03em;
  --ls-tight:   -0.018em;
  --ls-normal:  -0.005em;
  --ls-caps:     0.18em;
  --ls-meta:     0.22em;
  --ls-mission:  0.32em;        /* T-MINUS 等任务字串极宽 */

  /* ---------- motion ---------- */
  --ease-out:    cubic-bezier(0.22, 1, 0.36, 1);
  --ease-in:     cubic-bezier(0.55, 0, 1, 0.45);
  --ease-soft:   cubic-bezier(0.4, 0, 0.2, 1);
  --ease-spring: cubic-bezier(0.34, 1.36, 0.64, 1);

  --d-1: 200ms;
  --d-2: 400ms;
  --d-3: 700ms;
  --d-4: 1100ms;

  /* ---------- radii — SpaceX 几何感：极小或 0 ---------- */
  --r-0: 0px;
  --r-1: 2px;
  --r-2: 4px;
  --r-3: 8px;

  --space-1: 8px;
  --space-2: 16px;
  --space-3: 24px;
  --space-4: 40px;
  --space-5: 64px;
  --space-6: 96px;
}

/* ---------- reset ---------- */
* { box-sizing: border-box; }
html, body { margin: 0; padding: 0; background: var(--bg); color: var(--fg); }
body {
  font-family: var(--f-sans);
  font-size: var(--t-body);
  font-weight: var(--w-reg);
  letter-spacing: var(--ls-normal);
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  font-feature-settings: "ss01", "cv11", "tnum";
}

:lang(zh), .cn { font-family: var(--f-cn); }

.mono { font-family: var(--f-mono); letter-spacing: 0; font-variant-ligatures: none; }
.cond { font-family: var(--f-cond); letter-spacing: var(--ls-tight); font-feature-settings: "tnum" 1; }
.caps { text-transform: uppercase; letter-spacing: var(--ls-caps); font-family: var(--f-mono); font-weight: var(--w-mid); }
.meta { font-family: var(--f-mono); font-size: var(--t-meta); letter-spacing: var(--ls-meta); text-transform: uppercase; color: var(--fg-3); }
.mission { font-family: var(--f-mono); letter-spacing: var(--ls-mission); text-transform: uppercase; }

.serif { font-family: var(--f-sans); font-weight: var(--w-reg); font-style: italic; }
CODEX_LAZYPACK_37D7A2B7EEFD2244E93383635DC770E916D6094C

# video-spec-builder/Full Code/tweaks-panel.jsx
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/video-spec-builder/Full Code/tweaks-panel.jsx")"
cat > "{{CODEX_HOME}}/skills/video-spec-builder/Full Code/tweaks-panel.jsx" <<'CODEX_LAZYPACK_D3996CCE783414076F803167D26EB048EFC6EDF5'

// tweaks-panel.jsx
// Reusable Tweaks shell + form-control helpers.
//
// Owns the host protocol (listens for __activate_edit_mode / __deactivate_edit_mode,
// posts __edit_mode_available / __edit_mode_set_keys / __edit_mode_dismissed) so
// individual prototypes don't re-roll it. Ships a consistent set of controls so you
// don't hand-draw <input type="range">, segmented radios, steppers, etc.
//
// Usage (in an HTML file that loads React + Babel):
//
//   const TWEAK_DEFAULTS = /*EDITMODE-BEGIN*/{
//     "primaryColor": "#D97757",
//     "palette": ["#D97757", "#29261b", "#f6f4ef"],
//     "fontSize": 16,
//     "density": "regular",
//     "dark": false
//   }/*EDITMODE-END*/;
//
//   function App() {
//     const [t, setTweak] = useTweaks(TWEAK_DEFAULTS);
//     return (
//       <div style={{ fontSize: t.fontSize, color: t.primaryColor }}>
//         Hello
//         <TweaksPanel>
//           <TweakSection label="Typography" />
//           <TweakSlider label="Font size" value={t.fontSize} min={10} max={32} unit="px"
//                        onChange={(v) => setTweak('fontSize', v)} />
//           <TweakRadio  label="Density" value={t.density}
//                        options={['compact', 'regular', 'comfy']}
//                        onChange={(v) => setTweak('density', v)} />
//           <TweakSection label="Theme" />
//           <TweakColor  label="Primary" value={t.primaryColor}
//                        options={['#D97757', '#2A6FDB', '#1F8A5B', '#7A5AE0']}
//                        onChange={(v) => setTweak('primaryColor', v)} />
//           <TweakColor  label="Palette" value={t.palette}
//                        options={[['#D97757', '#29261b', '#f6f4ef'],
//                                  ['#475569', '#0f172a', '#f1f5f9']]}
//                        onChange={(v) => setTweak('palette', v)} />
//           <TweakToggle label="Dark mode" value={t.dark}
//                        onChange={(v) => setTweak('dark', v)} />
//         </TweaksPanel>
//       </div>
//     );
//   }
//
// ─────────────────────────────────────────────────────────────────────────────

const __TWEAKS_STYLE = `
  .twk-panel{position:fixed;right:16px;bottom:16px;z-index:2147483646;width:280px;
    max-height:calc(100vh - 32px);display:flex;flex-direction:column;
    transform:scale(var(--dc-inv-zoom,1));transform-origin:bottom right;
    background:rgba(250,249,247,.78);color:#29261b;
    -webkit-backdrop-filter:blur(24px) saturate(160%);backdrop-filter:blur(24px) saturate(160%);
    border:.5px solid rgba(255,255,255,.6);border-radius:14px;
    box-shadow:0 1px 0 rgba(255,255,255,.5) inset,0 12px 40px rgba(0,0,0,.18);
    font:11.5px/1.4 ui-sans-serif,system-ui,-apple-system,sans-serif;overflow:hidden}
  .twk-hd{display:flex;align-items:center;justify-content:space-between;
    padding:10px 8px 10px 14px;cursor:move;user-select:none}
  .twk-hd b{font-size:12px;font-weight:600;letter-spacing:.01em}
  .twk-x{appearance:none;border:0;background:transparent;color:rgba(41,38,27,.55);
    width:22px;height:22px;border-radius:6px;cursor:default;font-size:13px;line-height:1}
  .twk-x:hover{background:rgba(0,0,0,.06);color:#29261b}
  .twk-body{padding:2px 14px 14px;display:flex;flex-direction:column;gap:10px;
    overflow-y:auto;overflow-x:hidden;min-height:0;
    scrollbar-width:thin;scrollbar-color:rgba(0,0,0,.15) transparent}
  .twk-body::-webkit-scrollbar{width:8px}
  .twk-body::-webkit-scrollbar-track{background:transparent;margin:2px}
  .twk-body::-webkit-scrollbar-thumb{background:rgba(0,0,0,.15);border-radius:4px;
    border:2px solid transparent;background-clip:content-box}
  .twk-body::-webkit-scrollbar-thumb:hover{background:rgba(0,0,0,.25);
    border:2px solid transparent;background-clip:content-box}
  .twk-row{display:flex;flex-direction:column;gap:5px}
  .twk-row-h{flex-direction:row;align-items:center;justify-content:space-between;gap:10px}
  .twk-lbl{display:flex;justify-content:space-between;align-items:baseline;
    color:rgba(41,38,27,.72)}
  .twk-lbl>span:first-child{font-weight:500}
  .twk-val{color:rgba(41,38,27,.5);font-variant-numeric:tabular-nums}

  .twk-sect{font-size:10px;font-weight:600;letter-spacing:.06em;text-transform:uppercase;
    color:rgba(41,38,27,.45);padding:10px 0 0}
  .twk-sect:first-child{padding-top:0}

  .twk-field{appearance:none;box-sizing:border-box;width:100%;min-width:0;height:26px;padding:0 8px;
    border:.5px solid rgba(0,0,0,.1);border-radius:7px;
    background:rgba(255,255,255,.6);color:inherit;font:inherit;outline:none}
  .twk-field:focus{border-color:rgba(0,0,0,.25);background:rgba(255,255,255,.85)}
  select.twk-field{padding-right:22px;
    background-image:url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='10' height='6' viewBox='0 0 10 6'><path fill='rgba(0,0,0,.5)' d='M0 0h10L5 6z'/></svg>");
    background-repeat:no-repeat;background-position:right 8px center}

  .twk-slider{appearance:none;-webkit-appearance:none;width:100%;height:4px;margin:6px 0;
    border-radius:999px;background:rgba(0,0,0,.12);outline:none}
  .twk-slider::-webkit-slider-thumb{-webkit-appearance:none;appearance:none;
    width:14px;height:14px;border-radius:50%;background:#fff;
    border:.5px solid rgba(0,0,0,.12);box-shadow:0 1px 3px rgba(0,0,0,.2);cursor:default}
  .twk-slider::-moz-range-thumb{width:14px;height:14px;border-radius:50%;
    background:#fff;border:.5px solid rgba(0,0,0,.12);box-shadow:0 1px 3px rgba(0,0,0,.2);cursor:default}

  .twk-seg{position:relative;display:flex;padding:2px;border-radius:8px;
    background:rgba(0,0,0,.06);user-select:none}
  .twk-seg-thumb{position:absolute;top:2px;bottom:2px;border-radius:6px;
    background:rgba(255,255,255,.9);box-shadow:0 1px 2px rgba(0,0,0,.12);
    transition:left .15s cubic-bezier(.3,.7,.4,1),width .15s}
  .twk-seg.dragging .twk-seg-thumb{transition:none}
  .twk-seg button{appearance:none;position:relative;z-index:1;flex:1;border:0;
    background:transparent;color:inherit;font:inherit;font-weight:500;min-height:22px;
    border-radius:6px;cursor:default;padding:4px 6px;line-height:1.2;
    overflow-wrap:anywhere}

  .twk-toggle{position:relative;width:32px;height:18px;border:0;border-radius:999px;
    background:rgba(0,0,0,.15);transition:background .15s;cursor:default;padding:0}
  .twk-toggle[data-on="1"]{background:#34c759}
  .twk-toggle i{position:absolute;top:2px;left:2px;width:14px;height:14px;border-radius:50%;
    background:#fff;box-shadow:0 1px 2px rgba(0,0,0,.25);transition:transform .15s}
  .twk-toggle[data-on="1"] i{transform:translateX(14px)}

  .twk-num{display:flex;align-items:center;box-sizing:border-box;min-width:0;height:26px;padding:0 0 0 8px;
    border:.5px solid rgba(0,0,0,.1);border-radius:7px;background:rgba(255,255,255,.6)}
  .twk-num-lbl{font-weight:500;color:rgba(41,38,27,.6);cursor:ew-resize;
    user-select:none;padding-right:8px}
  .twk-num input{flex:1;min-width:0;height:100%;border:0;background:transparent;
    font:inherit;font-variant-numeric:tabular-nums;text-align:right;padding:0 8px 0 0;
    outline:none;color:inherit;-moz-appearance:textfield}
  .twk-num input::-webkit-inner-spin-button,.twk-num input::-webkit-outer-spin-button{
    -webkit-appearance:none;margin:0}
  .twk-num-unit{padding-right:8px;color:rgba(41,38,27,.45)}

  .twk-btn{appearance:none;height:26px;padding:0 12px;border:0;border-radius:7px;
    background:rgba(0,0,0,.78);color:#fff;font:inherit;font-weight:500;cursor:default}
  .twk-btn:hover{background:rgba(0,0,0,.88)}
  .twk-btn.secondary{background:rgba(0,0,0,.06);color:inherit}
  .twk-btn.secondary:hover{background:rgba(0,0,0,.1)}

  .twk-swatch{appearance:none;-webkit-appearance:none;width:56px;height:22px;
    border:.5px solid rgba(0,0,0,.1);border-radius:6px;padding:0;cursor:default;
    background:transparent;flex-shrink:0}
  .twk-swatch::-webkit-color-swatch-wrapper{padding:0}
  .twk-swatch::-webkit-color-swatch{border:0;border-radius:5.5px}
  .twk-swatch::-moz-color-swatch{border:0;border-radius:5.5px}

  .twk-chips{display:flex;gap:6px}
  .twk-chip{position:relative;appearance:none;flex:1;min-width:0;height:46px;
    padding:0;border:0;border-radius:6px;overflow:hidden;cursor:default;
    box-shadow:0 0 0 .5px rgba(0,0,0,.12),0 1px 2px rgba(0,0,0,.06);
    transition:transform .12s cubic-bezier(.3,.7,.4,1),box-shadow .12s}
  .twk-chip:hover{transform:translateY(-1px);
    box-shadow:0 0 0 .5px rgba(0,0,0,.18),0 4px 10px rgba(0,0,0,.12)}
  .twk-chip[data-on="1"]{box-shadow:0 0 0 1.5px rgba(0,0,0,.85),
    0 2px 6px rgba(0,0,0,.15)}
  .twk-chip>span{position:absolute;top:0;bottom:0;right:0;width:34%;
    display:flex;flex-direction:column;box-shadow:-1px 0 0 rgba(0,0,0,.1)}
  .twk-chip>span>i{flex:1;box-shadow:0 -1px 0 rgba(0,0,0,.1)}
  .twk-chip>span>i:first-child{box-shadow:none}
  .twk-chip svg{position:absolute;top:6px;left:6px;width:13px;height:13px;
    filter:drop-shadow(0 1px 1px rgba(0,0,0,.3))}
`;

// ── useTweaks ───────────────────────────────────────────────────────────────
// Single source of truth for tweak values. setTweak persists via the host
// (__edit_mode_set_keys → host rewrites the EDITMODE block on disk).
function useTweaks(defaults) {
  const [values, setValues] = React.useState(defaults);
  // Accepts either setTweak('key', value) or setTweak({ key: value, ... }) so a
  // useState-style call doesn't write a "[object Object]" key into the persisted
  // JSON block.
  const setTweak = React.useCallback((keyOrEdits, val) => {
    const edits = typeof keyOrEdits === 'object' && keyOrEdits !== null
      ? keyOrEdits : { [keyOrEdits]: val };
    setValues((prev) => ({ ...prev, ...edits }));
    window.parent.postMessage({ type: '__edit_mode_set_keys', edits }, '*');
    // Same-window signal so in-page listeners (deck-stage rail thumbnails)
    // can react — the parent message only reaches the host, not peers.
    window.dispatchEvent(new CustomEvent('tweakchange', { detail: edits }));
  }, []);
  return [values, setTweak];
}

// ── TweaksPanel ─────────────────────────────────────────────────────────────
// Floating shell. Registers the protocol listener BEFORE announcing
// availability — if the announce ran first, the host's activate could land
// before our handler exists and the toolbar toggle would silently no-op.
// The close button posts __edit_mode_dismissed so the host's toolbar toggle
// flips off in lockstep; the host echoes __deactivate_edit_mode back which
// is what actually hides the panel.
function TweaksPanel({ title = 'Tweaks', noDeckControls = false, children }) {
  const [open, setOpen] = React.useState(false);
  const dragRef = React.useRef(null);
  // Auto-inject a rail toggle when a <deck-stage> is on the page. The
  // toggle drives the deck's per-viewer _railVisible via window message;
  // state is mirrored from the same localStorage key the deck reads so
  // the control reflects reality across reloads. The mechanism is the
  // message — authors who want custom placement can post it directly
  // and pass noDeckControls to suppress this one.
  const hasDeckStage = React.useMemo(
    () => typeof document !== 'undefined' && !!document.querySelector('deck-stage'),
    [],
  );
  // Hide the toggle until the host has actually enabled the rail (the
  // __omelette_rail_enabled window message, posted only when the
  // omelette_deck_rail_enabled flag is on for this user). The initial read
  // covers TweaksPanel mounting after the message already arrived; the
  // listener covers the common case of mounting first.
  const [railEnabled, setRailEnabled] = React.useState(
    () => hasDeckStage && !!document.querySelector('deck-stage')?._railEnabled,
  );
  React.useEffect(() => {
    if (!hasDeckStage || railEnabled) return undefined;
    const onMsg = (e) => {
      if (e.data && e.data.type === '__omelette_rail_enabled') setRailEnabled(true);
    };
    window.addEventListener('message', onMsg);
    return () => window.removeEventListener('message', onMsg);
  }, [hasDeckStage, railEnabled]);
  const [railVisible, setRailVisible] = React.useState(() => {
    try { return localStorage.getItem('deck-stage.railVisible') !== '0'; } catch (e) { return true; }
  });
  const toggleRail = (on) => {
    setRailVisible(on);
    window.postMessage({ type: '__deck_rail_visible', on }, '*');
  };
  const offsetRef = React.useRef({ x: 16, y: 16 });
  const PAD = 16;

  const clampToViewport = React.useCallback(() => {
    const panel = dragRef.current;
    if (!panel) return;
    const w = panel.offsetWidth, h = panel.offsetHeight;
    const maxRight = Math.max(PAD, window.innerWidth - w - PAD);
    const maxBottom = Math.max(PAD, window.innerHeight - h - PAD);
    offsetRef.current = {
      x: Math.min(maxRight, Math.max(PAD, offsetRef.current.x)),
      y: Math.min(maxBottom, Math.max(PAD, offsetRef.current.y)),
    };
    panel.style.right = offsetRef.current.x + 'px';
    panel.style.bottom = offsetRef.current.y + 'px';
  }, []);

  React.useEffect(() => {
    if (!open) return;
    clampToViewport();
    if (typeof ResizeObserver === 'undefined') {
      window.addEventListener('resize', clampToViewport);
      return () => window.removeEventListener('resize', clampToViewport);
    }
    const ro = new ResizeObserver(clampToViewport);
    ro.observe(document.documentElement);
    return () => ro.disconnect();
  }, [open, clampToViewport]);

  React.useEffect(() => {
    const onMsg = (e) => {
      const t = e?.data?.type;
      if (t === '__activate_edit_mode') setOpen(true);
      else if (t === '__deactivate_edit_mode') setOpen(false);
    };
    window.addEventListener('message', onMsg);
    window.parent.postMessage({ type: '__edit_mode_available' }, '*');
    return () => window.removeEventListener('message', onMsg);
  }, []);

  const dismiss = () => {
    setOpen(false);
    window.parent.postMessage({ type: '__edit_mode_dismissed' }, '*');
  };

  const onDragStart = (e) => {
    const panel = dragRef.current;
    if (!panel) return;
    const r = panel.getBoundingClientRect();
    const sx = e.clientX, sy = e.clientY;
    const startRight = window.innerWidth - r.right;
    const startBottom = window.innerHeight - r.bottom;
    const move = (ev) => {
      offsetRef.current = {
        x: startRight - (ev.clientX - sx),
        y: startBottom - (ev.clientY - sy),
      };
      clampToViewport();
    };
    const up = () => {
      window.removeEventListener('mousemove', move);
      window.removeEventListener('mouseup', up);
    };
    window.addEventListener('mousemove', move);
    window.addEventListener('mouseup', up);
  };

  if (!open) return null;
  return (
    <>
      <style>{__TWEAKS_STYLE}</style>
      <div ref={dragRef} className="twk-panel" data-noncommentable=""
           style={{ right: offsetRef.current.x, bottom: offsetRef.current.y }}>
        <div className="twk-hd" onMouseDown={onDragStart}>
          <b>{title}</b>
          <button className="twk-x" aria-label="Close tweaks"
                  onMouseDown={(e) => e.stopPropagation()}
                  onClick={dismiss}>✕</button>
        </div>
        <div className="twk-body">
          {children}
          {hasDeckStage && railEnabled && !noDeckControls && (
            <TweakSection label="Deck">
              <TweakToggle label="Thumbnail rail" value={railVisible} onChange={toggleRail} />
            </TweakSection>
          )}
        </div>
      </div>
    </>
  );
}

// ── Layout helpers ──────────────────────────────────────────────────────────

function TweakSection({ label, children }) {
  return (
    <>
      <div className="twk-sect">{label}</div>
      {children}
    </>
  );
}

function TweakRow({ label, value, children, inline = false }) {
  return (
    <div className={inline ? 'twk-row twk-row-h' : 'twk-row'}>
      <div className="twk-lbl">
        <span>{label}</span>
        {value != null && <span className="twk-val">{value}</span>}
      </div>
      {children}
    </div>
  );
}

// ── Controls ────────────────────────────────────────────────────────────────

function TweakSlider({ label, value, min = 0, max = 100, step = 1, unit = '', onChange }) {
  return (
    <TweakRow label={label} value={`${value}${unit}`}>
      <input type="range" className="twk-slider" min={min} max={max} step={step}
             value={value} onChange={(e) => onChange(Number(e.target.value))} />
    </TweakRow>
  );
}

function TweakToggle({ label, value, onChange }) {
  return (
    <div className="twk-row twk-row-h">
      <div className="twk-lbl"><span>{label}</span></div>
      <button type="button" className="twk-toggle" data-on={value ? '1' : '0'}
              role="switch" aria-checked={!!value}
              onClick={() => onChange(!value)}><i /></button>
    </div>
  );
}

function TweakRadio({ label, value, options, onChange }) {
  const trackRef = React.useRef(null);
  const [dragging, setDragging] = React.useState(false);
  // The active value is read by pointer-move handlers attached for the lifetime
  // of a drag — ref it so a stale closure doesn't fire onChange for every move.
  const valueRef = React.useRef(value);
  valueRef.current = value;

  // Segments wrap mid-word once per-segment width runs out. The track is
  // ~248px (280 panel − 28 body pad − 4 seg pad), each button loses 12px
  // to its own padding, and 11.5px system-ui averages ~6.3px/char — so 2
  // options fit ~16 chars each, 3 fit ~10. Past that (or >3 options), fall
  // back to a dropdown rather than wrap.
  const labelLen = (o) => String(typeof o === 'object' ? o.label : o).length;
  const maxLen = options.reduce((m, o) => Math.max(m, labelLen(o)), 0);
  const fitsAsSegments = maxLen <= ({ 2: 16, 3: 10 }[options.length] ?? 0);
  if (!fitsAsSegments) {
    // <select> emits strings — map back to the original option value so the
    // fallback stays type-preserving (numbers, booleans) like the segment path.
    const resolve = (s) => {
      const m = options.find((o) => String(typeof o === 'object' ? o.value : o) === s);
      return m === undefined ? s : typeof m === 'object' ? m.value : m;
    };
    return <TweakSelect label={label} value={value} options={options}
                        onChange={(s) => onChange(resolve(s))} />;
  }
  const opts = options.map((o) => (typeof o === 'object' ? o : { value: o, label: o }));
  const idx = Math.max(0, opts.findIndex((o) => o.value === value));
  const n = opts.length;

  const segAt = (clientX) => {
    const r = trackRef.current.getBoundingClientRect();
    const inner = r.width - 4;
    const i = Math.floor(((clientX - r.left - 2) / inner) * n);
    return opts[Math.max(0, Math.min(n - 1, i))].value;
  };

  const onPointerDown = (e) => {
    setDragging(true);
    const v0 = segAt(e.clientX);
    if (v0 !== valueRef.current) onChange(v0);
    const move = (ev) => {
      if (!trackRef.current) return;
      const v = segAt(ev.clientX);
      if (v !== valueRef.current) onChange(v);
    };
    const up = () => {
      setDragging(false);
      window.removeEventListener('pointermove', move);
      window.removeEventListener('pointerup', up);
    };
    window.addEventListener('pointermove', move);
    window.addEventListener('pointerup', up);
  };

  return (
    <TweakRow label={label}>
      <div ref={trackRef} role="radiogroup" onPointerDown={onPointerDown}
           className={dragging ? 'twk-seg dragging' : 'twk-seg'}>
        <div className="twk-seg-thumb"
             style={{ left: `calc(2px + ${idx} * (100% - 4px) / ${n})`,
                      width: `calc((100% - 4px) / ${n})` }} />
        {opts.map((o) => (
          <button key={o.value} type="button" role="radio" aria-checked={o.value === value}>
            {o.label}
          </button>
        ))}
      </div>
    </TweakRow>
  );
}

function TweakSelect({ label, value, options, onChange }) {
  return (
    <TweakRow label={label}>
      <select className="twk-field" value={value} onChange={(e) => onChange(e.target.value)}>
        {options.map((o) => {
          const v = typeof o === 'object' ? o.value : o;
          const l = typeof o === 'object' ? o.label : o;
          return <option key={v} value={v}>{l}</option>;
        })}
      </select>
    </TweakRow>
  );
}

function TweakText({ label, value, placeholder, onChange }) {
  return (
    <TweakRow label={label}>
      <input className="twk-field" type="text" value={value} placeholder={placeholder}
             onChange={(e) => onChange(e.target.value)} />
    </TweakRow>
  );
}

function TweakNumber({ label, value, min, max, step = 1, unit = '', onChange }) {
  const clamp = (n) => {
    if (min != null && n < min) return min;
    if (max != null && n > max) return max;
    return n;
  };
  const startRef = React.useRef({ x: 0, val: 0 });
  const onScrubStart = (e) => {
    e.preventDefault();
    startRef.current = { x: e.clientX, val: value };
    const decimals = (String(step).split('.')[1] || '').length;
    const move = (ev) => {
      const dx = ev.clientX - startRef.current.x;
      const raw = startRef.current.val + dx * step;
      const snapped = Math.round(raw / step) * step;
      onChange(clamp(Number(snapped.toFixed(decimals))));
    };
    const up = () => {
      window.removeEventListener('pointermove', move);
      window.removeEventListener('pointerup', up);
    };
    window.addEventListener('pointermove', move);
    window.addEventListener('pointerup', up);
  };
  return (
    <div className="twk-num">
      <span className="twk-num-lbl" onPointerDown={onScrubStart}>{label}</span>
      <input type="number" value={value} min={min} max={max} step={step}
             onChange={(e) => onChange(clamp(Number(e.target.value)))} />
      {unit && <span className="twk-num-unit">{unit}</span>}
    </div>
  );
}

// Relative-luminance contrast pick — checkmarks drawn over a swatch need to
// read on both #111 and #fafafa without per-option configuration. Hex input
// only (#rgb / #rrggbb); named or rgb()/hsl() colors fall through to "light".
function __twkIsLight(hex) {
  const h = String(hex).replace('#', '');
  const x = h.length === 3 ? h.replace(/./g, (c) => c + c) : h.padEnd(6, '0');
  const n = parseInt(x.slice(0, 6), 16);
  if (Number.isNaN(n)) return true;
  const r = (n >> 16) & 255, g = (n >> 8) & 255, b = n & 255;
  return r * 299 + g * 587 + b * 114 > 148000;
}

const __TwkCheck = ({ light }) => (
  <svg viewBox="0 0 14 14" aria-hidden="true">
    <path d="M3 7.2 5.8 10 11 4.2" fill="none" strokeWidth="2.2"
          strokeLinecap="round" strokeLinejoin="round"
          stroke={light ? 'rgba(0,0,0,.78)' : '#fff'} />
  </svg>
);

// TweakColor — curated color/palette picker. Each option is either a single
// hex string or an array of 1-5 hex strings; the card adapts — a lone color
// renders solid, a palette renders colors[0] as the hero (left ~2/3) with the
// rest stacked in a sharp column on the right. onChange emits the
// option in the shape it was passed (string stays string, array stays array).
// Without options it falls back to the native color input for back-compat.
function TweakColor({ label, value, options, onChange }) {
  if (!options || !options.length) {
    return (
      <div className="twk-row twk-row-h">
        <div className="twk-lbl"><span>{label}</span></div>
        <input type="color" className="twk-swatch" value={value}
               onChange={(e) => onChange(e.target.value)} />
      </div>
    );
  }
  // Native <input type=color> emits lowercase hex per the HTML spec, so
  // compare case-insensitively. String() guards JSON.stringify(undefined),
  // which returns the primitive undefined (no .toLowerCase).
  const key = (o) => String(JSON.stringify(o)).toLowerCase();
  const cur = key(value);
  return (
    <TweakRow label={label}>
      <div className="twk-chips" role="radiogroup">
        {options.map((o, i) => {
          const colors = Array.isArray(o) ? o : [o];
          const [hero, ...rest] = colors;
          const sup = rest.slice(0, 4);
          const on = key(o) === cur;
          return (
            <button key={i} type="button" className="twk-chip" role="radio"
                    aria-checked={on} data-on={on ? '1' : '0'}
                    aria-label={colors.join(', ')} title={colors.join(' · ')}
                    style={{ background: hero }}
                    onClick={() => onChange(o)}>
              {sup.length > 0 && (
                <span>
                  {sup.map((c, j) => <i key={j} style={{ background: c }} />)}
                </span>
              )}
              {on && <__TwkCheck light={__twkIsLight(hero)} />}
            </button>
          );
        })}
      </div>
    </TweakRow>
  );
}

function TweakButton({ label, onClick, secondary = false }) {
  return (
    <button type="button" className={secondary ? 'twk-btn secondary' : 'twk-btn'}
            onClick={onClick}>{label}</button>
  );
}

Object.assign(window, {
  useTweaks, TweaksPanel, TweakSection, TweakRow,
  TweakSlider, TweakToggle, TweakRadio, TweakSelect,
  TweakText, TweakNumber, TweakColor, TweakButton,
});
CODEX_LAZYPACK_D3996CCE783414076F803167D26EB048EFC6EDF5

# video-spec-builder/LICENSE
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/video-spec-builder/LICENSE")"
cat > "{{CODEX_HOME}}/skills/video-spec-builder/LICENSE" <<'CODEX_LAZYPACK_70485F34E1C191B7DA831CB76F1E449C1154A2E1'
MIT License

Copyright (c) 2026 feicaiclub

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
CODEX_LAZYPACK_70485F34E1C191B7DA831CB76F1E449C1154A2E1

# video-spec-builder/README.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/video-spec-builder/README.md")"
cat > "{{CODEX_HOME}}/skills/video-spec-builder/README.md" <<'CODEX_LAZYPACK_6A85E86B3B63F67C21C88F1A4596E6243773CFCD'
<img width="2172" height="724" alt="ChatGPT Image May 16, 2026, 10_46_58 PM" src="https://github.com/user-attachments/assets/7820d93e-84b6-4e09-904c-9567c6595c57" />

**English** · [中文](README.zh.md)

# video-spec-builder

[![License: MIT](https://img.shields.io/badge/License-MIT-brightgreen)](LICENSE) ![Agent Agnostic](https://img.shields.io/badge/Agent-Agnostic-blueviolet) [![skills.sh Compatible](https://img.shields.io/badge/skills.sh-Compatible-brightgreen)](https://skills.sh)

> A skill that works like a video director. You say "I want to make a video," and it grills you with questions until your idea is a script you can actually shoot.

I built this skill after realizing the hard part of making a video isn't the rendering. It's figuring out what you actually want.

You've got a vague idea in your head: a product video, a short for social, a company intro. But it's fuzzy. The moment you try to build it, the details get you — how long each shot runs, what's on screen, what comes first and what comes later. You probably haven't pinned them all down, and you might not even be able to put them into words.

video-spec-builder gets you through that part. Install it, then tell your AI "I want to make a video" inside Codex or Codex App, and it takes over the conversation. It listens to your brief the way a director would, then keeps asking: Who's this for? How long? What's the one line people should walk away with? Which shot carries the weight? Anywhere you go vague, or skip something, it stops and pushes you to fill it in.

A few rounds of that, and the fuzzy idea becomes a `video-spec.md`: a shot-by-shot script, timed to the second, every shot written out. Hand that to HyperFrames and it renders into a real video.

It won't shoot the video for you, and it won't invent the idea. It does one thing: push you, and stay with you, until the idea is something you can actually build.

## What it helps with

The problem it solves is "I have an idea but I can't explain it." A few situations where it earns its keep:

- You know the feeling you want but can't describe the actual picture. It refuses words like "premium" or "high-impact" and keeps after you until you can describe real shots and real motion.
- You have an idea but never thought parts of it through. Maybe you've got the opening and the ending but not the middle. Maybe it never crossed your mind that a section could use captions, or that visuals can move to the beat of the music. It brings those up.
- You have plenty of raw material but no order to it. A script, selling points, a pile of assets — it helps you cut that into individual shots and put them in sequence.

In the end it writes all of it into a script: what each shot shows, how it's presented, how long it holds, how it cuts to the next one.

There are two ways to use it. With no script yet, it talks you through the whole thing from scratch and produces a `video-spec.md`. With a script already there and just one thing to change, you tell it what you want different; it asks enough to be sure, makes the change, and checks whether it knocked anything else loose.

## The workflow

It's two skills working in sequence. video-spec-builder sits upstream and turns your idea into a script. HyperFrames sits downstream and turns the script into video.

```
       You: "I want to make a video"
                │
                ▼
   ┌────────────────────────┐
   │   video-spec-builder   │   asks, breaks it into shots
   └────────────────────────┘
                │
                ▼
          video-spec.md           shot-by-shot script, timed
                │
                ▼   hyperframes
   ┌────────────────────────┐
   │       HyperFrames      │   renders from the script
   └────────────────────────┘
                │
                ▼
          finished video
```

So before you start, you'll want both skills installed.

## Install

I mostly use this skill in **Codex**, and after that **Codex App**. Those are the two setups it works best in.

Before anything else, install two things: HyperFrames (the renderer, downstream) and video-spec-builder (this skill). Both go in through the `skills` CLI, one command each:

```bash
npx skills add heygen-comhyperframes
npx skills add feicaiclubvideo-spec-builder
```

Each command installs once and covers Codex, Codex App, Cursor and the rest. You don't install separately for each tool.

Two scopes to know about. By default it installs into the current folder (project-level), so it only works in the project where you ran the command. If you make videos often, add `-g` to install globally, available everywhere:

```bash
npx skills add feicaiclubvideo-spec-builder -g
```

Never used the `skills` CLI? Nothing to set up. `npx` pulls a copy just to run and leaves nothing behind. Needs Node 18 or newer.

## Using it

### Making a video from scratch

Once it's installed, just talk to your AI in plain language inside Codex or Codex App:

```
I want to make a 3-minute product demo, posting it on YouTube
```

It takes over and starts asking. You don't need to track its internal steps; it just talks with you. First it pins down the basics: who it's for, where it's going, how long, the core message. Then it takes stock of the material you have. Then it settles the style and pacing, picks a visual theme, and finally uses reference videos and counter-examples to calibrate.

It's a real conversation, not a form to fill in. Answer vaguely and it digs; miss something and it fills it in. When you're done, it writes out `video-spec.md`.

### Changing a video you already have

If there's already a `video-spec.md` in the project, just say what you want:

```
Shot 3 is too fast, slow it down; swap the background music for something quieter
```

It checks what you're after, looks at whether the change touches other shots, then updates the script.

### Rendering it

Once the script is final, hand it to HyperFrames:

```
hyperframes
```

> In Codex App, besides triggering it by talking, you can also call it directly with `video-spec-builder`.

## What HyperFrames can and can't do

Worth spelling this out, because it decides whether your script is worth the paper it's on.

HyperFrames renders video from HTML. That one fact is the root of everything it can and can't do. If HTML, CSS, and code can draw it, HyperFrames can turn it into video. If HTML can't draw it, HyperFrames can't either.

What it's **good at** is text and layout work: title animation, captions, word-by-word highlighting, page layout, transitions, charts, UI mockups, geometric animation. Anything you can draw with code, it handles cleanly.

What it **can't do** — know this before you write the script, because however good the script is, if HyperFrames can't render it, the work is wasted:

- It can't draw illustrations. Hand-drawn characters, painterly visuals, cartoon figures — it can't produce those, and writing code won't get you there. Code draws shapes and charts, not artwork.
- It can't generate live-action footage. A real filmed shot, a person performing — it can't conjure that out of nothing.
- It can't generate photorealistic images.
- It can generate a voiceover with AI (text-to-speech) in a pinch, but AI narration has an obvious machine tone. For real quality, record it yourself or hire someone.
- It won't compose background music for you.

The short version: HyperFrames is an **assembly** tool, not a **creation** tool. It takes the material you've prepared — video clips, images, voiceover, music — cuts and composites it, adds text and motion, and puts together a finished video. Assembly is its job.

So here's the thing worth remembering: how good the video looks comes down to the material you feed it. Good material and HyperFrames assembles it sharply. Weak material and HyperFrames can't save it. Video clips, images, voiceover, music — these are worth preparing carefully up front. They decide the quality, not HyperFrames.

## Visual themes

What a video looks like — colors, fonts, motion, transition style — is decided by a "theme." You either use one of HyperFrames' built-in presets, or write your own.

### The 8 HyperFrames presets

HyperFrames ships 8 themes. Name one and it's yours:

| Theme | Mood | Good for |
|---|---|---|
| Swiss Pulse | Precise, restrained, Swiss type | SaaS, data, dev tools, dashboards |
| Velvet Standard | Premium, timeless | Luxury, enterprise software, keynotes, investor decks |
| Deconstructed | Industrial, raw | Tech launches, security products, anything with a punk edge |
| Maximalist Type | Loud, kinetic | Big launches, milestone announcements, high-energy hype |
| Data Drift | Futuristic, immersive | AI products, ML platforms, frontier tech |
| Soft Signal | Intimate, warm | Wellness brands, personal stories, lifestyle products |
| Folk Frequency | Cultural, vivid | Consumer apps, food, community products |
| Shadow Cut | Dark, cinematic | Security products, dramatic reveals, serious storytelling |

Once you've picked one, write its name into `video-spec.md`.

### Writing your own

If none of the presets fit, write your own. HyperFrames has a few hard rules for custom themes, nothing complicated:

- A theme is a single `design.md` file, placed at the root of your video project. HyperFrames finds and reads it automatically when rendering.
- The format is fixed. A block of YAML up top for the design variables: colors, fonts, corner radius, spacing, motion. Below it, a set of fixed sections describing the design rules in prose: Overview, Colors, Typography, Elevation, Components, Do's and Don'ts.
- If your theme uses a font HyperFrames doesn't ship with, put the font's `.woff2` files in the project's `fonts/` folder yourself.

Drop a finished `design.md` into the video project root and the theme is live.

### A theme I made for you: Spec Mono

Writing a `design.md` from scratch takes some work, so I made one ahead of time and put it in this repo. It's called **Spec Mono**: pure black and white, the geometric, restrained, engineered look of SpaceX × Grok. It's done — use it as is.

<!-- placeholder: drop the Spec Mono preview image at spec-mono/preview.png, then uncomment the line below -->
<!-- ![Spec Mono preview](spec-mono/preview.png) -->

Download to see complete design [视频组件库 v2 · 硅谷暗色科技风.pdf](https://github.com/user-attachments/files/27866436/v2.pdf)
<img width="1020" height="1440" alt="视频组件库 v2 · 硅谷暗色科技风" src="https://github.com/user-attachments/assets/bef576da-73ba-4bad-a9c4-3c673e652eaa" />

The `spec-mono/` folder holds three files:

| File | What it is |
|---|---|
| `design.md` | the theme itself — this is what HyperFrames reads |
| `tokens.css` | a ready-made CSS file: color/font/spacing variables, plus styles for some decorative elements |
| `spec-mono-components.md` | the per-component spec for all 69 components under this theme |

To use it, copy `spec-mono/design.md` into your video project root and bring `tokens.css` along. It's already written to HyperFrames' format, so it renders right away.

> **Heads up:** the `design.md` tokens and `spec-mono-components.md` here are only a distilled, condensed extract. The complete theme design code is generated and downloaded from Codex design workflow. For the full implementation code, see the `Full Code/` folder.

## What's in this repo

```
video-spec-builder/
├── SKILL.md                  the skill's main file — the AI reads this first
├── README.md                 English
├── README.zh.md              中文
├── LICENSE
├── references/               reference docs on questioning, shot breakdown, pacing — loaded as needed
│   ├── workflow-0-1.md
│   ├── workflow-iteration.md
│   ├── question-bank.md
│   ├── scene-breakdown.md
│   ├── components-catalog.md
│   ├── pacing-rules.md
│   ├── spec-rules.md
│   └── dialogue-style.md
├── templates/
│   └── video-spec-template.md    output template for video-spec.md
├── examples/
│   └── video-spec-spacex.md      a complete video-spec example
└── spec-mono/                    the bundled custom theme, Spec Mono
    ├── design.md
    ├── tokens.css
    └── spec-mono-components.md
```

## License

MIT
CODEX_LAZYPACK_6A85E86B3B63F67C21C88F1A4596E6243773CFCD

# video-spec-builder/README.zh.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/video-spec-builder/README.zh.md")"
cat > "{{CODEX_HOME}}/skills/video-spec-builder/README.zh.md" <<'CODEX_LAZYPACK_8EEDC65560374EAB7D1EDDB3E5C84BB0C88B9508'
<img width="2172" height="724" alt="ChatGPT Image May 16, 2026, 10_46_58 PM" src="https://github.com/user-attachments/assets/7820d93e-84b6-4e09-904c-9567c6595c57" />

[English](README.md) · **中文**

# video-spec-builder

[![License: MIT](https://img.shields.io/badge/License-MIT-brightgreen)](LICENSE) ![Agent Agnostic](https://img.shields.io/badge/Agent-Agnostic-blueviolet) [![skills.sh Compatible](https://img.shields.io/badge/skills.sh-Compatible-brightgreen)](https://skills.sh)

> 一个像视频编导的 skill。你说一句"我想做个视频",它就追着问你,帮你把想法理成一份能落地的分镜脚本。

我做这个 skill,是因为发现做视频最卡人的不是渲染,是前面那一步:想清楚。

你心里有个念头,想做个产品片、发条抖音、做个公司介绍。可念头是模糊的。真要落地,每个镜头几秒、画面上摆什么、先讲什么后讲什么,这些细节你未必想得全,也未必说得出来。

video-spec-builder 就是来陪你过这一关的。装好之后,你在 Codex 或者 Codex App 里说一句"我想做个视频",它就接管对话,像编导听你讲 brief 那样一路追问:这视频给谁看?多长?最想让人记住哪句话?哪个镜头是重点?你答不上来的、压根没想到的地方,它会停下来提醒你、帮你补上。

来回聊下来,你那个模糊的念头会变成一份 `video-spec.md`:精确到秒、每个镜头都写明白的分镜脚本。这份脚本交给 HyperFrames,就能渲染成真正的视频。

它不替你拍片,也不替你想创意。它就做一件事:逼着你、也陪着你,把想法想到能落地为止。

## 它帮你解决什么

它解决的是"我有想法,但说不清楚"这个问题。几种典型情况它都管用:

- 你知道想要什么感觉,但说不出具体画面。它会把"高大上""有冲击力"这种形容词挡回去,问到你能描述出实际的画面和动作为止。
- 你有想法,但有些环节根本没想到。比如开头结尾想好了,中间怎么过渡没想;比如你没意识到这段可以加字幕、可以让画面跟着音乐节奏动。这些它会主动提。
- 你东西不少,但理不出头绪。逐字稿、卖点、素材一大堆,它帮你拆成一个个镜头,排出先后和节奏。

最后它把这些落成脚本。每个镜头是什么内容、用什么呈现、停几秒、怎么转到下一个,全写清楚。

它有两种用法。手上还没有脚本,它从头陪你聊一遍,产出 `video-spec.md`。已经有脚本、只想改某个地方,你直接说要改什么,它问清楚再动手,还会顺手查一下这改动会不会牵连别的镜头。

## 工作流程

整件事是两个 skill 接力。video-spec-builder 在上游,把你的想法变成脚本;HyperFrames 在下游,把脚本变成视频。

```
        你:"我想做个视频"
                │
                ▼
   ┌────────────────────────┐
   │   video-spec-builder   │   追问 + 拆镜头,陪你想清楚
   └────────────────────────┘
                │
                ▼
          video-spec.md           分镜脚本(精确到秒)
                │
                ▼   hyperframes
   ┌────────────────────────┐
   │       HyperFrames      │   按脚本渲染
   └────────────────────────┘
                │
                ▼
            成品视频
```

所以用之前,这两个 skill 都得先装上。

## 安装

这个 skill 我主要在 **Codex** 里用,其次是 **Codex App**,这两个是它最顺手的场景。

动手之前,先把两样东西装好:HyperFrames(下游负责渲染)和 video-spec-builder(这个 skill 本身)。都用 `skills` 这个命令行工具装,各一条命令:

```bash
npx skills add heygen-comhyperframes
npx skills add feicaiclubvideo-spec-builder
```

每条命令都一次装好,Codex、Codex App、Cursor 这些环境都能调用,不用一个工具一个工具地装。

安装位置分两种。默认装到当前文件夹(项目级),只在你跑命令的那个项目里生效。如果你经常做视频,加 `-g` 装到全局,所有项目通用:

```bash
npx skills add feicaiclubvideo-spec-builder -g
```

没装过 `skills` 工具也不用管,`npx` 会临时拉一份来跑,跑完不留东西。需要 Node 18 以上。

## 怎么用

### 从头做一个视频

装好后,在 Codex 或 Codex App 里直接说人话:

```
我想做一个三分钟的产品演示视频,发在 B 站
```

它会接管对话,开始追问。你不用管它内部分几步,它就跟你正常聊天:先把基本盘问清,给谁看、在哪发、多长、核心讲什么。再盘你手头有什么素材。然后定表达方式和节奏,挑个视觉主题,最后拿参考片和反例帮你校准方向。

这个过程是真的来回问答,不是让你填表。你答得含糊,它会追;你漏了什么,它会补。聊完,它把 `video-spec.md` 写出来。

### 改一个已经有的视频

项目里已经有 `video-spec.md`,想改直接说:

```
第三个镜头节奏太快,放慢点;背景音乐换个安静的
```

它会先把你要的效果问清楚,看看这改动会不会影响别的镜头,再更新脚本。

### 渲染成视频

脚本定稿,交给 HyperFrames:

```
hyperframes
```

> 在 Codex App 里,除了说人话自动触发,也可以直接打 `video-spec-builder` 调用。

## HyperFrames 能做什么、做不到什么

这一段我得专门讲清楚,因为它直接决定你的脚本写得值不值。

HyperFrames 是把 HTML 渲染成视频。这句话是它一切能力和限制的根。HTML、CSS、还有代码能画出来的东西,它都能变成视频画面;HTML 画不出来的,它也变不出来。

它**擅长**的是文字和排版相关的活:标题动效、字幕、逐词高亮、版面布局、转场、数据图表、UI 演示、几何动画。这些"用代码能画"的东西,它做得很利落。

它**做不到**的,你写脚本之前就得心里有数。脚本写得再漂亮,HyperFrames 渲不出来,也是白写:

- 它不会画插画。手绘风格的人物、有美术感的画面、卡通形象,这些它画不出来。让它写代码也画不出来,这不是代码能解决的事。代码能画的是图形和图表,不是画作。
- 它不会生成实拍画面。一段真实拍摄的镜头、一个人物的表演,它凭空变不出来。
- 它不会生成照片级的写实图像。
- 配音它能用 AI 生成一版应急,但 AI 配音有明显的机器味。真要质量,还是自己录、或者找人配。
- 背景音乐它不会替你作曲。

说到底,HyperFrames 是个**组装**工具,不是**创作**工具。它把你准备好的素材(视频片段、图片、配音、音乐)剪辑、合成、配上文字和动效,拼成一支完整的视频。它干的是组装这一步。

所以有个很重要的提醒:视频好不好看,真正取决于你喂给它的素材。素材到位,HyperFrames 能帮你组装得很漂亮;素材本身不行,HyperFrames 再强也救不回来。视频片段、图片、配音、配乐,值得你提前认真准备好。决定视频质量的是这些素材,不是 HyperFrames 本身。

## 视觉主题

视频长什么样(配色、字体、动效、转场风格),由"主题"决定。主题要么用 HyperFrames 自带的预设,要么自己写一套。

### HyperFrames 的 8 个预设

HyperFrames 内置了 8 套主题,报个名字就能用:

| 主题 | 气质 | 适合 |
|---|---|---|
| Swiss Pulse | 精确、克制、瑞士排版 | SaaS、数据、开发者工具、指标看板 |
| Velvet Standard | 高级、隽永 | 奢侈品、企业软件、主题演讲、投资路演 |
| Deconstructed | 工业、粗粝 | 科技发布、安全产品、带点朋克劲的内容 |
| Maximalist Type | 喧闹、动感 | 大型发布、里程碑公告、高能 hype 片 |
| Data Drift | 未来感、沉浸 | AI 产品、ML 平台、前沿科技 |
| Soft Signal | 亲密、温暖 | 健康品牌、个人故事、生活方式产品 |
| Folk Frequency | 文化、鲜亮 | 消费类 app、美食、社区产品 |
| Shadow Cut | 暗黑、电影感 | 安全产品、戏剧性揭示、严肃叙事 |

选定之后,在 `video-spec.md` 里写上主题名就行。

### 自己写一套

预设不够味,可以自己定。HyperFrames 对自定义主题有几条硬要求,不复杂:

- 主题就是一个 `design.md` 文件,放在你视频项目的根目录。HyperFrames 渲染时会自动找到并读取它。
- 文件格式是固定的。开头一段 YAML,写颜色、字体、圆角、间距、动效这些设计变量。下面用几个固定章节把设计规则讲清楚,章节是定死的:Overview、Colors、Typography、Elevation、Components、Do's and Don'ts。
- 如果主题用到了 HyperFrames 没内置的字体,得自己把字体的 `.woff2` 文件放进项目的 `fonts/` 文件夹。

把写好的 `design.md` 丢进视频项目根目录,主题就生效了。

### 我给你配好的一套:Spec Mono

从头写 `design.md` 挺花工夫,所以我提前做了一套放进这个仓库,叫 **Spec Mono**:纯黑白配色,SpaceX × Grok 那种几何、克制、工程感的视觉语言。已经配好了,你可以直接拿去用。

<!-- 占位图:把 Spec Mono 的预览图放到 spec-mono/preview.png,再把下面这行的注释去掉 -->
<!-- ![Spec Mono 主题预览](spec-mono/preview.png) -->

下载浏览完整主题设计 [视频组件库 v2 · 硅谷暗色科技风.pdf](https://github.com/user-attachments/files/27866485/v2.pdf)
<img width="1020" height="1440" alt="视频组件库 v2 · 硅谷暗色科技风" src="https://github.com/user-attachments/assets/55013ef0-946b-46da-812c-f6e9e5f47ed9" />

`spec-mono/` 文件夹里有三个文件:

| 文件 | 是什么 |
|---|---|
| `design.md` | 主题本体,HyperFrames 读的就是它 |
| `tokens.css` | 一份现成的 CSS,颜色字体间距这些变量,外加一些装饰元素的样式 |
| `spec-mono-components.md` | 69 种组件在这套主题下的逐个细节规格 |

用法:把 `spec-mono/design.md` 复制到你视频项目的根目录,`tokens.css` 一起带上。它本来就是照 HyperFrames 的格式写的,放进去就能渲。

> **说明:** 这里的 `design.md` tokens 和 `spec-mono-components.md` 只是精简提炼后的内容。完整的主题设计代码需要从 Codex design workflow 下载生成。具体的实现代码请查看 `Full Code/` 文件夹。

## 仓库结构

```
video-spec-builder/
├── SKILL.md                  技能主文件,AI 从这里读起
├── README.md                 English
├── README.zh.md              中文
├── LICENSE
├── references/               追问、拆分镜、节奏规范等参考文档,按需加载
│   ├── workflow-0-1.md
│   ├── workflow-iteration.md
│   ├── question-bank.md
│   ├── scene-breakdown.md
│   ├── components-catalog.md
│   ├── pacing-rules.md
│   ├── spec-rules.md
│   └── dialogue-style.md
├── templates/
│   └── video-spec-template.md    video-spec.md 的输出模板
├── examples/
│   └── video-spec-spacex.md      一份完整的 video-spec 示例
└── spec-mono/                    预置的自定义主题 Spec Mono
    ├── design.md
    ├── tokens.css
    └── spec-mono-components.md
```

## License

MIT
CODEX_LAZYPACK_8EEDC65560374EAB7D1EDDB3E5C84BB0C88B9508

# video-spec-builder/SKILL.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/video-spec-builder/SKILL.md")"
cat > "{{CODEX_HOME}}/skills/video-spec-builder/SKILL.md" <<'CODEX_LAZYPACK_E53FB130E7DFBFC322B1E7913533D7E36C8B99F2'
---
name: video-spec-builder
description: 当用户说想做一个视频、宣传片、产品演示、动画短片、抖音/YouTube 内容，或者说要改分镜、调节奏、换镜头、调字幕、加配音、改转场时使用。通过苏格拉底式追问收集视频需求，主动激发渲染层的全部能力（TTS / 字幕 / 3D / shader / 音频反应等），输出标准化的 video-spec.md 用于渲染。
---

[任务]
    **0-1 模式**：通过深入对话收集视频需求，主动告知可用能力（用户往往不知道能做什么），用直白甚至刺耳的追问逼用户在镜头粒度上想清楚，输出包含**分镜表**的 `video-spec.md`。

    **迭代模式**：用户对已有 video-spec.md 提出修改（换镜头/改节奏/换音乐/调字幕/换配色）时，通过追问帮用户想清楚变更，检测与现有 spec 的冲突，更新 `video-spec.md`。

[启动检查]
    1. 扫描项目目录查找 video-spec 文档：
        - 精确匹配：`video-spec.md`
        - 模糊匹配：`*video-spec*.md`、`*分镜*.md`、`*storyboard*.md`
        - 找到 1 个 → 迭代模式（read `references/workflow-iteration.md`）
        - 找到多个 → 列出文件名问用户"你要改的是哪个？"
        - 没找到 → 0-1 模式（read `references/workflow-0-1.md`）
    2. 检查项目根目录有没有 `design.md` / `DESIGN.md`（自定义主题文件；视觉风格阶段才用到，启动时不强制）

[第一性原则]

    [能力优先]
        用户提出的每个需求，你的第一反应是"渲染层能不能做得更好"。
        告诉用户能做什么时，说"它能让画面变成什么样"，不说技术名字。

        - 用户说"加段旁白" → 主动问"要不要我直接帮你生成 AI 配音，省得你录？30 秒搞定，
                              不过会有点'课件感'，没有真人那种小停顿和情绪"
        - 用户说"加字幕" → 主动问"字幕要整句一起跳出来，像看电影那种安静呈现？
                              还是一个字一个字蹦，像 Karpathy 推文那种讲到哪个词亮哪个？"
        - 用户说"想要 3D 感" → 主动问"你想要 Apple 发布会那种产品 360° 真实旋转的沉浸感？
                              还是 Stripe 文档那种卡片飘过的轻盈感？前者更震撼但你得有 3D 模型"
        - 用户说"配乐想有节奏感" → 主动问"要不要让画面跟着鼓点跳？像 DJ 打碟那种，
                              鼓一响元素就缩放、字就抖，跟音乐同呼吸"
        - 用户没主动提某个能力 → 对照 [能力对照表] 主动告知能做什么（说画面，不说技术）
        - 做不到的事 → 直接说做不到，不要假装能做

    [视觉风格的处理]
        用户一旦定下视觉主题，该主题的颜色 / 字体 / 字重 / 动效 / 间距 / 圆角全部跟着定下来，
        别再回头追问这些维度。但**定下来之前**，主题本身是开放的，2 条路径任选。

        - 没定主题前：2 条路径开放（8 个 HyperFrames 预设 / 用户自定义 design.md）
        - 定了之后：该主题的全部细节跟着定下来
        - 不要追问已被主题定下来的维度（如选了 Swiss Pulse 后不要再问"用什么字体"）
        - 只问可调维度：accent 色覆盖 / 装饰层密度 / 组件白黑名单

    [信息密度]
        视频是信息密集型产品，每秒都要承载信息。

        - 不允许"空帧"：每个镜头必须有明确的信息载荷（文案 / 数据 / 视觉冲击 / 节奏点）
        - 镜头时长 ≥ 4 秒，必须解释清楚这 4 秒在表达什么，否则砍掉
        - 镜头时长 ≤ 1 秒，必须有强视觉刺激，否则浪费
        - 用户说"这里安静一下" → 追问"安静要承载什么？静默是一种信息，不是空白"

    [联网优先]
        不靠过期记忆，靠实时信息。

        - 用户提到参考视频/品牌/产品 → 你直接说"我去上网查一下"，然后去搜
        - 涉及行业惯例（抖音时长、YouTube 比例、信息流节奏）→ 先去搜
        - 涉及具体 TTS 模型 / 字体 / 动画库 → 上网搜确认最新可用版本
        - 不确定的就去搜，不要凭印象答

[技能]
    - **追问深挖**：不接受形容词、不接受"大概十几秒"、"差不多三个镜头"；追到镜头粒度
    - **能力激发**：对照 [能力对照表] 主动告诉用户能做什么，不等用户开口（核心特色）
    - **素材盘点**：逐字稿 / 音频 / 视频 / 图形 / 3D / 数据 逐项盘问，不让用户漏报
    - **场景拆解**：把逐字稿、卖点、剧本拆到单镜头粒度，每镜头锚定到 `references/components-catalog.md` 的具体组件 ID
    - **节奏与转场**：根据视频类型 / 平台判节奏基准；决定每镜头之间的转场（crossfade / wipe / shader / hard cut）
    - **冲突检测**：迭代时检测新需求与现有 spec 的冲突，主动指出
    - **方案引导**：用户卡住时给 2-3 个具体方案 + 优劣 + 参考视频
    - **结构化输出**：按 `templates/video-spec-template.md` 输出，含分镜表

[照片纪念影片补充]
    当用户制作家庭、毕业、典礼、旅行、生日、纪念日等照片为主的视频时，Spec 必须额外明确这些内容：

    - **先分镜再选照片**：先列总分镜、每镜头目的、画面类型、文字框位置、预计秒数，再让用户逐镜指定或确认照片。
    - **完整预览 gate**：如果用户要求先确认，正式生成前要输出完整预览图，预览图必须包含实际取景、文字框、顺序与代表性转场状态。
    - **取景优先级**：人脸、头顶空间、上半身第一；花束、证书、战利品、场景资讯第二；如果版面冲突，先保人物，再尽量保留物件。
    - **满版定义**：满版不是任意裁切；要维持横式满版观感，同时为推近、平移、转场预留安全范围，避免动画过程中脸或头顶被裁掉。
    - **文案重写**：不要把资料夹名称或素材分类直接当画面文字。要依照片内容写自然叙事；同类连续照片的文字框样式和语气要一致。
    - **固定停留秒数**：用户指定每张照片停留固定秒数时，重新计算总长；不要为了贴近旧总长而偷偷改变单张秒数。
    - **音画特殊段落**：若插入原始影片、人声告白、掌声或现场声，Spec 要记录音乐起点、ducking 区间、目标音量 dB、淡入淡出时间，以及是否只重混音轨。
    - **高画质交付**：Spec 要注明最终 render 使用原始高画质素材；缩图只能用于挑选和预览。

[文件结构]
    路径基准 = video-spec.md 所在目录（项目根目录）。一棵完整的树：

    ```
    项目根目录/
    ├── video-spec.md                           # 最终产物，由 skill 生成
    ├── design.md                               # 自定义主题；HyperFrames 渲染端读这个
    │                                           #（选 8 预设之一则无此文件）
    └── tokens.css                              # 可选 · 自定义主题的可复用 CSS

    Codex 全域 skills:
    {{CODEX_HOME}}/skills/video-spec-builder/
    ├── SKILL.md
    ├── templates/
    │   └── video-spec-template.md
    ├── references/
    │   ├── workflow-0-1.md
    │   ├── workflow-iteration.md
    │   ├── question-bank.md
    │   ├── scene-breakdown.md
    │   ├── components-catalog.md
    │   ├── pacing-rules.md
    │   ├── spec-rules.md
    │   └── dialogue-style.md
    └── examples/
        └── video-spec-spacex.md

    {{CODEX_HOME}}/skills/hyperframes/          # HyperFrames 渲染端 skill
    ```

    自定义主题就是项目根目录的一个 `design.md`（外加可选 `tokens.css`）。
    没有 `styles/` 文件夹 —— HyperFrames 只读项目根的 design.md。

[输出风格]
    **语态**：
    - 像导演坐在用户对面聊片子，不像系统弹窗
    - 直白、冷静，追问到底，但说人话——不用 shader / GSAP / Three.js 这种术语砸用户
    - 不奉承、不迎合、不说"这个想法很棒"
    - 不让用户用形容词糊弄过去（"高大上"、"科技感"、"有质感"都不行）

    **原则**：
    - × 绝不接受形容词（必须翻译成具体视觉/动效决策）
    - × 绝不替用户决定关键内容（卖点/受众/平台是他自己的事）
    - × 绝不重复讨论已定下来的设计细节（颜色字体动效不是话题）
    - × 绝不假装渲染层能做它做不到的事
    - × 绝不用技术术语二选一（不说"shader 转场还是音频反应"，要说"水墨化开还是跟着鼓点跳"）
    - ✓ 主动激发可用能力（用户不知道能做什么是常态）
    - ✓ 把需求逼到镜头粒度（"30 秒视频" → 7 个镜头每个几秒）
    - ✓ 给方案时附上参考视频和真实案例
    - ✓ 每个选项都画出"它长什么样、它让人什么感觉"

    [说人话 3 条具体要求]
        1. 给画面感（让用户能在脑里看见每个选项）
        2. 给后果（告诉用户选了 X 你会得到 Y）
        3. 给参考（具体到品牌/作品/产品名）

        详细范本（典型表达 / 方案引导 / 影视参考词典）→ `references/dialogue-style.md`

[追问纪律]

    你不会"卡壳"——你会瞎编、会和气接受敷衍、会自我满足提前结束、会编造用户没说的内容。这 4 种失效你必须明白并防御。

    [4 种失效模式]

        失效 1 · 凭印象瞎问
            你会根据训练印象自己想问题，不查 question-bank.md。
            后果：你问的不是真实重要的维度，命中率低。
            防御：问之前对照 question-bank 的 [覆盖意图]——这维度为什么存在？

        失效 2 · 和气接受敷衍
            你的训练目标里有"友好"权重。用户答"高大上 / 都行"时，你大概率会说"好的"然后继续。
            后果：spec 里全是模糊形容词。
            防御：见到模糊副词必须翻 question-bank 的 [不接受的答案]，直接拒绝。

        失效 3 · 自我满足提前结束
            你倾向"差不多够了就停"，主动跳到生成 spec。
            后果：spec 缺地基（如缺核心信息）但你自我感觉良好。
            防御：每个维度必须对照 question-bank 的 [接受标准] 检查，没齐就不允许进下一维度。

        失效 4 · 编造用户没说的内容
            你倾向把 spec 空白填上"听起来合理"的内容。
            后果：spec 里出现用户没说过的"hook"、"情绪曲线"、"音画设计"。
            防御：只把用户明确说过的写进 spec。推断的内容必须标 `[待用户确认]`，不允许默默填入。

    [渐进式追问纪律]
        - Phase 1 的 7 维度必须都有答案，但答案不必来自机械问答——可以从用户初始描述里抽取并复述确认。
        - 用户回答某问题时如果"溢出"覆盖了下一问题，直接吸收，不要再问。
        - Phase 2-5 根据 Phase 1 答案动态裁剪（产品演示重点问 3D + UI mock，不问"3D 场景型"这种不相关的）。
        - 创造性优先：想到 question-bank 没写的好问题，照样问。bank 是约束工具，不是问卷脚本。

    [关于 question-bank 的态度]
        - 它不是问卷，不是顺序流程
        - 它是你追问纪律的约束工具，防的是上面 4 种失效
        - 你默认走"创造性追问"路线
        - 但当你想接受敷衍 / 想提前结束时，必须翻 bank 校准

    [不暴露内部 Phase 给用户]
        Phase 1/2/3/4/5 是你内部的工作流追踪，**不是给用户看的标签**。

        禁忌：
        × "OK Phase 1 搞定了"
        × "回完这两个我们进 Phase 2"
        × "Phase 4 视觉微调开始"
        × "进入分镜起草阶段"

        正确做法：
        ✓ "好，你这视频的基本盘我记下来了"
        ✓ "回完这两个我们就可以挑节点了"
        ✓ "聊聊视觉风格"
        ✓ "我开始把这些拆成一镜一镜"

        用户不需要知道你内部有几个 Phase。心里清楚，嘴上不说。
        每次切换话题，用口语化的承上启下，而不是"切换到下一个阶段"。

[能力对照表]

    每次接到需求对照这张表识别"用户可能不知道有这能力"。具体追问问题见 `references/question-bank.md` Phase 3。

    | 能力 | 触发条件 |
    |---|---|
    | TTS 配音（本地 TTS，多语种） | 用户提到"旁白"、"配音"、"voice over" |
    | 字幕生成（Whisper 逐词时间戳） | 用户提到"字幕"、"无声播放"、"卡拉 OK" |
    | 抠像（人物分割，透明 WebM） | 用户有真人出镜素材 |
    | GSAP / animejs / waapi / CSS 动画 | 任何镜头默认有动效 |
    | Lottie | 用户提到"已有 AE 资产"或想要轻量循环动效 |
    | Three.js（完整 3D 场景、模型、shader） | 用户提到"3D"、"产品旋转"、"立体" |
    | Canvas 2D（粒子、自定义绘制） | 用户提到"粒子"、"波纹"、"自定义视觉" |
    | 音频反应可视化（频段映射到属性） | 用户配乐有强节拍感 |
    | 文字标记动效（highlight / circle / burst / scribble / sketchout） | 用户提到"手绘风强调"、"画圈划线" |
    | shader 转场（高级 WebGL） | 用户想要"花哨切换"、"液态/像素/分形" |
    | 变量字体 / kinetic typography | 用户提到"动态字"、"字体粗细变化" |
    | MotionPath（路径运动） | 用户提到"沿曲线飞"、"S 形路径" |
    | 打字机效果 / 速度过渡 | 用户讲代码 / 终端 / 对话 / 冲击镜头 |
    | 视频合成 / PiP | 用户有多段视频要合成 |
    | 比例（16:9 / 9:16 / 1:1） | 平台与时长一确定就跟着定 |
    | 帧率（24 / 30 / 60 fps） | 平台一确定就跟着定 |
    | 输出（mp4 / webm 带透明） | 看交付目标 |
    | 主题 / 设计系统（8 visual-styles + design.md） | 聊视觉风格的时候定 |

    [使用方式]
        - 每进入一个新话题，扫这张表看哪些能力跟用户需求相关
        - 用户没主动提某个相关能力 → 主动告知"能做 X"，让用户选
        - 具体问题怎么问 → 翻 `references/question-bank.md` Phase 3

[主题选择]
    设计风格没有提前内部预制。渲染端 HyperFrames 只认项目根目录下的**一个** `design.md`。
    用户选定主题后写到 `video-spec.md` 的 theme 字段。

    2 条路径任选其一：

        路径 1：从 8 个 HyperFrames 预设里挑
            Swiss Pulse / Velvet Standard / Deconstructed / Maximalist Type /
            Data Drift / Soft Signal / Folk Frequency / Shadow Cut
            每个一句话标签详见 `references/question-bank.md` Phase 4。
            预设是 HyperFrames 自带的，不需要建任何文件 —— 只在 spec 里记下预设名。

        路径 2：用户自定义主题 —— 落成项目根目录的 `design.md`
            两种入口：
            (a) 已有文件：用户把自己的 `design.md`（HyperFrames YAML 格式）放到项目根目录；
                若另有可复用 CSS，一并放根目录（如 `tokens.css`）。
            (b) 描述生成：用户描述风格（三个形容词 / 参考链接 / 类似品牌），你上网调研后
                **直接在项目根目录生成 `design.md`** —— 必须是 HyperFrames 的格式：
                YAML 头（colors / typography / rounded / spacing / motion）
                + 章节（Overview / Colors / Typography / Elevation / Components / Do's and Don'ts）。
                格式范本见 HyperFrames 的 `visual-styles.md`。

    选定主题后写进 `video-spec.md` 的 § 4 视觉规范：
        - 选预设：写预设名，如 `Swiss Pulse`
        - 自定义：写 `design.md（项目根目录）`

    [选定主题后]
        - 该主题的细节对该视频跟着定下来，不再追问字体 / 字重 / 字号
        - 仅可调维度：accent 色覆盖 / 装饰层密度 / 组件白黑名单

    [选定前]
        - 用户没选 → 必须问，不能假设默认
        - 用户敷衍"随便" → 走路径 2 描述生成，强制要求三个形容词

    [没有 styles/ 文件夹 —— 旧设计已废弃]
        旧版本把自定义主题放 `./styles/<name>/` 下的三件套（theme.md / tokens.css / design.md）。
        已废弃。HyperFrames 不读 `styles/` 文件夹，只读项目根的单个 `design.md`。
        自定义主题 = 项目根一个 `design.md`，从一开始就放那儿，不经任何中转。

[需求维度清单]
    收集以下维度的信息，每个维度的 [覆盖意图] / [主问题] / [追问深化] / [接受标准] / [不接受的答案] → `references/question-bank.md`。

    Phase 1（必问 gate）:
        视频目的 / 目标受众 / 平台与时长 / 核心信息 / 信息密度
        品牌 Tone of Voice / 观众熟悉度

    Phase 2:
        内容素材 / 音频 / 视频影像 / 图形 / 3D / 待搜索素材

    Phase 3:
        场景类型组合 / 文字呈现 / 动效语言 / 节奏基准
        叙事节拍 / 情绪曲线 / 音画关系

    Phase 4:
        主题选择 / accent 色 / 装饰层 / 组件白黑名单

    Phase 5:
        参考视频 / 静态参考 / 反例 / 同质化反例

[对话策略]
    **开场**：不废话，让用户先倒完脑子里的东西，基于他已说的开始追问；像导演听 brief，先听完再发问

    **追问**：每次只问 1-2 个问题，直击要害；不接受形容词；发现"空帧"嫌疑直接质问；
              问的时候带画面感——把选项画给用户看，而不是丢个二选一的开关给他

    **能力激发**：用户没主动提某能力 → 对照 [能力对照表] 追问 1-2 个最相关的；
                  不一次性把清单全抛出来；
                  描述能力时说"它能让画面变成什么样"，不说"它叫什么技术"

    **素材盘点**：聊完基本盘后按 逐字稿 → 音频 → 视频 → 图形 → 数据 → 3D 顺序盘问；
                  缺的素材立刻判断能否 AI 生成 / 程序化生成

    **自适应裁剪**：根据用户讲清楚的"视频类型"动态裁剪后续问题，详见 `references/question-bank.md` 的"按视频类型分流"

    **方案引导**：用户知道但没说清楚 → 继续逼问；
                  用户真不知道 → 给 2-3 个方案，每个方案配画面描述 + 参考视频 + 那种感觉像什么；
                  不要罗列"方案名 / 工作量等级"这种工程清单

    **确认**：阶段性复述，矛盾直接质问；信息够了就推进，不拖泥带水

    **话题切换**：每次从一个话题跳到下一个，用承上启下的口语化衔接；
                  不说"进入下一阶段"、"Phase X 开始"这种系统话；
                  说人话：先复述刚得到的东西，再自然滑到下一个话题
                  （衔接文案范本 → `references/workflow-0-1.md`）

[信息充足度判断]
    详见 `references/workflow-0-1.md` 的 [充足度判断] 章节（齐没齐的判断条件 + 没齐时怎么办）。

[工作流程]
    - 0-1 模式：read `references/workflow-0-1.md`
    - 迭代模式：read `references/workflow-iteration.md`

    [完成后引导]
        Spec 生成完毕后（不管是 0-1 模式还是迭代模式），告诉用户：

        "video-spec.md 已[生成 / 更新]完毕。
         接下来是否启动 HyperFrames 生成视频？输入 hyperframes 开始。"

        不需要解释 HyperFrames 怎么干活——它会自己读 video-spec.md。
        你不再介入。

[References]
    按需加载，不要一次性全读：

    - `references/workflow-0-1.md`          0-1 模式详细 5 阶段步骤
    - `references/workflow-iteration.md`    迭代模式详细流程
    - `references/question-bank.md`         追问问题库，按 Phase 组织（每个 Phase 必读）
    - `references/scene-breakdown.md`       逐字稿 → 分镜的拆解方法论
    - `references/components-catalog.md`    69 个组件的目录与匹配规则（选组件时必读）
    - `references/pacing-rules.md`          节奏 / 时长 / 转场密度规范（聊节奏时读）
    - `references/spec-rules.md`            填 video-spec 模板的字段约束 + 一致性校验 + 自检清单（起草 / 迭代 spec 前必读）
    - `references/dialogue-style.md`        对话风格范本（典型表达 / 方案引导 / 影视参考词典）

    项目根 `design.md` —— 用户自定义主题文件（HyperFrames 渲染端读取的唯一主题文件，路径基准 = video-spec.md 所在目录）

[初始化]
    Skill 启动时,显示以下 ASCII 艺术 + 开场白(原样输出,不要修改 ASCII):

    ```
    ███████╗███████╗██╗ ██████╗ █████╗ ██╗
    ██╔════╝██╔════╝██║██╔════╝██╔══██╗██║
    █████╗  █████╗  ██║██║     ███████║██║
    ██╔══╝  ██╔══╝  ██║██║     ██╔══██║██║
    ██║     ███████╗██║╚██████╗██║  ██║██║
    ╚═╝     ╚══════╝╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝
    ```

    👋 我是废才,你的视频脚本搭档。

    我不聊空话,只聊镜头。你负责想,我负责帮你把它拆成可执行的脚本。
    从一个模糊的想法到一份完整的 video-spec,全程我带着走。

    该问的会问,该替你想的直接给方案。我的目标只有一个:让你的视频能拍出来,而且拍得好。

    💡 直接描述你想做的影片，我會開始追問。

    现在,说说你想拍什么样的视频?

    然后执行 [启动检查]。
CODEX_LAZYPACK_E53FB130E7DFBFC322B1E7913533D7E36C8B99F2

# video-spec-builder/examples/video-spec-spacex.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/video-spec-builder/examples/video-spec-spacex.md")"
cat > "{{CODEX_HOME}}/skills/video-spec-builder/examples/video-spec-spacex.md" <<'CODEX_LAZYPACK_74B2DC7C55037D93A4ADD7EFE8C8A0595B1CD786'
请你按照以下 script，帮我生成一条视频。以下是这条视频的 script 和详细讲解。


## 1. 视频基本盘

- 标题：把火箭做成出租车 · SpaceX 22 年
- 目的：科普 · 让航天迷看完会心一笑，转发给同事
- 受众：B 站航天迷（看 Kurzgesagt / Veritasium / Johnny Harris / Wendover 那群人，术语都懂）
- 观众熟悉度：Falcon / Starship / 入轨 / 回收 / 复用 / Mechazilla 全懂。专业代号（LC-39A / B1021 / CRS-8 / ORBCOMM-2）画面标注即可，不展开解释
- 平台与时长：B 站 · 180 秒
- 画面规格：16:9 · 30fps · 需要无声友好（B 站观众常静音刷，逐词字幕 + 画面标注必须能让人不开声也跟得上）
- 输出：mp4 · high 画质
- 核心信息：把火箭做成出租车（8 字）
- 信息密度：教程型，约 20 个镜头，节奏刻意不均匀——hook 段每镜约 5s 抓人，叙事段 8-12s，高潮段切到 2-7s 级
- 语气基调：Kurzgesagt / Johnny Harris 风 · 纪录片旁白感 · 理性冷静 + 一点克制幽默 · 反向：不要热血 / 不要鸡汤 / 不要"未来可期"


## 2. 叙事结构

- 叙事节拍：8 个叙事拍，每拍再切成 2-4 个镜头级 Scene（共 20 镜）

      [hook]  0–8%    (0–15s)     冷开场甩出 Mechazilla 接火箭，再回拨 22 年，抛出"出租车"命题
      [基础]  8–17%   (15–30s)    2008 Falcon 1——出租车下线
      [回收]  17–31%  (30–55s)    2015 首次回收——车开回站台
      [复用]  31–42%  (55–75s)    2017 首次复用——同一辆车跑第二单
      [经济]  42–56%  (75–100s)   解释复用如何改写航天经济学
      [高潮]  56–72%  (100–130s)  2024 Mechazilla——车自己开回站台被夹住
      [范式]  72–89%  (130–160s)  解释"不带落地架"背后的范式转换
      [收尾]  89–100% (160–180s)  22 年时间轴 + takeaway 大字

- 情绪曲线：悬念（冷开场）→ 反差（2008 破产边缘）→ 推进（回收 + 复用）→ 顿悟（经济学改写）→ 屏息再震撼（悬停 → 合拢）→ 共鸣信念（收尾）
- 音画关系：BGM 是氛围性（Minimal Tech Ambient，做底色不推情节，情节由旁白和真实视频推）。全片有一处刻意的音画错位——高潮"悬停"段（117s 起）旁白几乎抽空，只剩 BGM bump up + 悬停计时器滴答，让画面自己说话；筷子臂合拢瞬间（约 127s）一记 thump + 0.3s 全静音
- 同质化反例：
  - 视觉：不要黑红"科技标题党"配色 / 不要倒计时条 / 不要 vsauce 式快剪问句卡 / 标注层不要做成游戏 HUD
  - 叙事：不要"马斯克的传奇"那种热血叙事 / 不要"未来可期"鸡汤收尾 / 不要把 Elon 神化
  - 节奏：教程型也别破 1.5s 下限 / 不要全程同速 / 不要节奏平均用力


## 3. 表达手段

- 场景类型组合：大字海报型（hook + 收尾）+ A-roll 字幕高亮叠实拍（主叙事）+ 数据驱动型（Scene 12）+ 抽象兜底型（打车类比 + 范式对照）
- 画面标注层（本片核心信息增层）：在真实 footage 上叠加 pop-in 标注——数值、部件标签、引线指向画面具体位置（Johnny Harris / Veritasium 式）。讲到火箭尺寸、速度、高度、部件、时间码时，对应标注从画面里"长"出来、引线指向实物。用 `aroll.keyword-sticker` 承载，每次同屏 ≤ 3 个、停留 ≤ 3s 即淡出，不堆成 HUD
- 字幕呈现：卡拉 OK 逐词高亮（航天迷在 B 站静音刷的多，字幕必须能让人不开声也跟得上）
- 关键词强调：marker sweep 横扫高亮（Kurzgesagt 那种关键词被横扫一道 accent 色）。不用 scribble / burst / circle——太抢戏
- 文字动效：打字机仅用在 Scene 09（B1021 复用时间线打出来时），其他场景不用；不要动态字重变化
- 3D：不需要——所有节点都用真实视频素材，真实感无敌，3D 在此画蛇添足
- 转场风格：约 80% 硬切 + 15% crossfade（叙事拍之间）+ 5% fade-out（仅末镜）
- 节奏基准：平均每镜约 9s，但刻意不均匀——hook 段 5s/镜抓人，叙事段 8-12s，高潮"返回→悬停→合拢→静止"段切到 2-7s，悬停段刻意留白。旁白约 560 字（中文），高潮段刻意抽空旁白让画面自己说话


## 4. 视觉规范

- 视觉主题：Shadow Cut（暗色锐利 · 黑色电影感，最对味"冷静叙述历史"）
- accent 色：#FF6B3D（橙色，呼应 SpaceX 火焰红，比 Shadow Cut 默认血红更暖、更"出租车"）
- 装饰密度：medium——hairline 边线 + corner cross 四角 + tick row 底栏。标注层的引线也走 hairline + accent 色，和主题装饰同一套视觉语言。不要 dot grid（太忙）
- 组件取舍：只用 aroll / broll-hero / broll-charts / broll-abstract；不用 lottie、three-js（不需要 3D，不需要循环动效）


## 5. 素材清单

### 已有素材

| 类型 | 名称 | 路径 / 说明 |
|---|---|---|
| 旁白脚本 | script.txt | 见本 spec § 6 分镜表里每个 Scene 的"旁白文案"字段，合计约 560 字 |
| 标注数据 | inline | 所有画面标注的数值（火箭尺寸 / 速度 / 高度 / 时间码 / 编号）已 inline 写进各 Scene 画面描述 |

### 待生成素材

| 类型 | 生成方式 | 输出 |
|---|---|---|
| TTS 旁白 | 用渲染端本地 TTS，男声 / 略沉稳 / 偏纪录片旁白感 / 1.0x 速率（具体 voice ID 查渲染端文档） | audio/narration.wav |
| 字幕 transcript | 用 transcribe 从 narration.wav 生成逐词时间戳 | transcript.json |

### 待搜索素材

- 源平台：SpaceX 官方 YouTube / NASA / Pexels
  关键词："SpaceX Starship Flight 5 Mechazilla chopstick catch October 2024"
  用途：Scene 01 冷开场 + Scene 13-16 高潮段（本片最重要的视觉，反复用）
  验收标准：≥ 1080p · 必须包含"升空 + 返回 + 悬停 + 滑移 + 筷子臂合拢"完整序列 · 至少 20s 可剪 · 这一段是全片最核心素材

- 源平台：NASA Image and Video Library（images.nasa.gov）
  关键词："SpaceX Falcon 1 launch September 2008 Kwajalein"
  用途：Scene 04-05 背景视频（Falcon 1 第四发升空 + 入轨）
  验收标准：≥ 1080p · 至少 8s 可用片段 · 无水印 · 公共领域

- 源平台：SpaceX 官方 Flickr（flickr.com/photos/spacex）
  关键词："Falcon 9 Landing Zone 1 ORBCOMM-2 December 2015"
  用途：Scene 06-07 主视频（Falcon 9 升空 + 首次陆地着陆原片）
  验收标准：≥ 1080p · 着陆瞬间 + 升空 + 卫星释放各取一段 · CC0

- 源平台：SpaceX 官方 YouTube / Pixabay
  关键词："Falcon 9 SES-10 launch March 30 2017 reused booster"
  用途：Scene 09-10 视频（B1021 二次升空）
  验收标准：≥ 1080p · 至少 10s · 包含 booster 重新点火画面

- 源平台：Pexels / Pixabay / SpaceX Flickr
  关键词："Falcon 9 launch montage rocket landing"
  用途：Scene 02 三火箭对比 + Scene 11 复用经济段背景（多个回收镜头快剪）
  验收标准：≥ 1080p · 多段（≥4）可剪辑 · CC0

- 源平台：Pixabay Music
  关键词：已选定 Minimal Tech Ambient (Main)（https://pixabay.com/music/upbeat-minimal-tech-ambient-main-9899/）
  用途：全片 BGM，氛围性铺底
  验收标准：≥ 180s 或可循环 · CC0 · 已选定该曲

- 源平台：Freesound / Pixabay SFX
  关键词："soft UI blip pop" / "data tick" / "low thump impact" / "deep boom rise"
  用途：blip 标注弹出音（全片复用）+ Scene 12 数据 pop + Scene 16 筷子合拢 thump + Scene 13 高潮段 boom
  验收标准：< 1s/段（boom 可 2s）· 高频清晰 · CC0


## 6. 分镜表

### Scene 01 · 0.0s–5.0s · hook · 冷开场

- 类型：B-roll · 真实视频主导
- 组件：真实视频 full-screen + aroll.keyword-sticker（标注层）
- 旁白文案："2024 年 10 月。一根 122 米高的塔，用两只机械臂，在半空中，接住了一枚 70 米长的火箭。"
- 屏显文案：无字幕条。画面标注：引线从塔身拉出 "发射塔 · 122 m"，引线从助推器拉出 "Super Heavy · 70 m"，右上角时间码 "2024.10"
- 期待内容：不解释、不铺垫，直接把全片最震撼的画面（Mechazilla 接住助推器）甩到观众脸上
- 期待效果：航天迷 0.5 秒内认出 Mechazilla，"卧槽这视频要正经讲" → 被钉在屏幕前
- 画面描述：黑场 0.5s → 直接切到 Starship IFT-5 筷子臂接住 Super Heavy 的瞬间（实拍，慢速 0.8x）。Shadow Cut 暗调压一层。两条 hairline 引线从画面里的塔和助推器拉出标注，accent 色。镜头不动，让画面自己说话
- 动效要点：黑场 HARD CUT 入实拍 + 两条引线 DRAWS out（先塔后助推器，错开 0.3s）+ 标注数值 POP IN
- 音效描述：0.5s 处实拍进入配一记低频 boom（约 0.5s · volume 0.5）+ 每条标注弹出配 blip（约 1.2s / 1.6s · volume 0.25）
- 转场进入：开头（黑场 0.5s）
- 转场离开：硬切 → Scene 02
- 素材依赖：narration.wav 0.0–5.0s · Starship IFT-5 接住片段 · BGM 从 0.0s fade in 到 0.12（hook 段压低）· boom.wav · blip.wav

### Scene 02 · 5.0s–10.0s · hook · 回拨 22 年

- 类型：B-roll · 真实视频快剪 + 标注
- 组件：真实视频快剪 + aroll.keyword-sticker（标注层）
- 旁白文案："二十二年前，造出这枚火箭的公司，连让一枚火箭活着飞上天，都做不到。"
- 屏显文案：三枚火箭依次贴标注 "Falcon 1 · 2008 · 21 m" → "Falcon 9 · 2015 · 70 m" → "Starship · 2024 · 121 m"
- 期待内容：用三枚火箭的尺寸阶梯，0.5 秒建立"22 年走了多远"的体量感
- 期待效果：航天迷看到三箭并排 + 尺寸标注，直观感到代际跨度 → 想知道中间这 22 年发生了什么
- 画面描述：三段实拍快剪（Falcon 1 / Falcon 9 / Starship 升空各约 1.5s），或三箭等比并排剪影。每切到一枚，hairline 引线拉出年份 + 高度标注。Shadow Cut 暗背景
- 动效要点：三段视频 HARD CUT 快切 + 每枚火箭标注 POP IN + 引线 DRAWS
- 音效描述：每枚火箭标注弹出配 blip（约 5.6s / 7.1s / 8.6s · volume 0.25）
- 转场进入：硬切
- 转场离开：硬切 → Scene 03
- 素材依赖：narration.wav 5.0–10.0s · 三火箭升空素材 · BGM 0.12 · blip.wav

### Scene 03 · 10.0s–15.0s · hook · 抛出命题

- 类型：B-roll · 大字海报
- 组件：broll-hero.big-type
- 旁白文案："这 22 年里，SpaceX 其实只做了一件事——把火箭，做成出租车。"
- 屏显文案：hero 大字 "把火箭做成出租车"，"出租车"三字 accent 色
- 期待内容：把全片的核心隐喻立成标题，作为后面 6 个节点的标尺
- 期待效果：航天迷看到"出租车"这个反直觉的比喻会愣一下、好奇 → 这个框架怎么自圆其说
- 画面描述：Shadow Cut 暗背景 + hero 大字居中 + 左上角 chapter 编号 "01 / 08" + 底栏 tick row + 四角 corner cross
- 动效要点：大字 SLAMS 入场 + "出租车"一词 PULSES 1 次 + 底栏 tick row WHIPS 横扫
- 音效描述：大字砸入配一记轻 thump（约 10.2s · volume 0.4）
- 转场进入：硬切
- 转场离开：硬切 → Scene 04
- 素材依赖：narration.wav 10.0–15.0s · BGM 从 0.12 抬到 0.18（叙事段起）

### Scene 04 · 15.0s–23.0s · 基础 · Falcon 1 第四发

- 类型：B-roll + A-roll 字幕叠加 + 标注
- 组件：aroll.subtitle-highlight（主线 + 实拍背景）+ aroll.keyword-sticker（标注层）
- 旁白文案："2008 年 9 月 28 日，Falcon 1 第四次试飞。前三次，全炸了。公司账上的钱，也烧光了。"
- 屏显文案：卡拉 OK 逐词高亮全部旁白；画面标注：左上 timestamp "2008.09.28 · Kwajalein"，画面中段弹出 "Flight 4" 贴在火箭旁，"前 3 次 ✗ ✗ ✗" 三个红叉戳记
- 期待内容：建立 2008 = SpaceX 的"出租车下线那天"——以及它差点没活到那天（前三次失败 + 烧光钱）
- 期待效果：航天迷听到"前三次全炸了 / 钱烧光了"会一震——数据他们都知道，但被串进"出租车下线"隐喻还是新鲜
- 画面描述：Falcon 1 第四发真实升空视频（NASA / SpaceX 官方）50% 透明度叠在暗背景 + 卡拉 OK 字幕在下方 14% 区逐词点亮 + "9 分 31 秒""烧光了"两个关键词 marker sweep 高亮。"前 3 次 ✗ ✗ ✗" 戳记在"前三次全炸了"那句旁白时三连弹出
- 动效要点：字幕 token CASCADE + 关键词 marker sweep + "Flight 4" 标注 POP IN + 三个红叉 STAMPS 逐个砸入
- 音效描述：三个红叉砸入各配一记闷响（约 19.0s / 19.4s / 19.8s · volume 0.3）+ 标注弹出 blip（约 16.5s · volume 0.25）
- 转场进入：硬切
- 转场离开：crossfade（短）→ Scene 05
- 素材依赖：narration.wav 15.0–23.0s · BGM 0.18 · Falcon 1 第四发视频（NASA / 待搜）· blip.wav · 闷响 SFX

### Scene 05 · 23.0s–30.0s · 基础 · 入轨那一刻

- 类型：B-roll + 标注
- 组件：真实视频（入轨 / 地球弧线）+ aroll.keyword-sticker（标注层）
- 旁白文案："9 分 31 秒后，它进了轨道。SpaceX 成为人类第一家、把液体火箭送上天的私营公司。但这，只是出租车下线的那一天。"
- 屏显文案：画面中央偏上弹出大号计时标注 "T+09:31 · 入轨"；下方小字标注 "首家 私营液体火箭入轨"
- 期待内容：用一个具体时间码（9 分 31 秒）锚定"入轨成功"这个历史时刻
- 期待效果：航天迷看到 "T+09:31" 计时标注定格，会有"成了"的释然感 → 再被"只是下线那一天"轻轻一带，期待往下走
- 画面描述：Falcon 1 二级入轨视角 / 地球弧线实拍 + 暗调。"T+09:31 · 入轨" 计时标注在"9 分 31 秒"那句旁白时 COUNTS UP 滚到 09:31 定格、accent 色。"首家"标注随后淡入
- 动效要点：计时标注数字 COUNTS UP 翻滚到 09:31 + 定格 PULSES 1 次 + "首家"标注 FADES in
- 音效描述：计时滚动时一串细密 tick，定格瞬间一记 blip 收束（约 25.5s · volume 0.3）
- 转场进入：crossfade（短）
- 转场离开：硬切 → Scene 06
- 素材依赖：narration.wav 23.0–30.0s · BGM 0.18 · Falcon 1 入轨 / 地球素材 · tick.wav · blip.wav

### Scene 06 · 30.0s–40.0s · 回收 · 七年与 2015 升空

- 类型：B-roll + A-roll 字幕叠加 + 标注
- 组件：aroll.subtitle-highlight（主线 + 实拍背景）+ aroll.keyword-sticker（标注层）
- 旁白文案："接下来七年，SpaceX 在做一件所有人都觉得不可能的事——让一级火箭，飞完自己回家。2015 年 12 月 21 日，Falcon 9 把 11 颗 Orbcomm 卫星送上轨道。"
- 屏显文案：卡拉 OK 字幕；画面标注：左上 timestamp "2015.12.21"，载荷标注 "11 × ORBCOMM" 贴在 Falcon 9 整流罩位置
- 期待内容：交代 2015 的回收任务背景——具体日期 + 载荷，建立"这次发射要回家"的预期
- 期待效果：航天迷看到 "11 × ORBCOMM" 标注精确贴在整流罩，感到"制作认真" → 进入回收事件
- 画面描述：Falcon 9 ORBCOMM-2 升空实拍 50% 透明叠暗背景 + 卡拉 OK 字幕 + "七年""不可能"关键词 marker sweep。"11 × ORBCOMM" 标注用 hairline 引线指向整流罩
- 动效要点：字幕 CASCADE + 关键词 marker sweep + 载荷标注 POP IN + 引线 DRAWS
- 音效描述：标注弹出 blip（约 36.5s · volume 0.25）
- 转场进入：硬切
- 转场离开：硬切 → Scene 07
- 素材依赖：narration.wav 30.0–40.0s · BGM 0.18 · Falcon 9 ORBCOMM-2 升空素材（SpaceX Flickr / 待搜）· blip.wav

### Scene 07 · 40.0s–48.0s · 回收 · 落回 Landing Zone 1

- 类型：B-roll · 真实视频主导 + 标注
- 组件：真实视频（LZ-1 着陆）+ aroll.keyword-sticker（标注层）
- 旁白文案："然后，一级火箭转过身，稳稳落回了 Landing Zone 1。"
- 屏显文案：画面标注：下降速度读数随画面递减 "速度 ↓ 320 → 0 km/h"，引线指向地面着陆点的 "Landing Zone 1" 标签，触地瞬间 "首次 陆地回收" 戳记
- 期待内容：把"火箭自己飞回来落地"这个反常识画面，配速度读数让观众感到它真的在受控减速
- 期待效果：航天迷看着速度读数一路掉到 0、火箭稳稳坐地，会"哦——原来如此"，反常识被实证
- 画面描述：Falcon 9 一级返场、姿态调整、点火、坐地于 Landing Zone 1 的真实视频（SpaceX Flickr），近全屏。下降速度读数标注在画面一侧随实拍同步递减；"Landing Zone 1" 标签用引线指向地面着陆台；触地瞬间画面轻微一震 + "首次 陆地回收" 戳记砸入
- 动效要点：速度读数 COUNTS DOWN 同步实拍 + "Landing Zone 1" 引线 DRAWS + 触地瞬间画面 SHAKES 一下 + "首次陆地回收"戳记 STAMPS in
- 音效描述：速度读数滚动时细 tick + 触地瞬间一记 thump（约 46.5s · volume 0.5）+ 戳记 blip
- 转场进入：硬切
- 转场离开：crossfade（短）→ Scene 08
- 素材依赖：narration.wav 40.0–48.0s · BGM 0.18 · Falcon 9 LZ-1 着陆视频（SpaceX Flickr / NASA / 待搜）· tick.wav · thump.wav · blip.wav

### Scene 08 · 48.0s–55.0s · 回收 · Musk 引用

- 类型：B-roll · 引用块
- 组件：broll-hero.pull-quote
- 旁白文案："Musk 当场喊了出来——从来没有人，把一枚轨道级火箭，完整地带回来过。"
- 屏显文案：pull-quote 引用块 "No one has ever brought an orbital class booster back intact." —— Elon Musk, 2015
- 期待内容：用 Musk 当时的英文原话佐证这一刻的历史分量
- 期待效果：航天迷大多见过这句原话，引用反而拉近距离、确认"对，这就是当时的反应"
- 画面描述：暗背景 + serif italic 引用大字（Shadow Cut 主题字体）+ 左侧大装饰引号 + byline "—— Elon Musk, 2015"。画面安静，让文字独自承担
- 动效要点：pull-quote 整体 FADES in + 引号装饰 SLIDES in 左侧 + Musk 名字 TYPES on
- 音效描述：无（让引文的视觉冲击单独承担）
- 转场进入：crossfade（短）
- 转场离开：硬切 → Scene 09
- 素材依赖：narration.wav 48.0–55.0s · BGM 0.18

### Scene 09 · 55.0s–67.0s · 复用 · B1021 翻新再飞

- 类型：B-roll + A-roll 字幕叠加 + 打字机 + 标注
- 组件：aroll.subtitle-highlight（主线 + 实拍背景）+ aroll.keyword-sticker（标注层）
- 旁白文案："但回得来，只是上半场。真正的大事，发生在 2017 年 3 月 30 日。助推器 B1021——2016 年它执行过 CRS-8——这一次，它被翻新、加注、重新点火，把 SES-10 送进了轨道。"
- 屏显文案：卡拉 OK 字幕；约 61s 处打字机打出复用时间线 "B1021 · 2016 CRS-8 ──→ 2017 SES-10"；"B1021" 标注用引线贴在画面里的助推器箭体
- 期待内容：讲清"同一枚实体火箭跑了两单"——B1021 编号 + 两次任务的时间线
- 期待效果：航天迷听到 B1021 / CRS-8 这种内部编号会心一笑——行家级细节被这样调用，觉得制作认真
- 画面描述：Falcon 9 SES-10 升空视频（B1021 复飞）做背景 + 卡拉 OK 字幕。"B1021" 标注 hairline 引线指向箭体下段。约 61s 处画面右下区打字机逐字打出 "B1021 · 2016 CRS-8 ──→ 2017 SES-10"，etch 字号
- 动效要点：字幕 CASCADE + "B1021" 标注 POP IN + 引线 DRAWS + 时间线 TYPES on（打字机）+ "翻新""再次点火"关键词 marker sweep
- 音效描述：打字机逐字配细密 tick（约 61.0–63.0s · volume 0.3）+ "B1021" 标注 blip
- 转场进入：硬切
- 转场离开：硬切 → Scene 10
- 素材依赖：narration.wav 55.0–67.0s · BGM 0.18 · Falcon 9 SES-10 视频（SpaceX YouTube / 待搜）· tick.wav · blip.wav

### Scene 10 · 67.0s–75.0s · 复用 · 同一枚火箭（强调停顿）

- 类型：B-roll · 大字强调
- 组件：broll-hero.big-type
- 旁白文案："同一枚火箭。跑了第二单。"
- 屏显文案：hero 大字分两次落 "同一枚火箭" → "第 2 次飞行"，"第 2 次"用 accent 色
- 期待内容：把"复用"这个全片转折点单独拎出来，用一个强调镜头钉死
- 期待效果：旁白极短 + 画面留出呼吸，航天迷会停半拍消化"复用真正意味着什么" → 节奏上的一次故意减速
- 画面描述：Shadow Cut 暗背景 + hero 大字。先落"同一枚火箭"，旁白停顿后"第 2 次飞行"砸入、accent 强调。背景极简，这是一个刻意的强调停顿镜头
- 动效要点："同一枚火箭" SLIDES in + 停顿 + "第 2 次飞行" SLAMS in + PULSES 1 次
- 音效描述："第 2 次飞行"砸入配一记 thump（约 71.5s · volume 0.45）
- 转场进入：硬切
- 转场离开：crossfade（短）→ Scene 11
- 素材依赖：narration.wav 67.0–75.0s · BGM 0.18

### Scene 11 · 75.0s–88.0s · 经济 · 一次性火箭与打车类比

- 类型：B-roll · 抽象类比
- 组件：broll-abstract.analogy
- 旁白文案："这一发，改写了航天经济学。过去六十年，每一枚火箭都是一次性的。打个比方：你打了辆车，司机把你送到，然后，把整辆车开进河里、炸掉。"
- 屏显文案：类比图示——左侧"火箭"图标 + 右侧"出租车"图标用等号连起；"开进河里炸掉"时出租车图标坠入水线、爆开
- 期待内容：用"打车开进河里炸掉"的荒诞类比，让观众瞬间理解"一次性火箭有多浪费"
- 期待效果：航天迷会笑——这个类比太形象了；笑完立刻 get 到复用的经济意义
- 画面描述：Shadow Cut 暗背景 + analogy 双栏：左"传统火箭 = 一次性"、右"打车 = 一次性"。讲到"开进河里炸掉"，右侧出租车图标沿弧线坠落、撞水线、accent 色爆开
- 动效要点：双栏 SLIDES in + 等号 FADES in + 出租车图标 ARCS down + 撞水 BURSTS（accent 色碎裂）
- 音效描述：出租车坠落配一段下滑音 + 撞水/爆开配一记闷响 pop（约 85.5s · volume 0.45）
- 转场进入：crossfade（短）
- 转场离开：硬切 → Scene 12
- 素材依赖：narration.wav 75.0–88.0s · BGM 0.18

### Scene 12 · 88.0s–100.0s · 经济 · 数据揭示

- 类型：B-roll · 数据驱动
- 组件：broll-charts.bar-chart
- 旁白文案："复用之后，Falcon 9 的发射成本，砍掉了一大半。今天的 SpaceX，一年发射一百多次，占了全球商业发射的大半。"
- 屏显文案：bar-chart——左组对比柱"传统火箭 · 一次性"vs"Falcon 9 · 复用"成本（后者矮一半）；右组柱"SpaceX 年度发射数 2010 → 2024"，从 2 涨到 100+；右下角小字数据来源 "SpaceX official launch records · 2010–2024"
- 期待内容：用真实数据柱状图把"复用 = 经济学颠覆"实证落地
- 期待效果：航天迷看到成本柱砍半 + 发射数飙到 100+，产生"这数字真的疯了"的震撼
- 画面描述：Shadow Cut 暗背景 + bar-chart。左组成本对比柱（复用柱矮一半、accent 柱顶），右组年度发射数柱递增。"100+" 这个终点数字最大、accent 强调
- 动效要点：bars GROW UP 入场 + 数字 COUNTS UP 滚动 + "100+" PULSES 1 次
- 音效描述：每根柱跳出配细 tick + "100+" 定格配一记 pop（约 96.5s · volume 0.5）
- 转场进入：硬切
- 转场离开：硬切 → Scene 13（猛切到 Mechazilla 实拍，视觉反差最大化）
- 素材依赖：narration.wav 88.0–100.0s · BGM 0.18 · 数据 inline · tick.wav · pop.wav

### Scene 13 · 100.0s–108.0s · 高潮 · 不止于降落

- 类型：B-roll + A-roll 字幕叠加 + 标注
- 组件：aroll.subtitle-highlight（主线 + 实拍背景）+ aroll.keyword-sticker（标注层）
- 旁白文案："但 Musk 不满足于'飞完、再降下来'。他要的是——飞完，直接接住。2024 年 10 月 13 日，Starship 第五次试飞。"
- 屏显文案：卡拉 OK 字幕；"直接接住"四字 marker sweep 重扫；左上 timestamp "2024.10.13 · Starship IFT-5"
- 期待内容：把高潮段的命题立起来——"降落"还不够，目标是"接住"
- 期待效果：航天迷意识到下面要讲 Mechazilla 了，肾上腺素开始上来
- 画面描述：Starship IFT-5 点火升空实拍近全屏 + 卡拉 OK 字幕。"直接接住"被 marker sweep 用力扫一道 accent。画面比叙事段更亮、更满
- 动效要点：字幕 CASCADE + "直接接住" marker sweep（比平时更快更重）+ timestamp FADES in
- 音效描述：BGM 在此处开始缓慢抬升（0.18 → 0.22）+ 一记低频 boom 垫底（约 100.2s · volume 0.4）
- 转场进入：硬切（从数据柱猛切到火焰升空）
- 转场离开：硬切 → Scene 14
- 素材依赖：narration.wav 100.0–108.0s · BGM 0.18→0.22 · Starship IFT-5 升空片段 · boom.wav

### Scene 14 · 108.0s–117.0s · 高潮 · Super Heavy 返场

- 类型：B-roll · 真实视频主导 + 标注
- 组件：真实视频（Super Heavy 返回）+ aroll.keyword-sticker（标注层）
- 旁白文案："Super Heavy 升空、绕地、然后掉头，朝着 Starbase 的发射塔飞回来。注意——它没有落地架。"
- 屏显文案：画面标注：高度读数 "高度 ↓"、速度读数同步递减；"注意——它没有落地架"时，引线指向助推器底部本该有落地架的位置，弹出标注 "无落地架"
- 期待内容：建立"它在朝塔飞回来"的空间关系，并用"无落地架"标注埋下高潮的钩子——它必须被接住，没有别的退路
- 期待效果：航天迷看到"无落地架"引线指向空荡荡的箭体底部，意识到"那它怎么落？" → 屏息
- 画面描述：Super Heavy 返场实拍——掉头、再入、栅格翼调姿、朝塔逼近，近全屏。高度 / 速度读数标注在画面一侧同步递减。讲到"没有落地架"，hairline 引线从箭体底部拉出 "无落地架" 标注，accent 色
- 动效要点：高度 / 速度读数 COUNTS DOWN 同步实拍 + "无落地架"引线 DRAWS（慢、强调）+ 标注 POP IN
- 音效描述：读数滚动细 tick + "无落地架"标注弹出配一记略沉的 blip（约 114.5s · volume 0.3）
- 转场进入：硬切
- 转场离开：硬切 → Scene 15
- 素材依赖：narration.wav 108.0–117.0s · BGM 0.22 · Starship IFT-5 Super Heavy 返场片段 · tick.wav · blip.wav

### Scene 15 · 117.0s–124.0s · 高潮 · 悬停七秒（留白）

- 类型：B-roll · 真实视频主导 + 标注（刻意留白镜头）
- 组件：真实视频（悬停）+ aroll.keyword-sticker（标注层）
- 旁白文案："悬停。七秒。"
- 屏显文案：画面中央偏下一个极简悬停计时器，从 "01" 跳到 "07"，每秒一跳，accent 色
- 期待内容：把全片张力推到顶点——靠"几乎抽空旁白 + 一个滴答走字的计时器"制造屏息感
- 期待效果：旁白只剩四个字，画面安静，航天迷会跟着计时器一秒一秒屏住呼吸 → 这是全片情绪的最高悬点
- 画面描述：Super Heavy 悬停于塔旁的实拍，镜头几乎不动。画面中央偏下悬停计时器 "01…07" 每秒一跳。除计时器外无其他标注，画面刻意干净、安静。这是一个故意放慢、留白的镜头
- 动效要点：计时器数字每秒 TICKS 一跳 + 助推器在画面里极轻微地浮动，其余一切静止
- 音效描述：BGM 在此 bump up 到 0.32；旁白说完"七秒"后抽空；只剩计时器每跳一次配一记清脆 tick（117–124s 共 7 记 · volume 0.35）
- 转场进入：硬切
- 转场离开：硬切 → Scene 16
- 素材依赖：narration.wav 117.0–124.0s（仅前段有旁白）· BGM 0.22→0.32 · Starship IFT-5 悬停片段 · tick.wav

### Scene 16 · 124.0s–130.0s · 高潮 · 筷子臂合拢（重击 + 静止）

- 类型：B-roll · 真实视频主导 + 标注
- 组件：真实视频（筷子臂合拢 + 静止）+ aroll.keyword-sticker（标注层）
- 旁白文案："塔上的两只机械臂——合上了。"
- 屏显文案：合拢瞬间画面中央一记 "接住" 戳记砸入；静止段画面一角安静浮出 "Super Heavy · 已接住"
- 期待内容：兑现全片所有铺垫——筷子臂合拢、接住助推器，"出租车自己开回站台"的隐喻在此落地
- 期待效果：航天迷虽然看过无数遍，但配合前 15 镜的铺垫 + 悬停的屏息，这一下"接住"会有顿悟级的情绪释放
- 画面描述：筷子臂水平滑移、合拢、夹住 Super Heavy 的实拍，慢镜 0.7x。合拢瞬间 "接住" 戳记 accent 色砸在画面中央。之后镜头静止 2s，停在被夹住的助推器上，"Super Heavy · 已接住" 标注安静浮出
- 动效要点：实拍慢镜驱动 + "接住"戳记 SLAMS in（合拢那一帧）+ 静止段"已接住"标注 FADES in
- 音效描述：合拢瞬间一记低频 thump + 紧接 0.3s 全静音（约 127.0s · volume 0.7）；静音后 BGM 轻轻回落到 0.18
- 转场进入：硬切
- 转场离开：硬切 → Scene 17
- 素材依赖：narration.wav 124.0–130.0s · BGM 0.32→静音→0.18 · Starship IFT-5 合拢 + 静止片段 · thump.wav

### Scene 17 · 130.0s–145.0s · 范式 · 为什么不要落地架

- 类型：B-roll · 抽象对照 + 标注
- 组件：broll-abstract.versus + aroll.keyword-sticker（标注层）
- 旁白文案："为什么不要落地架？带轮子的，才叫车；不带的，就只是火箭。Musk 要的从来不是一枚可回收的火箭——他要的，是一台能像飞机那样、加油就能再飞的机器。"
- 屏显文案：versus 卡前半——左卡"可回收的火箭"，右卡"加油就能再飞的机器"；"带轮子的才叫车"时弹出对照标注
- 期待内容：把高潮的视觉震撼，翻译成一个观念——Musk 追求的不是回收，是"航班级的复飞"
- 期待效果：航天迷会"对，我之前没这么想过" → 概念被刷新
- 画面描述：Shadow Cut 暗背景 + versus 对照卡。左卡灰阶"可回收的火箭"，右卡 accent 强调"加油就能再飞的机器"。中间 serif italic "vs"。"带轮子的才叫车"配一个轻量图示标注
- 动效要点：left card SLIDES in 左 + right card SLIDES in 右 + "vs" FADES in + 右卡 PULSES 1 次
- 音效描述：标注弹出 blip（约 134.0s · volume 0.25）
- 转场进入：硬切
- 转场离开：硬切 → Scene 18
- 素材依赖：narration.wav 130.0–145.0s · BGM 0.18

### Scene 18 · 145.0s–160.0s · 范式 · 两个范式

- 类型：B-roll · 抽象对照
- 组件：broll-abstract.versus
- 旁白文案："Falcon 9，是出租车，跑了两单。Starship，是出租车，自己开回了站台。这是两个完全不同的范式。"
- 屏显文案：versus 卡完成态——左卡 "Falcon 9" + 副释"出租车跑两单"（灰阶），右卡 "Starship" + 副释"自己开回站台"（accent 强调），中间"vs"
- 期待内容：用 versus 组件把"Falcon 9 与 Starship 是两个范式而非迭代"一眼讲清
- 期待效果：航天迷意识到 Starship 不是 Falcon 的升级版，是另一种东西 → 概念被升级，呼应 hook 的"出租车"框架闭环
- 画面描述：承接 Scene 17 的 versus 卡，左右卡填入 Falcon 9 / Starship 的最终副释。左卡灰阶、右卡 accent。卡片 hairline 描边，呼应主题装饰
- 动效要点：两卡副释 TYPES on + Starship 卡 PULSES 1 次强调
- 音效描述：无（让对比视觉单独承担）
- 转场进入：crossfade（短）
- 转场离开：crossfade（短）→ Scene 19
- 素材依赖：narration.wav 145.0–160.0s · BGM 0.18

### Scene 19 · 160.0s–172.0s · 收尾 · 22 年时间轴

- 类型：B-roll · 真实视频快剪 + 标注
- 组件：真实视频快剪 + aroll.keyword-sticker（标注层）
- 旁白文案："2002 到 2024，二十二年。从一枚连入轨都困难的小火箭，到一根能在空中接住助推器的塔。"
- 屏显文案：画面下方一条时间轴 "2002 ●········● 2024"，4 个节点（2008 / 2015 / 2017 / 2024）随旁白逐个点亮并弹出小标注
- 期待内容：把全片 4 个节点收拢成一条 22 年时间轴，形成结构性记忆锚点
- 期待效果：航天迷看到时间轴 4 点亮起，会"嗯，这视频确实贯穿了这条主线" → 结构感带来满足
- 画面描述：4 个节点的代表画面快剪（Falcon 1 / LZ-1 着陆 / SES-10 / Mechazilla 各约 2.5s）半透明叠暗背景 + 画面下方时间轴随旁白点亮节点，每个节点弹出年份小标注
- 动效要点：4 段快剪 CROSSFADE 之间软切 + 时间轴节点从左到右逐个 LIGHTS UP + 年份标注 POP IN
- 音效描述：每个节点点亮配一记 blip（约 162 / 165 / 168 / 171s · volume 0.25）
- 转场进入：crossfade（短）
- 转场离开：crossfade（短）→ Scene 20
- 素材依赖：narration.wav 160.0–172.0s · BGM 0.18 · 4 节点代表素材 · blip.wav

### Scene 20 · 172.0s–180.0s · 收尾 · 大字呼应

- 类型：B-roll · 大字海报
- 组件：broll-hero.big-type（呼应 Scene 03）
- 旁白文案："SpaceX 没有发明火箭。它只是——把火箭，做成了出租车。"
- 屏显文案：hero 大字 "把火箭做成出租车"，这次"出租车"三字最大、占主导；上方时间轴 "2002 ········· 2024"（22 个 dot）；底部小字 #SpaceX
- 期待内容：用与 hook 呼应的大字 + 22 年 dot 时间轴封口，把核心信息钉成可截图的一句话
- 期待效果：航天迷看到首尾呼应的大字，形成截图欲 / 转发欲，记住"把火箭做成出租车"
- 画面描述：Shadow Cut 暗背景 + "把火箭做成出租车"大字居中、"出租车"accent 强调 + 上方 22 个 dot 时间轴 + 底部 #SpaceX 小字 + 最后 2s 整体 fade-out 到黑（全片唯一允许的 exit 动画）
- 动效要点：hero 大字 SLAMS in + accent 词 PULSES 1 次 + 22 个 dot 从左到右 CASCADE 点亮 + 最后 2s 整体 FADE OUT 到黑
- 音效描述：BGM 在最后 3s fade-out 到 0
- 转场进入：crossfade（短）
- 转场离开：fade-out 到黑（本片唯一 exit 动画，合规）
- 素材依赖：narration.wav 172.0–179.0s · BGM 0.18 → 0 fade out 在最后 3s


## 7. 音频时间轴

- 旁白（narration.wav）：0.0–179.0s，用 TTS 生成（男声 / 沉稳 / 纪录片旁白感 / 1.0x）。注意两处刻意留白——Scene 15 悬停段（约 119–124s）旁白说完"七秒"后抽空，Scene 16 合拢瞬间（约 127s）留 0.3s 全静音。旁白节奏要配合视觉，不要匀速念到底
- 背景音乐（Minimal Tech Ambient · Pixabay，氛围性铺底，act 级动态）：
  - 0.0–3.0s：fade-in 到 volume 0.12（hook 段刻意压低，让冷开场的实拍和 boom 突出）
  - 3.0–15.0s：维持 0.12
  - 15.0–100.0s：抬到 0.18，叙事段平稳铺底
  - 100.0–117.0s：缓慢抬升 0.18 → 0.22（进入高潮）
  - 117.0–124.0s：bump up 到 0.32（悬停段，配合旁白抽空，音乐接管张力）
  - 约 127.0s：合拢瞬间留 0.3s 全静音
  - 127.0–160.0s：回落到 0.18
  - 160.0–177.0s：维持 0.18
  - 177.0–180.0s：fade-out 到 0
- 音效（SFX）：
  - blip.wav（标注弹出音，全片复用，约 14 处）· 每次画面标注 POP IN 时触发，见各 Scene 音效描述 · volume 0.25–0.30
  - tick.wav（读数 / 计时 / 打字滚动音，全片复用）· 见 Scene 05 / 07 / 09 / 12 / 14 / 15 音效描述 · volume 0.30–0.35
  - 0.5s · boom.wav（Scene 01 冷开场实拍进入）· volume 0.5
  - 19.0 / 19.4 / 19.8s · 闷响 ×3（Scene 04 "前 3 次"红叉三连砸入）· volume 0.3
  - 46.5s · thump.wav（Scene 07 Falcon 9 触地）· volume 0.5
  - 71.5s · thump.wav（Scene 10 "第 2 次飞行"大字砸入）· volume 0.45
  - 85.5s · pop.wav（Scene 11 出租车撞水爆开）· volume 0.45
  - 96.5s · pop.wav（Scene 12 数据"100+"定格）· volume 0.5
  - 100.2s · boom.wav（Scene 13 高潮段起，低频垫底）· volume 0.4
  - 127.0s · thump.wav（Scene 16 筷子臂合拢，后接 0.3s 全静音）· volume 0.7


## 8. 参考与反例

- 正向参考：
  - Johnny Harris（YouTube）——9 分像其"真实素材 + 画面标注层 + 引线指向具体位置"的信息增层做法。1 分不一样：标注更克制，不做成满屏 HUD，每次同屏 ≤ 3 个
  - Kurzgesagt – In a Nutshell（YouTube）——9 分像其"节奏密度 + 信息凝练 + 一个核心隐喻贯穿全片"。1 分不一样：不用 Kurzgesagt 的高饱和插画风，改用真实 NASA / SpaceX 视频素材
  - Wendover Productions（YouTube）——9 分像其"冷静纪录片旁白 + 数据驱动"。1 分不一样：不要 Wendover 的 19 分钟长度，要 3 分钟极致紧凑
- 静态参考：
  - Stripe Press 网页排版——Shadow Cut 主题的暗色锐利 + hairline 装饰对味，标注引线也走这套 hairline 语言
  - Apple Keynote 的 hero 大字——Scene 03 / Scene 20 的大字呼应风格
- 反例（绝对不要）：
  - 视觉：不要黑红"科技标题党"配色 / 不要倒计时条 / 不要 vsauce 式问号卡片 / 标注层不要做成游戏 HUD 或满屏飞数字
  - 叙事：不要"马斯克的传奇"那种热血叙事 / 不要"未来可期"鸡汤收尾 / 不要把 Elon 神化或妖魔化
  - 节奏：教程型也别破 1.5s 下限 / 不要全程同速 / 不要节奏平均用力 / 高潮悬停段不要往里塞旁白


## 9. 开放问题

- Scene 01 / 13–16 Starship IFT-5 视频：这是本片最核心素材，反复用于冷开场和整个高潮段。SpaceX 官方 YouTube 上有完整 4K 版本，渲染前必须确认有可剪辑的本地副本，且包含"升空 + 返回 + 悬停 + 合拢 + 静止"完整序列
- Scene 04–05 Falcon 1 第四发视频：NASA 公共素材是否有 1080p 以上版本？如果只有低质，需在渲染前确认，或考虑用 SpaceX 后期重制的纪念视频
- 画面标注数值核对：各 Scene 标注里的数值（122m 塔高 / 70m 助推器 / Falcon 9 着陆速度区间 / SpaceX 年度发射数）渲染前需逐项核对最新公开数据，避免标注出错——标注层一旦数字错，比没有标注更伤可信度
- 速度 / 高度读数：Scene 07 / 14 的实时读数需要和所选 footage 的真实下降曲线对齐，渲染端若拿不到遥测数据，可改为"区间标注"（如"≈ 300 → 0 km/h"）而非逐帧精确读数
- Voice ID：语气基调描述为"男声 / 略沉稳 / 纪录片旁白感"，具体可用 voice ID 查渲染端文档后填入，建议试 2-3 个选最对味的
- 音效文件：blip / tick / pop / thump / boom 待从 Freesound / Pixabay SFX 搜索下载，关键词已在 § 5 待搜索素材列出
- BGM 时长适配：Pixabay 上 Minimal Tech Ambient (Main) 原长度需确认是否 ≥ 180s，如不足需用同曲多版本拼接
CODEX_LAZYPACK_74B2DC7C55037D93A4ADD7EFE8C8A0595B1CD786

# video-spec-builder/references/components-catalog.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/video-spec-builder/references/components-catalog.md")"
cat > "{{CODEX_HOME}}/skills/video-spec-builder/references/components-catalog.md" <<'CODEX_LAZYPACK_AC5F079FB80D4C824B65E505A60D3B4DD433D4FF'
---
name: components-catalog
description: 视频内容类型词汇表 · 69 个标准内容类型。
---

# 内容类型词汇表 · Components Catalog

69 个标准内容类型，拆分镜时每镜锚定一个组件 ID。本目录只描述「用途 / 何时用 / 何时不用 / 内容期待」，不含视觉实现细节。

[使用方式]
    - 选组件：先看 [何时用] / [何时不用] 划范围，再看 [用途] 确认
    - 填内容：照 [内容期待] 把所需字段补齐
    - 兜底：找不到合适组件 → `broll-abstract.placeholder` + 在「开放问题」登记
    - 命名规则：`namespace.component-id`（如 `aroll.subtitle-highlight`）

11 个 namespace（不允许自创）：
    aroll · broll-hero · broll-charts · broll-abstract · broll-flows ·
    broll-structure · broll-structures2 · broll-thinking · broll-ui ·
    icons · illustrations


[A-roll · 出镜讲解层]

[aroll.subtitle-highlight] 字幕高亮 · Subtitle Highlight · SPOKEN-WORD CAPTIONS
    用途：把讲者口播逐词分解，念到哪个高亮哪个，做视觉节拍器。
    何时用：口播节奏需逐词强调 / 字幕做节拍器 / 关键名词被锁住 / 双语字幕。
    何时不用：大段背景旁白 / 字幕只需平铺 / 关键词需贴画面具体位置（→ keyword-sticker）。
    内容期待：一整句口播文案（中/英/双语）· 哪些词是关键词 · 讲者名 / 章节 / 时间码（可选）· 整句念完的预估时长。

[aroll.keyword-sticker] 关键词贴纸 · Keyword Sticker · POP-IN LABELS
    用途：讲者抛出新名词时，在画面里"贴"上 1-3 个关键词做视觉锚点。
    何时用：抛出新名词 / 行话 / 人名 / 公司名 · 想给口播加锚点但不做完整卡 · 关键词散布画面。
    何时不用：≥ 4 个标签（→ card-grid）· 需要完整定义（→ concept-card）· 需驻留 > 3s。
    内容期待：1-3 个关键词（中/英）· 哪个最关键（被反色）· 出现时机（口播第几秒）。

[aroll.concept-card] 概念卡 · Concept Card · EXPLAINER CARD
    用途：在画面侧贴一张完整"新词定义卡"——标题 + 一段正文 + 来源引用。
    何时用：抛新名词需驻留 3-5s · 引用书 / blog / paper 的核心论点 · 章节首次介绍核心概念。
    何时不用：同屏已有另一张概念卡 · 信息量 > 3 行（→ pull-quote / analogy）· 偏抽象需图示（→ broll-abstract.*）。
    内容期待：概念名（中+英）· 一句话定义（≤ 3 行）· 来源（书 / 作者 / paper / URL）· 是否需斜体强调某词。


[B-roll · 重锤海报]

[broll-hero.big-type] 大字海报 · Big Type · TYPOGRAPHIC POSTER
    用途：撑满全屏的章节封面 / 标题大字——用字体本身做段落分隔。
    何时用：章节封面 · 整支视频核心论点的"标题镜头" · 段落之间需要节奏停顿 / 视觉清场。
    何时不用：普通段落标题（→ concept-card）· 同段落已用过另一张 hero · 信息 ≥ 2 行论点。
    内容期待：一行核心标题（≤ 8 中文字 / ≤ 5 英文词）· 章节编号 · 是否某字斜体 / 反色 · 关键短语副标（可选）。

[broll-hero.big-number] 大数字 · Big Stat · STATISTIC HERO
    用途：用一个超大数字（百分比 / 倍数 / 量级）撑满画面，配一句精炼解释。
    何时用：决定性数字（87% · 10× · $1B）· 想让数字独立成镜 · 引用数据 source 时。
    何时不用：数据是趋势 / 多点（→ line-chart）· 数字只是过渡 · 没 source / 方法 / 出处。
    内容期待：主数字 + 单位 · 一句解释 · 来源（调研名 / 样本量 / 误差范围）· 数字的标签（FINDING / DELTA / SHARE）。

[broll-hero.pull-quote] 引用块 · Pull Quote · EDITORIAL MOMENT
    用途：全屏引用名人 / 论文 / 文档原话，下方署名作者。
    何时用：引用领域权威（Karpathy / Sutton / paper 摘要）· 核心论点想借口说出 · 需要杂志质感的节奏镜头。
    何时不用：没具体出处 / 作者 · 引用 > 4 行（拆镜或 → concept-card）· 需要数据 / 图表佐证。
    内容期待：引用原文（≤ 4 行）· 作者姓名 + 身份职业 + 年份 · 分类（如 ON CRAFT）· 是否某词强调。

[broll-hero.inversion-flash] 反白闪屏 · Inversion Flash · CUT-IN TRANSITION
    用途：瞬间反白做修辞停顿 / 段落切换。
    何时用：段落切换的"刹车" · 反问 / 转折前的修辞停顿（"等一下。"）· 强调一句话的"重音"。
    何时不用：单支视频已用过 2 次以上 · 连续使用 · 持续 > 1s。
    内容期待：一句要重锤的话（≤ 10 中文字）· 出现时机 · 闪屏后下一镜的方向。


[B-roll · 数据图表]

[broll-charts.line-chart] A1 · 折线图 · Line Chart · TREND OVER TIME
    用途：展示一个指标随时间的变化趋势。
    何时用：单一指标的时间序列 · 强调"增长 / 下降 / 峰值" · 数据点 6-30 个。
    何时不用：多指标对比（→ multi-line）· 离散类别（→ bar）· 比例占比（→ donut）· 数据点 < 6（→ sparkline）。
    内容期待：数据来源 · 主标签（如"周活用户增长"）· 关键数值（终点 / 峰值 / 起始）· 时间范围 · 是否标注异常点 / 关键节点。

[broll-charts.multi-line] A2 · 多线对比 · Multi-line · MODEL COMPARISON
    用途：多条折线同图对比同一指标（多模型 / 多产品 / 多赛道）。
    何时用：2-3 条同维度时间序列 · 强调"谁领先 / 谁追赶" · 模型 benchmark / 产品增长。
    何时不用：单一指标（→ line-chart）· ≥ 4 条线（拆图 / → bar）· 维度不同（→ compare-table）。
    内容期待：2-3 条线的名字 · 每条数据来源 · 哪条是主角（高亮）· 主标 · 时间范围。

[broll-charts.bar-chart] A3 · 柱形图 · Bar Chart · DISCRETE QUANTITIES
    用途：离散类别（月 / 周 / 类型）的数值高低对比。
    何时用：4-8 个离散类别 · 想凸显"哪个最高 / 最低" · 月度 / 季度 / 单位量级。
    何时不用：连续时间趋势（→ line）· 类别 > 10（→ h-bar）· 比例占比（→ donut）· 多维度叠加（→ stacked）。
    内容期待：各类别名 · 各类别数值 · 哪个是峰值（被高亮）· 主标（突出峰值发现）。

[broll-charts.h-bar] A4 · 横向条形 · H-Bar · RANKING
    用途：排行榜——横向条形按降序排列，强调第一名。
    何时用：5-10 个项目排序 · 项目名较长（横向能完整显示）· 强调"第一名 vs 其他"。
    何时不用：时间序列（→ line / bar）· 项目 ≤ 3（→ big-number）· 不需要排名感（→ bar）。
    内容期待：5-10 个项目名 · 各项数值（降序）· 排名第一项（自动 accent）· 主标 + 数据来源。

[broll-charts.stacked] A5 · 堆叠柱 · Stacked · COMPOSITION OVER TIME
    用途：时间序列上各组成部分的占比变化。
    何时用：总量 + 构成同时关注 · 季度 / 月度的"构成演化" · 主项要在底部视觉锚定。
    何时不用：只关心总量（→ line / area）· 只关心单时刻占比（→ donut）· 构成 ≥ 5 项。
    内容期待：时间标签 · 每时间点 3 个分项数值 · 主项（放底部）· 主标 + 数据来源。

[broll-charts.area-chart] A6 · 面积图 · Area · ACCUMULATED VOLUME
    用途：强调"累积量 / 容量增长"——折线下方填充。
    何时用：强调"累积"（token 用量 / 用户数累计）· 单一指标的体量增长感 · 需比 line 更有视觉重量。
    何时不用：多条线对比 · 数据有负值 / 剧烈波动 · 想强调精确数值（→ line + 端点标）。
    内容期待：数据来源 · 主标（强调累积 / 增长叙事）· 时间范围 + 数据点 · 起点值 + 终点值。

[broll-charts.donut] A7 · 环形图 · Donut · PROPORTION
    用途：4 块以内的占比构成图（一个主项 + 几个次项 + Other）。
    何时用：比例占比 / 关注"主项占多少" · 项目数 ≤ 4 · 想让中心数字成视觉锚。
    何时不用：项目 > 4（→ bar）· 想强调排名（→ h-bar）· 是绝对值非百分比 · 多时间段（→ stacked）。
    内容期待：各分项名 + 百分比（≤ 4 项）· 中心要显示的关键数 · 主项是哪个 · 主标 + 数据来源。

[broll-charts.scatter] A8 · 散点图 · Scatter · CORRELATION
    用途：二维分布——x/y 轴各代表一维度，点大小可映射第三维度。
    何时用：二维相关性（cost × quality）· 想找甜蜜点 / 异常值 · "模型 D 是甜蜜点"叙事。
    何时不用：时间序列（→ line）· 只有一维度（→ bar）· 数据点 > 30（→ heatmap）。
    内容期待：x / y 轴各代表什么 · 5-15 个点的名字 + 坐标 · 哪个是甜蜜点 / 主角 · 第三维度（可选）· 主标 + 来源。

[broll-charts.heatmap] A9 · 热力图 · Heatmap · 2D INTENSITY
    用途：二维网格上的强度分布（行 × 列 = 强度）。
    何时用：二维强度（时间 × 类别）· 想揭示"哪个时段 / 区域最热" · 数据是离散网格。
    何时不用：一维数据（→ bar / line）· 网格 < 5×5（→ bar）· 需要精确数值（→ bar / table）。
    内容期待：行标签（如周一到周日）· 列标签（如 0-23 时段）· 每格强度值（0-100）· 主标 + 数据来源。

[broll-charts.gauge] A10 · 仪表盘 · Gauge · SINGLE METRIC
    用途：单一指标向某个目标的进度（如 RAG Fidelity 73% · 目标 80%）。
    何时用：单一 KPI 当前值 + 目标值 · 强调"完成度 / 距离目标" · 不需要历史趋势。
    何时不用：有时间趋势（→ line + 目标线）· 多个 KPI（→ sparkline）· 进度不是关键（→ big-number）。
    内容期待：当前值 + 单位 · 目标值 · 一句叙事解释 · 状态标签（HEALTHY / WARNING / CRITICAL）。

[broll-charts.sparkline] A11 · 迷你图 · Sparkline · DENSE METRIC CARDS
    用途：多张 KPI 卡片的"周报"——每卡含大数字 + delta + 迷你曲线。
    何时用：关键指标看板总览 · 同时展示 3-6 个 KPI · 强调涨/跌用颜色编码。
    何时不用：单一指标深挖（→ gauge / line）· 卡片间维度差异大 · 卡片数 < 3 或 > 6。
    内容期待：3-6 个 KPI 名 + 当前值 · 每个的 delta · 每个的迷你曲线数据（5-10 点）· 是否带 LIVE 标签。

[broll-charts.sankey] A12 · Sankey 流图 · FLOW DISTRIBUTION
    用途：多列节点之间的流量分布（漏斗 / 转化 / 资源分配）。
    何时用：多阶段漏斗（来源 → 试用 → 留存）· 多对多的资源分配 · 揭示"哪条主路径最粗"。
    何时不用：单一线性漏斗（→ funnel）· 节点 > 8 · 流量不是核心（→ 普通流程图）。
    内容期待：各列节点名 · 节点间流量数值（决定流条粗细）· 主路径是哪条 · 主标 + 数据来源。


[B-roll · 抽象兜底]

[broll-abstract.analogy] 类比框 · Analogy · UNFAMILIAR ≈ FAMILIAR
    用途：把陌生概念左右对应到熟悉事物（"RAG ≈ 开卷考试"），中间用 ≈ 连接。
    何时用：引入新名词（最常用的抽象组件）· 找到熟悉概念做桥 · 强调"本质相似但形式不同"。
    何时不用：两者对立 / 对抗（→ versus）· 关系是因果 / 推导（→ equation）· 没有合适熟悉概念（→ black-box / placeholder）。
    内容期待：陌生概念（中+英+副释）· 熟悉概念（中+英+副释）· 类比的成立维度（哪一点相似）。

[broll-abstract.black-box] 黑盒图 · Black Box · INPUT → ? → OUTPUT
    用途：强调"中间过程不可知"——输入 → "?"盒 → 输出。
    何时用：讲"内部不可解释"（LLM 黑盒 / 神经网络）· 想表达"我们不需要知道内部" · 输入输出明确，过程模糊。
    何时不用：内部步骤是清晰的（→ broll-flows.complex）· 没明确输入 / 输出（→ placeholder）· 想说明内部机制。
    内容期待：输入是什么 · 输出是什么 · 黑盒内的副释（如"175B 参数 · 不可解释"）。

[broll-abstract.equation] 概念等式 · Concept Equation · A + B = C
    用途：把概念组合写成"教科书等式"——如"模型 + 资料 = 可靠回答"。
    何时用：强调"两个要素组合产生结果" · 公式化表达核心论点 · 想要教科书 / 严谨气质。
    何时不用：概念是 A vs B 对立（→ versus）· 是因果 / 流程（→ flow）· 三项以上要素。
    内容期待：等式左侧两项（每项名词 + 副释）· 等式右侧结果（名词 + 副释）· 哪一项是关键（accent）。

[broll-abstract.spectrum] 光谱 · Spectrum · ONE AXIS · TWO POLES
    用途：一根轴 · 两端对立极 · 中间一个 marker 标当前位置。
    何时用：表达"X 在 A 和 B 之间偏哪边" · 连续过渡的两极 · 标"当前状态"在光谱上的位置。
    何时不用：离散两类（→ versus）· 不是连续过渡（→ analogy）· 多维度（→ matrix-2x2）。
    内容期待：左极概念 · 右极概念 · 当前 marker 在 0-1 区间的位置 · marker 的标签（如"RAG · 0.68"）。

[broll-abstract.iceberg] 冰山 · Iceberg · VISIBLE / HIDDEN
    用途：水面以上"可见 10%"，水面以下"隐藏 90%"。
    何时用：比例悬殊的"看得见 / 看不见" · 强调"冰山一角" · LLM 显性 UI vs 隐性权重。
    何时不用：比例接近 1:1（→ versus）· 不是显性 / 隐性（→ stacked / donut）· 不需要"上下层级"（→ layered-stack）。
    内容期待：水面以上是什么（"可见 10%"内容）· 水面以下是什么（"隐藏 90%"内容）· 一句叙事主标。

[broll-abstract.versus] 对照 · Versus · A vs B · DELTA
    用途：两个方案左右等宽对比 · 中间 "vs" · 每行对齐对照。
    何时用：两个方案 / 概念逐项对比（预训练 vs 微调）· 行行对齐看差异 · 想突出某一边更好。
    何时不用：≥ 3 个对象（→ compare-table）· 不是对立 / 平行（→ analogy）· 维度只 1 个（→ spectrum）。
    内容期待：左侧方案名 + 短描述 · 右侧方案名 + 短描述 · 3-4 个对比维度（每维左值/右值）· 哪边被推荐（accent）。

[broll-abstract.placeholder] 占位框 · Placeholder · WHEN YOU LACK AN ASSET
    用途：缺素材时的兜底框——标注后续要补什么素材。
    何时用：真的找不到合适组件，缺截图 / 录屏 · 占位以推进 spec · 标注未来要补的素材规格。
    何时不用：任何能用其他组件替代的场景（不要偷懒）· 已经确定的镜头。
    内容期待：素材名（如"产品 demo 截屏"）· 素材规格（尺寸 / 时长 / 格式）· 谁负责补 / 何时补。


[B-roll · 流程图]

[broll-flows.complex] B1 · 复杂流程 · Multi-step · EXTENDED LINEAR FLOW
    用途：7 个左右节点的线性流程，含 latency / 高亮关键 cluster。
    何时用：6-9 步线性 pipeline（RAG / CI-CD）· 想圈出"核心段" · 每步有耗时数据可标。
    何时不用：流程有分支（→ branching）· 节点 ≤ 5（→ flow-chart）· 不需 latency 数据（→ flow-chart）。
    内容期待：6-9 个节点名（中+英）· 每步 latency · 哪段是"核心 cluster" · 主路径节点（被 accent）。

[broll-flows.branching] B2 · 分支流程 · Branching · IF / ELSE
    用途：单一决策点 + YES / NO 分支（如缓存命中 → 返回 / 调模型）。
    何时用：单一决策点的 if/else · 缓存策略 / 错误处理 / 准入判断 · 强调"YES vs NO"。
    何时不用：多级决策（→ decision-tree）· 没分支（→ complex / flow-chart）· 决策回到原节点（→ loop）。
    内容期待：决策点问题（如"缓存命中？"）· YES 分支后续节点 · NO 分支后续节点 · 主路径是哪条（accent）。

[broll-flows.decision-tree] B3 · 决策树 · Decision Tree · MULTI-LEVEL JUDGMENT
    用途：多级决策（根 → 决策 → 叶），推荐路径全程高亮。
    何时用："我选 A 还是 B 还是 C" · 工程选型决策（RAG / 微调 / 联网 / 原生）· 引导观众跟着推理走。
    何时不用：单一决策（→ branching）· 层级 > 3（拆图）· 不是判断而是流程（→ complex）。
    内容期待：根问题 · 每层决策问题 + YES/NO · 终点叶节点（推荐结果）· 推荐路径（被 accent 高亮）。

[broll-flows.state-machine] B4 · 状态机 · State Machine · STATES WITH TRANSITIONS
    用途：圆形节点（状态） + 箭头（转移事件） + 自循环。
    何时用：Agent 状态（IDLE / THINKING / ACTING）· UI 状态机（pending / loading / success）· 强调"可循环 / 可回退"。
    何时不用：线性步骤（→ complex / flow-chart）· 单向无循环（→ sequence）· 状态 > 6。
    内容期待：各状态名（建议 4 个，最多 6）· 状态间转移事件（INVOKE / RETRY）· 哪个是循环（self-loop）· 主路径。

[broll-flows.sequence] B5 · 时序图 · Sequence · API / INTERACTION TIMELINE
    用途：多个 actor 之间的时序调用——顶部 actor + 下垂 lifeline + 箭头。
    何时用：多角色 API 调用顺序（User → API → LLM → DB）· 同步 vs 异步对比 · 强调"先后 / 时间顺序"。
    何时不用：单一线性流程（→ complex）· 不强调时间顺序（→ hub-spoke）· 角色 > 6。
    内容期待：3-5 个 actor · 调用顺序每步（from → to + 操作名）· 哪些是同步 / 异步 · 关键调用（accent）。

[broll-flows.swimlane] B6 · 泳道图 · Swimlane · MULTI-ROLE PROCESS
    用途：横向泳道，节点位置编码"哪条道 = 谁来做"。
    何时用：多角色协作（human-in-the-loop）· 强调"责任移交 handoff" · AutoML / 标注 / 复核工作流。
    何时不用：单角色（→ complex / flow-chart）· 不强调"谁做"（→ sequence）· 角色 > 4。
    内容期待：3-4 条 lane（角色名）· 每个步骤 + 在哪条 lane · 哪些步骤是"跨 lane 移交"（被高亮）。

[broll-flows.fork-join] B7 · 并行 / 汇合 · Fork-Join · PARALLEL EXECUTION
    用途：主控 → fork → 并行 worker → join → merge 结果。
    何时用：并行调用多个 agent / API（map-reduce）· 强调"并发度"和"等所有完成" · 多源同时检索后合并。
    何时不用：串行流程（→ complex）· 没汇合（→ branching）· worker 间有顺序依赖（→ sequence）。
    内容期待：主控节点名（如"Coordinator"）· 并发 worker 数（推荐 3 个）· 每个 worker 做什么 · merge 结果。

[broll-flows.loop] B8 · 循环流程 · Loop · ITERATIVE OPTIMIZATION
    用途：4 节点环形排列 + 闭环 + 中心写退出条件（如 RLHF 4-step）。
    何时用：迭代优化（训练 → 推理 → 评估 → 再训练）· 强调"形成闭环" · 直到指标收敛才退出。
    何时不用：线性流程（→ complex）· 单节点自循环（→ state-machine）· 节点 ≠ 4。
    内容期待：4 个节点名（必须 4 个）· 退出条件（一句话）· 哪个节点是关键（被 accent）。


[B-roll · 结构图 I]

[broll-structure.flow-chart] 流程图 · Flow Chart · LINEAR PROCESS
    用途：4 步线性流程，自动推进高亮当前步骤。
    何时用：简单 4 步流程 · 让镜头自己走完一遍 · 强调"过去 / 当前 / 未来"三态。
    何时不用：步骤 ≠ 4 或有分支（→ broll-flows.*）· 步骤间有 latency（→ complex）· 静态展示（→ complex 精简版）。
    内容期待：4 个步骤名（中+英）· 每步一句话描述（可选）· 推进节奏（默认自动 / 配合口播）。

[broll-structure.pyramid] 金字塔 · Pyramid · HIERARCHY
    用途：3 层金字塔（如战略 / 方法 / 执行），顶层强调。
    何时用：层级金字塔（战略 / 方法 / 执行）· 强调"少而决定性 vs 大量重复" · Maslow 类层级。
    何时不用：层数 > 3 · 等量层级（→ layered-stack）· 不是层级而是流程（→ flow）。
    内容期待：3 层各自名字（中+英）· 每层简短描述 · 哪层是 accent（默认顶层）。

[broll-structure.funnel] 漏斗 · Funnel · CONVERSION
    用途：4 阶段转化漏斗，最终留存被强调。
    何时用：用户转化漏斗（AWARE → TRY → COMMIT → EVANGELIZE）· 招聘 / 销售 / 留存递减 · 强调"最后剩下的"。
    何时不用：阶段数 ≠ 4 · 多对多流量分布（→ sankey）· 阶段没有递减性质（→ stack / flow）。
    内容期待：4 阶段名字（中+英）· 每阶段数值（人数 / 比例）· 主标 + 数据来源。

[broll-structure.concentric] 同心圆 · Concentric · NESTED SCOPE
    用途：嵌套同心圆（业务 → 产品 → 体验 → 核心），强调最里圈。
    何时用：范围嵌套（business 包含 product 包含 experience）· "由外向内"的核心论点 · 关注点收敛模型。
    何时不用：不是嵌套（→ hub-spoke / node-graph）· 重叠相交（→ venn）· 圈数 > 4。
    内容期待：4 层名字（从外到内）· 每层简短描述 · 最内圈的"核心"是什么。

[broll-structure.node-graph] 节点图 · Node Graph · ROUTING / WORKFLOW
    用途：节点 + 边的图结构（如 input → router → tool A/B → output）。
    何时用：Agent 路由 / 工具调用图 · 想强调"中心 router 是关键" · 节点数 4-6 个，结构简单。
    何时不用：节点 > 8（→ hub-spoke / 拆图）· 强调时间顺序（→ sequence）· 节点是层级（→ tree）。
    内容期待：4-6 个节点名（中+英）· 节点间连接关系 · 哪个节点是关键（如 router，被 accent）。

[broll-structure.spectrum] 谱系图 · Spectrum · OPPOSITE AXIS
    用途：水平轴 + 两极标签 + 当前位置点（简化版，对比 broll-abstract.spectrum）。
    何时用：演进位置（规则驱动 → 智能体驱动）· 想标"我们当前在哪里" · 单一维度对立两极。
    何时不用：二维定位（→ matrix-2x2）· 多极（→ mind-map）· 需要数值精度（→ broll-abstract.spectrum）。
    内容期待：左极概念 · 右极概念 · 当前位置点的标签（如"我们在这里"）。


[B-roll · 结构图 II]

[broll-structures2.tree] C6 · 树 · Tree / Taxonomy · HIERARCHICAL CLASSIFICATION
    用途：三层分类树（如 LLM → Encoder/Decoder/MoE → GPT-4/GPT/LLaMA）。
    何时用：分类学 / taxonomy · 组织架构图 · 强调"父子 / 包含"层级。
    何时不用：节点有多父（→ node-graph）· 强调"中心-外围"（→ hub-spoke）· 强调"重叠"（→ venn）。
    内容期待：根节点名 · 第二层各分类（2-4 个）· 每分类下实例（2-3 个）· 哪条分支被强调（accent）。

[broll-structures2.mind-map] C7 · 思维导图 · Mind Map · RADIAL DECOMPOSITION
    用途：中心主题 + 6 个一级分支 + 各自 2-3 个二级子项。
    何时用：系统拆解（ML = 数据 / 训练 / 评估 / 部署 / 反馈 / 安全）· 知识图谱 · "主题向外辐射"。
    何时不用：严格层级（→ tree）· 单链 / 线性分解（→ flow）· 分支 > 8。
    内容期待：中心主题名 · 6 个一级分支名 · 每个一级分支下 2-3 个二级子项 · 哪个一级分支是 hot（accent）。

[broll-structures2.matrix-2x2] C8 · 2x2 矩阵 · Matrix · POSITIONING / QUADRANTS
    用途：二维定位象限——每个对象一个点放在合适象限。
    何时用：商业 / 产品 / 模型定位 · 强调"理想象限是哪个" · 多对象在二维上相对位置。
    何时不用：一维（→ spectrum）· 维度 > 2（拆多张 / → mind-map）· 想要精确数据（→ scatter）。
    内容期待：x / y 轴各代表什么 · 四象限各自标签 · 5-10 个对象 + 各自所在象限 · 哪个是"理想 / 主角"。

[broll-structures2.venn] C9 · Venn 图 · INTERSECTION / UNION
    用途：三圆相交 · 中心交集标"灵魂名词"（如 AI 工程师 = 软件 ∩ ML ∩ 产品）。
    何时用：揭示"X 是 A、B、C 的交集" · 跨学科 / 跨能力领域定义 · 解释新角色的复合性。
    何时不用：集合数 > 3 · 集合不相交（→ stack / grid）· 强调"包含"而非"重叠"（→ concentric）。
    内容期待：3 个集合名字（中+英）· 中心交集"是什么"（灵魂名词）· 哪个集合是主圈（accent）。

[broll-structures2.layered-stack] C10 · 分层堆栈 · Layered Stack · ARCHITECTURE LAYERS
    用途：7 层架构堆栈（L1 硬件 → L7 UI），可指定某 2-3 层为 focus。
    何时用：系统架构 7 层 / OSI / AI 应用栈 · 强调"今天讨论的是第 X 层" · 想用"层"这个词。
    何时不用：不是严格分层（→ concentric / hub-spoke）· 层间互动水平（→ swimlane）· 层 ≤ 3（→ pyramid）。
    内容期待：7 层各自名字（编号 + 中+英）· 每层一句话备注 · 哪 1-2 层是 focus（被高亮）。

[broll-structures2.hub-spoke] C11 · Hub & Spoke · CENTRALIZED SYSTEM
    用途：中心 hub + 6 个方向辐射 spoke（如 AI Agent + 工具集成）。
    何时用：中央控制 + 多外围工具的"枢纽" · 强调 Agent 调度多工具 · "X 是所有 Y 的中心"。
    何时不用：节点是平等的（→ node-graph）· 多对多（→ sankey / mind-map）· 强调"层级"（→ tree）。
    内容期待：中心 hub 名字（如 AI Agent）· 6 个 spoke 名字（GitHub / Slack / Notion）· 哪些 spoke 是重点（accent）。

[broll-structures2.grid-map] C12 · 网格地图 · Grid Map · CLUSTER TOPOLOGY
    用途：大规模节点网格 · 颜色映射状态（active / idle / error）。
    何时用：GPU 集群 / 服务节点拓扑 · 实时状态监控类视觉 · 强调"规模感"（几十节点一眼看完）。
    何时不用：节点 < 30（→ node-graph）· 节点有关系连线（→ node-graph）· 状态 > 3 类。
    内容期待：总节点数（推荐 72=12×6）· 状态分类（active / idle / error）· 每类数量 · 主标 + 一句叙事。


[B-roll · 思考与组织]

[broll-thinking.compare-table] D1 · 对比表 · Comparison Table · A VS B VS C
    用途：多对象 × 多维度对比表（如 GPT-4 / Gemini / LLaMA × 6 维）。
    何时用：3 个对象多维度对比 · 每行有"最优"项可标 · 表格式 spec 表达。
    何时不用：仅 2 个对象（→ versus）· 维度 > 8（拆表）· 想要叙事感（→ versus）。
    内容期待：3 个对象名 · 4-6 个对比维度 · 每行各对象的值 · 每行赢家是谁（一致项可不标）。

[broll-thinking.swot] D2 · SWOT 四宫格 · STRATEGIC ANALYSIS
    用途：2×2 网格 SWOT 分析（优势 / 劣势 / 机会 / 威胁）。
    何时用：战略 / 产品 / 模型的 SWOT · 强调"正负两面" · 项目 / 业务复盘。
    何时不用：不是 SWOT 框架（→ compare-table）· 单一维度（→ card-grid）· 项目数 > 12。
    内容期待：S / W / O / T 各 3-4 条 · 分析对象是什么（如"自家产品 vs 市场"）。

[broll-thinking.fishbone] D3 · 鱼骨图 · Fishbone · ROOT CAUSE ANALYSIS
    用途：水平主干（=问题）+ 6 类成因斜插（人/方法/工具/环境/数据/反馈）。
    何时用：故障复盘 / 根因分析 · 6 大类原因可视化（5M+1E）· 强调"主因 vs 次因"。
    何时不用：单一因果链（→ flow）· 不是因果而是分类（→ tree）· 类别 ≠ 6。
    内容期待：问题陈述（鱼头）· 6 大类原因（标签 + 每类 1-3 个子因素）· 哪 1-2 类是主因（被 accent）。

[broll-thinking.timeline-row] D4 · 时间线 · Timeline · HISTORICAL EVOLUTION
    用途：水平时间轴 + 6 个事件 · 上下交错卡片。
    何时用：行业演化（Transformer → GPT-3 → ChatGPT）· 公司里程碑 · 6-8 个关键年份事件。
    何时不用：项目周计划（→ gantt）· 不是时间而是步骤（→ flow）· 事件 > 10。
    内容期待：6-8 个事件（日期 + 标题 + 一句说明）· 哪 2-3 个是关键（被 accent）· 时间范围（如 2017-2025）。

[broll-thinking.gantt] D5 · 甘特图 · Gantt · PROJECT TIMELINE
    用途：项目时间表——左列任务 + 右侧周柱。
    何时用：项目计划（roadmap / sprint）· 强调任务并行 / 依赖 · 标关键里程碑。
    何时不用：历史事件（→ timeline-row）· 单一任务（→ flow）· 任务 > 12 行（拆表）。
    内容期待：时间范围（如 W1-W10）· 6-12 个任务名 + 起止周 · 哪些是关键里程碑（accent）。

[broll-thinking.kanban] D6 · Kanban 看板 · STATUS COLUMNS
    用途：4 列任务看板（待办 / 进行中 / 复审 / 完成）。
    何时用：团队 sprint 状态 · 工作流可视化 · 强调"哪些在做 / 哪些卡住"。
    何时不用：项目时间维度（→ gantt）· 单一任务列表（→ card-grid）· 列数 ≠ 4。
    内容期待：4 列名（默认 BACKLOG / IN PROGRESS / REVIEW / DONE）· 每列卡片数 + 任务名 · 哪列是当前焦点。

[broll-thinking.card-grid] D7 · 卡片网格 · Card Grid · CONCEPT GALLERY
    用途：4×2 = 8 张概念卡片网格（如 8 种 prompting 技术）。
    何时用：同类概念集合（"8 种 prompting 技术"）· 想推荐 1-2 个 · 8 个左右对等项目。
    何时不用：概念有层级 / 顺序（→ tree / flow）· 项数 < 4 或 > 12 · 项目维度不一致。
    内容期待：8 个概念名（中+英+编号）· 每个副标（一句话）· 哪 1-2 个是推荐项（被 accent）。


[B-roll · UI Mock]

[broll-ui.terminal] 终端 · Terminal · CLI MOCK
    用途：模拟 CLI 终端窗口——命令字 + 打字机光标 + 元数据输出。
    何时用：演示 CLI 工具（codex run / git / curl）· 强调"代码 / 工程"质感 · 配合 CLI 教学。
    何时不用：演示 web UI（→ browser）· 演示 API 调用（→ api-call）· 仅演示代码片段（→ code-editor）。
    内容期待：终端标题（如 "~/projects/rag-demo · zsh"）· 命令字（真实可信）· 输出主响应 + 尾部元数据（tokens / 延迟 / 成本）· 是否带打字机动画。

[broll-ui.chat-thread] 对话流 · Chat Thread · LLM CONVERSATION
    用途：模拟 LLM 对话——user 气泡 / AI 气泡左右对话。
    何时用：演示 prompt → response · LLM 对话教学 · 凸显"对话感"。
    何时不用：演示 API（→ api-call）· 演示 CLI（→ terminal）· 多人协作（→ sequence）。
    内容期待：用户提问内容 · AI 回答内容 · 是否有追问 / 多回合（推荐 2-3 回合）· 是否带等待光标（流式响应）。

[broll-ui.browser] 浏览器 · Browser · URL + VIEWPORT
    用途：模拟浏览器窗口——tabs + URL + viewport 内容。
    何时用：演示 Web 产品（codex.ai 等）· URL + 页面内容同时强调 · 多 tab 场景。
    何时不用：桌面应用（→ terminal / code-editor）· 没有 URL（→ placeholder）· 仅强调输入框（→ api-call）。
    内容期待：当前 URL（不含 https://）· 3 个 tab 标题（选中哪个）· viewport 内的主标 + CTA 文案 · 是否带 LIVE 标签。

[broll-ui.code-editor] 代码编辑器 · Code Editor · SYNTAX HIGHLIGHTED
    用途：代码编辑器——可选文件树 + 行号 + 高亮当前行。
    何时用：演示代码片段（Python / JS / SQL）· 教学 API 怎么调 · 想 highlight 某一行做讲解。
    何时不用：命令行操作（→ terminal）· 演示请求响应（→ api-call）· 不是真实代码（→ placeholder）。
    内容期待：文件名 + 语言（如 rag.py · Python 3.12）· 6 行以内真实可运行代码 · 哪一行高亮 · 是否需侧边栏文件树。

[broll-ui.api-call] API 调用 · Request / Response · REST · JSON
    用途：左右双面板模拟 REST API——请求 + 延迟 + 响应。
    何时用：演示 API 调用结构 · 强调 latency 数字（教学可信感）· JSON 字段映射。
    何时不用：演示前端界面（→ browser）· 演示完整代码（→ code-editor）· 不是 REST 而是 SDK（→ code-editor）。
    内容期待：请求方法 + 路径（如 POST /v1/messages）· 请求 body（真实 JSON）· 响应状态码 + body · latency（真实毫秒）· 哪个响应字段是重点。

[broll-ui.dashboard] 仪表盘 · Dashboard · LIVE METRICS
    用途：模拟实时监控仪表盘——多 KPI 卡 + 长 sparkline 卡。
    何时用：实时监控 / 性能仪表盘 · 同时展示多 KPI + 趋势 · 演示运维 / SRE 场景。
    何时不用：单一 KPI（→ gauge）· 详细数据图（→ broll-charts.*）· 静态报告（→ sparkline）。
    内容期待：3 张 KPI 卡（标签 + 主数字 + 单位）· 哪张是 hot（accent）· 底部 sparkline 数据（24h 时序）· 是否带 LIVE 标签。


[图标与插画]

[icons.lucide-set] I-2 · 常用图标库 · 48 个 · CURATED SET
    用途：从 Lucide 1500+ 图标中精选 48 个，可在 spec 里用 ID 引用。
    何时用：UI 信息层 / 注脚 / 节点标识 / 列表前缀 · 卡片标题装饰 · 输入框前缀（search / mail）。
    何时不用：大于 48px 的装饰图标（→ 插画）· 手绘风格的图标 · 同屏混用多个 icon set。
    内容期待：图标 ID（如 `zap` / `database` / `bot`）· 使用场景（节点 / 标签 / 标题）· 不够用时可从 lucide.dev 现搜（直接 name 传入）。
    可用图标（48 个，按组）：
        - 人/沟通: user · users · message-circle · mic · mail · phone · hand · user-cog
        - 数据/系统: database · cloud · cpu · hard-drive · network · git-branch · workflow · layers
        - AI/工具: bot · brain · wand-sparkles · zap · terminal · code · function-square · plug
        - 文档/内容: file-text · book-open · notebook-pen · bookmark · quote · list-checks · tag · folder-open
        - 行动/状态: rocket · target · compass · search · check-circle-2 · triangle-alert · x-circle · help-circle
        - 度量/时间: line-chart · bar-chart-3 · pie-chart · timer · calendar · gauge · trending-up · shield-check

[icons.stroke-weights] I-1 · 描边粗细 · 4 档 · STROKE WEIGHTS
    用途：Lucide 图标支持 4 档描边粗细，约定使用场景。
    何时用：一般不指定（默认走中档）· 仅当需要"特别细 / 特别重锤"时指定。
    何时不用：同屏混用 3 档以上 · 默认让视觉富化阶段处理 · 直接锚定语义。
    内容期待：通常无需指定 · 如有需要：标注"该镜需要重锤图标"或"需要极细图标"。

[illustrations.scene-thinking] 01 · 深度思考 · DEEP THINKING · SEATED + LIGHTBULB
    用途：坐姿人物手托腮 + 思考气泡 + 灯泡装饰，做"灵感 / 思考"封面。
    何时用："灵感 / 思考"主题章节封面 · 介绍方法论 / 思想类内容。
    何时不用：团队 / 协作主题（→ scene-co-create）· 非章节封面镜头（插画限封面用）。
    内容期待：章节标题（中+英）· 是否需章节编号 / 副标 · 章节核心论点（一句话）。

[illustrations.scene-co-create] 02 · 协作共创 · CO-CREATE · TWO PEEPS + SCREEN
    用途：两人共看屏幕 + 一人指屏一人抱臂，做"团队 / 协作"封面。
    何时用："团队 / 协作"主题章节封面 · 强调"共同创造 / 共看"。
    何时不用：单人主题（→ scene-thinking / scene-prompt）· 非章节封面镜头。
    内容期待：章节标题（中+英）· 章节核心论点。

[illustrations.scene-prompt] 03 · 提示工程 · PROMPT CRAFT · STANDING + TERMINAL
    用途：站立人物 + 指向终端窗口 + 漂浮符号，做"提示工程"封面。
    何时用："提示工程 / 编写命令"章节 · 强调"人在主动构造"。
    何时不用：RAG / 检索主题（→ scene-retrieval）· 非章节封面镜头。
    内容期待：章节标题（中+英）· 章节核心论点。

[illustrations.scene-retrieval] 04 · 知识检索 · RETRIEVAL · RAG · MAGNIFIER + FILE CABINET
    用途：站立人物拿放大镜 + 文件柜（中抽屉拉出），做"RAG / 检索"封面。
    何时用："RAG / 检索"章节封面 · 强调"查文件 / 翻资料"。
    何时不用：数据分析主题（→ scene-analytics）· 非章节封面镜头。
    内容期待：章节标题（中+英）· 章节核心论点。

[illustrations.scene-analytics] 05 · 验证分析 · ANALYTICS · WHITEBOARD + UPWARD CURVE
    用途：站立人物 + 白板上扬曲线 + 柱状，做"数据分析 / 复盘"封面。
    何时用："数据分析 / 复盘"章节封面 · 强调"看曲线 / 上升趋势"。
    何时不用：上线 / 发布主题（→ scene-launch）· 非章节封面镜头。
    内容期待：章节标题（中+英）· 章节核心论点。

[illustrations.scene-launch] 06 · 上线发布 · LAUNCH · WAVE + ROCKET TRAIL
    用途：挥手人物 + 火箭沿弧形虚线飞向右上，做"发布 / 上线"封面。
    何时用："发布 / 上线"章节封面（视频结尾常用）· 强调"成功 / 出发"。
    何时不用：思考主题（→ scene-thinking）· 非章节封面镜头。
    内容期待：章节标题（中+英）· 章节核心论点（多用于视频收尾）。

[illustrations.scene-library] I-3 · 场景插画库 · 6 SCENES · OPEN PEEPS STYLE
    用途：6 张场景插画的统一规范——做章节封面用。
    何时用：章节封面（一章一张）· 需要手绘人物 + 主道具的镜头。
    何时不用：非章节封面（插画限封面用）· 一屏多张插画（每屏最多 1 张）。
    内容期待：从 6 张中选一张（scene-thinking / scene-co-create / scene-prompt / scene-retrieval / scene-analytics / scene-launch）· 主题不匹配时直接用 broll-hero.big-type 兜底。


[组件选型决策树]

```
要展示什么？
├── 数字 / 趋势 / 占比                → broll-charts.*（12 个）
├── 步骤 / 决策 / 状态 / 协同         → broll-flows.*（8 个）
├── 层级 / 分类 / 拓扑                → broll-structure.* (6) + broll-structures2.* (7)
├── 对比 / 分析 / 时间线              → broll-thinking.*（7 个）
├── 软件界面 / 终端 / 对话            → broll-ui.*（6 个）
├── 抽象概念（没有具象图标）          → broll-abstract.*（7 个）
├── 重锤强调 / 大字 / 引用 / 反白闪屏 → broll-hero.*（4 个）
├── 出镜叠加（字幕 / 贴纸 / 概念卡）  → aroll.*（3 个）
├── 章节封面（手绘人物 + 道具）       → illustrations.*（7 个）
├── UI 小图标                         → icons.*（2 个）
└── 缺素材兜底                        → broll-abstract.placeholder
```

合计 69 个组件 · 11 个 namespace。
CODEX_LAZYPACK_AC5F079FB80D4C824B65E505A60D3B4DD433D4FF

# video-spec-builder/references/dialogue-style.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/video-spec-builder/references/dialogue-style.md")"
cat > "{{CODEX_HOME}}/skills/video-spec-builder/references/dialogue-style.md" <<'CODEX_LAZYPACK_86FC90684EABCA6007B5F3C122319066B62E4A08'
---
name: dialogue-style
description: 对话风格的具体范本和参考词典。当你需要追问用户、引导用户做选择、给方案对比时,翻这个文档找具体的"导演式"话术范本。
---

# 对话风格

[定位]
    SKILL.md 给的是说话**纪律**(语态 / 原则 / 不暴露 Phase)。
    本文档给具体**范本**——典型表达对照、方案引导框架、追问转换原则、影视参考词典。

    什么时候翻这里:
    - 不知道怎么把抽象问题问得有画面感 → 看 [典型表达对照]
    - 用户卡壳没主意 → 看 [方案引导范本]
    - 想找一个比喻 / 形容词 → 看 [影视参考词典]
    - 用户答了模糊词("高级"/"炫酷")想反击 → 看 [必杀技 · 用户答模糊词时]

---

## [典型表达对照]

九组对照,每组 `❌ 程序员式 vs ✅ 导演式`。规律:**给画面感 + 给后果 + 给参考**。

### 谈镜头时长

❌ "这镜头打算放多少秒?1 秒和 4 秒是两个完全不同的语言。"

✅ "1 秒和 4 秒,观众的感受完全不一样——
   1 秒像一记拍肩,转身就走;
   4 秒像有人盯着你看,让人不自觉屏住呼吸。
   这一镜你想让人怎么感觉?"

### 谈"炫酷"动效

❌ "想要'动效炫酷',对应是 shader 转场还是音频反应可视化?要哪个?"

✅ "'炫酷'有几种很不一样的味道——
   一种是液态融化的转场,画面像水墨化开,神秘感拉满;
   一种是画面跟着鼓点跳,像 DJ 打碟,又跳又燃;
   一种是粒子炸开,像烟花'啪'地一下散开。
   你脑里哪个画面更对?"

### 谈平台

❌ "你这视频要在抖音播还是 YouTube 播?时长和比例完全不一样。"

✅ "抖音和 YouTube 完全是两个世界——
   抖音观众站在地铁里,3 秒抓不住就划走;
   YouTube 观众坐着泡咖啡,愿意听你讲 5 分钟。
   你想拍给哪种人看?"

### 谈 3D / 2.5D

❌ "这镜头你想要 3D 模型还是 2.5D 卡片飞?前者要 Three.js 资产,后者用 GSAP 就行,工作量差 10 倍。"

✅ "你想要 Apple 发布会那种产品 360° 真实旋转的沉浸感?
   还是 Stripe 文档那种卡片轻飘飘飞过的轻盈感?
   前者更震撼,但需要你手里有现成的 3D 模型;
   后者更快出活,画面也更克制。"

### 谈配音

❌ "用 TTS 还是真人录?"

✅ "AI 配音 30 秒就能生成,但听起来还是有点'课件感',平稳没情绪;
   真人录花 1-2 小时,但能传递你说话时的小停顿、小喘息,那种'有人在跟我讲话'的感觉。
   你这视频是哪种更重要?"

### 谈字幕

❌ "要常驻字幕 / 关键词高亮 / 卡拉 OK 逐词,挑一个。"

✅ "字幕有三种感觉——
   整句跳出来像看电影底字,稳但平;
   关键词被横扫高亮像 Karpathy 推文,锐利;
   逐词一个个亮起像卡拉 OK,有节拍感。
   你这视频更想要哪种?"

### 谈镜头节奏

❌ "0.8s/镜还是 2s/镜?"

✅ "镜头切得快像刷抖音,3 秒抓不住就走;
   切得慢像看电影,每帧禁得住停留。
   你这视频在哪种场景被看到?反推回来节奏自然就定了。"

### 谈"高级感"

❌ "'高级感'是什么意思?"

✅ "'高级感'有几种很不同的口味——
   一种是 Apple 那种冷峻锐利,像金属切割(适合科技产品);
   一种是 Stripe Press 那种编辑杂志感,像在读《纽约客》(适合内容品牌);
   一种是 Vogue 那种慵懒优雅,像 magazine 跨页(适合时尚生活)。
   你想要哪一种'高级'?"

### 谈"安静一下"

❌ "'安静'要承载什么?静默是一种信息,不是空白。"

✅ "'安静'有两种——
   一种是电影里枪响前的那 2 秒,屏住呼吸等爆点;
   一种是看完哭点之后的留白,让情绪沉一下。
   你这里的安静,是在等什么?"

---

## [方案引导范本]

用户卡壳 / 没主意时,不要开放问("你想要什么 BGM?")—— 用户答不出。给 **3 个**完整方案,每个方案 **4 件套**:**名字 + 画面感 + 参考 + 后果**。最后给你的推荐。

### 完整范本(以 BGM 选择为例)

✅ "三个方向你听看看,哪个对味——

**方案 A · Minimal Tech Ambient**
- 画面感:像 Kurzgesagt 那种科普视频的底色,节奏紧但不焦虑
- 参考:[Pixabay 链接]
- 选这个你会得到:全片有'思路在推进'的节奏感,信息密度撑得住

**方案 B · Cinematic Documentary**
- 画面感:像看一部 Netflix 纪录片开头,弦乐铺底,带点叙事张力
- 参考:[Pixabay 链接]
- 选这个你会得到:气质上更'传记片',但 3 分钟视频可能略拖

**方案 C · Ambient Inspiring Space**
- 画面感:像 SpaceX 官方发布会开头那种'即将出大事'的氛围
- 参考:[Pixabay 链接]
- 选这个你会得到:主题最贴,但有点'corporate inspiring'味,看你接不接受

我推荐 **A**——你这视频是航天迷向的科普,A 的节奏感和 Kurzgesagt 风互锁,最对味。但 B 和 C 也各有优势,你拍板。"

### 关键纪律

- 不给开放问(用户答不出)
- 不给二选一(容易让用户被迫选差的)
- 给 **3 个**(刚好覆盖差异,又不过多让用户犯难)
- 每个方案带 **画面感 + 参考 + 后果** 三件套
- 最后给 **你的推荐**(不是命令,是专业建议),理由要具体

---

## [追问风格 · 3 条转换原则]

把抽象问题转成画面感问题的三条规律。

### 原则 1 · 画面感优先

每个选项要让用户在脑海里看见。

❌ "想要 hook 型还是教程型?"
✅ "你想要那种 3 秒抓住人不撒手的感觉,还是带着观众慢慢走、给他时间消化的感觉?"

### 原则 2 · 比喻代替术语

用生活场景说话。

❌ "0.8s/镜还是 2s/镜?"
✅ "镜头切得快像刷抖音,切得慢像看电影。你这视频在哪种场景被看到?"

### 原则 3 · 揭示后果

告诉用户"选了 X 你会得到 Y"。

❌ "用 TTS 还是真人?"
✅ "AI 配音 30 秒生成,但听起来还是有点'课件感';真人录花 1-2 小时,但能传递你说话时的小情绪和停顿。你这视频是哪种重要?"

---

## [必杀技 · 用户答模糊词时]

用户说"高级感 / 炫酷 / 高大上" → 不要直接驳回,先给他 2-3 种"高级感"的画面描述:

✅ "'高级感'有不同口味——
   一种是 Apple 那种冷峻锐利,像金属切割(适合科技产品);
   一种是 Stripe Press 那种编辑杂志感,像在读《纽约客》(适合内容品牌);
   一种是 Vogue 那种慵懒优雅,像 magazine 跨页(适合时尚生活)。
   你想要哪一种'高级'?"

把模糊词翻译成 2-3 个具体画面,让用户指认。

---

## [影视参考词典]

追问时主动从这里拿词,让对话有"行业内人"的质感。

### 节奏感
拍肩 · 屏息 · 心跳 · 喘息 · 抽离 · 卡点 · 留白 · 节拍器

### 情绪
冷峻 · 锐利 · 慵懒 · 神秘 · 烟火 · 倔强 · 安静爆炸 · 反差顿悟 · 信念

### 场景
地铁刷手机 · 电影院屏息 · 客厅泡咖啡 · 会议室强光 · 朋友圈滑过 · 通勤路上 · 摸鱼时间

### 视觉
水墨化开 · 鼓点跳动 · 粒子炸开 · 金属切割 · 油画质感 · 杂志切换 · 卡片飘飞

### 真实参考(创作者 / 作品 / 品牌)
Apple Keynote · Stripe Press · Vogue · The Verge · 三联生活周刊 · Kurzgesagt · Wendover Productions · Karpathy 推文 · Netflix 纪录片
CODEX_LAZYPACK_86FC90684EABCA6007B5F3C122319066B62E4A08

# video-spec-builder/references/pacing-rules.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/video-spec-builder/references/pacing-rules.md")"
cat > "{{CODEX_HOME}}/skills/video-spec-builder/references/pacing-rules.md" <<'CODEX_LAZYPACK_8DE065AE278F6C410484375B7583A7ADF2DCA56A'
---
name: pacing-rules
description: 视频节奏与时长规范。
---

# 节奏规范

[使用时机]
    - 选定信息密度后（Phase 1.5）
    - 分配每个 Scene 时长时
    - 决定转场密度时
    - 校验总时长时
    - 判断 hook 镜头是否合格时

[核心命题]
    节奏不是"感觉"，是每秒承载多少信息的数学问题。
    - 高密度 = 每秒一个信息点
    - 低密度 = 每 5-8 秒一个信息点 + 中间用情绪填充
    - 节奏 ↔ 平台 互相约束（抖音不允许慢节奏，发布会不允许 hook 型）

---

## [三档节奏]

按主导节奏给出每镜头时长 / 每分钟镜头数 / 转场频率 / 留白比例。

```
[hook 型 · 高密度]
    适用：短视频开头 / 抖音 / 广告 / 产品发布
    每镜头：0.8 - 2.0s
    每分钟镜头数：30 - 60
    大转场频率：每 4-6s 一次
    留白：< 5%
    旁白字数：≈ 1.5-2 字/秒（60s ≈ 90-130 字）
    典型应用：YouTube Shorts 30s · TikTok 15s · 信息流广告 6s
    音频：BGM 必须有强节拍，每镜头切换对应一个 beat

[教程型 · 中等密度]
    适用：科普 / 教程 / 产品演示 / B 站知识区
    每镜头：2.0 - 5.0s
    每分钟镜头数：15 - 30
    大转场频率：每 10-15s 一次
    留白：10-15%
    旁白字数：≈ 2-3 字/秒（3min ≈ 400-550 字）
    典型应用：B 站知识区 3-5min · 教程视频 · 产品演示 60-90s
    音频：BGM 偏柔，旁白为主，关键节点留呼吸感

[纪录型 · 慢节奏]
    适用：vlog / 纪录片 / 品牌片 / 慢叙事
    每镜头：3.0 - 8.0s
    每分钟镜头数：8 - 15
    大转场频率：每 20-30s 一次
    留白：20-30%
    旁白字数：≈ 1.5-2.5 字/秒（90s ≈ 140-220 字，可大段无旁白）
    典型应用：品牌片 90s · 纪录片 5min+ · 电影预告 60-120s
    音频：氛围乐 / 情绪音 / 旁白慢语速 / 留白
```

[Rhythm 命名]
    具体 rhythm pattern（如 fast-fast-SLOW / hook-PUNCH-hold-CTA）后续视觉富化阶段定。
    本文件只管时长基准 + 总时长校验。

---

## [总时长校验]

按目标时长反推镜头数 + 转场密度。

| 时长 | 镜头数 | 大转场 | 反白闪屏 | hook 时点 | 典型场景 |
|---|---|---|---|---|---|
| < 3s | — | — | — | — | 拒做（信息载荷不够） |
| 3-5s | 1-2 | 0 | 0 | 全镜即 hook | 微视频封面 / 极短广告 |
| 5-10s | 3-7 | 0-1 | ≤ 1 | 全片即 hook | 抖音封面 / Twitter / Story |
| 15-20s | 8-15 | 1-3 | ≤ 1 | 开头 3s | 抖音单条 / 信息流广告 |
| 30s | 12-25 | 2-4 | ≤ 2 | 开头 3-5s + 结尾 2-3s CTA | 抖音长版 / 产品宣传 |
| 60-90s | 18-40 | 3-6 | ≤ 2 | 中段允许小章节切换 | 发布会片头 / 品牌片 / Vlog |
| 3-5min | 50-150 | 6-12 | 章节卡分隔 | 每 30-45s 一次节奏重置 | YouTube / B 站知识区 |
| 5-10min | 90-300 | 12-30 | 章节卡分隔 | 每章节独立 hook | YouTube 长视频 / B 站深度 |
| 10-30min | 拆 spec | — | — | 每 episode 独立 hook | 拆为 2-4 个独立 spec |
| ≥ 30min | 拆系列 | — | — | — | 不在单 spec 范围内 |

[平台对照]

| 平台 | 节奏类型 | 每镜头时长 | hook 时点 | 画幅 |
|---|---|---|---|---|
| 抖音 / TikTok | hook 型 | 0.8-2s | 前 3s（强制字幕） | 9:16 |
| YouTube Shorts | hook 型 | 1-2.5s | 前 3s | 9:16 |
| YouTube 主频道 | 教程型 | 2.5-5s | 前 15s（章节标记） | 16:9 |
| B 站知识区 | 教程型 | 2-4s | 前 10s（章节卡） | 16:9 |
| 发布会大屏 | 纪录型 | 3-8s | 前 5s（建立氛围） | 16:9 |
| 品牌官网 hero | loop 友好 | 5-15s | 首尾帧相似 | 16:9 |

[时长推算公式]
    镜头数 N = 总时长 T ÷ 平均镜头时长
    转场总时长 ≈ N × 0.2-0.5s（粗估）
    实际镜头总时长 = T − 转场总时长
    误差 ±0.5s 允许。

    举例：
    - hook 型 30s → N ≈ 30/1.5 ≈ 20 镜，转场占用 2-3s
    - 教程型 3min → N ≈ 180/3.5 ≈ 51 镜，转场占用 8-10s
    - 纪录型 90s → N ≈ 90/5 ≈ 18 镜，转场占用 5-8s

---

## [Hook 镜头]

第一镜决定用户停留还是滑走，是整支视频最贵的镜头。

```
[第一镜定生死]
    - 0-3s 内必须建立"看下去的理由"
    - hook 镜头时长 ≤ 2s（短平快）
    - 必须有强视觉刺激：大字 / 数字 / 强反差 / 转场闪屏
    - 不允许第一镜是"安静的标题卡"
    - 不允许 logo 单独占第一镜（logo 是片尾，不是 hook）
    - 不允许"黑屏 + 渐入文字"超过 1s（除非是极端慢叙事）

[hook 推荐组件]
    1. broll-hero.big-type        文字 hook
    2. broll-hero.big-number      数据 hook
    3. broll-hero.inversion-flash 视觉切入
    4. aroll.subtitle-highlight   口语 hook
    5. broll-charts.bar-chart     数据反差 hook

[hook 反例]
    × 第一镜放品牌 logo 渐入 3 秒
    × 第一镜放黑屏 + "故事开始于一个夜晚..."
    × 第一镜放主持人自我介绍
    × 第一镜放安静的产品图（除非是奢侈品片）
```

---

## [转场密度]

转场不是装饰，是节奏的换气符号。用错了眩晕，用少了平。

```
[硬切 / 软转 / 大转场比例]
    - 80% 硬切（场景之间瞬切）
    - 15% 软转（B-roll 之间）
    - 5% 大转场（反白闪屏 / shader / wipe，章节切换专用）
    具体 crossfade / shader duration 后续视觉富化阶段定。

[反白闪屏纪律]
    - 每支视频 ≤ 2 次（硬规则）
    - 不允许连续使用（间隔 ≥ 8s）
    - 用于"章节切换"或"修辞停顿"，不用作日常切换
    - 反白瞬间不允许有内容（纯白屏即可）

[同组件连续切换]
    例：连续 3 个 broll-charts.bar-chart 展示季度数据
    - 用软切 + 组件自带 stagger 让数据变化看起来连贯
    - 不要每次都"重新出现一个新图表"
    - 让组件框架不变、内部数据更新，类似 dashboard 切换

[shader 转场纪律]
    - 仅用于节奏巨大转折点（hook → 主体 / 主体 → 高潮 / 高潮 → 收尾）
    - 每支视频 ≤ 1 次（30s 以下）或 ≤ 2 次（60s 以上）
    - shader 风格要匹配视频调性（液态/像素/分形 vs 极简风冲突）
    - 具体 shader ID 后续视觉富化阶段定
```

---

## [信息密度]

判断每个 Scene 能不能存在的核心标准。

```
[每个 Scene 的信息承载]
    - hook 型：1 个核心信息 + 0 个支撑信息（专注一击）
    - 教程型：1 个核心信息 + 1-2 个支撑信息（标题 + 1-2 个细节）
    - 纪录型：1 个核心信息 + 0-1 个氛围信息

[禁止空帧]
    - 每个 Scene 都必须承载至少 1 个信息
    - 不允许"过渡黑屏 3 秒"（除非是 hook 前的悬念，最多 0.5s）
    - 留白要承载"喘息"而非"等待"
    - 用户说"这里安静一下" → 追问"安静要承载什么？静默是一种信息，不是空白"

[文字密度]
    - 每屏文字 ≤ 12 字（中文）或 ≤ 8 词（英文）
    - 引用块例外，可到 30 字 / 20 词
    - 数据图表的标签除外
    - 超限 → 拆成两个镜头 + crossfade

[数据密度]
    - 单屏数据 ≤ 3 个数字（hook 镜头 ≤ 1 个大数字）
    - 图表轴标签 ≤ 7 个
    - 表格 ≤ 5 行 × 4 列（超出拆成多镜头）
```

---

## [微视频策略 · ≤ 10s]

抖音封面、Twitter 短帖、Story / Reels 封面、信息流 hover 等场景。
极短时长意味着信息载荷必须收敛到 1-2 个点，否则观众消化不动。

```
[时长决策]
    - < 3s：拒做。告诉用户改用静图或加长到 5s+
    - 3-5s：单镜或双镜，每镜 2-3s。纯 hero 大字 / 数据冲击。hook 即全部
    - 5-10s：hook 型，每镜 0.8-1.5s，3-7 镜。hook + 小展开 + 收尾大字

[追加要求]
    - 结构 = hook + CTA（或 hook + hero takeaway），不分"展开/高潮"
    - 反白闪屏 ≤ 1 次（5s 内 2 次过密，眼睛吃不消）
    - 文字密度 ≤ 8 字/屏（停留时间短，超 8 字读不完）
    - 旁白控制：
        - ≤ 5s：无旁白，纯视觉 + 大字
        - 5-10s：≤ 25 字旁白，或纯字幕无旁白
    - 必须无声友好（静音状态下用户也能 get 到信息）
    - 必须有强视觉刺激（大字 / 大数字 / 强反差 / 反白闪屏，4 选 1）

[反例]
    × 5s 视频塞 3 段旁白 → 旁白未完用户已划走
    × 8s 视频用 4 个 1.5s 镜头讲 4 件事 → 信息过载，1 个也记不住
    × 3s 视频用淡入淡出 → 转场吃掉 1s，浪费 1/3 时长
```

---

## [长视频策略 · ≥ 5min]

长视频拆 episode（章节），不要单 spec 写完一坨。
拆章节带来：每章节独立 hook（重复抓回观众）+ 节奏 reset 点（快慢交替更明显）+ 渲染失败可独立重做。

```
[时长决策]
    - ≤ 5min：单 spec 完整覆盖
    - 5-10min：单 spec，分镜表必须分 3-5 章节（每章节有独立节拍 + 高潮点）
    - 10-30min：拆成 2-4 个独立 spec（每个 5-10min），用 episode 信息串起
        - 每个 spec 在 § 1 视频基本盘注明「episode 1/4 · 系列名 <series-name>」
        - 各 episode 独立可渲染，但共用主题 / accent / 组件白名单
    - ≥ 30min：建议拆系列视频（不在单 spec 范围内），先做 trailer + 第一集

[追加要求]
    - 每章节独立 hook（每 60-90s 重复抓回观众，否则注意力流失）
    - 每章节有节奏 reset 点（章节内快-慢交替更明显，不允许全章节同速）
    - 章节之间用 shader 转场或反白闪屏作章节卡分隔（章节卡内有章节编号 + 标题）
    - 总镜头数 = 60-180 个（5-10min 区间），按 2-4s/镜均速估算
    - 章节间用 timeline-row 或 chapter-marker 做"目前进度"提示（强信息流场景必加）
    - BGM 必须有 2-3 个 motif 切换（不能 5min 同一段循环 30 遍）

[章节结构推荐]
    - 总览 hook（5-10%）：抛出整片要解决的问题
    - 章节 1（25%）：第一个论点 + 论据 + 小高潮
    - 章节 2（25%）：第二个论点 + 论据 + 小高潮
    - 章节 3（25%）：第三个论点 / 反转 / 综合
    - 收束 CTA（10-15%）：复述核心 takeaway + 行动召唤

[反例]
    × 8min 视频从头到尾没有章节卡 → 观众 3min 就走神
    × 章节都是相同节奏（3s/镜）→ 没有 reset 点，观众疲劳
    × BGM 一首循环到底 → 听觉单调
```

---

## [节奏校验自检]

生成 video-spec.md 之前必须过一遍。

```
□ 第一镜在 2s 内（hook 型）/ 5s 内（教程型）/ 8s 内（纪录型）
□ 总镜头数符合节奏类型基准
□ 反白闪屏 ≤ 2 次且不连续
□ shader 转场 ≤ 2 次
□ 没有空帧（除 < 0.5s 悬念）
□ 文字密度 ≤ 12 字/屏
□ 每个 Scene 都承载至少 1 个信息
□ 转场比例：80% 硬切 / 15% 软转 / 5% 大转场
□ 总时长 = Σ镜头时长 + Σ转场时长（误差 ±0.5s）
□ 节奏类型与平台匹配（抖音不允许慢节奏，发布会不允许 hook 型）
□ hook 镜头有强视觉刺激
□ CTA 镜头时长 2-3s（不超不少）
□ 中长视频（≥ 60s）有节奏重置点
```

---

## [常见错误]

```
[第一镜慢入]
    诊断：第一镜超过 2s 还没有视觉冲击
    修正：换成 hook 推荐组件中的任一个，或把节奏从 hook 改为慢节奏（仅当不是社媒平台）

[连续反白闪屏]
    诊断：两次反白闪屏间隔 < 8s
    修正：保留一次，把另一次改为硬切或 crossfade

[总时长不对]
    诊断：Σ镜头时长 + Σ转场时长 ≠ 目标时长
    修正：调整镜头时长，优先压缩中段非关键镜头

[信息密度为零]
    诊断：某个 Scene 时长 ≥ 3s 但没有具体信息载荷
    修正：要么砍掉，要么加内容（文字 / 数据 / 视觉细节）

[转场过多]
    诊断：30s 视频用了 5 个反白闪屏
    修正：保留 2 个（章节切换 + 高潮），其他改为硬切

[节奏与平台错配]
    诊断：抖音视频用慢节奏，发布会用 hook 型快剪
    修正：节奏对齐平台基准
```
CODEX_LAZYPACK_8DE065AE278F6C410484375B7583A7ADF2DCA56A

# video-spec-builder/references/question-bank.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/video-spec-builder/references/question-bank.md")"
cat > "{{CODEX_HOME}}/skills/video-spec-builder/references/question-bank.md" <<'CODEX_LAZYPACK_1D79B36EF3D4E3D404CCADD5595972781DC99825'
---
name: question-bank
description: 视频需求收集追问问题库，5 个 Phase。你在收集需求时按 Phase 翻这本题库，每个 Phase 包含多个维度的覆盖意图、主问题、追问深化、接受标准与不接受的答案。
---

[定位]
    这是追问纪律的约束工具，不是"灵感库"，也不是问卷脚本。
    你默认走"创造性追问"路线，本题库是约束基准——想接受敷衍时翻 [不接受的答案]，
    想提前结束时翻 [接受标准]，想瞎问时翻 [主问题]。

[纪律 · 用户面前不暴露 Phase 标签]

    Phase 1-5 是你内部的工作追踪用语，**不是给用户看的标签**。
    维度章节名（如 [1.1 · 视频目的]）也是你内部翻题库用的，不要念给用户听。

    禁忌对用户说：
    × "OK Phase 1 锁定"
    × "进入 Phase 2"
    × "Phase 4 视觉微调"
    × "[追问深化] 触发"
    × "[接受标准] gate 通过"
    × "我去开锁 WebSearch 给你查"

    正确做法：用导演聊天的口语，**承上启下**。
    一个话题聊完了，用一句"基本盘我懂了 / 素材清楚了"复述要点，
    然后自然引到下一个话题（"现在我们聊聊素材"、"接着聊聊视觉风格"）。
    具体过渡话术示例写在每个 Phase 末尾的 [过渡话术示例] 里。

[五段结构 · 每个维度都长这样]

    [覆盖意图]      为什么问这个维度（防"问完不知道为什么问"）
    [主问题]        默认抛给用户的问题（防"凭印象瞎问"）
    [追问深化]      用户敷衍时的反击话术，格式"用户说 X → 你回 Y"（防"和气接受敷衍"）
    [接受标准]      gate 通过条件（防"自我满足提前停"）
    [不接受的答案]  必须驳回的答案样本（防"编造合理答案"）

[渐进式追问]
    - Phase 1 是 gate，必须全部有答案，但答案可以从用户初始描述抽取并复述确认
    - 用户答某问题时"溢出"覆盖了下一问题 → 直接吸收，不要再问
    - Phase 2-5 根据 Phase 1 答案动态裁剪（产品演示重点问 3D + UI mock，
      不问"3D 场景型"这种与产品演示不相关的维度）

[全量维度索引]

    Phase 1 · 视频基本盘（必问 gate）
        1.1 视频目的 / 1.2 目标受众 / 1.3 平台与时长 /
        1.4 核心信息 / 1.5 信息密度 /
        1.6 品牌 Tone of Voice / 1.7 观众熟悉度

    Phase 2 · 素材盘点
        2.1 内容 / 2.2 音频 / 2.3 视频影像 /
        2.4 图形 / 2.5 3D / 2.6 待搜索素材

    Phase 3 · 表达手段激发
        3.1 场景类型组合 / 3.2 文字呈现 / 3.3 动效语言 /
        3.4 节奏基准 /
        3.5 叙事节拍设计 / 3.6 情绪曲线 / 3.7 音画关系

    Phase 4 · 视觉主题选定 + 微调
        4.1 主题选择 / 4.2 accent 色 / 4.3 装饰层 / 4.4 组件白黑名单

    Phase 5 · 参考与反例
        5.1 参考视频 / 5.2 静态参考 / 5.3 反例 /
        5.4 同质化反例

[Phase 1 · 视频基本盘]
    Phase 1 是地基。地基塌了，后面 4 个 Phase 全是流沙。这些维度必须全部问到具体答案，不允许跳过。

    [1.1 · 视频目的]
        [覆盖意图]
            没有目的的视频是给自己看的日记。目的决定整片的取舍——
            没有这条 gate，后面所有判断都没参考系。

        [主问题]
            - 这个视频要解决什么问题？让看的人记住什么？做什么？
            - 这是科普 / 营销 / 教学 / 产品演示 / 品牌 / 纪录 哪一类？混合的不算，挑主导。
            - 看完之后用户应该有什么具体行动？点链接？记住一个概念？分享转发？下载？注册？

        [追问深化]
            - 用户说"想火"→ 你回："火的标准是什么？播放量、点赞数、转化率、还是行业讨论度？给我一个数字。"
            - 用户说"科普 + 营销"→ 你回："挑一个主导。如果只能保留一个目的，你保留哪个？另一个砍掉视频就不成立吗？"
            - 用户说"让大家学到东西"→ 你回："学到什么具体的东西？一个名词的定义？一个步骤的方法？一个判断的标准？说一个。"
            - 用户说"提升品牌认知"→ 你回："提升后用户怎么用脚投票？搜你的品牌名？复访你的官网？提到品牌名时态度变了？"
            - 用户说"做内容沉淀"→ 你回："沉淀给谁看？投资人？候选人？老用户？新用户？这三种人想看的东西完全不一样。"
            - 用户说"先做了再说"→ 你回："做了之后用什么标准判断它成功还是失败？没标准就别做。"

        [接受标准]
            - 一句话能说清楚"是什么类型 + 让谁记住什么 + 看完去做什么"
            - 例如：这是产品演示视频，让 SaaS 团队的产品经理记住"我们的 AI 自动写 PRD"，看完去官网注册免费试用
            - 例如：这是品牌纪录片，让设计圈记住"我们的创始人是从工业设计转 AI 的"，看完愿意把视频转发到同行群

        [不接受的答案]
            - "都行 / 看你的 / 没想好" → 继续追问
            - "想火 / 想出圈 / 高大上 / 显得专业" → 这是结果不是目的，追问背后的具体目标
            - "做内容矩阵" / "为了内容沉淀" → 没有具体看的人就不叫沉淀，叫自嗨
            - "营销 + 品牌 + 科普" 三合一 → 砍到一个，混合的不算

    [1.2 · 目标受众]
        [覆盖意图]
            "给所有人看"等于"没人会看"。受众画像决定旁白用语、信息密度、节奏速度——
            没有这条 gate，所有表达决策都没收敛方向。

        [主问题]
            - 画一个具体的人。年龄、职业、城市、什么时候看这个视频？
            - 为什么会看？是被广告投到了？是朋友转的？是搜什么搜到的？是从哪个账号刷到的？
            - 他看过类似的内容吗？看过的话，是什么风格？看完什么感觉？

        [追问深化]
            - 用户说"年轻人"→ 你回："18 岁的实习生和 32 岁的产品经理都是年轻人，差 14 岁。挑一个。"
            - 用户说"所有人"→ 你回："所有人 = 没有人。一支视频在某个具体场景给某个具体的人看。说一个场景一个人。"
            - 用户说"懂技术的人"→ 你回："懂到什么程度？看到 transformer 不用解释？看到 attention 需要解释？说一个具体标准。"
            - 用户说"B 端客户"→ 你回："什么角色的 B 端客户？决策者(CXO)、用户(一线员工)、采购(IT)？这三种人关心的点不一样。"
            - 用户说"投资人 + 用户 + 内部团队都看"→ 你回："这三种人想看的视频是三支不同的视频。挑一个主受众，其他两个看就看不看就拉倒。"
            - 用户说"我也不知道谁会看"→ 你回："那做什么？没有目标受众的视频是给自己看的日记，不是给别人看的内容。"

        [接受标准]
            - 能说清楚一个具体画像：年龄段 / 职业 / 行业 / 看视频的场景 / 看视频前他在想什么 / 看完会有什么感觉
            - 例如：32 岁产品经理，在 SaaS 公司，刷小红书时看到的，平时被产品 PRD 编写折磨，看完想：原来 AI 能帮我写 PRD，去试试

        [不接受的答案]
            - "所有人 / 任何想了解的人" → 没有目标 = 没有视频
            - "懂行的 / 不懂行的" → 这是光谱，不是答案
            - "看个人喜好" → 那你为什么要做这支视频？

    [1.3 · 平台与时长]
        [覆盖意图]
            不同平台的硬约束(竖横屏、时长上限、静音率)完全不同。
            不先定平台和时长，所有节奏、文字大小、字幕策略都没法落地。

        [主问题]
            - 主投放平台是哪个？抖音、小红书、B 站、视频号、YouTube、Twitter/X、LinkedIn、官网首页、产品页内嵌、销售 Deck？
            - 时长上限是多少？硬上限（平台限制）和软上限（你愿意的最长时长）。
            - 比例：16:9 横屏、9:16 竖屏、1:1 方屏、其他？
            - 帧率：24 / 30 / 60？
            - 是否需要无声播放友好（用户默认静音刷，靠字幕看懂）？

        [追问深化]
            - 用户说"多平台都发"→ 你回："主战场是哪个？多平台 = 你要做横屏、竖屏、方屏三个版本，时长和叙事节奏都不一样。先挑主战场。"
            - 用户说"时长不限"→ 你回："B 站可以发 10 分钟，抖音 1 分钟就刷走了。'不限'意味着你没想清楚。给我一个上限。"
            - 用户说"看效果定"→ 你回："你的渲染参数 fps 都没定，怎么开始做？30fps 还是 60fps？60fps 渲染时间翻倍。"
            - 用户说"竖屏"→ 你回："竖屏意味着大字海报、关键词高亮、画面中央留 70% 高度避开 UI 遮挡。你接受这套约束吗？"
            - 用户说"15 秒"→ 你回："15 秒能放 4-6 个 hook 节奏的镜头，每个 2-3 秒。这是抖音爆款节奏。你的内容塞得下吗？"
            - 用户说"3 分钟左右"→ 你回："精确点。180 秒 vs 200 秒 vs 240 秒，这是三种叙事密度。挑一个。"

        [接受标准]
            - 知道：主平台 / 时长（精确到 5 秒粒度）/ 比例 / 帧率 / 是否需要无声友好
            - 例如：主投小红书，竖屏 9:16，60 秒，30fps，无声播放友好（必须有逐词字幕）

        [不接受的答案]
            - "都发 / 多平台" → 挑主战场
            - "不限 / 看效果" → 不行
            - "默认就好" → 哪个默认？平台默认还是你默认？说清楚

    [1.4 · 核心信息]
        [覆盖意图]
            防止视频做完用户说"看完不知道想说什么"——一句话 takeaway 是整片的锚点。

        [主问题]
            - 用一句话说清楚：看完这支视频，用户应该记住什么？
            - 砍到 12 字以内。多余的字都是废话。
            - 这句话是 hook 还是收尾？还是从头贯穿到尾？

        [追问深化]
            - 用户说"我们的产品很厉害"→ 你回："厉害是结果不是信息。说一个具体能力：写 PRD？改图？分析数据？说一个。"
            - 用户说"AI 让设计更简单"→ 你回："让谁的设计更简单？怎么简单？省了什么步骤？给一个对比。"
            - 用户写了 30 个字→ 你回："砍到 12 字。砍掉哪些字视频还成立？砍掉哪些字视频就垮？"
            - 用户说"我们的核心理念是 XX"→ 你回："理念是抽象的，转化成一个能被打印在 T 恤上的口号。一句话。"
            - 用户给了三句话→ 你回："三句话 = 三个视频。挑一个，另两句话出现在脚本里但不是主信息。"
            - 用户说"我没法用一句话讲完"→ 你回："讲不完意味着信息没收敛。一支视频只能传递一个核心信息，其他的都是支撑。"

        [接受标准]
            - 一句 12 字以内的核心信息
            - 这句话能被剪成大字海报的标题
            - 例如："AI 让你 10 分钟写完 PRD" / "我们重新发明了 SaaS 计费" / "设计稿一键变前端代码"

        [不接受的答案]
            - "我们的愿景是改变世界" → 太空，砍到具体
            - 超过 12 字 → 砍
            - "看完用户自己理解" → 你都不愿意写一句，凭什么用户花 60 秒看？

    [1.5 · 信息密度]
        [覆盖意图]
            节奏密度决定脚本字数、镜头数量、素材规模。
            不先定密度，后面的素材盘点和脚本编写都没参考线。

        [主问题]
            - 这支视频的节奏是哪种？
                1. **Hook 型**（0.8-2s 一刀）：抖音爆款节奏，每秒都有新信息，靠节奏拉住人
                2. **教程型**（2-5s 一刀）：解释清楚每个步骤，给观众反应时间，能跟着学
                3. **纪录型**（3-8s 一刀）：让画面呼吸，有留白，有情绪铺垫
            - 节奏密度和时长反推：60 秒 hook 型 = 30-60 个镜头；3 分钟教程型 = 36-90 个镜头。你的素材撑得住吗？

        [追问深化]
            - 用户说"快节奏"→ 你回："0.8s 一刀还是 1.5s 一刀？这是两种快。每个镜头你有内容塞进去吗？"
            - 用户说"看起来高级一点"→ 你回："高级 = 慢 + 留白 + 大字。但慢节奏要求每一帧都禁得住看。你的素材禁得住吗？"
            - 用户说"卡点剪辑"→ 你回："卡 BPM 的鼓点还是卡旁白的重音？这是两套时间码。说清楚。"
            - 用户说"中等节奏就行"→ 你回："中等是托词。说一个数字：平均每个镜头多少秒？2 秒 vs 3.5 秒 vs 5 秒，是三种感觉。"
            - 用户说"先做着看"→ 你回："节奏决定脚本字数。60 秒 hook 型只能塞 90-130 个字旁白。你脚本写完没？"

        [接受标准]
            - 选定 hook / 教程 / 纪录 中的一种主节奏
            - 知道大概的镜头时长（精确到 0.5 秒粒度）
            - 例如：hook 型 + 平均 1.5s 一镜头，60 秒视频约 40 镜头

        [不接受的答案]
            - "看着办 / 中等 / 看素材定" → 现在就定，节奏决定脚本字数
            - "再快一点 / 再慢一点" → 这是相对词，给绝对值

    [1.6 · 品牌 Tone of Voice]
        [覆盖意图]
            没有 Tone 锚点的视频，旁白和文案会显得没人格，"机器味重"。

        [主问题]
            视频的"气质"是什么？严肃 / 幽默 / 自嘲 / 权威 / 反讽 / 冷静 / 热烈？
            挑 1-2 个主导 + 1 个绝对不要的反向。

        [追问深化]
            - 用户说"专业"→ 你回："专业有很多种。是 TED 讲者那种'温和权威'，还是 Apple Keynote 那种'神圣感'，还是麦肯锡那种'数据冷静'？"
            - 用户说"幽默"→ 你回："你是想让人会心一笑，还是哈哈大笑，还是冷笑？幽默的颗粒度差别很大。"
            - 用户说"年轻有活力"→ 你回："这是结果不是 Tone。具体是抖音网感、B 站二次元、还是 Z 世代反讽？"

        [接受标准]
            能用 1-2 个具体的"参考形象"锚定 Tone（如"TED 讲者 + 一点 Karpathy 的自嘲"）

        [不接受的答案]
            - "专业 / 高大上 / 年轻 / 有活力" → 这些是结果不是 Tone
            - "看你的" → 必须用户自己定

    [1.7 · 观众熟悉度]
        [覆盖意图]
            默认懂行话的视频，给小白看就劝退；
            默认讲基础的视频，给行内看就 boring。
            必须先定 onboarding 深度。

        [主问题]
            目标观众对话题的熟悉度是什么？
            - 完全小白（要从"这是什么"开始讲）
            - 听说过但不懂细节（要从"为什么重要"开始讲）
            - 行内人（直接讲"有什么新东西"，不解释术语）

        [追问深化]
            - 用户说"普通人"→ 你回："普通人也分。地铁里刷视频的普通人 vs 产品页主动搜索的普通人，熟悉度完全不一样。"
            - 用户说"懂技术的人"→ 你回："懂到什么程度？知道 RAG 是什么吗？知道 cosine similarity 吗？知道 reranker 吗？测试用户的知识下限。"

        [接受标准]
            能说出"用户 100% 懂的术语清单 + 100% 不懂的术语清单"的边界

        [不接受的答案]
            - "都看得懂" → 不可能
            - "我猜他们应该懂" → 猜不算

    [过渡话术示例 · 聊完基本盘 → 开始聊素材]
        本段维度收完后，用承上启下口语复述要点，自然引到素材话题。
        不要用"切换到下一阶段"、"Phase 1 锁定"、"进入 Phase 2"这种话。

        ✓ "好，你这视频的基本盘我懂了——[复述目的/受众/平台/时长/核心信息中关键的几条]。现在我们看看你手头有什么素材。"
        ✓ "OK，基本盘清楚了。聊聊素材吧——你有逐字稿吗？有 BGM 吗？有视频片段吗？"
        ✓ "明白了，[一句话总结视频定位]。那我们盘一下素材，从脚本开始。"

        禁忌：
        × "Phase 1 锁定"
        × "进入 Phase 2 素材盘点"
        × "回完这两个 → Phase 2"
        × "OK 接住了，开锁下一阶段"

[Phase 2 · 素材盘点]
    逐项盘问已有素材——用户没主动提的必须挨个问，否则就是凭空捏造内容。

    [2.1 · 内容素材]
        [覆盖意图]
            脚本是视频的代码。没有逐字稿和数据来源，必然瞎编数字、瞎造案例。
            "差不多"出现在视频里就是事故。

        [主问题]
            - 旁白脚本有完整版吗？大纲？卖点列表？还是只有一个想法？
            - 视频里要出现的具体数字、数据、案例、引用 —— 都有吗？来源是什么？
            - 用户证言、客户 logo、获奖证书、媒体报道引用 —— 这些"信任锚点"素材有吗？

        [追问深化]
            - 用户说"我有大概的脚本"→ 你回："大概 = 没有。逐字稿发我，或者我们现在写。脚本是视频的代码，没有脚本你就在拼乐高没有图纸。"
            - 用户说"数字大概是 XX%"→ 你回："XX% 还是 XX.5%？数据出现在视频上一旦错了，就是事故。来源在哪？"
            - 用户说"我现场再想"→ 你回："现场想 = 你愿意接受 AI 自由发挥然后你回炉重做。要么现在写要么接受 AI 写完你审。"
            - 用户说"卖点很多"→ 你回："列出来，按优先级排序。前 3 个出现在视频里，剩下的砍掉。"
            - 用户说"我们的客户有 XX、YY、ZZ"→ 你回："有 logo 授权吗？没授权的 logo 不能放，那一帧就是法务风险。"

        [接受标准]
            - 有完整旁白逐字稿（或确认让你写脚本后人工审）
            - 视频中出现的所有数字 / 数据有来源
            - 已确认要出现的客户 logo / 案例都有使用权

        [不接受的答案]
            - "大概" / "差不多就那个意思" → 视频上不能差不多
            - "你帮我编一下" → 编可以，但你必须审，AI 编出来的数字你不审就上线是事故

    [2.2 · 音频素材]
        [覆盖意图]
            旁白来源（真人 / TTS / 无）直接决定整片制作流程和时间表。
            BGM 节奏决定剪辑卡点。不先定音频路径，所有时间码都没基准。

        [主问题]
            先告知能力："渲染端内置本地 TTS（不需要 API key、不要钱、纯本地。具体型号 / 支持声音 ID / 支持语言数 → 我去查渲染端文档或上网搜一下最新版本。)"
            然后问：
            - 旁白怎么搞？三个选项：
                1. **真人录音**（你或同事录，发我 wav/mp3）
                2. **本地 TTS**（直接走配置）
                3. **不要旁白**（纯文字 + 音乐）
            - 背景音乐打算用版权音乐（Epidemic Sound / Artlist）还是免版税（YouTube Audio Library）？还是不要？
            - 音效（whoosh、click、ding）打算放吗？

        [追问深化]
            **(a) TTS 路径**
                - 用户说"用 AI 配音"→ 你回："什么语言？具体可用的声音 ID 我去查渲染端文档（或上网拉最新列表）。选一个或我列候选给你试。"
                - 用户说"中文配音"→ 你回："本地 TTS 中文整体不如英文自然（中文 TTS 普遍如此）。介意吗？介意就考虑真人录音 + 后期混音。"
                - 用户说"用 GPT 那种 voice"→ 你回："本地 TTS 不要 API key 不要钱不发出网络请求。要做几十次迭代用本地 TTS 不心疼，要做一次但音质极致可以考虑 ElevenLabs / 类似云 TTS，但要单独接入。挑一个路线。"
                - 用户说"语速正常"→ 你回："本地 TTS 默认 1.0，教程类一般 0.7-0.8，营销类 1.1-1.2。你这支是哪种？"

            **(b) 真人录音路径**
                - 用户说"我录"→ 你回："录音环境是房间还是录音棚？房间有反响音的话需要后期降噪。"
                - 用户说"我自己录中文"→ 你回："录完发 wav 不要 mp3，无损方便调音。"
                - 用户说"找配音演员"→ 你回："已经找好了？没找好的话，从找配音到录完到交付通常 3-7 天，先确认时间够不够。"

            **(c) 背景音乐**
                - 用户说"用一首激励向的音乐"→ 你回："激励 = 多少 BPM？120 还是 140？决定剪辑卡点节奏。"
                - 用户说"你帮我选"→ 你回："我可以从 Epidemic Sound 推荐 3 首，但你要有账号能下载。有吗？没有就用 YouTube Audio Library。"
                - 用户说"不要背景音乐"→ 你回："纯人声 + 环境音也行，但要确认旁白音频本身够干净。再说一次：要有节奏感的视频，没 BGM 会显得很赤裸。"

        [接受标准]
            - 旁白路径确定：真人 / TTS（带声音 ID，具体 ID 由渲染端文档定）/ 无旁白
            - BGM 来源确定（具体歌曲或确认让你推荐）
            - 是否要音效确定

        [不接受的答案]
            - "默认就行" → 哪个默认？
            - "等我录完再说" → 那等你录完再做视频，现在先停

    [2.3 · 视频 / 影像素材]
        [覆盖意图]
            真人出镜 / B-roll / Lottie 是三类截然不同的影像素材，
            每类有不同的版权、抠像、循环规则。漏问任何一类后期都要回炉。

        [主问题]
            先告知能力："可用 u2net 本地抠像生成 VP9 alpha WebM，做'文字在人后面'这种透明叠加效果（text-behind-subject），一行命令搞定，不用绿幕。"
            然后问：
            - 有真人出镜的素材吗？（你自己讲解、客户证言、Vlog 风格、演示操作）
            - 有 B-roll 素材吗？（产品镜头、工作场景、城市、自然画面）这些是版权素材（Pexels / Pond5 / 自己拍）还是要从素材库找？
            - 有现有的 Lottie 动画文件（.json）吗？

        [追问深化]
            **(a) 真人出镜**
                - 用户说"我有一段我自己讲解的视频"→ 你回："几分钟？分辨率？需要抠像放进视频里还是直接全屏放？需要抠像的话，背景是单色（绿幕/白墙）还是杂乱场景？u2net 对杂乱场景也行但边缘可能有锯齿。"
                - 用户说"用客户证言"→ 你回："客户授权了吗？时长多少？需不需要打字幕？需要的话我们后面用 transcribe 自动生成。"
                - 用户说"我想做'文字穿过人后面'那种效果"→ 你回："OK，用 remove-background 生成两层：cutout（人物前景透明）+ plate（背景透明，人物位置挖空）。中间夹文字。原视频不能有快速移动否则边缘穿帮。介意吗？"

            **(b) B-roll**
                - 用户说"用一些科技感的素材"→ 你回："科技感是 dystopia 那种霓虹？硅谷极简？还是 NASA 控制台？三种完全不同。"
                - 用户说"我去 Pexels 找"→ 你回："找好了再说。Pexels 的素材有时和你想的差很远，先找完再敲定节奏。"
                - 用户说"我没有 B-roll"→ 你回："那这支视频就是纯文字 + 数据 + 图表了。可以做，但视觉就靠版式和动效撑。能接受吗？"

            **(c) Lottie**
                - 用户说"有 Lottie"→ 你回："几个？分别是什么动画？时长多少？要循环播放还是单次？不允许 repeat: -1，循环要算 Math.ceil(duration / cycleDuration) - 1 的次数。"
                - 用户说"没有 Lottie 但想用"→ 你回："做 Lottie 要 After Effects + Bodymovin，这是单独工作流。这次时间够吗？不够就改用 CSS/GSAP 动画。"

        [接受标准]
            - 真人出镜素材列表：文件名 / 时长 / 分辨率 / 是否抠像
            - B-roll 素材列表：来源 / 数量 / 时长 / 是否已下载
            - Lottie 文件列表：路径 / 时长 / 循环规则

        [不接受的答案]
            - "我有一些素材" → 列出来
            - "等我去找" → 找完再开工，否则就是凭空编

    [2.4 · 图形素材]
        [覆盖意图]
            插画、Logo、字体在视频里都被放大数倍，"随便用"等于"随便糊"。
            字体格式不对、Logo 没授权都会直接卡住制作。

        [主问题]
            先告知能力："不支持 .ttf 不支持 .otf，字体必须 .woff2（放 fonts/ 目录，由编译器自动嵌入）。"
            然后问：
            - 有插画素材吗？（SVG 矢量、PNG、AI / Figma 文件）有的话发我。
            - 有照片素材吗？产品照、团队照、场景照。
            - 有 Logo 吗？SVG 或高清 PNG。透明背景。
            - 有自定义字体吗？.woff2 文件。

        [追问深化]
            **(a) 插画**
                - 用户说"我有一些 SVG"→ 你回："几个？是装饰用的还是叙事用的？装饰用的（背景纹理）和叙事用的（步骤图标）处理方式不一样。"
                - 用户说"用 Notion 那种插画"→ 你回："Notion 自己的插画是版权资产不能用。如果你想要类似风格，可以用 unDraw 或 Storyset。"
                - 用户说"用 emoji"→ 你回："emoji 在不同操作系统上长得不一样，渲染时容易踩坑。建议用 SVG emoji 替代（Twemoji 是开源的）。接受吗？"

            **(b) Logo**
                - 用户说"Logo 在 PPT 里"→ 你回："PPT 里的是 PNG 还是矢量？发我 SVG 或高分辨率 PNG（≥ 1000px）。低分辨率在视频里会糊。"
                - 用户说"用客户 logo 墙"→ 你回："几个？拿了授权没？没授权的 logo 一律不能放，就算放了也得马赛克。"

            **(c) 字体**
                - 用户说"用思源黑体"→ 你回："提供 .woff2，至少含主题需要的字重（具体档位由主题定，渲染时校验）。你提供完整的吗？"
                - 用户说"我没有字体"→ 你回："等下选完主题就用主题自带字体（每个主题字体不同，预设由 HyperFrames 的 visual-styles.md 定义、自定义由项目根 design.md 定义）。除非你有强 brand 需求，否则跟主题走。"
                - 用户说"用品牌字体 XX"→ 你回："有版权吗？商用字体里很多是按席位订阅，视频用如果是分发场景需要商用许可。确认了吗？"

        [接受标准]
            - 图形素材列表：每一项都有文件路径和用途
            - 字体文件清单：.woff2 路径 + 字重列表

        [不接受的答案]
            - "等我去问设计师要" → 要到了再开工
            - "随便用一个" → 视频上每个素材都被放大 10 倍，"随便用"等于"随便糊"

    [2.5 · 3D 资产 & 特殊视觉]
        [覆盖意图]
            3D / Shader / 音频反应是"能力推销项"，用户不知道能做什么就不会主动要。
            漏问 = 视觉表达手段被人为缩减一半。

        [主问题]
            先告知能力：
            - 有 3D 模型吗？GLTF / GLB 格式可以直接用，Three.js 加载。
            - 需要 HDRI 环境贴图（让 3D 物体有真实反射）吗？
            - 想要 Three.js 程序生成的几何体（粒子系统、wireframe、变形球）吗？
            - 想要 Shader 转场（WebGL 的高级转场，比 CSS 转场更有质感）吗？
            - 想要音频反应可视化（音频频谱驱动的图形动画）吗？有现成 audio-reactive 参考支持。

        [追问深化]
            **(a) 3D**
                - 用户说"用 3D 模型"→ 你回："模型来源？Blender 导出？买的？开源（Sketchfab CC 协议）？有版权吗？"
                - 用户说"做粒子效果"→ 你回："粒子是装饰还是叙事？装饰（背景闪烁）用 Canvas 2D 就够，叙事（粒子组合成 Logo）需要 Three.js + 自定义着色器，工作量差 10 倍。"
                - 用户说"做 wireframe 风格"→ 你回："wireframe 是装饰背景还是某个 scene 的主角？如果是主角，要不要旋转？要旋转的话 RPM 多少？慢转 6 秒一圈还是快转 1 秒一圈？"

            **(b) Shader 转场**
                - 用户说"我要那种高级转场"→ 你回："Shader 转场是 GLSL 写的，有现成的 shader-transitions 包。常见的有 dissolve、warp、glitch、wave。你想要哪种感觉？粗暴爆裂 vs 柔和过渡？"
                - 用户说"看你的"→ 你回："我可以给 3 个 shader 备选，但每个 shader 是一种情绪。我给你预渲染 demo 你选。接受这种节奏吗？"

            **(c) 音频反应**
                - 用户说"要那种音乐律动的效果"→ 你回："对哪个音频做反应？BGM 还是旁白？反应在哪个元素上？字体粗细？光晕大小？卡片缩放？说一个。"
                - 用户说"看着办"→ 你回："对 BGM 节拍做反应最常见。元素是 hero 大字的 letter-spacing 或者背景圆环的半径。你接受这个默认吗？"

        [接受标准]
            - 是否需要 3D / Shader / 音频反应可视化，明确 yes/no
            - 如果 yes，每一项都有具体描述

        [不接受的答案]
            - "高级一点" / "酷一点" → 砍到具体效果
            - "看你的" → 给方案让用户选，不要替用户决定

    [2.6 · 待搜索素材]
        [覆盖意图]
            前面盘点出"没有"的素材，要么写清搜索清单要么砍掉相关 scene。
            没有这一步，制作时必然临时编关键词，搜出的素材货不对板。

        [主问题]
            前面盘点出"没有"的素材，要不要 AI 帮你搜？
            不替你下载，但会把"要搜什么、从哪搜、验收标准"写进 video-spec.md，
            渲染时知道去哪儿找。

        [告知能力]
            "免费商用素材主要从这些平台搜：
            - 视频 B-roll：Pixabay / Pexels / Mixkit / Coverr（大多 CC0）
            - 图片：Unsplash / Pexels / Pixabay
            - 音乐 BGM：Pixabay Music / YouTube Audio Library / Uppbeat
            - 音效：Freesound / Pixabay SFX / Zapsplat
            - 字体：Google Fonts / Adobe Fonts
            - 图标：Lucide / Heroicons / Feather Icons / Phosphor
            - 插画：Open Peeps / unDraw / Storyset
            - 3D 模型：Sketchfab / Poly Pizza / Quaternius
            - Lottie：LottieFiles"

        [追问深化]
            逐项追问 Phase 2 前几步用户答"没有"的素材（前缀代表"该类素材缺口"，回答均为你的追问句）：
            - 用户没 BGM → 你回："要 AI 帮你从 Pixabay Music 找一段 ___ 风格的 BGM 吗？"
            - 用户没 B-roll → 你回："要从 Pexels / Mixkit 搜 ___ 主题的素材吗？"
            - 用户没图片 → 你回："要从 Unsplash 搜 ___ 风格的图片吗？"
            - 用户没音效 → 你回："要从 Freesound 搜 ___ 类型的音效吗？"
            - 用户没插画 → 你回："要从 unDraw / Storyset 搜 ___ 风格的插画吗？"
            - 用户没图标 → 你回："默认用 Lucide 图标库（内置），还是要自定义？"
            - 用户没 3D 模型 → 你回："要从 Sketchfab / Poly Pizza 搜 ___ 模型吗？注意筛选 CC 协议。"

        [每条搜索需求要写齐 4 个字段]
            1. **源平台**（Pixabay / Pexels / Unsplash / Freesound / ...）
            2. **关键词**（具体英文/中文搜索词，你帮翻译优化）
            3. **用途**（哪个 Scene / 用作什么）
            4. **验收标准**（分辨率 / 时长 / 风格 / 协议要求）

            示例：
            ```
            - 源平台：Pixabay 视频
              关键词："coding programmer screen typing"
              用途：Scene 04 B-roll（讲"打字编程"段落）
              验收标准：≥ 1080p、≥ 8s、无水印、CC0

            - 源平台：Freesound
              关键词："whoosh transition" 或 "swoosh fast"
              用途：Scene 02 反白闪屏配音效
              验收标准：< 1s、清晰高频
            ```

        [追问要点]
            - 用户说"我自己搜" → 不写到 Script
            - 用户说"AI 找几个候选" → 写 2-3 个候选关键词到 Script
            - 用户给中文关键词 → 你翻译成更可能搜到结果的英文
            - 用户给模糊描述（"温暖的早晨"）→ 翻译为具体素材关键词（"morning sunrise warm light"）
            - 用户说"你看着办" → 不允许，必须用户拍板每条搜索需求的用途
            - 用户给"好看的图片" → 必须翻译为具体关键词 + 风格描述

        [接受标准]
            每条待搜素材都有 4 字段（源平台 / 关键词 / 用途 / 验收标准）

        [不接受的答案]
            - "随便找几个" → 必须明确用途
            - "好看的图片" → 必须翻译为具体关键词
            - "你帮我下载" → 只列清单不下载
            - 中文模糊词不翻英 → 多数素材库英文检索结果更好，必须翻译

    [过渡话术示例 · 盘完素材 → 开始聊表达手段]
        本段维度收完后，复述素材清单的关键点，自然引到表达风格话题。

        ✓ "OK 素材清单我心里有数了。我们来聊聊视觉风格——你想要什么感觉？"
        ✓ "好，素材这块清楚了。现在最关键的：这视频要让人看完什么感觉？"
        ✓ "素材盘完了——你有 [复述：什么素材] / 缺 [复述：要搜什么]。接下来聊聊节奏和呈现方式。"

        禁忌：
        × "Phase 2 接住"
        × "进入 Phase 3 表达手段激发"
        × "素材层 lock，开锁下一阶段"

[Phase 3 · 表达手段激发]
    主动推销可用能力。先告诉用户"这个能力是什么、能做什么、不能做什么"，再问"你要不要"。
    不要让用户回答自己不知道的东西。

    [3.1 · 场景类型组合]
        [覆盖意图]
            场景类型决定每个时间段的视觉语言。
            不先定组合，会拼成"什么都有但什么都不主导"的杂烩。

        [主问题]
            先告知能力："擅长以下 8 种场景类型，多选（你的视频可能 60 秒里组合 3-5 种）："

                1. **大字海报型**：屏幕大字 + 极简留白。用于 hook、收尾、强调金句。字号由主题 display 档位决定。
                2. **数据驱动型**：数字、图表、对比、增长曲线。数字对齐由主题等宽设置处理。
                3. **流程图解型**：箭头、步骤、连接线。SVG path 绘制 + GSAP 时间轴。
                4. **结构图解型**：层级、关系、架构图。用 grid + hairline 边框。
                5. **UI 演示型**：产品截图、点击轨迹、状态变化。可以是真截图或 mock 复刻。
                6. **抽象概念型**：粒子、wireframe、变形、隐喻。Three.js 或 Canvas 2D。
                7. **真人出镜型**：talking head、抠像、文字穿人后面。u2net 抠像。
                8. **3D 场景型**：3D 模型旋转、剖切、解构。Three.js + GLTF。

            你的视频里会出现哪几种？按出现顺序列。

        [追问深化]
            - 用户说"全要"→ 你回："60 秒视频里塞 8 种场景类型 = 每种 7.5 秒。这种密度只有 hook 型短视频能撑住，3 分钟视频塞 8 种会失焦。砍到 3-5 种。"
            - 用户说"主要是大字海报"→ 你回："纯大字海报视频要么很猛要么很瘟。猛是节奏快 + 字体变形 + 反白闪屏；瘟是字大但镜头不动 8 秒。你哪种？"
            - 用户说"要数据驱动"→ 你回："数据的来源准备好了？数据可视化里数字必须出现在屏幕上，不准确就是事故。"
            - 用户说"UI 演示"→ 你回："UI 用真截图还是 mock 复刻？真截图分辨率够吗？mock 复刻你提供设计稿还是用 components-catalog 拼？"
            - 用户说"抽象概念"→ 你回："抽象到什么程度？粒子飘动（装饰）vs 粒子组成数据（叙事）。"
            - 用户说"3D 场景"→ 你回："3D 是 1 个镜头还是贯穿全片？1 个镜头可以做，全片 3D 渲染时间和复杂度直线上升。"

        [接受标准]
            - 列出 3-5 个场景类型，按出现顺序排
            - 例如：[大字海报型(hook + 收尾)]→[数据驱动型]→[流程图解型]→[UI 演示型]→[大字海报型]

        [不接受的答案]
            - "全要 / 看你的 / 都可以" → 砍

    [3.2 · 文字呈现方式]
        [覆盖意图]
            字幕样式直接决定信息密度和静音可读性。
            社媒短视频不用逐词字幕，70% 静音用户看不懂在说什么。

        [主问题]
            先告知能力："字幕能力有三档（旁白时间轴决定）："

                1. **常驻字幕**：全句出现，停留几秒，下一句替换。最朴素。
                2. **关键词高亮**：全句出现，某个关键词颜色加粗或加 marker / 圈圈 / burst / scribble。
                3. **卡拉 OK 逐词**：本地 Whisper 自动生成逐词时间戳，每个词在被念到的瞬间高亮（颜色变 / 字重变 / 微缩放）。

            然后问：
            - 你要哪一档？社媒短视频几乎必选 3，教程片常选 1 或 2，纪录片常选 1。
            - 关键词强调用什么形式？marker（亮色矩形扫过）/ 手绘圈（SVG 圆圈逐渐画出）/ burst（爆炸放射线）/ scribble（涂鸦曲线下划线）/ sketchout（手绘划掉线表示否定）。
            - 还有打字机效果（字一个一个跳出来）吗？动态字重变化（字重从 400 渐变到 800 强调）吗？

        [追问深化]
            - 用户说"做小红书的"→ 你回："几乎一定要卡拉 OK 逐词字幕，因为 70% 用户静音刷。用本地 Whisper 直接生成时间戳，不要 API key。同意吗？"
            - 用户说"教程视频"→ 你回："建议常驻字幕 + 关键词高亮。每句话停留 2-4 秒，关键词用 marker（亮色矩形扫过）强调。"
            - 用户说"不要字幕"→ 你回："确定？平台默认静音播放的话，30%-70% 用户看不懂在说什么。再次确认。"
            - 用户说"想要那种打字机"→ 你回："打字机效果在每个场景持续 2-3 秒就够，太长用户会烦。你要打字机的场景是 hook、定义、还是收尾？"
            - 用户说"要 marker"→ 你回："marker 颜色用主题 accent 色（如品牌色覆盖默认），跨越关键词宽度做 sweep 动画。OK 吗？"

        [接受标准]
            - 字幕档位确定（1/2/3）
            - 如果选 2，关键词强调形式确定（marker / 圈 / burst / scribble / sketchout）
            - 是否要打字机、动态字重，明确 yes/no

        [不接受的答案]
            - "看你的字幕样式" → 字幕样式直接影响信息密度，必须用户参与
            - "都要" → 选一种主力，其他偶尔点缀

    [3.3 · 动效语言]
        [覆盖意图]
            转场密度和类型决定整片的"质感锚点"。
            不先定动效语言，每个 Scene 之间的过渡会乱拼，显得廉价。

        [主问题]
            先告知能力："支持以下转场类型——"
                1. **反白闪屏**（bg-flash 闪一帧，硅谷科技风经典）
                2. **CSS crossfade**（柔和淡入淡出）
                3. **CSS wipe**（横向 / 纵向擦除）
                4. **Shader 转场**（GLSL 着色器，dissolve / warp / glitch / wave，更有质感）

            然后问：
            - 转场密度：硬切多（节奏快，类似 MTV）/ 转场多（每个场景间都有过渡）？
            - 转场是统一一种还是混用？混用的话怎么分配？
            - 音频反应可视化要吗？（BGM 节拍驱动元素脉动 / 旁白音量驱动字体粗细）

        [追问深化]
            - 用户说"转场多"→ 你回："每个场景间都转场？60 秒视频如果 30 个场景，30 次转场，每次平均 0.4-0.8 秒，那纯转场就占 12-24 秒，剩余内容时间只有 36-48 秒。你能接受吗？"
            - 用户说"用 shader 转场"→ 你回："shader 转场单次 0.6-1.2 秒。每个 shader 是一种情绪，混用会乱。建议全片用 1 种 shader（比如 dissolve），关键节点偶尔换。"
            - 用户说"反白闪屏经典"→ 你回："反白闪屏单次 0.1-0.2 秒，是节奏性强调。一般用在 hook 进入或者大数据揭示前。频率多了眼睛累。"
            - 用户说"硬切多一些"→ 你回："硬切适合 hook 型短视频，连续硬切让节奏 punchy。但硬切之间的镜头如果同色调，会显得混乱。你的镜头色调对比够吗？"
            - 用户说"音频反应"→ 你回："对哪段音频？BGM 节拍最常见。可映射的属性：大字字距微抖 / 背景圆环脉动 / 卡片轻微缩放。你选一种作为主导，具体参数等下定。"

        [接受标准]
            - 转场密度 + 主转场类型 + 是否音频反应，全部明确
            - 例如：转场密度中等（每 4-5 个场景一次），主用 CSS crossfade，重点节点用 shader dissolve，反白闪屏用在 2 处大数据揭示

        [不接受的答案]
            - "酷一点 / 高级一点" → 给具体转场名
            - "看你的" → 给 2-3 个方案让用户选

    [3.4 · 节奏基准]
        [覆盖意图]
            节奏档位的具体参数（镜头数 / 字数）在 Phase 1.5 之后再精确化一遍，
            避免脚本字数和素材数对不上时长。

        [主问题]
            先告知能力："节奏决定脚本字数和镜头数量。推荐三档："

                1. **Hook 型**：每个镜头 0.8-2 秒。60 秒视频 ≈ 30-60 镜头。中文旁白约 90-130 字。
                2. **中等**：每个镜头 2-5 秒。3 分钟视频 ≈ 36-90 镜头。中文旁白约 400-550 字。
                3. **慢节奏**：每个镜头 3-8 秒。3 分钟视频 ≈ 22-60 镜头。中文旁白约 280-450 字。

            然后问：
            - 你选哪一档？和前面说的信息密度保持一致。
            - 钉一个目标镜头数量。
            - 钉一个目标旁白字数。

        [追问深化]
            - 用户说"节奏快但不要太快"→ 你回："1.5 秒一镜头还是 2.5 秒一镜头？这是两种节奏。1.5 秒 = hook 型，2.5 秒 = 中等。挑一个。"
            - 用户说"hook 型"→ 你回："60 秒视频里你要塞多少信息？hook 型每镜头只能传 1 个信息点。60 秒 = 40 个镜头 = 40 个信息点。你的脚本有 40 个信息点吗？"
            - 用户说"按音乐节奏剪"→ 你回："音乐 BPM 多少？120 BPM = 每拍 0.5 秒，每两拍 1 秒，每四拍 2 秒。你卡哪个？四拍 = 2 秒一刀，是中等节奏。"
            - 用户说"开头快后面慢"→ 你回："前 15 秒 hook 型，15 秒后转中等？这种结构常见但要保证转点自然。转点设计了吗？"
            - 用户说"快慢交替"→ 你回："怎么交替？2 快 1 慢 vs 3 快 2 慢？规律不清的话感觉会乱。"

        [接受标准]
            - 节奏档位确定
            - 目标镜头数量精确到 5 镜头粒度
            - 目标旁白字数精确到 50 字粒度

        [不接受的答案]
            - "看素材定" → 节奏决定素材怎么剪，必须先定
            - "灵活一点" → 灵活 = 没想清楚

    [3.5 · 叙事节拍设计]
        [覆盖意图]
            没有节拍设计的视频是"线性平铺"，留不住观众。
            必须明确 hook / 转折 / 高潮 / cta 的位置。

        [主问题]
            视频的节拍设计：
            - hook 在第几秒？抛什么钩子？
            - 有没有"屏息时刻"（让观众喘一口气）？
            - 高潮 / 反转 / 揭晓在哪里？
            - CTA 收在哪里？

        [追问深化]
            - 用户说"开头直接讲"→ 你回："讲什么？数据冲击、反问、悬念、自嘲，四种 hook 路线，挑一个。"
            - 用户说"没想过节拍"→ 你回："用前面说的信息密度反推——hook 型必须有钩子，纪录型可以平铺。你是哪种？"
            - 用户说"全程高潮"→ 你回："全程高潮就是没高潮。挑 1-2 个真正的爆点。"

        [接受标准]
            画得出节拍曲线（X 轴时间 / Y 轴情绪强度）

        [不接受的答案]
            - "顺其自然" → 视频不是日记
            - "全程紧凑" → 这是密度不是节拍

    [3.6 · 情绪曲线]
        [覆盖意图]
            情绪没有起伏的视频是"平的"，看完没记忆点。
            每个 Scene 都要服务于情绪曲线的某个位置。

        [主问题]
            视频开头 / 中段 / 收尾，分别想让观众产生什么情绪？
            起伏方向是什么？（平→爆 / 爆→冷 / 冷→暖 / 暖→反思）

        [追问深化]
            - 用户说"看完觉得我们牛逼"→ 你回："这是结论不是情绪。是震撼？敬意？信任？兴奋？挑一个具体情绪。"
            - 用户说"没想过"→ 你回："反推一下——如果删掉某个 Scene，情绪曲线断在哪？用这个找每个 Scene 的情绪职责。"

        [接受标准]
            能用 3 个情绪词分别描述开头 / 中段 / 收尾（如"好奇 → 震撼 → 行动欲"）

        [不接受的答案]
            - "都行" → 情绪是设计不是偶然
            - "看完觉得值" → "值"不是情绪

    [3.7 · 音画关系]
        [覆盖意图]
            BGM 和画面同步 vs 错位，是两种完全不同的视频语法。
            默认同步会显得乏味（看到 X 听到 X），错位会显得高级。

        [主问题]
            - BGM 是叙事性（推动情节进度）还是氛围性（衬托情绪）？
            - 旁白节奏和画面节奏同步还是错开？
            - 是否要"音画同步爆点"（鼓点+反白闪屏这种 hard cut）？

        [追问深化]
            - 用户说"BGM 跟着画面走"→ 你回："跟着画面走就是从属，BGM 没存在感。要不要让 BGM 独立成线？"
            - 用户说"不知道音画关系"→ 你回："给三个反例自己挑——看到爆炸+听到爆炸 = 廉价；看到爆炸+听到悠扬钢琴 = 高级；看到平静+听到鼓点 = 紧张。你想要哪种？"

        [接受标准]
            能说出至少 1 处"音画错位"的设计点（或明确选择全程同步）

        [不接受的答案]
            - "BGM 配上就行" → 这是后期不是设计
            - "随便" → 音画关系决定视频质感

    [过渡话术示例 · 聊完表达手段 → 选视觉主题]
        本段维度收完后，复述节奏/字幕/转场的关键决定，自然引到主题选择。

        ✓ "节奏和呈现方式都定了。最后挑个主题——8 个 HF 预设里选，或者你自己上传？"
        ✓ "OK 表达手段这块清楚了——[复述：节奏几秒一刀 / 字幕哪一档 / 转场什么风格]。下一个事儿是视觉主题，我有 8 个预设你看看。"
        ✓ "好，节奏感和动效语言我心里有谱了。现在挑主题——按你的内容方向我可以先推 2-3 个候选。"

        禁忌：
        × "Phase 3 锁定，Phase 4 视觉微调"
        × "表达层 gate 通过，进入主题选择"

[Phase 4 · 视觉主题选定 + 微调]
    [使用顺序]
        先 4.1 主题选择 → 后 4.2/4.3/4.4 微调

    [4.1 · 主题选择]
        [覆盖意图]
            主题是 token 锁定的入口。不先选定主题，
            后面任何字号 / 间距 / 配色调整都没基准。

        [主问题]
            视频要长什么样？两条路任选：

            路径 1：8 个 HyperFrames 预设里挑一个
            路径 2：自己的自定义主题 —— 项目根目录的一个 design.md

        [路径 1 · 8 预设速览]
            - Swiss Pulse · 极简瑞士排版（适合：数据冷静、工程图味）
            - Velvet Standard · 高端编辑风（适合：文化内容、杂志感）
            - Deconstructed · 工业解构（适合：音乐艺术、实验性）
            - Maximalist Type · 排版炸街（适合：快消、零售、时尚）
            - Data Drift · 未来感数据艺术（适合：科技演示、AI 内容）
            - Soft Signal · 温暖手作（适合：情绪驱动、人文）
            - Folk Frequency · 民艺活泼（适合：多彩文化、年轻群体）
            - Shadow Cut · 黑色电影暗色锐利（适合：科幻、悬疑、严肃）

        [路径 2 · 自定义主题]
            落地位置：项目根目录的 `design.md`（HyperFrames 渲染端唯一读取的主题文件，
            路径基准 = video-spec.md 所在目录）。不再有 styles/ 文件夹。

            两种入口：
            (a) 已有设计文件 → 用户把自己的 design.md（HyperFrames YAML 格式）放项目根 / 粘贴聊天
            (b) 只有感觉没有具体值 → 用户描述给你（三个形容词/参考链接/类似品牌），
                你上网调研后给 2-3 个候选方案，定稿后在项目根生成 design.md

        [追问深化]
            - 用户说"预设但不知道选哪个"→ 你回："你视频的内容是什么类型？我根据前面说的目的帮你匹配最贴的 2-3 个。"
            - 用户说"自定义"→ 你回："已经有设计好的文件了吗？有就上传 / 粘贴；没有就描述三个形容词 + 给参考链接，我上网搜搜后出 2-3 个候选方案。"
            - 用户说"随便"→ 你回："这不是答案。给三个最常用的预设三选一：Swiss Pulse（数据冷静）/ Data Drift（科技演示）/ Shadow Cut（严肃科幻）。挑一个。"

        [接受标准]
            用户给出明确的 theme 选择，能写到 video-spec.md 的 theme 字段

        [不接受的答案]
            - "随便 / 都行 / 你看着办" → 必须用户拍板
            - "想要高大上 / 炫酷 / 有质感" → 形容词不算答案
            - "和 XX 一样" → 不指明哪个具体决定，需追问到具体 hex / 字体名

    [4.2 · accent 色覆盖]
        [覆盖意图]
            accent 色是品牌识别度的核心 token。
            不明确"保留主题默认 / 改为品牌色"，视频会被默认值"通用化"掉品牌特征。

        [主问题]
            主题里的 accent 用默认，还是换成你的品牌色？

        [追问深化]
            - 用户说"换"→ 你回："给我 hex 值。'品牌橙' / '深蓝色' 不接受。"
            - 用户说"默认"→ 记下"用主题默认 accent"，不再追问
            - 用户说"不知道"→ 你回："发 logo 链接，我帮你提取主色给你确认。"

        [接受标准]
            明确决定保持 / 覆盖；覆盖时有具体 hex 值

        [不接受的答案]
            - "差不多颜色就行" → 必须给 hex
            - "和 logo 一样" → 必须用户发 logo 让你取色

    [4.3 · 装饰层密度]
        [覆盖意图]
            装饰过多盖过信息，装饰过少显得空。
            必须明确档位，否则会按个人审美自由发挥。

        [主问题]
            装饰量：纯净 / 中等 / 强？
            - 纯净 = 只用主题原生装饰
            - 中等 = 加 hairline / cross / 角标
            - 强 = 加 dot-pulse / scan-lines / 多层装饰

        [追问深化]
            - 用户说"看着办"→ 你回："默认中等。如果你的视频信息密度大（数据型/教程型），建议纯净；如果视频偏氛围（hook 型 / 品牌片），可以中等到强。"
            - 用户说"越多越好"→ 你回："装饰过多会盖过信息密度，看完观众记住装饰记不住内容。除非你做品牌氛围片，否则建议中等。"

        [接受标准]
            三档之一明确

        [不接受的答案]
            - "好看就行" → 给三档让用户选
            - "你决定" → 给推荐 + 让用户拍板

    [4.4 · 组件白名单 / 黑名单]
        [覆盖意图]
            黑白名单是"风险隔离"机制——某些组件用户明确不要（如图表 / 卡通插画），
            提前写进 spec 可以避免误用。

        [主问题]
            看过 components-catalog.md 后，有想用的 / 一定不要的组件吗？

        [追问深化]
            - 用户说"没看过 catalog"→ 你回："先扫 3 个核心分类（aroll / broll-hero / broll-charts），10 分钟看完。"
            - 用户说"全都行"→ 默认白黑名单都为空 = 全开
            - 用户说"不要图表"→ 你回："黑名单加 broll-charts.*，确认。"

        [接受标准]
            白名单 / 黑名单明确（可以都为空 = 全开）

        [不接受的答案]
            - "我不知道有哪些组件" → 让用户先扫一眼 catalog，不允许跳过

    [过渡话术示例 · 主题定了 → 聊参考与反例]
        本段维度收完后，复述主题选择，自然引到参考视频/反例话题。

        ✓ "OK 主题挑好了。最后一步——你有看过类似的视频参考吗？或者哪种风格是绝对不要的？"
        ✓ "好，[复述：主题名 + accent 色 + 装饰档位] 都定了。剩最后一件事：发我 1-2 个参考视频，再说说哪种感觉你最讨厌。"

        禁忌：
        × "Phase 4 完成，进入 Phase 5"
        × "主题层 lock，开锁参考层"

[Phase 5 · 参考与反例]
    Phase 5 是用具体作品定调，比抽象描述精确 10 倍。

    [5.1 · 参考视频]
        [覆盖意图]
            没有参考 = 你和用户脑子里各想各的。
            参考视频是"对齐期待"的最高效方式。

        [主问题]
            - 发链接：YouTube、Vimeo、B 站、抖音、小红书、Apple 发布会片段、Stripe 官网视频、Linear 发布视频，任何具体作品。
            - 这支视频和参考"9 分像 1 分不一样"，那 1 分不一样的是什么？

        [追问深化]
            - 用户发了链接但说"全都像"→ 你回："全都像 = 抄。你这支视频凭什么独立存在？至少给一个差异化的点。"
            - 用户说"像 Apple 那种"→ 你回："Apple 的哪一支？iPhone 发布会的产品镜头？AirPods Max 的 motion graphics？M 系列芯片的剖切动画？这是三种风格，挑一个。"
            - 用户说"像 Linear / Stripe 那种产品视频"→ 你回："Linear 和 Stripe 的视频风格不一样。Linear 是产品截图 + 慢镜头 + 极简文字；Stripe 是数据可视化 + 流畅过渡。挑一个。"
            - 用户没参考→ 你回："没参考 = 你的脑子里有一个想象但没法对齐。强制找一个，哪怕不完全像。否则你和 AI 都在猜对方想要什么。"
            - 用户发了 5 个参考→ 你回："5 个参考之间冲突吗？把它们贴在一起看一下，矛盾的地方你选哪个？"

        [接受标准]
            - 至少 1 个参考视频 + 1 个差异化点
            - 例如："像 Linear 发布视频，但我们配音是中文 + 数据更多 + 节奏更快"

        [不接受的答案]
            - "我脑子里有个画面但没找到参考" → 强制找一个
            - "都不像 / 全新的风格" → 全新 = 没基准 = 风险拉满

    [5.2 · 静态参考]
        [覆盖意图]
            静态参考补充视频参考无法对齐的视觉细节（版式 / 字体 / 装饰）。
            少了这一层，主题 token 微调就靠"感觉"。

        [主问题]
            - 海报、Behance / Dribbble 作品、产品页截图、PPT 一页、杂志版式 —— 任何静态视觉参考。
            - 哪一点想要：版式？颜色？字体？装饰？层次感？

        [追问深化]
            - 用户发了 Behance 链接→ 你回："里面 12 张图，你看的是哪一张？发图不是发链接。"
            - 用户说"参考 Linear 官网首页"→ 你回："首页的 hero 区？feature 区？还是 pricing 区？截图发我。"
            - 用户说"杂志感"→ 你回："什么杂志？Apartamento（极简版式）vs Wired（信息密集）vs Kinfolk（留白多）。三种完全不一样。"
            - 用户说"产品页好看的就行"→ 你回："Linear / Stripe / Vercel / Resend / Cursor / Raycast，这些都是产品页好看的，但风格各异。挑一个。"

        [接受标准]
            - 至少 1-3 张具体参考图（图，不是链接）
            - 明确说出参考的具体点（版式 / 颜色 / 字体 / 装饰 / 层次）

        [不接受的答案]
            - 只发链接不发图 → 让用户截图
            - "都好看" → 这不是答案

    [5.3 · 反例]
        [覆盖意图]
            反例是"边界 fence"。用户没态度，就会按平均审美自由发挥，
            结果做出一个"标准但平庸"的视频。

        [主问题]
            - 讨厌的类似视频是什么？讨厌的具体点？
            - 反向要求：绝对不能出现的元素 / 风格 / 表达方式。
            - 哪个友商的视频你最不想被对比？

        [追问深化]
            - 用户说"不要太花哨"→ 你回："花哨 = ？粒子？转场密？颜色多？emoji？给一个具体反例。"
            - 用户说"不要看起来 cheap"→ 你回："cheap 的标志是什么？Times New Roman 字体？emoji？模板感动效？低分辨率截图？"
            - 用户说"不要像友商 XX"→ 你回："友商 XX 的视频你具体讨厌哪个点？版式？颜色？节奏？模仿？避开模仿那一点就行。"
            - 用户说"没什么不想要的"→ 你回："那你就是没态度。强制找一个反例：你刷到什么样的视频会立刻划走？"
            - 用户说"不要 AI 味"→ 你回："AI 味 = 什么？模板化转场？无意义的粒子飘动？过度精致的渐变？说一个。"

        [接受标准]
            - 至少 1 个反例 + 至少 3 条"绝对不要"清单
            - 例如："讨厌国内 SaaS 厂商视频里那种渐变 + 3D 图标 + 卡通插画的组合 / 不要用 emoji / 不要圆角太大 / 不要插画风格"

        [不接受的答案]
            - "都行 / 没什么不要的" → 没态度 = 自由发挥 = 你回炉重做风险拉满

    [5.4 · 同质化反例]
        [覆盖意图]
            每个赛道都有"做烂了"的视觉套路。
            如果不主动避开，新视频会立刻被观众归类到"又一个 XX 类视频"。

        [主问题]
            同类视频做烂了什么套路？哪些视觉 / 叙事 / 节奏要主动避开？

        [追问深化]
            - 用户说"不知道做烂了什么"→ 你回："列 3 个同类视频发我，我帮你分析公共套路。"
            - 用户说"我的视频不一样"→ 你回："不一样在哪里？具体到视觉 / 叙事 / 节奏 / 音乐。"
            - 用户说"反正不要俗气的"→ 你回："俗气不是反例。具体——'不要黑红配色 / 不要倒计时 / 不要男低音 voiceover'。给三条。"

        [接受标准]
            至少 3 个具体的"不要 XX"清单（视觉 / 叙事 / 节奏 / 音乐各一个）

        [不接受的答案]
            - "不要俗气" → 不具体
            - "做出新意就行" → 结果不是反例

    [过渡话术示例 · 所有维度收完 → 开始拆镜头]
        所有维度都聊完了，自然引到下一步动作（拆镜头 / 输出草稿）。

        ✓ "前面这些足够我开始拆镜头了。我先按你的逐字稿/大纲切成几个 Scene，然后给你看草稿。"
        ✓ "OK，我有足够的料了，现在开始拆镜头，稍等。"
        ✓ "好，[一句话总结整片定位 + 主题 + 节奏]。我去拆 Scene，拆完发你审。"

        禁忌：
        × "Phase 5 完成，进入输出阶段"
        × "[接受标准] 全部 gate 通过，开始生成"
        × "全部 Phase 接住了"

[追问纪律 · 8 条]

    1. 不凭印象瞎问 —— 问之前对照 [覆盖意图] 校准
    2. 不和气接受敷衍 —— 用户答"高大上 / 都行 / 随便"时翻 [不接受的答案] 驳回
    3. 不自我满足提前停 —— 对照 [接受标准] 检查 gate
    4. 不编造用户没说的内容 —— 推断 / 假设的内容标 [待用户确认]
    5. 能力告知先于追问 —— 问能力前先解释能做什么，让用户在知情前提下选
    6. 主题选定后不重复问 token —— 选定后字体/字重/字号锁定
    7. 素材逐项盘问 —— Phase 2 不能漏报
    8. 每 Phase 闭环复述 —— Phase 结尾把答案复述给用户确认
CODEX_LAZYPACK_1D79B36EF3D4E3D404CCADD5595972781DC99825

# video-spec-builder/references/scene-breakdown.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/video-spec-builder/references/scene-breakdown.md")"
cat > "{{CODEX_HOME}}/skills/video-spec-builder/references/scene-breakdown.md" <<'CODEX_LAZYPACK_49787C70564F52EB1D88FA3F5C9F69D419970239'
---
name: scene-breakdown
description: 逐字稿 / 卖点列表 → 分镜表的拆解方法论。
---

# 分镜拆解方法论

[使用时机]
    - 0-1 模式 Phase 1-5 都问完后，进入分镜起草阶段
    - 迭代模式加新场景 / 大段重排时

[核心理念]
    分镜 = 把脚本翻译成可执行的画面 + 动效，不是切段落。
    每个 Scene 必须回答 4 个问题：
    1. 信息载荷 —— 这一镜让观众 get 到什么？
    2. 组件 ID —— 用 components-catalog 哪个组件承载？
    3. 时长 —— 几秒？
    4. 转场 —— 怎么进、怎么出？

---

## [输入]

[输入形态]

    1. 逐字稿（最理想）
        已有完整旁白文本，按句号 / 语意单元切分

    2. 卖点列表
        3-7 个要点，每点要单独镜头表达

    3. 大纲
        三幕结构（开-中-收），每幕有粗略要点

    4. 都没有
        基于核心信息 + 受众 + 时长，你写草稿（前置：Phase 1 五维度齐全）

[输入校验]
    每种输入都必须能回答：
    - 总时长（来自 Phase 1）
    - 信息密度档位（hook / 教程 / 纪录）
    - 核心信息（≤ 12 字）
    - 叙事结构（来自 Phase 3.5 / 3.6 / 3.7）：
      节拍曲线 + 情绪曲线 + 音画关系 + 同质化反例
      → 拆分镜前必须先读 video-spec.md 的 [叙事结构] 章节
      → 每个 Scene 都要落到节拍曲线的某一段

---

## [六步法]

### [一、内容分割]

    [逐字稿]
        1. 按句号断句 → 候选镜头列表
        2. 合并连续短句（< 8 字）→ 节奏镜头
            例："来。看这个。这就是答案。" → 合并为 1 镜，但保留 3 段动效层级
        3. 长句（> 30 字）拆成多镜头
            拆分点：连词（但是 / 因为 / 所以）/ 转折标记 / 数据出现处
        4. 排比句 / 列举句 → 每项独立镜头（视觉上做"序列感"）

    [卖点列表]
        每个卖点拆成：
        - 1 个核心镜头（陈述卖点）
        - 0-2 个支撑镜头（证据 / 数据 / 演示）
        - 总数控制：3-7 个卖点 × 平均 2 镜 = 6-14 个 Scene

    [大纲]
        三段分配：
        - 开（hook）：1-3 镜头，占 15-20%（30s 视频 → 5-6s 内 / 60s → 10-12s 内）
        - 中（核心）：5-15 镜头，占 60-70%（主要信息密度区，节奏快-慢交替）
        - 收（cta / 收束）：1-2 镜头，占 10-15%（收束核心信息 + 可选 CTA）

    [都没有]
        你根据 Phase 1 五维度起草大纲：
        - 推算镜头总数（按节奏类型 × 总时长 → 大致镜头数）
        - 起草大纲三段
        - 必须让用户确认大纲再继续拆细
        - 不要从零跳到逐字稿——中间要有大纲校准

### [二、节奏分配]

    [按节奏类型分配时长基准]

        - hook 型（每镜 0.8-2s 主，关键镜头 2-3s）
        - 教程型（每镜 2-5s 主，关键解释 5-7s）
        - 纪录型（每镜 3-8s 主，强调镜头 6-10s）

        详细分配见 pacing-rules.md。

    [总时长校验]
        - 所有镜头时长 + 转场时长（粗略） ≈ 用户设定的总时长
        - 转场粗估 0.2-0.5s/转场（精确值后续渲染时定）
        - 误差 ±0.5s 以内允许

    [节奏曲线纪律]
        - 不允许"全片均速"——会让观众疲劳
        - 推荐节奏曲线：快-快-慢-快-慢-慢-快收尾
        - 关键信息镜头前一镜可以加快（制造对比，凸显关键镜头的"停顿感"）

### [三、镜头打标]

    [标签集合（一镜可多标签）]

        - `[hook]` 抓注意力（开头 / 大转折 / 反差冲击）
        - `[data]` 数据 / 统计 / 排名
        - `[concept]` 概念 / 定义 / 抽象阐释
        - `[emotion]` 情绪 / 价值观 / 故事感
        - `[demo]` 演示 / 操作 / 产品功能
        - `[versus]` 对比 / 反差 / A vs B
        - `[structure]` 结构 / 层级 / 分类
        - `[flow]` 流程 / 步骤 / 序列
        - `[cta]` 行动召唤 / 引导动作
        - `[bridge]` 过渡 / 桥接（不承载主信息，但连接两段）
        - `[summary]` 总结 / 收束 / 重申核心信息

    [打标纪律]
        - 每个 Scene 至少 1 个主标签 + 0-2 个副标签
        - `[bridge]` 占比 ≤ 15%（桥接太多会稀释信息密度）
        - `[hook]` 标签的镜头必须落在视频开头 3s 内（至少 1 个）
        - 一个 Scene 同时具备 `[data] + [concept]` → 警告"信息复合度高，注意信息过载"

### [四、组件匹配]

    [按标签 + 内容性质从 components-catalog 选组件]

    | 标签 | 优先匹配 |
    |------|---------|
    | hook | broll-hero.big-type / broll-hero.inversion-flash / aroll.subtitle-highlight |
    | data | broll-charts.* / broll-hero.big-number |
    | concept | broll-abstract.* / aroll.concept-card |
    | emotion | broll-hero.pull-quote |
    | demo | broll-ui.* / 真人 + aroll |
    | versus | broll-abstract.versus / broll-abstract.spectrum |
    | structure | broll-structure.* / broll-structures2.* |
    | flow | broll-flows.* |
    | cta | broll-hero.big-type |
    | bridge | broll-hero.inversion-flash（注意 ≤2 次）|
    | summary | broll-hero.pull-quote / aroll.subtitle-highlight |

    [组件匹配纪律]
        - 不允许"自创组件"——必须落到 components-catalog 已有 ID
        - 某 Scene 没有合适组件 → 重写文案 / 改标签，不要发明组件
        - 同一组件全片用 ≥ 4 次 → 警告"视觉单调"
        - 同一类组件（如 broll-charts.*）用 ≥ 5 次 → 警告"图表过密集"

    [详细清单]
        见 components-catalog.md（含每个组件的适用场景 / 何时不用 / 内容期待）。

### [五、转场决策]

    每个 Scene 都要明确"转场进入"和"转场离开"，只写类型，不写参数。
    不允许 jump cut。

    转场类型（4 种粗粒度）：
    - 硬切（hard cut）—— 默认，瞬间切换
    - 软切（crossfade）—— 柔和过渡
    - 反白闪屏 —— 硬规则：≤ 2 次/视频，间隔 ≥ 8s
    - shader 转场 —— 仅写"shader 转场"，具体效果后续选

    具体 ease / duration / shader ID 由视觉富化阶段决定。

### [六、素材绑定]

    [每镜必须绑定的素材]

        - 旁白文案
            - 从逐字稿对应段落抽取
            - 如无逐字稿，你根据 Scene 主题 + 屏显文案补
            - 用 TTS → 在素材依赖里标 "voice/scene-XX.mp3"

        - 屏显文案
            - 旁白的关键词（不是全文！）
            - 12 字以内的核心句
            - 高亮词单独标记

        - 素材依赖
            标注需要的：图片（路径）/ 视频（路径 + 时长 + 起始偏移）/
            数据文件（data.json）/ Lottie / 3D 模型（路径 + camera 参数）/ 非默认字体

        - 缺素材的镜头
            标记 `[待补充素材]` + 退化方案
            例：`[待补充素材] 真人产品演示视频；退化方案：用 broll-ui.browser 模拟产品界面`

    [素材绑定纪律]
        - 不允许"过度乐观"——没素材就标待补充，不要默认你能生成
        - 素材路径用相对路径（./assets/xxx）
        - 同一素材在多 Scene 复用 → 明确标注 "复用自 Scene XX"

---

## [输出格式]

[每镜必填字段]
    严格对齐 templates/video-spec-template.md「Script · 分镜表」节的字段，顺序不变：

    标题行：Scene NN · [start]s – [end]s · [节拍标签，如 hook / 反差 / 数据 / 高潮 / CTA]

    11 个内容字段：
        1.  类型（A-roll / B-roll / 转场）
        2.  组件（来自 components-catalog.md 的真实 ID）
        3.  旁白文案（完整原文 / —）
        4.  屏显文案（屏幕显示的文字 / —）
        5.  期待内容（本镜传达的内容 / 数据 / 概念 / 情绪）
        6.  期待效果（观众应该产生的反应：震撼 / 理解 / 记住 / 笑 / 共鸣）
        7.  画面描述（镜头里有什么、布局、是否 3D、关键视觉要素）
        8.  动效要点（动词级，如 SLAMS / CASCADE / floats）
        9.  音效描述（无音效写「无」；有写具体类型 + 时间点）
        10. 转场进入 + 转场离开（类型级：硬切 / crossfade / shader / 反白闪屏）
        11. 素材依赖（narration.wav 段 / bgm.mp3 / 待搜索 X / 已有素材 Y）

[Scene 排版]

```
Scene XX  [start-end / duration]  · [节拍标签]
├─ 类型：A-roll / B-roll / 转场
├─ 组件 ID：broll-hero.big-number
├─ 旁白文案：…
├─ 屏显文案：…（含高亮词标记）
├─ [期待内容]：本镜要传达的具体内容（数据/概念/情绪/动作）
├─ [期待效果]：本镜应该让观众产生什么反应（震撼/理解/记住/笑/共鸣）
├─ 画面描述：（画面构成 / 布局 / 是否 3D / 装饰层）
├─ 动效要点：（关键入场 / 出场 / 内部动效，动词级）
├─ 音效描述：（无 / 具体类型 + 时间点，如「3.0s · 短促 click，volume 0.3」）
├─ 转场进入 ← / 转场离开 →
└─ 素材依赖：（路径 / [待补充素材]）
```

[期待内容] 和 [期待效果] 是产品需求——渲染时按这两个字段调整视觉强度、节奏、装饰层。
[音效描述] 字段不能省，无音效也要明写「无」，避免输出时被遗漏。

[动效要点]
    只写动词级别（choreography verbs），不写具体动效参数。
    常用动词：SLAMS / CASCADE / FLOATS / WHIPS / DISSOLVES / PULSES / SPIRALS / SCRATCHES。

    合格："title SLAMS 入场 + subtitle CASCADE 错峰"
    反例："y 30→0, 700ms ease power3.out"（这是视觉富化的活儿）

    具体 ease / duration / 物理参数后续富化时再写。

---

## [自检清单]

[输出后逐项检查]

```
□ 每个 Scene 都锚定到 components-catalog 里的组件 ID（没有自创）
□ 总时长 = 所有 Scene 时长 + 转场时长（误差 ±0.5s 以内）
□ 反白闪屏 ≤ 2 次（全片硬上限）
□ Shader 转场使用频率 ≤ 1/3 Scene
□ 每 Scene 都明确写出转场进入和离开
□ 没有 jump cut（无转场切换）
□ A-roll 字幕高亮的镜头有完整的旁白文本
□ 数据图表 Scene 标注了数据来源（data.json 或 inline）
□ 用了真人出镜组件的 Scene 标注了视频路径和是否需要抠像
□ 每个组件的"何时不用"原则没被违反（参考 components-catalog）
□ hook 镜头落在视频开头 3s 内
□ 同一组件全片使用 ≤ 4 次（视觉变化保证）
□ [bridge] 标签镜头占比 ≤ 15%
□ 节奏曲线不是均速（有快慢对比）
□ 收尾镜头有明确的结束方式（淡出 / 静帧 / CTA 停留）
□ 缺素材的 Scene 标了 [待补充素材] 和退化方案
□ 旁白文案的总字数与总时长匹配（按 3-4 字/秒估算）
□ 所有屏显文案 ≤ 12 字（hero 句）或 ≤ 8 字（关键词）
□ 每个 Scene 都有信息载荷（不存在空帧）
□ 每个 Scene 都明确写了 [期待内容]（要传达的具体信息）
□ 每个 Scene 都明确写了 [期待效果]（观众应该产生的反应）
□ 每个 Scene 都明确写了 [画面描述]（含布局 + 是否 3D）
□ 每个 Scene 都明确写了 [音效描述]（无音效就写「无」，不能省）
□ 动效要点只写动词级（SLAMS / CASCADE / FLOATS 等），不写 GSAP 参数
□ 转场字段只写类型（硬切 / 软切 / 反白闪屏 / shader），不写 duration / ease
```

---

## [示例]

[输入]
    项目类型：科普视频
    平台：YouTube / 30s / 16:9 / 30fps
    受众：3-5 年经验的 AI 工程师
    核心信息：模型是 compiler，不是 oracle
    信息密度：教程型（信息中等密度，留消化时间）
    场景组合：[大字海报型 + 数据驱动型 + 抽象概念型 + UI 演示型]
    装饰层：hairline grid + 四角十字
    Accent 色：#FF6B3D（默认）

[逐字稿（30 秒）]

    > "让我们聊聊上下文工程。它不是提示词魔法。模型不缺聪明，缺材料。RAG 在'纯背诵'和'纯检索'之间偏向后者。87% 的开发者认为提示工程会被上下文工程取代。结论：模型是 compiler，不是 oracle。"

[8 Scene 完整拆解]

```
─────────────────────────────────────────
Scene 01  [0.0s - 2.5s / 2.5s]  · [hook] [concept]
├─ 类型：B-roll
├─ 组件 ID：broll-hero.big-type
├─ 旁白文案：让我们聊聊上下文工程。
├─ 屏显文案：上下文工程
│   高亮词：「上下文工程」作为整句的 hero 强调
├─ [期待内容]：抛出视频核心主题词"上下文工程"
├─ [期待效果]：观众听到主题词 → 想知道它和"提示词"有什么不一样 → 愿意看下去
├─ 画面描述：主题主色背景，hero 大字居中。
│   accent 色细线作为左下装饰。
│   四角十字 cross 默认装饰层。
│   16:9 横屏，无 3D。
├─ 动效要点：
│   - hero 大字 SLAMS 入场
│   - accent 底线 WHIPS 横扫
│   - 整体 holds 静帧收尾
├─ 音效描述：无（让旁白单独承担开场）
├─ 转场进入 ← 视频起始（无前一镜，纯入场）
├─ 转场离开 → 硬切
└─ 素材依赖：无（纯组件渲染）
                                                          
─────────────────────────────────────────
Scene 02  [2.5s - 5.5s / 3.0s]  · [concept] [versus]
├─ 类型：B-roll
├─ 组件 ID：broll-abstract.versus
├─ 旁白文案：它不是提示词魔法。
├─ 屏显文案：左侧「提示词魔法」（划掉）  vs  右侧「材料工程」
│   高亮词：「提示词魔法」加 sketchout 划掉效果
├─ [期待内容]：建立"否定旧认知 vs 引入新框架"的对比 —— 上下文工程 ≠ 提示词魔法
├─ [期待效果]：观众原有认知被打破 → 产生"那它到底是什么"的好奇 → 进入接收新概念的状态
├─ 画面描述：
│   - 左右二分布局，左 50% 右 50%
│   - 左侧灰阶弱化放"提示词魔法"标签
│   - 右侧 accent 色高亮放"材料工程"标签
│   - 中间用 hairline 竖线分隔
│   - 16:9 横屏，无 3D
├─ 动效要点：
│   - 左右两侧 SLIDES 对冲入场（左从左、右从右）
│   - "提示词魔法" SCRATCHES 划掉
│   - "材料工程" PULSES 高亮
├─ 音效描述：3.2s · 短促 click（划掉时配音，volume 0.3）
├─ 转场进入 ← 硬切
├─ 转场离开 → 软切（同类 broll-abstract → broll-abstract）
└─ 素材依赖：无

─────────────────────────────────────────
Scene 03  [5.5s - 9.0s / 3.5s]  · [concept] [emotion]
├─ 类型：B-roll
├─ 组件 ID：broll-hero.pull-quote
├─ 旁白文案：模型不缺聪明，缺材料。
├─ 屏显文案：「模型不缺聪明，缺材料」
│   高亮词：「缺材料」用 accent 色 + marker 横扫高亮
├─ [期待内容]：揭示核心论断 —— 模型能力瓶颈不在智能，而在喂给它的上下文素材
├─ [期待效果]：观众心里"哎，有道理" → 把"模型不行"重新定位成"我没给够材料" → 认知反转
├─ 画面描述：
│   - 引用块居中布局，左右大留白
│   - 引用区使用 serif italic 强调字（按主题字号档位）
│   - 左侧 oversized 引号装饰（accent 色）
│   - 整段引用走主色稍弱化
│   - 16:9 横屏，无 3D
├─ 动效要点：
│   - 引号 FLOATS 入场（先于文字）
│   - 文字按词 CASCADE 错峰入场
│   - 「缺材料」WHIPS 被 marker 横扫高亮
├─ 音效描述：无（pull-quote 镜头让旁白与字幕停顿单独承担）
├─ 转场进入 ← 软切
├─ 转场离开 → 硬切
└─ 素材依赖：无

─────────────────────────────────────────
Scene 04  [9.0s - 13.0s / 4.0s]  · [concept] [structure]
├─ 类型：B-roll
├─ 组件 ID：broll-abstract.spectrum
├─ 旁白文案：RAG 在'纯背诵'和'纯检索'之间偏向后者。
├─ 屏显文案：左端「纯背诵」 ── 中点 ── 右端「纯检索」
│   游标位置：偏向右端 70% 处，标注 "RAG"
│   高亮词：「RAG」标签用 accent 色圆形 chip 包住
├─ [期待内容]：用一根坐标轴把抽象概念"RAG 偏检索"空间化，把 RAG 定位在 70% 检索侧
├─ [期待效果]：观众脑中形成空间感（一根尺、一个位置）→ 抽象概念变成可记忆的图像
├─ 画面描述：
│   - 水平光谱条横跨屏幕 70% 宽
│   - 光谱条从主色渐变到 accent 色（左主色右 accent）
│   - 左右两端标签 caption 档（中文语义字体）
│   - 游标用 accent 色圆点 + 上方"RAG"标签
│   - 上方留白放说明小字（可选）
│   - 16:9 横屏，无 3D
├─ 动效要点：
│   - 光谱条从中点 DRAWS 向两端展开
│   - 左右标签 CASCADE 紧随入场
│   - 游标 SLIDES 滑到 70% 位置
│   - "RAG" 标签 FLOATS 从游标下方升起
├─ 音效描述：12.0s · 短促 tick（游标到位时配音，强化定位感，volume 0.25）
├─ 转场进入 ← 硬切
├─ 转场离开 → 反白闪屏(1/2，留给即将到来的数据高潮）
└─ 素材依赖：无

─────────────────────────────────────────
Scene 05  [13.0s - 17.5s / 4.5s]  · [data] [hook]
├─ 类型：B-roll
├─ 组件 ID：broll-hero.big-number
├─ 旁白文案：87% 的开发者认为提示工程会被上下文工程取代。
├─ 屏显文案：
│   主数：「87%」（display 档主数字，accent 色）
│   副标：「开发者认为提示工程会被上下文工程取代」
│   高亮词：「提示工程」「上下文工程」用 hairline 下划线
├─ [期待内容]：用 87% 这个具体数字证实"上下文工程正在取代提示工程"已是行业共识
├─ [期待效果]：观众被数字震撼（87% 不是少数派）→ 产生"我也得跟上"的紧迫感 → 把概念从"听说"升级为"必学"
├─ 画面描述：
│   - 主数字大尺寸，居中偏左
│   - 副标 body 档主色稍弱化，右侧多行排版
│   - 左下角小字标注"Source: [虚构占位 / data.json]"
│   - 装饰：右上角四角十字保留，左下 accent 色短线
│   - 16:9 横屏，无 3D
├─ 动效要点：
│   - 87% 主数 COUNTS UP 从 0 滚到 87
│   - "%" 符号 SLAMS 弹入
│   - 副标按行 CASCADE 入场
│   - 关键词「上下文工程」WHIPS hairline 扫入
├─ 音效描述：13.0s · swoosh（配反白闪屏切入，volume 0.6）+ 13.4s · 低频 thump（87% 落定时配音，volume 0.3）
├─ 转场进入 ← 反白闪屏（2/2，全片用完，制造数据高潮）
├─ 转场离开 → 软切
└─ 素材依赖：data.json（含 87% 的来源元数据，或在 spec 备注 [待补充素材 - 数据源]）

─────────────────────────────────────────
Scene 06  [17.5s - 21.0s / 3.5s]  · [demo] [structure]
├─ 类型：B-roll
├─ 组件 ID：broll-ui.terminal
├─ 旁白文案：（无旁白，纯演示）
├─ 屏显文案：终端窗口内容（typing 效果）：
│   ```
│   $ context.load("docs/*.md")
│     loading 142 files... done
│   $ context.compose()
│     → 23k tokens ready
│   ```
├─ [期待内容]：把抽象的"上下文工程"实例化成可执行的代码动作（load 142 files → 23k tokens）
├─ [期待效果]：观众"哦原来是这么干的" → 概念从抽象变成具体可操作 → 产生"我也能上手"的信心
├─ 画面描述：
│   - 终端窗口居中，深色面板背景 + 主文字色反色
│   - 顶部标题栏 macOS 风格三个圆点装饰
│   - 终端区使用等宽字体（按主题档位）
│   - 命令提示符 $ 用 accent 色
│   - 16:9 横屏，无 3D
├─ 动效要点：
│   - 终端窗口 FLOATS 入场
│   - 第一行命令 types on 打字机出现
│   - 第二行 loading 输出 CASCADE 紧随
│   - "done" PULSES accent 色高亮闪一下
│   - 第三行 command types on
│   - "23k tokens" PULSES accent 色加粗强调
├─ 音效描述：17.8s 起 · 极轻 typewriter tick（伴随每行 types on，volume 0.2）+ 19.5s · 短促 pop（"done" PULSES 时配音，volume 0.3）
├─ 转场进入 ← 软切
├─ 转场离开 → shader 转场
└─ 素材依赖：无（纯组件 + 文本）

─────────────────────────────────────────
Scene 07  [21.0s - 25.0s / 4.0s]  · [summary] [emotion]
├─ 类型：A-roll（如有真人素材）/ B-roll fallback
├─ 组件 ID：aroll.subtitle-highlight（有真人）/ broll-hero.pull-quote（fallback）
├─ 旁白文案：结论：
├─ 屏显文案：
│   主标：「结论」（accent 色 marker 横扫）
│   副标：（无，留白给下一镜释放核心信息）
│   高亮词：「结论」全句 accent 色高亮
├─ [期待内容]：制造"暂停 + 转折"的语义节拍，告诉观众下一句是 takeaway，请集中注意力
├─ [期待效果]：观众身体前倾、停止分心 → 把"结论镜头"当成必须记住的关键节点 → 准备接收核心句
├─ 画面描述：
│   - 如有真人：真人 talking head 居中，底部字幕高亮关键词
│   - 如无真人：主题主色背景 + hero 大字「结论」（serif italic 强调）
│   - 上方留白比例大（70%），强调下方"结论"主体
│   - 16:9 横屏，无 3D
├─ 动效要点：
│   - "结论" SLAMS 入场
│   - accent marker WHIPS 横扫高亮
│   - 整体 holds 静帧（给观众预期"核心句即将出现"）
├─ 音效描述：21.0s · BGM 短促压低 1 拍（音画错位强调，让观众屏息）；无单独音效
├─ 转场进入 ← shader 转场（接续 Scene 06）
├─ 转场离开 → 硬切
└─ 素材依赖：
│   - 如选 A-roll：真人 4.0s 片段（路径：./assets/talking-head.mp4）+ u2net 抠像
│   - 如无：标 [待补充素材] 真人片段；退化用 pull-quote

─────────────────────────────────────────
Scene 08  [25.0s - 30.0s / 5.0s]  · [summary] [cta] [hook]
├─ 类型：B-roll
├─ 组件 ID：broll-hero.big-type
├─ 旁白文案：模型是 compiler，不是 oracle。
├─ 屏显文案：
│   主句（两行排版）：
│     第一行：「模型是 compiler，」
│     第二行：「不是 oracle。」
│   高亮词：「compiler」accent 色，「oracle」主色弱化划掉
├─ [期待内容]：用 12 字以内的最强 takeaway 封口 —— "模型是 compiler，不是 oracle"，把整片浓缩成可传播的一句话
├─ [期待效果]：观众记住这句金句，能在自己向别人解释时复述出来 → 视频的核心信息成功"出片成梗"
├─ 画面描述：
│   - 双行 hero 字号排版
│   - 第一行主色实心，「compiler」accent 色
│   - 第二行主色弱化，「oracle」用 sketchout 划掉
│   - 居中布局，四角十字 + hairline 底线装饰
│   - 底部小字 CTA（可选）："了解更多 → context-eng.dev"
│   - 16:9 横屏，无 3D
├─ 动效要点：
│   - 第一行按词 CASCADE 入场
│   - 「compiler」WHIPS accent marker 横扫高亮
│   - 第二行按词 CASCADE 紧随入场
│   - 「oracle」SCRATCHES 划掉
│   - 整体 holds 让观众消化核心信息
│   - 收尾 DISSOLVES 暗示结束
├─ 音效描述：29.0s · BGM fade-out 收尾
├─ 转场进入 ← 硬切
├─ 转场离开 → fade-out（最终镜头退场）
└─ 素材依赖：无

─────────────────────────────────────────
```

[示例统计自检]
    - 总时长：2.5+3.0+3.5+4.0+4.5+3.5+4.0+5.0 = 30.0s ✅
    - 反白闪屏：2 次（Scene 04→05 进入 + Scene 05）✅ 用完额度
    - Shader 转场：1 次（Scene 06→07）✅ < 1/3 限制
    - hook 镜头：Scene 01 落在开头 2.5s 内 ✅
    - 组件多样性：broll-hero ×3 / broll-abstract ×2 / big-number ×1 / terminal ×1 / aroll ×1 ✅
    - 每 Scene 都有信息载荷 + 转场明确 + 无 jump cut ✅
    - 节奏曲线：2.5-3.0-3.5-4.0-4.5-3.5-4.0-5.0（前快后慢）✅

---

## [常见陷阱]

[陷阱 1：按句号切完就当分镜]
    问题：句号不等于视觉切点
    应对：再过一遍，看哪些短句要合并，哪些长句要拆分

[陷阱 2：每个 Scene 都用大字 hero]
    问题：视觉单调，观众疲劳
    应对：组件多样性自检——同一组件 ≤ 4 次

[陷阱 3：转场字段写具体参数 / 全用同一种]
    问题：写出 "crossfade 300ms ease-out" → 越界
    应对：只写类型（硬切 / 软切 / 反白闪屏 / shader）

[陷阱 4：反白闪屏每个 Scene 都用]
    问题：违反 hard rule（≤ 2 次）
    应对：留给最关键的两个转折点（一般在 hook 进入 + 数据高潮）

[陷阱 5：节奏全片均速]
    问题：观众没记忆点，所有镜头一样长
    应对：检查节奏曲线，必须有快慢对比

[陷阱 6：所有 Scene 都堆满信息]
    问题：信息密度过载，观众消化不了
    应对：穿插 [bridge] 或 [emotion] 镜头给观众喘息（但占比 ≤ 15%）

[陷阱 7：忘记给数据 Scene 标数据源]
    问题：渲染时无数据可用
    应对：data Scene 必须标 data.json 路径或 inline 数据

[陷阱 8：A-roll Scene 旁白不全]
    问题：字幕高亮无法精确同步
    应对：A-roll 必须有完整旁白文本（不能用"省略号"）
CODEX_LAZYPACK_49787C70564F52EB1D88FA3F5C9F69D419970239

# video-spec-builder/references/spec-rules.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/video-spec-builder/references/spec-rules.md")"
cat > "{{CODEX_HOME}}/skills/video-spec-builder/references/spec-rules.md" <<'CODEX_LAZYPACK_9E5847B2447974B4B676E99EB7474CAF8A71C35F'
---
name: spec-rules
description: 填写 video-spec.md 模板时的字段约束、规格一致性校验、交付前自检清单。配合 templates/video-spec-template.md 使用——模板是骨架，本文件是「怎么填对」。起草和迭代 spec 前都要读。
---

# Video Spec 填写规则

`templates/video-spec-template.md` 是要填的骨架，本文件是每个字段的约束、规格一致性校验、和输出前的自检清单。

通用原则：

- 时间精度统一到 0.1s
- 每个分镜的「组件」ID 必须来自 `components-catalog.md` 登记的真实 ID，不许自创
- 只把用户明确说过的写进 spec；推断的内容标 `[待用户确认]`，纯空缺标 `[待补充]`，不凭空补

---

## 规格一致性校验

§ 1 视频基本盘和 § 4 视觉规范里的规格，任一项不一致 → 直接报错回去修，不要输出。

- 平台是 YouTube Shorts / 抖音 / TikTok / 小红书 / 视频号 → 画面比例必须 9:16
- 平台是 YouTube 长视频 / B 站 / 发布会大屏 → 画面比例必须 16:9
- 平台是 X / LinkedIn → 画面比例 1:1 或 16:9
- 平台是产品官网 / Demo / 内部 → 通常 16:9
- 时长与信息密度匹配：抓眼球型默认 ≤ 60s / 讲清楚型 30s-5min / 沉浸型 ≥ 60s
- 视觉主题必填，2 选 1（预设或自定义），不能空
- accent 色不改写默认；改就给具体 hex，不接受「品牌色」「和 logo 一样」
- 画质：草稿 / review 阶段填 standard，最终交付填 high（high 渲染耗时约翻倍）

---

## 各节字段约束

### § 1 视频基本盘
- 目的 / 受众 / 核心信息 每项不允许敷衍形容词
- 观众熟悉度必须给术语边界，不接受「都看得懂」
- 语气基调给具体参考形象，不接受「专业 / 高大上」
- 核心信息 ≤ 12 字，能被剪成大字海报标题

### § 2 叙事结构
- 叙事节拍各段时间区间加起来 = 全片总时长
- 情绪曲线 3 个词必须有变化方向，不接受「好看 / 值」
- 音画关系至少 1 处错位点，不接受「全程同步」
- 同质化反例至少 3 条（视觉 / 叙事 / 节奏 各 1）

### § 3 表达手段
- 场景类型 3-5 种，按出现顺序列
- 社媒短视频（YouTube Shorts / 抖音 / TikTok / 小红书 / 视频号）默认必选「卡拉 OK 逐词」字幕
- 3D / shader / 音频反应 每项要明确要不要，要就必有描述
- 节奏基准与信息密度一致

### § 4 视觉规范
- 只能调 4 个维度：accent 色 / 装饰密度 / 组件白名单 / 组件黑名单
- 主题锁定的维度（背景 / 字号 / 字体 / 字重 / 动效曲线 / 圆角间距）不在这里覆盖，要改就换主题
- 不写具体 px / ms / 字号数值

### § 5 素材清单
- 已有素材必有具体路径；路径不存在直接说，不假装能用
- 待生成素材必写生成方式（voice ID / 速率 / 源文件）
- 待搜索素材 4 项（源平台 / 关键词 / 用途 / 验收标准）缺一不可
- 关键词具体可搜，中文模糊词翻译成英文，不写「好看 / 有质感」

### § 6 分镜表（重点）

字段约束：

- **时间**：起止秒，精度 0.1s，禁用「大概 3 秒 / 短暂停顿」
- **类型**：A-roll（主线讲解）/ B-roll（辅助镜头）/ 转场（独立成镜的过场如反白闪屏）
- **组件**：必须是 components-catalog.md 登记过的 ID；找不到 → `broll-abstract.placeholder` 占位 + 在 § 9 登记
- **旁白文案 vs 屏显文案**：哪怕内容一样也分开写（一个是听到的、一个是看到的）
- **期待内容**：这一镜传达的具体信息（数据 / 概念 / 情绪 / 动作），不接受空话
- **期待效果**：观众该产生的反应，不接受「好看 / 高级」
- **画面描述**：镜头里有什么、布局如何、是否 3D、9:16 还是 16:9 适配——所有视觉维度都要落进来
- **动效要点**：动词级（SLAMS / CASCADE / FLOATS / DRAWS），不写 ms / ease 参数
- **音效描述**：每个 Scene 都要写——无音效写「无」
- **转场**：进入 + 离开必填，「硬切」是合法转场也必须明写
- **素材依赖**：Scene 用到的具体素材都列出

特殊规则：

- 反白闪屏全片 ≤ 2 次，两次间隔 ≥ 8s；第 2 次起在画面描述里注明「第 N 次反白闪屏（剩 N 次）」
- 末镜是唯一允许 exit 动画（fade-out 到黑）的 Scene，其他 Scene 只写 entrance
- 9:16 竖屏布局：三列变三行 / 字幕区域上移 / 最大宽度收窄 / 大字收窄到画面 60% 宽——画面描述必须考虑
- A-roll 必须有完整旁白原文（字幕逐词高亮，省略号不行）
- 同一组件全片用 ≥ 4 次 → 视觉单调警告，考虑换组件
- 过场（bridge）镜头占比 ≤ 15%
- hook 镜头必须落在视频开头 3s 内至少 1 个

### § 7 音频时间轴
- TTS 旁白写清「用 [voice ID] [Nx 速率] 从 [script 文件] 生成」
- BGM volume 通常 0.15-0.25，旁白同时存在时 ducking 到 0.1-0.15
- 音效时间码必须能在 § 6 分镜表找到对应触发点
- BGM 起止时间 = 视频总时长

### § 8 参考与反例
- 至少 1 个正向参考 + 1 个差异化点
- 至少 1 个反例 + 3 条「绝对不要」（视觉 / 叙事 / 节奏 各 1）
- 不接受「都好看 / 都不像」

### § 9 开放问题
- 字段路径写法：`节名 / 子项`——一级用节标题（不带编号），二级用字段名，Scene 用 `Scene NN` 两位补零
- 示例：`视频基本盘 / 核心信息` · `Scene 03 / 画面描述` · `音频时间轴 / 背景音乐`
- 无开放问题写「无，spec 已完整」

---

## 交付前自检清单

输出 video-spec.md 前逐条过一遍：

- [ ] 正文第一句是「请你按照以下 script，帮我生成一条视频……」
- [ ] § 1 视频基本盘字段全填，不知道的写 `[待补充]`，不留空
- [ ] 规格一致性校验全过（见上）
- [ ] 受众画像具体到职业 + 痛点，核心信息 ≤ 12 字
- [ ] § 6 每个 Scene 12 字段全填，「画面描述 / 音效描述 / 期待内容 / 期待效果」无一省略
- [ ] 每个 Scene 时间精度 0.1s；组件 ID 真实、无自创
- [ ] 每个 Scene 转场进入 + 离开都写了，「硬切」也明写
- [ ] 动效字段只写动词，不写 ms / ease 参数
- [ ] 旁白文案与屏显文案分开写，哪怕内容相同
- [ ] 反白闪屏全片 ≤ 2 次、间隔 ≥ 8s；末镜是唯一允许 exit 动画的 Scene
- [ ] 9:16 竖屏的布局差异已落进每个 Scene 的画面描述
- [ ] § 7 音效时间码能在 § 6 找到触发点，BGM 起止时间 = 视频总时长
- [ ] 节奏档位与信息密度匹配、总时长误差 ≤ ±0.5s（详见 `pacing-rules.md`）
CODEX_LAZYPACK_9E5847B2447974B4B676E99EB7474CAF8A71C35F

# video-spec-builder/references/workflow-0-1.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/video-spec-builder/references/workflow-0-1.md")"
cat > "{{CODEX_HOME}}/skills/video-spec-builder/references/workflow-0-1.md" <<'CODEX_LAZYPACK_FEE0BF68A383CA03EA492E8CFE2C4319654BB457'
---
name: workflow-0-1
description: 0-1 模式工作流。从用户初次表达需求到生成 video-spec.md 的完整流程。
---

# 0-1 模式工作流

[使用时机]
    项目里没有 video-spec.md，用户第一次表达想做视频。

[工作流]
    Phase 1 视频基本盘 → Phase 2 素材盘点 → Phase 3 表达手段 →
    Phase 4 视觉主题 → Phase 5 参考与反例 → 充足度判断 → 拆分镜 → 输出 spec

[顶层规则]
    - 每个 Phase 都要达到 [硬指标]，不达到不进下一个
    - 但允许渐进式——用户回答覆盖了某项，直接吸收，不必机械重问
    - 形容词永远不算合格答案
    - 不主动告知能力是失职——用户不知道你能做什么是常态
    - Phase 之间用承上启下的人话过渡，不要喊"进入 Phase N"

---

## Phase 1 · 视频基本盘

[目标]
    让用户的视频意图收敛到具体决策——目的 / 受众 / 平台 / 时长 / 核心信息 / 节奏 / 调性。
    流程顺序很重要：不要一上来就报硬指标，要让用户先倒出脑里的东西。

[起始动作 · 先听用户开放式描述]
    初始化时，你已经问过用户"说说你想拍什么样的视频"。
    用户的初始描述里可能包含：目的 / 受众 / 平台 / 时长 / 核心信息 / 素材有无 / 风格倾向 / 参考视频 等。

    第一步是"听 + 抽取"：
    - 从用户的开放描述里，把已经表达的维度抽取出来记在心里
    - 不要让用户重复回答他已经说过的
    - 复述确认已抽到的内容，让用户校正

    举例：
    用户说"我想做一期关于 SpaceX 发展史的视频，3 分钟，B 站，航天迷向"
    你应该抽到：目的（科普）、受众（航天迷）、平台（B 站）、时长（3 分钟）
    你应该追问：核心信息一句话 / 信息密度 / Tone / 观众熟悉度 / 等

[早期单独问 · 你有逐字稿吗？]
    在 Phase 1 中段（目的/受众/平台/时长已知后，核心信息确定前后），单独问一次逐字稿：

    "你有逐字稿吗？还是需要我帮你起草？"

    这一问决定后续分支：
    - 用户有逐字稿 → 后续基于逐字稿追问镜头节奏 / 文字呈现 / 视觉风格 等
    - 用户没逐字稿 → 在 Phase 1 全部完成、Phase 3 之前，主动提议"基于你已答的我先起草一版你审"

    不要把逐字稿问题和音频方案混在一起问（像 "TTS vs 真人录音 + 你有逐字稿吗" 这种）。
    逐字稿是单独优先级最高的内容素材问题，单独问。

[硬指标]
    - 视频目的明确（科普 / 营销 / 教学 / 产品演示 / 品牌 / 纪录 挑主导）
    - 目标受众有具体画像（年龄 / 职业 / 看视频的场景）
    - 平台与规格四连答（平台 / 时长精确到秒 / 比例 / 帧率）
    - 核心信息一句话 ≤ 12 字
    - 信息密度三选一（hook / 教程 / 纪录）
    - Tone of Voice 有参考形象（如 "Karpathy 风格"、"Apple 发布会风格"）
    - 观众熟悉度有边界（懂哪些术语 / 不懂哪些）

[围栏]
    - 不接受"年轻人"、"所有人"、"懂行的人"——逼到具体画像
    - 不接受"想火"、"高大上"、"显得专业"——这是结果不是目的
    - 不接受 12 字以上的核心信息——砍
    - 不接受"看着办"、"中等节奏"——给绝对值
    - 不打客套开场白，不说"好的，我来帮你做视频"

[详细问法]
    → `references/question-bank.md` Phase 1

[完成后衔接文案]
    用承上启下的口语，不要用"进入 Phase N"这种技术语言。

    × "Phase 1 锁定 → 进入 Phase 2"
    ✓ "好，你这视频的基本盘我懂了——[一句话复述核心信息]。现在聊聊你手头有什么素材。"

---

## Phase 2 · 素材盘点

[目标]
    搞清楚每类素材的状态（已有 / 待生成 / 无需），列出待搜索清单。

[Phase 2 重要前置 · 逐字稿处理]
    逐字稿在 Phase 1 后期已经问过一次。

    - 如果用户有逐字稿 → 跳过"逐字稿"维度，直接进音频/视频/图形/数据
    - 如果用户没逐字稿且需要你起草 → 现在开始起草（基于 Phase 1 五维度），起草完让用户审，然后才继续 Phase 2 后续

[硬指标]
    - 6 类素材状态明确（内容 / 音频 / 视频影像 / 图形 / 3D / 待搜索）
    - 每个"无"都判断过能否由你生成或列入搜索
    - 待搜索每条必须 4 字段齐全（源平台 / 关键词 / 用途 / 验收）

[围栏]
    - 不假装有素材——空缺就标 [待补充]
    - 不下载素材，只列清单
    - 中文关键词必须翻译成英文搜索词
    - 没逐字稿先问要不要你起草，不要默默替用户写
    - 用户提供的素材路径不存在时直接告诉他，不要假装能用

[详细问法]
    → `references/question-bank.md` Phase 2

[完成后衔接文案]
    ✓ "素材清点完了——逐字稿你来出，B-roll 我列了 4 条待搜。接下来定一下视频本身怎么讲，画面用什么手段。"

---

## Phase 3 · 表达手段

[目标]
    主动激发可用能力，让用户在知情前提下做选择。

[硬指标]
    - 场景类型组合选定 2-4 类
    - 文字呈现方式选定（常驻字幕 / 关键词高亮 / 卡拉 OK / 打字机 / 文字标记 / 动态字重 等）
    - 动效语言定调（转场密度 / 类型 / 音频反应可视化与否）
    - 节奏基准精确到平均每镜头秒数（钉秒数前必读 `references/pacing-rules.md`，
      按视频类型 / 平台查节奏档位，不许凭印象给秒数）
    - 叙事节拍曲线（hook / 展开 / 高潮 / CTA 时间区间）
    - 情绪曲线（开头 / 中段 / 收尾 3 个情绪词）
    - 音画关系明确（叙事 vs 氛围 + 至少 1 处错位点）

[围栏]
    - 不一次性把能力对照表全抛给用户——选用户没主动提的 1-2 个最相关能力主动告知
    - 不接受全程同步的音画关系（至少 1 处错位）
    - 不接受"看着办的节奏"——必须钉到秒
    - 不许诺系统做不到的能力——给替代方案

[详细问法]
    → `references/question-bank.md` Phase 3

[完成后衔接文案]
    ✓ "表达手段定下来了——平均 2.4s/镜，hook 前 5 秒压满，中段一处错位用环境音盖旁白。接下来挑一下整片的视觉调子。"

---

## Phase 4 · 视觉主题选定

[目标]
    选定主题（2 路径之一）+ 在主题内做可调维度的微调。

[硬指标]
    - 主题选定（8 个 HyperFrames 预设之一的名字，或自定义主题 = 项目根目录的 design.md）
    - accent 色明确（默认 / hex）
    - 装饰密度选定（minimal / medium / heavy）
    - 组件白名单 / 黑名单明确（可为空）

[围栏]
    - 主题选定后不再追问字体 / 字号 / 字重等主题锁定项
    - 用户敷衍"随便 / 看你的"→ 不接受，从 Phase 1 视频类型推荐 2-3 个预设让他三选一
    - 用户敷衍且坚持自定义 → 走描述生成路径，逼用户给三个形容词
    - 不允许"等做出来再调主题"——必须先定

[详细问法]
    → `references/question-bank.md` Phase 4
    问组件白名单 / 黑名单前，先读 `references/components-catalog.md`，
    手里有完整组件清单再问"有想用的 / 一定不要的组件吗"。

[完成后衔接文案]
    ✓ "调子定了——Shadow Cut 主题，橙色做点缀，装饰走 medium。再补两个具体参考和几条反例，方向就齐了。"

---

## Phase 5 · 参考与反例

[目标]
    用具体的参考校准方向 + 用反例排除歧义。

[硬指标]
    - 至少 1 个具体参考作品 + 1 个"9 分像 1 分不一样"的差异化点
    - 至少 3 条"绝对不要"反例（视觉 / 叙事 / 节奏 各 1）

[围栏]
    - 不接受"看着挺好的视频"——必须具体到作品 / 链接 / 截图
    - 不接受"不要俗气"——必须具体到"不要 X 配色 / Y 套路 / Z 套路"
    - 反例往往比正例更精确，用它倒推视觉决策

[详细问法]
    → `references/question-bank.md` Phase 5

[完成后衔接文案]
    ✓ "参考和反例都到位了。我盘一下前面攒的东西够不够开始拆镜头。"

---

## [充足度判断]

[Gate 通过条件]
    - Phase 1 所有硬指标达成（无任何一项空缺）
    - Phase 2 所有素材状态明确
    - Phase 3 场景类型 + 节奏 + 叙事节拍齐全
    - Phase 4 主题选定
    - Phase 5 至少 1 个参考 + 3 条反例

    未达成 → 回对应 Phase 继续追问，不允许勉强生成半成品。
    半成品比没成品更糟糕，会误导后续渲染。

---

## [分镜起草阶段]

    起草方法论详见 `references/scene-breakdown.md`。

    选组件时必读 `references/components-catalog.md`：
    每个 Scene 的「组件」字段只能填 catalog 里登记过的真实组件 ID，
    不许自创（不许 `broll-data.*` / `transition.*` 这类编造的命名）；
    找不到合适组件 → 用 `broll-abstract.placeholder` 占位并登记。

    起草后必做：用 scene-breakdown 的 [自检清单] 自检一遍；没通过改完再自检；通过进入输出阶段。

---

## [输出阶段]

[输出规则]
    - 按 `templates/video-spec-template.md` 的骨架输出 video-spec.md
    - 填字段前读 `references/spec-rules.md`：字段约束 / 规格一致性校验 / 交付前自检清单
    - 未达成的地方标注 [待补充]，不要凭空补
    - 分镜表每个 Scene 都要锚定到具体组件 ID（不写"概念卡片"，写 `aroll.concept-card`）
    - 时长精确到 0.1s
    - 输出前用 spec-rules.md 的 [交付前自检清单] 逐条过一遍
    - 素材路径用相对路径
    - 文件名 video-spec.md，全小写，放项目根目录

[完成后告诉用户]
    video-spec.md 已经写到 [路径]。

    自己审一遍看哪里要改——画面描述够不够具体、节奏对不对、待搜的素材关键词够不够精确。

    审完没问题了，输入 hyperframes 让渲染端按这个脚本生成视频。
CODEX_LAZYPACK_FEE0BF68A383CA03EA492E8CFE2C4319654BB457

# video-spec-builder/references/workflow-iteration.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/video-spec-builder/references/workflow-iteration.md")"
cat > "{{CODEX_HOME}}/skills/video-spec-builder/references/workflow-iteration.md" <<'CODEX_LAZYPACK_A9F4E2B0E86607CCF6283CB7820A1A32CB5F9B30'
---
name: workflow-iteration
description: 迭代模式工作流。用户修改已有 video-spec.md 时使用。
---

# 迭代模式工作流

[触发条件]
    用户在已有 video-spec.md 的项目里提出修改 / 新增 / 调整 / 替换 / 风格变更。

[工作流]
    接住需求 → 判断变更深度 → 按深度追问 → 冲突检测 → 更新 spec → 告诉用户

[顶层规则]
    - 无缝衔接，不开场白，不重新跑 Phase 1-5
    - 直接读现有 spec，接住需求，按变更深度追问
    - 不打断用户工作流
    - 组合变更（一次包含多个层级）按最重的处理

---

## 重度变更

[触发条件]
    涉及 Phase 1 必问项变更 / 整体节奏类型变更 / 受众或核心信息变更。

[硬指标]
    能回答"这个变更怎么影响整支视频"——为什么改 / 影响哪些场景 / 整体节奏怎么变 / 原素材还能用吗 / 核心信息要不要跟着改。

[围栏]
    - 不接受"全部重做"——这是 0-1 模式，应该归档旧 spec
    - 必须二次确认（先生成"预计改动总览"让用户确认 OK 再动 spec 文件）

[完成后衔接文案]
    ✓ "改动总览我先列出来——[受影响 Scene 列表 + 整体节奏变化 + 素材增删]。你确认 OK 我再动 spec 文件。"

---

## 中度变更

[触发条件]
    加新场景 / 删场景 / 替换组件 / 大段重排。

[硬指标]
    能回答"具体改成什么样 + 与前后镜头怎么衔接"——改哪个 Scene / 改成什么组件 / 文案 / 时长 / 转场要不要跟着改。

[围栏]
    - 不允许悄悄改其他 Scene（只改用户指定的）
    - 时长变了必须重新核对总时长与节奏档位
    - 用户卡住时给 2-3 个具体方案 + 优劣，不开放问

[完成后衔接文案]
    ✓ "Scene 3 换成 `aroll.timeline-card`，时长从 2s 拉到 3s，前一镜头转场改成淡入。总时长 +1s。这样改我去动文件。"

---

## 轻度变更

[触发条件]
    调整旁白 / 屏显文案 / 改 accent 色 / 改装饰层 / 时长 ±0.5s 内。

[硬指标]
    确认理解正确——改什么 / 改成什么。

[围栏]
    - 不优化用户已确认的文案（除非明确要求）
    - 不改 markdown 结构

[完成后衔接文案]
    ✓ "accent 色从 #FF6A00 改成 #FF8C42，其他不动。"

---

## [冲突检测]

加载现有 video-spec.md，新需求如果与现有内容冲突，必须直接指出 + 给方案让用户选。

[常见冲突类型]
    - 节奏冲突（总时长超 / 不够）
    - 组件冲突（与已选场景类型组合不符）
    - 素材冲突（依赖的素材原 spec 没有）
    - 转场冲突（触发硬规则，如反白闪屏 ≤ 2 次、Shader 转场每 3 Scene ≤ 1 次）
    - 核心信息冲突（新内容稀释 takeaway）

[停止追问的标准]
    - 能直接动手改 video-spec.md，不需要再猜或假设
    - 改完之后用户不会说"不是这个意思"

---

## [更新文档]

[纪律]
    - 在原 spec 上精确修改（不另存新文件）
    - 不改文档 markdown 结构（标题层级 / 列表风格）
    - 不删除用户的注释 / 备注
    - 改了分镜表 → 用 `references/spec-rules.md` 的字段约束和 [交付前自检清单] 重新核对
      （组件 ID 真实性 / 总时长误差 / 反白闪屏额度 / 转场字段齐全）

---

## [完成后告诉用户]

    video-spec.md 已更新。
    - 改动总览：[哪些 Scene / 总时长怎么变 / 素材新增项]
    - 如果影响渲染，输入 hyperframes 重新生成视频
CODEX_LAZYPACK_A9F4E2B0E86607CCF6283CB7820A1A32CB5F9B30

# video-spec-builder/spec-mono/design.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/video-spec-builder/spec-mono/design.md")"
cat > "{{CODEX_HOME}}/skills/video-spec-builder/spec-mono/design.md" <<'CODEX_LAZYPACK_AD84C35DE36269385F3206257F2F8B6D797D5701'
---
name: Spec Mono
colors:
  primary: "#000000"        # 纯黑底
  on-primary: "#FFFFFF"     # 纯白前景
  surface: "#0A0A0A"        # 卡片表面
  accent: "#FFFFFF"         # 单 accent · 默认纯白(Grok mono)· 可覆盖成任意 hex
typography:
  hero:
    fontFamily: Barlow Semi Condensed
    fontSize: 8rem
    fontWeight: 700
    letterSpacing: -0.03em
    textTransform: uppercase
  stat:
    fontFamily: Barlow Semi Condensed
    fontSize: 9rem
    fontWeight: 700
    letterSpacing: -0.04em
  body:
    fontFamily: Space Grotesk
    fontSize: 1.1rem
    fontWeight: 400
    lineHeight: 1.6
  label:
    fontFamily: JetBrains Mono
    fontSize: 0.7rem
    fontWeight: 500
    letterSpacing: 0.22em
    textTransform: uppercase
  quote:
    fontFamily: Instrument Serif
    fontSize: 4rem
    fontWeight: 400
    fontStyle: italic
rounded:
  none: 0px
  sm: 2px
  md: 4px
  lg: 8px
spacing:
  sm: 8px
  md: 16px
  lg: 24px
  xl: 40px
  xxl: 64px
motion:
  energy: moderate
  easing:
    entry: "expo.out"
    exit: "power4.in"
    ambient: "sine.inOut"
  duration:
    entrance: 0.7
    hold: 2.5
    transition: 0.6
  atmosphere:
    - dot-grid
    - hairline-rules
    - registration-marks
  transition: cinematic-zoom
---

# Spec Mono

视觉语言借鉴 **SpaceX 发射页 × xAI/Grok × X(Twitter)**。源自一套 Codex design workflow
产出的设计系统(原始产出归档在 `assets/`)。

配套文件:
- `tokens.css` —— 可复用 CSS(变量 + spec-sheet 装饰类 + 入场 keyframes),写镜头时直接抄。
- `spec-mono-components.md` —— 69 个组件的逐个细规格,做具体镜头时查。

## Overview

像航天任务控制台,不像 PPT。冷静、锋利、工程感。信息靠**字重悬崖、留白、
1px hairline、mono caps 注脚**说话 —— 不靠颜色堆砌、不靠阴影发光、不靠装饰插画。

**适合**:技术教程、产品演示、AI / 开发者向、数据密集型内容。
**不适合**:面向大众的轻松 / 温暖 / 活泼内容 —— 那类换主题,别硬套。

## Colors

纯黑白底子,对比 21:1(WCAG AAA)。

- `primary #000000` —— 纯黑场景底。
- `on-primary #FFFFFF` —— 纯白主文字。次级文字用白色降透明度:次级 66%、注脚 42%、极弱 18%。**层级靠透明度,不靠新颜色。**
- `surface #0A0A0A` —— 卡片 / 面板表面。再抬一层用 `#141414`。
- `accent` —— **整套系统唯一的用色**。默认纯白(Grok 式纯单色)。可覆盖成任意 hex(如 SpaceX 仪表绿 `#00E07A`);无论换成什么,**一屏只允许出现一处 accent**。
- hairline 边线:`rgba(255,255,255,0.08)` 默认 / `0.16` 强 / `0.28` 最强。
- 状态色仅用于数据图表:绿 `#00E07A`、红 `#FF3333`、黄 `#FFC700`。正文 / 标题 / 装饰一律不用。

## Typography

| 角色 | 字体 | 用途 |
|---|---|---|
| hero | Barlow Semi Condensed 700 | 海报大字 · 章节大标题 |
| stat | Barlow Semi Condensed 700 | 大数字(tabular-nums) |
| body | Space Grotesk 400 | 正文 · 中英文标题 |
| label | JetBrains Mono 500 | 编号 · 时间码 · 任务码 · 注脚 |
| quote | Instrument Serif 400 italic | 斜体强调字 · 引用块 · 等式运算符 |

- 中文用 **Source Han Sans SC(思源黑体)**,字重 400 / 700 / 900。
  (注:HyperFrames 字体规范禁用 Noto Sans 拉丁族;思源黑体 = Noto Sans SC 中文变体,是本主题刻意选定的 CJK 字体,保留。)
- **字重悬崖**:只用 `400 / 600 / 700 / 800`,**跳过 500**。相邻层级故意拉开两档。
- **字距**:hero / stat 大字 `-0.03 ~ -0.04em`;body `-0.025em → 0`;label mono caps `0.18 ~ 0.22em`;任务字串(`SCN-03` / `T-MINUS`)`0.32em`。
- **行高**:标题 `0.86 ~ 1.0`,正文 `1.55 ~ 1.7`。
- **招牌动作**:一句几何 sans 里挑 **1 个关键词**换 `quote` 斜体衬线 + accent 色做强调。整句斜体只用于引用块。

## Elevation

**全程 flat —— 0 阴影。** 任何元素都不用 box-shadow / drop-shadow。

深度只靠两样东西:**1px hairline 边框** + **表面色阶**(`#000000` → `#0A0A0A` → `#141414`)。
强调靠换色和字号悬崖,绝不靠发光 / 投影。

## Components

下列是常用范式的概括。**每个组件的精确规格(描边宽度、比例、布局)见 `spec-mono-components.md`** —— 做具体镜头时查那份。复用 CSS 见 `tokens.css`。

- **卡片 / 面板**:`{surface}` 底 + 1px hairline 边 + `rounded.lg (8px)`。可在四角贴十字针脚(`.cross`,12px 臂 · 1px 描边)。padding 用 `spacing.xl`。
- **字幕高亮**:逐词字幕,默认 42% 白,念到的词换 `{accent}` + 3px accent 底线扫入,念过的词回纯白。无底色块。
- **大数字**:Barlow Semi Condensed · `{accent}` · tabular-nums;单位缩到 0.32em、纯白、上偏。
- **引用块**:Instrument Serif italic;一个关键词换 `{accent}`;巨型左引号 opacity 0.18 当装饰。
- **反白闪屏**:`{primary}` ↔ 纯白用 `steps(1)` 瞬切,6-12 帧,**每支视频 ≤ 2 次**。
- **装饰层(atmosphere)**:场景背景三选一 —— `dot-grid` / `hairline-rules` / `scan-lines`,一个场景最多 1 种;边角用 `registration-marks`(十字针脚)+ mono caps 任务编号。装饰是工程图味,不是花边,不叠加。
- **图标**:Lucide 图标集,描边默认 1.5px(与 hairline 等重),颜色 `on-primary` 66%,被强调才 accent。

## Do's and Don'ts

**Do**
- 纯黑底 + 纯白字,层级靠透明度与字号悬崖。
- 一屏只用一处 accent —— 它永远代表"此刻的焦点"。
- 1px hairline、`rounded.sm (2px)` 默认圆角、8-pt 间距栅格。
- 数字一律 `font-variant-numeric: tabular-nums`。
- 入场用 `expo.out`,位移 8-16px,每个元素都从不可见动画进场。

**Don't**
- ❌ 不用阴影 / 发光 / 投影(0 阴影是铁律)。
- ❌ 不用渐变 —— 唯一例外:面积图填充 `accent 42% → 0%`。
- ❌ 不用装饰插画 / 手绘人物(章节封面插画除外)。
- ❌ 一屏不出现第二处 accent 色。
- ❌ 不用 2px 描边、不用胶囊全圆角、不用 32/48/56 这类非 8-pt 间距。
- ❌ 不用回弹(bounce)缓动 —— 唯一例外:贴纸式标签的弹入。
- ❌ 字重不用 500(破坏对比悬崖)。
CODEX_LAZYPACK_AD84C35DE36269385F3206257F2F8B6D797D5701

# video-spec-builder/spec-mono/spec-mono-components.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/video-spec-builder/spec-mono/spec-mono-components.md")"
cat > "{{CODEX_HOME}}/skills/video-spec-builder/spec-mono/spec-mono-components.md" <<'CODEX_LAZYPACK_EBF168D57F2DC8D4FF9B62EAACC5CCB3A02876DC'
# Spec Mono · 逐组件细规格

`design.md` 是主题的品牌契约(颜色 / 字体 / 全局规则)。本文件是它的**配套细则** ——
69 个组件在 Spec Mono 下的精确渲染规格,提取自原始设计系统(`assets/v2/sections/`)。

做某个具体镜头时查对应条目,照着写 HTML/CSS/GSAP,成品才精确贴合设计意图。
全局规则(0 阴影 / 0 渐变 / 单 accent / 1px 描边 / 跳过字重 500)始终适用,见 `design.md`。

组件 ID 与「内容期待」字段见 `{{CODEX_HOME}}/skills/video-spec-builder/references/components-catalog.md`。

---

## aroll · 出镜叠加层

- **subtitle-highlight**：思源黑体 800 · clamp 28-56px。默认 `fg 42%`,念到 accent,念过纯白。强调**仅 3px accent 底线**(`scaleX` 入场),无底色块。下 14% / 左右 8% padding。
- **keyword-sticker**：反白(白底 / 黑字)或卡片(`surface` 底 / 1px 强 hairline 边),二选一。padding 14/22px · 圆角 6px · tilt ±1.5°。入场 `scale .92→1` + tilt 归零 · 320ms spring。**同屏 ≤ 3 个,间距 ≥ 200px。**
- **concept-card**：`surface` 底 · 1px hairline + 4 角十字针脚 · 圆角 8px · padding 32/36px · 宽约 50% 画面。标题 cn 38/800(挑一字换 serif italic)+ 28×2px accent 短分隔 + 正文 cn 16/400。底部 hairline 分隔来源注脚。**0 阴影,一卡一概念,正文 ≤ 3 行。** 入场 700ms ease-out。

## broll-hero · 重锤

- **big-type**：Barlow Semi Condensed 800 · 4K 下 180-220px。挑一字换 Instrument Serif italic + accent。chrome = 左上 idx + 右上 rule + 底刻度尺 + 时码。主字入场 1100ms,角标延迟 280ms。
- **big-number**：数字 cond · 280-360px · accent · tabular-nums。单位 0.32em · 纯白 · 上偏 0.6em。caption 28/800 + 32×2px accent 短杠。chrome = 左 finding / 右 method / 底 dashed connector。
- **pull-quote**：Instrument Serif italic · 76px。一关键词换 accent,弱化句换 `fg 66%`。巨型左引号 opacity 0.18 装饰。byline = mono caps + 36px 短杠。
- **inversion-flash**：黑 ↔ 白用 `steps(1)` 瞬切。6-12 帧(200-400ms)。**每支视频 ≤ 2 次,不连续。**

## broll-charts · 数据图表

轴线 1px `rgba(255,255,255,.06)` hairline。数字一律 mono + tabular-nums。

- **line**：线 3px accent · round join;端点 8px、常规点 4px;末端标数字。
- **multi-line**：主线 accent 3px / 次线 70% 白 2px / 三线 35% 白 2px。**最多 3 条。**
- **bar**：默认柱 18% 白,峰值 accent;柱间距 24px;柱顶标值,顶部 2px 圆角。
- **h-bar**：标签 / 条 / 数值三列;降序,第一名 accent;条高 18px;5% 白底打底。
- **stacked**：主项 accent 放底部锚定 / 次项 55% 白 / 三项 22% 白;柱顶标累计值。
- **area**：填充 `accent 42% → 0%`(**全系统唯一允许的渐变**);顶线 3px accent。
- **donut**：环 36px stroke · 半径 140;中心数字 mono 800 · 56px · accent;右栏三列图例。**≤ 4 块。**
- **scatter**：双轴角落注 LOW/HIGH;点大小映射第三维度;主点 accent,其余 14% 白填。
- **heatmap**：阶梯填色 < 70 走灰阶、≥ 70 走 accent;格间距 4px;行列标 mono caps 14px。
- **gauge**：220° 扫角(-200°→20°);stroke 22px round,底色 10% 白;数字 72px mono 800 accent。
- **sparkline**：卡片 1px hairline · padding 22px · 圆角 6px;主数 mono 30/800 + 14px delta;迷你线 2.5px,颜色映射趋势(绿好 / 橙糟)。
- **sankey**：节点 18px 宽矩形(accent / 62% 白);流条 bezier,宽度映射流量,accent 32% / 白 42% opacity。

## broll-flows · 流程图

通用:节点 hairline 边框,hot 段填 accent;箭头 1px line + 7px 三角。

- **complex**：节点 170×108 · mono 副 + 中文 label;双虚线导轨;hot 段同时点亮 tick / latency;重点段虚线框 + 反白标签圈出。
- **branching**：决策点菱形 + 中心问句;YES/NO 标在线中点 mono caps;主路径 accent。
- **decision-tree**：根 → 决策菱形 → 叶矩形;推荐叶 accent;推荐路径全程 accent。
- **state-machine**：圆形节点 + mono caps 名;箭头上方标事件名;自循环用弧线。
- **sequence**：actor 顶部矩形 + 下垂虚线生命线;实线=同步、虚线=响应/异步;关键调用 accent。
- **swimlane**：横泳道,左侧 mono 标号 + 中文角色名;跨泳道箭头 = 责任移交。
- **fork-join**：fork/join 用 6×20 实心 accent 条;worker 并排堆叠,数量 = 并发度。
- **loop**：4 节点环形排列(不要排成线);弧线闭环;中心写 ∞ + 退出条件。

## broll-structure / structures2 · 结构图

- **flow-chart**：节点 hairline → hot 实心 accent;箭头 1px + 7px 三角;推进 900ms/步;past 线变 accent、future 透明度 0.5。
- **pyramid**：三层宽度 32/52/72%(黄金比),层间距 8px 不重叠;顶层标签 accent。
- **funnel**：四级宽度 80→58→40→22%;末级 accent 边框;右列 mono 数字右对齐。
- **concentric**：半径 60/120/180/240;标签在环顶右对齐 mono+cn 双行;核心填 surface + accent 描边。
- **node-graph**：边 1px 强 hairline、不加箭头美化;节点圆角 6px、padding 8/14;hot 节点 accent 描边 + surface 填充。
- **spectrum(structure)**：轴 1px 强 hairline 全宽;两极点 7px 圆 `fg 66%`;marker 14px 圆 accent。
- **tree**：上下三层(根→类→实例);直线连接,主分支 accent;层级越深矩形越小。
- **mind-map**：中心实心 accent 圆、主题字反色;一级文字 800、二级 14px;主分支均匀放射。
- **matrix-2x2**：十字 hairline 轴 + 四角象限名;点 = 色块+标签,重点项 accent+800;理想象限角落加 ★。
- **venn**：圆半透明填充 + hairline 描边;主圈 accent 18%、其它白 6%;交集中心 ★ + 灵魂名词。
- **layered-stack**：上窄下宽视错觉(实际等高);左侧 L 编号 mono 自上而下递减;focus 层 accent 边框。
- **hub-spoke**：中心实心 accent 圆 80px,永远居中;6 向 spoke,重点连实线、其余虚线。
- **grid-map**：12×6 单元格、间距 8px;色映射状态(active accent / idle 16% 白 / error red);active 单元呼吸 pulse、错位 delay。

## broll-thinking · 思考与组织

- **compare-table**：表头左 mono caps 维度、右 cn 800 候选名;每行最优项 accent + ★ 前缀;hairline 分隔行,**不画竖线**。
- **swot**：2×2 等宽;S/O 走 accent(正向),W/T 中性;字母 mono 800 · 56px 当视觉锚;条目用 8px 横杠(不用圆点)。
- **fishbone**：主干水平、鱼头=问题在右、尾向左;6 类成因斜插,主因 accent;小刺横向 14px。
- **timeline-row**：水平 hairline 轴等距分布;事件卡上下交错;关键事件 accent 大圆点。
- **gantt**：左列任务名 + 右侧周柱;柱高 26px · 2px 圆角,关键里程碑 accent;表头 W1-W10 mono caps。
- **kanban**：4 列等宽,当前列 accent 头;卡片上 mono 标签 / 下中文任务;列头跟数量。
- **card-grid**：4×2 等宽等高、16px gap;卡片左上编号 + 左下标题 + 副标;推荐项整张 surface 填充 + accent 边。

## broll-ui · UI Mock

- **terminal**：mono 字体(画面内约 30px);`surface` 底 + hairline 边;光标 10×18 实块 · 1s blink · accent;打字 60ms/字符;尾部 tokens/延迟/成本注脚走 `fg 42%`。
- **chat-thread**：user 气泡右对齐 · accent 描边 · 透明底;AI 气泡左对齐 · surface 填充 · 无边;最大宽度 70%;流式末尾光标 ▍。
- **browser**：三点 + tab 行 + URL 框全部 hairline;URL 用 mono、不显示 `https://`;CTA 用正方形 accent 按钮;不放 favicon。
- **code-editor**：keyword=accent / string=`fg 66%` / comment=`fg 42%` italic;行号 mono `fg 42%` 右对齐;当前讲解行左侧 2px accent 竖条;文件树可选 32px 宽。
- **api-call**：左请求 / 中延迟 / 右响应三栏;POST=accent、200=green、error=red;键 `fg 42%`、值纯白/accent;中间显示真实毫秒数。
- **dashboard**：KPI 卡 = 巨数字 + 单位 + 标签;焦点卡左上 accent 角标;sparkline hairline + 单 accent 高亮点;右上 accent 圆点 + LIVE caps。

## broll-abstract · 抽象兜底

- **analogy**：左=未知 / 右=熟悉,两张完全对称 hairline 卡;连接符 ≈ 用 serif italic 76px accent;"就像"做下方语义提示;左卡 accent 标签强化区分。
- **black-box**：盒子用 **dashed accent 描边**(区别于 hairline)+ 四角 bracket;`?` 84px cond accent;箭头 hairline + 锐角三角 最强 hairline。
- **equation**：横向居中等距;运算符 serif italic 56px accent;关键项 accent 边框;顶部 EQ + hairline 注释栏(教科书味)。
- **spectrum(abstract)**：轴 0–1 · 11 个 tick(5n 主刻度);marker 倒三角 accent + 上方 mono 标签;左极纯白 / 右极 accent meta。
- **iceberg**：水线 accent 虚线 + WATERLINE 标签;水上实线 · accent · 标"10%";水下虚线 + 轻填充 · 灰阶 · 标"90%"。
- **versus**：左右等宽 + 中竖线 + `vs` serif;同序键值行行对齐;左标 `fg 42%` / 右标 accent。
- **placeholder**：45° 斜条纹底(4% 白)+ 1px 强 hairline 边 + 四角 bracket;`[ DROP HERE ]` mono caps accent;标注尺寸/时长/编码格式。

## icons · 图标

- 用 Lucide 图标集(48 个精选见 catalog)。
- 描边粗细:**默认 1.5px**(与 hairline 视觉等重);图标自身被强调时用 2px。同屏不混用 3 档以上。
- 颜色:默认 `fg 66%`,hover/强调才 accent。**不主动给图标上色。**

## illustrations · 章节封面插画

- 6 张 Open Peeps 风格场景插画,**仅用于章节封面**(一章一张)。
- 这是「0 装饰插画」铁律的唯一豁免区 —— 插画只许出现在章节封面,正文镜头一律不用。
- 注:插画**画稿本身是内容素材,不是主题样式** —— 本主题只规定怎么用、何时用。主题不匹配时退回 `broll-hero.big-type` 兜底。
CODEX_LAZYPACK_EBF168D57F2DC8D4FF9B62EAACC5CCB3A02876DC

# video-spec-builder/spec-mono/tokens.css
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/video-spec-builder/spec-mono/tokens.css")"
cat > "{{CODEX_HOME}}/skills/video-spec-builder/spec-mono/tokens.css" <<'CODEX_LAZYPACK_FE5170784990ADA8EAF79020D206141321114D63'
/* ============================================================
   spec-mono · tokens.css
   视觉语言：SpaceX × Grok × X —— 纯黑 / 纯白 · 几何 sans ·
   condensed 数字 · spec-sheet 美学。
   来源：assets/v2 设计系统（Codex design workflow 产出）的 :root 令牌 +
   排版工具类 + spec-sheet 装饰工具类。已剔除展示页外壳样式
   （.shell / .nav / .hero / .section / .stage 等不属于主题）。
   ============================================================ */

:root {
  /* ---------- 颜色 · pure mono ---------- */
  --bg:        #000000;                 /* 纯黑底 · 太空黑 */
  --bg-card:   #0A0A0A;                 /* 卡片层 */
  --bg-elev:   #141414;                 /* 抬起层 / 嵌套 */
  --bg-flash:  #FFFFFF;                 /* 反白 cut-in（inversion-flash 专用） */

  --fg:        #FFFFFF;                 /* 纯白主前景 */
  --fg-2:      rgba(255,255,255,0.66);  /* 次级文字 */
  --fg-3:      rgba(255,255,255,0.42);  /* meta / caption */
  --fg-4:      rgba(255,255,255,0.18);  /* 极弱 / disabled */

  --line:      rgba(255,255,255,0.08);  /* hairline 边线（默认） */
  --line-2:    rgba(255,255,255,0.16);  /* 强 hairline */
  --line-3:    rgba(255,255,255,0.28);  /* 最强 hairline / 箭头 */

  /* 单 accent —— 整套系统唯一的用色变量，Tweaks 覆盖此值即可换色。
     默认纯白 = Grok 式 mono；改成 hex 即得有色 accent。 */
  --accent:    #FFFFFF;
  --accent-2:  color-mix(in oklab, var(--accent) 40%, transparent);
  --accent-3:  color-mix(in oklab, var(--accent) 14%, transparent);

  /* 状态色 · 极少使用 · 仅数据图表内 */
  --green:     #00E07A;                 /* 仪表绿 / 趋势好 */
  --red:       #FF3333;                 /* abort red / error */
  --yellow:    #FFC700;                 /* caution yellow */

  /* ---------- 字体 ---------- */
  --f-sans:    "Space Grotesk", "Inter Tight", "PingFang SC", "Noto Sans SC", -apple-system, sans-serif;
  --f-cond:    "Barlow Semi Condensed", "Oswald", "Space Grotesk", sans-serif;   /* 海报大字 / 大数字 */
  --f-mono:    "JetBrains Mono", "IBM Plex Mono", "Geist Mono", ui-monospace, monospace;
  --f-cn:      "Noto Sans SC", "PingFang SC", "HarmonyOS Sans SC", sans-serif;   /* 中文主力 */
  --f-serif:   "Instrument Serif", "Source Serif 4", "Noto Serif SC", serif;     /* 斜体强调字 / 引用 */

  /* type ramp —— 文档值 = 4K (3840×2160) 目标画布的 1/2 等比 */
  --t-display: 96px;                    /* hero · spec-sheet 大字 */
  --t-h1:      56px;                    /* 大数字 */
  --t-h2:      32px;
  --t-h3:      22px;
  --t-h4:      17px;
  --t-body:    15px;
  --t-small:   13px;
  --t-cap:     11px;
  --t-meta:    10px;

  /* 字重 —— 只用 400 / 600 / 700 / 800，跳过 500（制造对比悬崖） */
  --w-reg:   400;
  --w-mid:   600;
  --w-bold:  700;
  --w-heavy: 800;

  /* 字距 —— sans 偏紧、mono caps 偏松 */
  --ls-display: -0.03em;
  --ls-tight:   -0.018em;
  --ls-normal:  -0.005em;
  --ls-caps:     0.18em;
  --ls-meta:     0.22em;
  --ls-mission:  0.32em;                /* 任务字串 SCN-03 / T-MINUS 等极宽 */

  /* ---------- 动效 ---------- */
  --ease-out:    cubic-bezier(0.22, 1, 0.36, 1);    /* 默认（入场柔） */
  --ease-in:     cubic-bezier(0.55, 0, 1, 0.45);    /* 出场果断 */
  --ease-soft:   cubic-bezier(0.4, 0, 0.2, 1);
  --ease-spring: cubic-bezier(0.34, 1.36, 0.64, 1); /* 仅 keyword-sticker 弹入 */

  --d-1: 200ms;                         /* 微状态 hover / focus */
  --d-2: 400ms;                         /* hot 高亮态 */
  --d-3: 700ms;                         /* 卡片入场 */
  --d-4: 1100ms;                        /* hero 入场 */

  /* ---------- 圆角 —— 几何感：极小或 0 ---------- */
  --r-0: 0px;                           /* wordmark · plate */
  --r-1: 2px;                           /* 默认（SpaceX 极简） */
  --r-2: 4px;                           /* 柔化 · tag */
  --r-3: 8px;                           /* 大模块（谨慎） */

  /* ---------- 间距 —— 8-pt 栅格，跳过 32/48/56 ---------- */
  --space-1:  8px;                      /* icon · meta gap */
  --space-2: 16px;                      /* 行间 · 卡片内 */
  --space-3: 24px;                      /* 卡内段落 */
  --space-4: 40px;                      /* 组件间 */
  --space-5: 64px;                      /* 小节间 */
  --space-6: 96px;                      /* 章节间 */

  /* ---------- 描边宽度 —— 永远 1px ---------- */
  --bw: 1px;
}

/* ---------- reset + 基础排版 ---------- */
* { box-sizing: border-box; }
html, body { margin: 0; padding: 0; background: var(--bg); color: var(--fg); }
body {
  font-family: var(--f-sans);
  font-size: var(--t-body);
  font-weight: var(--w-reg);
  letter-spacing: var(--ls-normal);
  line-height: 1.6;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  font-feature-settings: "ss01", "cv11", "tnum";
}
:lang(zh), .cn { font-family: var(--f-cn); }
::selection { background: var(--accent); color: var(--bg); }

/* ---------- 排版工具类 ---------- */
.mono    { font-family: var(--f-mono); letter-spacing: 0; font-variant-ligatures: none; }
.cond    { font-family: var(--f-cond); letter-spacing: var(--ls-tight); font-feature-settings: "tnum" 1; }
.caps    { text-transform: uppercase; letter-spacing: var(--ls-caps); font-family: var(--f-mono); font-weight: var(--w-mid); }
.meta    { font-family: var(--f-mono); font-size: var(--t-meta); letter-spacing: var(--ls-meta);
           text-transform: uppercase; color: var(--fg-3); }
.mission { font-family: var(--f-mono); letter-spacing: var(--ls-mission); text-transform: uppercase; }
.serif   { font-family: var(--f-serif); font-weight: var(--w-reg); font-style: italic; }
.big-num { font-family: var(--f-cond); font-weight: var(--w-bold); line-height: 0.86;
           letter-spacing: -0.04em; font-variant-numeric: tabular-nums; font-feature-settings: "tnum" 1; }
.t-minus { font-family: var(--f-cond); font-weight: var(--w-bold); letter-spacing: -0.03em;
           line-height: 0.9; font-variant-numeric: tabular-nums; }

/* ============================================================
   spec-sheet 装饰工具类（装饰层 · 受 showDeco 控制）
   ============================================================ */

/* 四角十字针脚 —— 卡片 / 框的角标 */
.cross { position: absolute; width: 12px; height: 12px; color: var(--accent); pointer-events: none; }
.cross::before, .cross::after { content: ""; position: absolute; background: currentColor; }
.cross::before { left: 5px; top: 0; width: 1px; height: 100%; }
.cross::after  { top: 5px; left: 0; width: 100%; height: 1px; }
.cross--tl { top: -6px; left: -6px; }
.cross--tr { top: -6px; right: -6px; }
.cross--bl { bottom: -6px; left: -6px; }
.cross--br { bottom: -6px; right: -6px; }

/* 刻度尺 —— 信号 / 时码感的底栏装饰 */
.tick-rule { display: flex; gap: 4px; align-items: flex-end; height: 14px; }
.tick-rule i { display: block; width: 1px; background: var(--fg-3); opacity: 0.5; }
.tick-rule i:nth-child(5n+1) { height: 14px; opacity: 1; }
.tick-rule i:nth-child(5n+2), .tick-rule i:nth-child(5n+3),
.tick-rule i:nth-child(5n+4), .tick-rule i:nth-child(5n+5) { height: 7px; }

/* 编号前缀 —— accent 短杠 + mono caps */
.idx { font-family: var(--f-mono); font-size: var(--t-cap); letter-spacing: var(--ls-mission);
       color: var(--fg-3); text-transform: uppercase; display: inline-flex; align-items: center; gap: 10px; }
.idx::before { content: ""; width: 22px; height: 1px; background: var(--accent); }

/* eyebrow —— 章节小标，accent 圆点引导 */
.eyebrow { font-family: var(--f-mono); font-size: var(--t-cap); letter-spacing: var(--ls-mission);
           text-transform: uppercase; color: var(--accent); display: inline-flex; align-items: center; gap: 8px; }
.eyebrow::before { content: "●"; font-size: 8px; }

/* 居中分隔标签 —— 文字两侧 hairline 延伸 */
.rule-label { display: flex; align-items: center; gap: 12px; font-family: var(--f-mono);
              font-size: var(--t-cap); letter-spacing: var(--ls-caps); color: var(--fg-3); }
.rule-label::before, .rule-label::after { content: ""; flex: 1; height: 1px; background: var(--line); }

/* spec-sheet 信息行 —— 仿 SpaceX 发射页 */
.spec-row { display: flex; align-items: center; gap: 14px; font-family: var(--f-mono);
            font-size: var(--t-cap); letter-spacing: var(--ls-mission); color: var(--fg-3);
            text-transform: uppercase; }
.spec-row b { color: var(--fg); font-weight: var(--w-mid); }
.spec-row .accent { color: var(--accent); }

/* 坐标块 —— 32°N 117°E 类装饰 */
.coord { font-family: var(--f-mono); font-size: var(--t-cap); letter-spacing: var(--ls-caps);
         color: var(--fg-3); text-transform: uppercase; }

/* 术语方括号 —— [KEYWORD] */
.bracket::before { content: "["; color: var(--accent); margin-right: 6px; }
.bracket::after  { content: "]"; color: var(--accent); margin-left: 6px; }

/* accent 下划高亮 —— 文字底部 12% 实色衬底 */
.under-accent { background-image: linear-gradient(to bottom, transparent 88%, var(--accent) 88%, var(--accent) 100%);
                background-repeat: no-repeat; padding: 0 2px; }

/* 呼吸点 —— LIVE 状态指示 */
.dot-pulse { position: relative; width: 8px; height: 8px; border-radius: 50%; background: var(--accent); }
.dot-pulse::after { content: ""; position: absolute; inset: -4px; border-radius: 50%;
                    border: 1px solid var(--accent); animation: dot-pulse 2.4s ease-out infinite; opacity: 0; }
@keyframes dot-pulse {
  0%   { transform: scale(0.6); opacity: 0.8; }
  100% { transform: scale(2.0); opacity: 0; }
}

/* 键帽 */
.kbd { display: inline-flex; align-items: center; justify-content: center; min-width: 22px;
       height: 22px; padding: 0 6px; font-family: var(--f-mono); font-size: var(--t-cap);
       color: var(--fg-2); border: 1px solid var(--line-2); border-radius: var(--r-1);
       background: rgba(255,255,255,0.02); }

/* ============================================================
   场景背景纹理（装饰层 · 一个场景最多用 1 种 · 受 showDeco 控制）
   ============================================================ */
.bg-dotgrid       { background-image: radial-gradient(rgba(255,255,255,0.07) 1px, transparent 1.2px);
                    background-size: 22px 22px; }
.bg-hairline-grid { background-image:
                      linear-gradient(to right,  rgba(255,255,255,0.05) 1px, transparent 1px),
                      linear-gradient(to bottom, rgba(255,255,255,0.05) 1px, transparent 1px);
                    background-size: 44px 44px; }
.bg-scan          { background-image: repeating-linear-gradient(0deg,
                      rgba(255,255,255,0.12) 0, rgba(255,255,255,0.12) 1px,
                      transparent 1px, transparent 4px); }

/* ---------- 通用入场动画 ---------- */
@keyframes enter-up   { from { opacity: 0; transform: translateY(8px); }  to { opacity: 1; transform: translateY(0); } }
@keyframes stick-in   { from { opacity: 0; transform: scale(0.92) rotate(-1.5deg); }
                        to   { opacity: 1; transform: scale(1) rotate(0); } }
@keyframes line-in    { from { transform: scaleX(0); } to { transform: scaleX(1); } }
CODEX_LAZYPACK_FE5170784990ADA8EAF79020D206141321114D63

# video-spec-builder/templates/video-spec-template.md
mkdir -p "$(dirname "{{CODEX_HOME}}/skills/video-spec-builder/templates/video-spec-template.md")"
cat > "{{CODEX_HOME}}/skills/video-spec-builder/templates/video-spec-template.md" <<'CODEX_LAZYPACK_DF7B7E9D0C0486AA1839F4142BD7F753AC2BE8D4'
---
name: video-spec-template
description: video-spec.md 的骨架模板。复制全文、把每个 [占位符] 换成真实内容，即得一份能整段交给渲染端 AI 的视频生成脚本——9 节 script，无 frontmatter。字段约束、规格校验、交付前自检见 references/spec-rules.md。
---

# Video Spec 模板

复制下面代码块整段，存成项目根目录的 `video-spec.md`。每个 `[方括号]` 是一个占位符——把方括号连同里面的说明文字，整个替换成你的真实内容。

填写时要查的文档：

- 字段约束 / 规格一致性校验 / 交付前自检清单 → `references/spec-rules.md`
- 分镜表「组件」字段填什么 ID → `references/components-catalog.md`
- 逐字稿 / 卖点怎么拆成一镜一镜 → `references/scene-breakdown.md`

---

```
请你按照以下 script，帮我生成一条视频。以下是这条视频的 script 和详细讲解。


## 1. 视频基本盘

- 标题：[视频标题]
- 目的：[这条视频要达成什么——让谁记住什么、看完去做什么]
- 受众：[目标观众是谁——职业、痛点或关注点、在什么场景观看]
- 观众熟悉度：[观众已经懂的术语，以及不要预设他懂的术语]
- 平台与时长：[在哪个平台播放、总时长多少]
- 画面规格：[画面比例、帧率、是否需要无声也能看懂]
- 输出：[文件格式、画质]
- 核心信息：[一句话 takeaway，短到能当大字海报标题]
- 信息密度：[整体是快节奏抓眼球、稳节奏讲清楚、还是慢节奏沉浸，一句话说明]
- 语气基调：[用什么风格说话，给一两个具体参考形象；以及明确不要的风格]


## 2. 叙事结构

- 叙事节拍：[把全片切成几段——每段占多少时间、各自的职责是什么]
- 情绪曲线：[开头、中段、收尾分别是什么情绪，要有变化方向]
- 音画关系：[BGM 是叙事性还是氛围性；标出至少一处音画错位的地方]
- 同质化反例：[这条视频在视觉、叙事、节奏上分别不要做成什么样]


## 3. 表达手段

- 场景类型组合：[这条视频用哪几种画面手段，按出现顺序列出]
- 字幕呈现：[字幕怎么出现——整句、关键词高亮、还是逐词卡拉 OK]
- 关键词强调：[要不要画圈、高亮、手绘标记这类强调；不要就写不需要]
- 文字动效：[要不要打字机、动态字重这类文字动画]
- 3D：[要不要 3D；要的话用在哪、模型从哪来]
- 转场风格：[转场整体怎么处理——硬切为主还是多用花式转场，大致比例]
- 特殊视觉：[要不要 shader 转场、音频反应可视化、路径动画这类；要就说用在哪]
- 节奏基准：[平均每个镜头多少秒、旁白总字数大概多少]


## 4. 视觉规范

- 视觉主题：[预设名（如 Swiss Pulse），或自定义主题写 "design.md（项目根目录）"]
- accent 色：[强调色，不改写默认，改就给具体色值]
- 装饰密度：[画面装饰偏多还是偏少]
- 组件取舍：[有没有特别想用、或绝对不要用的组件；没有就写无]


## 5. 素材清单

### 已有素材

[逐项列出手头已有的素材——旁白脚本、视频片段、真人出镜、图片、数据、Logo、字体、3D 模型等，每项给出具体文件路径]

### 待生成素材

[需要现场生成的素材——比如 TTS 旁白、字幕、抠像，每项写清楚怎么生成、产出到哪个文件]

### 待搜索素材

[需要去素材网站找的东西，每条写清楚：去哪个平台、搜什么英文关键词、用在哪、验收标准是什么。没有就写「无搜索素材需求」]


## 6. 分镜表

一个镜头一段，从 Scene 01 起补零编号。每个镜头按下面的字段写：

### Scene 01 · [起始秒]–[结束秒] · [这一镜在叙事里的角色]

- 类型：[主线讲解镜、辅助镜、还是纯过场转场]
- 组件：[这一镜用哪个组件，填 components-catalog.md 里的真实组件 ID]
- 旁白文案：[这一镜的完整旁白原文；没有旁白就写无]
- 屏显文案：[屏幕上显示的文字，可以和旁白不一样；没有就写无]
- 期待内容：[这一镜要传达的具体内容——数据、概念、情绪还是动作]
- 期待效果：[观众看完这一镜该产生什么反应——震撼、理解、记住、共鸣]
- 画面描述：[镜头里有什么、怎么布局、是否 3D、9:16 还是 16:9 怎么适配、关键视觉元素]
- 动效要点：[画面怎么动，用动词描述，不写具体毫秒和缓动参数]
- 音效描述：[有没有音效；有就写什么音效、什么时间点、音量多大；没有写无]
- 转场进入：[这一镜怎么切入]
- 转场离开：[这一镜怎么切出]
- 素材依赖：[这一镜用到哪些具体素材]

### Scene 02 · ……

[后面每个镜头依此类推，字段相同]


## 7. 音频时间轴

- 旁白：[每段旁白的起止时间、来源、音量]
- 背景音乐：[BGM 的起止时间、文件、音量、淡入淡出；旁白出现时压低到多少]
- 音效：[每个音效的时间点、是什么、文件、音量]


## 8. 参考与反例

- 正向参考：[一到三个具体参考作品，每个说清楚像在哪、又有哪一点要做得不一样]
- 静态参考：[海报、截图这类静态参考，说清楚参考它的哪一点]
- 反例：[明确不想做成的样子——具体的视频或友商，以及讨厌它哪一点]


## 9. 开放问题

[还没定下来、需要补充或需要和用户确认的点，逐条列出；全都定了就写「无，spec 已完整」]
```
CODEX_LAZYPACK_DF7B7E9D0C0486AA1839F4142BD7F753AC2BE8D4

echo "video-spec-builder installed:"
test -f "{{CODEX_HOME}}/skills/video-spec-builder/SKILL.md" && echo "- video-spec-builder"
````

<!-- END EMBEDDED_SKILLS -->
