import React, { useState, useEffect, useRef } from "react";
import {
  Moon, Mic, Sparkles, BookOpen, BarChart3, ChevronDown, ChevronRight,
  Feather, Brain, Compass, Globe2, Sun, ScrollText, ArrowLeft, Plus,
  CircleDot, Wind, Waves, Bug, Plane, DoorOpen, Check
} from "lucide-react";

/* ------------------------------------------------------------------ */
/*  Design tokens — "Night Garden" system                              */
/* ------------------------------------------------------------------ */
const T = {
  ink: "#F4F1FF",
  inkSoft: "rgba(244,241,255,0.64)",
  inkFaint: "rgba(244,241,255,0.40)",
  lavender: "#B9A8F7",
  peach: "#F2B8A2",
  teal: "#8FE3D2",
  rose: "#EEA7C4",
  glass: "rgba(255,255,255,0.065)",
  glassStrong: "rgba(255,255,255,0.10)",
  stroke: "rgba(255,255,255,0.14)",
};

const glass = (extra = {}) => ({
  background: T.glass,
  border: `1px solid ${T.stroke}`,
  backdropFilter: "blur(24px)",
  WebkitBackdropFilter: "blur(24px)",
  borderRadius: 24,
  boxShadow: "0 8px 32px rgba(6,4,22,0.35), inset 0 1px 0 rgba(255,255,255,0.08)",
  ...extra,
});

/* ------------------------------------------------------------------ */
/*  Demo content — the "giant mosquito in Japan" dream                 */
/* ------------------------------------------------------------------ */
const DEMO_DREAM =
  "I was traveling with friends to a park in Japan. There was a rumor that Japanese mosquitoes were huge. I stayed outside the park while others entered. Suddenly everyone ran back out saying the mosquitoes really were huge, and then a giant black mosquito larger than a football flew out of the park.";

const PERSPECTIVES = [
  {
    id: "zhougong",
    name: "Zhougong (周公解梦)",
    tag: "Classical Chinese",
    icon: ScrollText,
    color: T.peach,
    weight: 14,
    short: "Mosquitoes are 'small troubles' — yours has been fed by worry.",
    full:
      "In the Zhougong tradition, mosquitoes represent minor nuisances or draining people (小人) circling your life. A mosquito grown monstrous suggests a small concern that has been allowed to swell far beyond its true size. Remaining outside the gate is read favorably: prudence at a threshold protects you from a trouble others rush into.",
    contributed: "Anchored the idea that the threat began small — the dream is about growth of worry, not the worry itself.",
  },
  {
    id: "freud",
    name: "Freudian",
    tag: "Psychoanalysis",
    icon: Feather,
    color: T.rose,
    weight: 18,
    short: "An anticipatory anxiety, inflated by the group, then confirmed.",
    full:
      "The rumor of huge mosquitoes is anticipatory anxiety: a fear rehearsed before any encounter. The insect condenses a vaguer worry about being intruded upon or 'drained.' Waiting outside is a classic avoidance compromise — you satisfy the wish to belong (you traveled with friends) while defending against the feared contact. The dream then vindicates the avoidance: the threat is real, and enormous.",
    contributed: "Identified avoidance-with-belonging as the central tension, and the rumor as rehearsed fear.",
  },
  {
    id: "jung",
    name: "Jungian",
    tag: "Analytical psychology",
    icon: Compass,
    color: T.lavender,
    weight: 24,
    short: "A small shadow-fear given monstrous, almost mythic form.",
    full:
      "The park gate is a threshold archetype — a boundary between the known self and unexplored territory. Friends cross; the dreamer waits. The giant black mosquito is a shadow figure: an ordinary irritation the psyche has mythologized so it can finally be seen. That it flies out to meet you suggests the confrontation cannot be outsourced to the group — the exaggerated fear seeks you specifically, asking to be examined rather than fled.",
    contributed: "Framed the mosquito as your own exaggerated fear personified, and the gate as a decision point.",
  },
  {
    id: "neuro",
    name: "Neuroscience",
    tag: "Modern research",
    icon: Brain,
    color: T.teal,
    weight: 20,
    short: "REM threat-simulation, primed by expectation and social contagion.",
    full:
      "This fits threat-simulation theory: during REM sleep the amygdala rehearses danger in exaggerated form, at low cost. Predictive-processing research adds a neat detail — the 'rumor' primes the perception, so the brain renders exactly what was expected, only larger. Fear spreading through the group of friends mirrors social threat contagion, which the sleeping brain readily amplifies.",
    contributed: "Explained the mechanism: expectation shaped the imagery, and the exaggeration is rehearsal, not prophecy.",
  },
  {
    id: "culture",
    name: "Cultural symbolism",
    tag: "Cross-cultural",
    icon: Globe2,
    color: "#A8C7F5",
    weight: 12,
    short: "Travel novelty plus folklore-scale exaggeration of the unfamiliar.",
    full:
      "Dreams set abroad often process novelty stress — the low hum of navigating an unfamiliar place. Japanese folklore is rich with ordinary creatures grown uncanny (yōkai), and the football-sized mosquito borrows that grammar: the foreign is rendered as the familiar, magnified. A park — curated nature — hiding something wild inverts the promise of safety in the unfamiliar.",
    contributed: "Placed the imagery in a travel/novelty context, softening the personal-threat reading.",
  },
  {
    id: "spirit",
    name: "Spiritual",
    tag: "Contemplative",
    icon: Sun,
    color: "#F5DFA8",
    weight: 12,
    short: "A messenger insisting a small irritation carries a lesson.",
    full:
      "In many contemplative traditions the mosquito is a persistent messenger: a small thing that will keep returning, and growing, until it receives attention. Honoring your instinct to pause at the threshold is read as intuition working correctly. The dream does not punish the pause — it rewards it with clarity about what everyone else ran from.",
    contributed: "Reframed the pause at the gate as wisdom rather than fear, and the mosquito as a signal worth heeding.",
  },
];

const RESULT = {
  summary:
    "A small, nagging worry has grown larger in your mind than in reality — and your instinct to pause before rushing in is quietly protecting you.",
  confidence: 78,
  tones: [
    { label: "Anticipation", color: T.lavender },
    { label: "Anxiety", color: T.rose },
    { label: "Relief", color: T.teal },
    { label: "Awe", color: T.peach },
  ],
  synthesis:
    "Every lens converges on one shape: something genuinely minor — an irritation, a doubt, a draining obligation — has been fed by rumor, expectation, and group emotion until it looks monstrous. The neuroscience view explains how (expectation renders what it predicts, larger); Zhougong and the spiritual view name what (a small trouble left unattended); Freud and Jung locate where you stand (at a threshold, choosing between belonging and self-protection). Notably, the dream never harms you. You paused, you observed, and the exaggerated fear revealed itself. The synthesis is not 'you are in danger' — it is 'look directly at the small thing before it grows again.'",
  mainMessage:
    "Name the mosquito. Somewhere in waking life there is a small, buzzing concern you have been managing by keeping your distance. The dream suggests distance has stopped working — the worry now arrives on its own.",
  concerns: [
    "A minor obligation or friction (work, social, or health) that you have postponed examining directly.",
    "Sensitivity to group opinion — the rumor moved through friends before anything was seen.",
    "A quiet fear of being 'drained' by something or someone if you commit fully.",
  ],
  opportunities: [
    { kind: "opportunity", text: "Your pause at the gate was discernment, not cowardice — trust it in one real decision this week." },
    { kind: "opportunity", text: "Exaggerated fears, once seen clearly, tend to shrink fast. The hard part is the looking." },
    { kind: "warning", text: "Avoidance is rewarding in the short term; the dream hints the worry will keep growing if only observed from outside." },
    { kind: "warning", text: "Borrowed anxiety: check whether this fear is originally yours, or absorbed from people around you." },
  ],
  questions: [
    "What is the smallest real-life version of the mosquito — the thing that buzzes at me most evenings?",
    "Whose voice first told me it was 'huge'? Have I verified that myself?",
    "Where am I currently waiting outside a gate while others go in — and is waiting still serving me?",
    "If the fear were exactly football-sized and no larger, what would I do tomorrow?",
  ],
  actions: [
    "Write down the one recurring worry that best matches the mosquito, in a single honest sentence.",
    "Spend 15 focused minutes gathering first-hand facts about it — replace the rumor with observation.",
    "Tell one of the 'friends' from the dream (or a real confidant) what the worry actually is.",
    "Before sleep tonight, revisit the gate in imagination and watch the mosquito calmly, without running.",
  ],
};

const HISTORY = [
  {
    id: "h1",
    title: "The giant mosquito at the park gate",
    date: "Today · 6:42 AM",
    excerpt: "Traveling with friends in Japan… a mosquito larger than a football flew out of the park.",
    tone: "Anxiety → Relief",
    color: T.lavender,
    symbols: ["Insect", "Threshold", "Travel"],
    isDemo: true,
  },
  {
    id: "h2",
    title: "The endless library",
    date: "Jul 2 · 7:15 AM",
    excerpt: "Shelves rearranged themselves as I walked; every book had my handwriting inside.",
    tone: "Curiosity",
    color: T.teal,
    symbols: ["Books", "Maze", "Self"],
  },
  {
    id: "h3",
    title: "Glass elevator over the sea",
    date: "Jun 28 · 5:58 AM",
    excerpt: "Rising slowly above a calm ocean at dusk. I wasn't afraid of the height at all.",
    tone: "Wonder",
    color: "#A8C7F5",
    symbols: ["Water", "Height", "Threshold"],
  },
  {
    id: "h4",
    title: "Late for the flight, no shoes",
    date: "Jun 21 · 6:30 AM",
    excerpt: "The gate kept moving further away and my boarding pass turned into a leaf.",
    tone: "Stress",
    color: T.rose,
    symbols: ["Travel", "Time", "Unprepared"],
  },
  {
    id: "h5",
    title: "Grandmother's kitchen",
    date: "Jun 14 · 8:02 AM",
    excerpt: "Warm bread, steam on the windows, a song I couldn't quite remember on the radio.",
    tone: "Nostalgia",
    color: T.peach,
    symbols: ["Home", "Food", "Memory"],
  },
];

const SYMBOL_STATS = [
  { label: "Travel", count: 4, icon: Plane },
  { label: "Thresholds", count: 3, icon: DoorOpen },
  { label: "Water", count: 3, icon: Waves },
  { label: "Insects", count: 2, icon: Bug },
];

const EMOTION_STATS = [
  { label: "Curiosity", count: 5, color: T.teal },
  { label: "Anxiety", count: 4, color: T.rose },
  { label: "Wonder", count: 3, color: "#A8C7F5" },
  { label: "Nostalgia", count: 2, color: T.peach },
];

const FREQ = [1, 0, 2, 1, 0, 1, 1, 0, 1, 2, 0, 1, 0, 1]; // last 14 nights
const TREND = [52, 58, 47, 61, 55, 64, 60, 71, 66, 74]; // emotional balance score

/* ------------------------------------------------------------------ */
/*  Shared bits                                                        */
/* ------------------------------------------------------------------ */
const SectionLabel = ({ children }) => (
  <div style={{
    fontSize: 11, letterSpacing: "0.14em", textTransform: "uppercase",
    color: T.inkFaint, fontWeight: 600, marginBottom: 10,
  }}>{children}</div>
);

const Chip = ({ label, color }) => (
  <span style={{
    display: "inline-flex", alignItems: "center", gap: 6,
    padding: "6px 12px", borderRadius: 999, fontSize: 12.5, fontWeight: 500,
    color: T.ink, background: "rgba(255,255,255,0.07)",
    border: `1px solid ${T.stroke}`,
  }}>
    <span style={{ width: 7, height: 7, borderRadius: 99, background: color }} />
    {label}
  </span>
);

const Orb = ({ size = 120, breathing = true }) => (
  <div aria-hidden style={{
    width: size, height: size, borderRadius: "50%", position: "relative",
    animation: breathing ? "breathe 4.5s ease-in-out infinite" : "none",
  }}>
    <div style={{
      position: "absolute", inset: 0, borderRadius: "50%",
      background: "radial-gradient(circle at 32% 30%, rgba(255,255,255,0.55), rgba(185,168,247,0.55) 32%, rgba(143,227,210,0.35) 62%, rgba(238,167,196,0.28) 100%)",
      filter: "blur(1px)",
      boxShadow: "0 0 60px rgba(185,168,247,0.45), 0 0 120px rgba(143,227,210,0.18), inset 0 0 40px rgba(255,255,255,0.25)",
    }} />
    <div style={{
      position: "absolute", inset: -18, borderRadius: "50%",
      border: "1px solid rgba(255,255,255,0.10)",
      animation: breathing ? "ringPulse 4.5s ease-in-out infinite" : "none",
    }} />
  </div>
);

const ConfidenceRing = ({ value }) => {
  const r = 34, c = 2 * Math.PI * r;
  return (
    <div style={{ position: "relative", width: 88, height: 88, flexShrink: 0 }}
      role="img" aria-label={`Interpretation confidence ${value} percent`}>
      <svg width="88" height="88" viewBox="0 0 88 88">
        <circle cx="44" cy="44" r={r} fill="none" stroke="rgba(255,255,255,0.10)" strokeWidth="7" />
        <circle cx="44" cy="44" r={r} fill="none" stroke="url(#confGrad)" strokeWidth="7"
          strokeLinecap="round" strokeDasharray={c}
          strokeDashoffset={c * (1 - value / 100)}
          transform="rotate(-90 44 44)"
          style={{ transition: "stroke-dashoffset 1.4s cubic-bezier(.22,1,.36,1)" }} />
        <defs>
          <linearGradient id="confGrad" x1="0" y1="0" x2="1" y2="1">
            <stop offset="0%" stopColor={T.lavender} />
            <stop offset="100%" stopColor={T.teal} />
          </linearGradient>
        </defs>
      </svg>
      <div style={{
        position: "absolute", inset: 0, display: "flex", flexDirection: "column",
        alignItems: "center", justifyContent: "center",
      }}>
        <span style={{ fontSize: 20, fontWeight: 650, color: T.ink }}>{value}%</span>
        <span style={{ fontSize: 9.5, color: T.inkFaint, letterSpacing: "0.06em" }}>confidence</span>
      </div>
    </div>
  );
};

/* ------------------------------------------------------------------ */
/*  Screens                                                            */
/* ------------------------------------------------------------------ */
function InputScreen({ text, setText, onInterpret }) {
  const [recording, setRecording] = useState(false);
  const timerRef = useRef(null);

  const toggleVoice = () => {
    if (recording) { clearTimeout(timerRef.current); setRecording(false); return; }
    setRecording(true);
    timerRef.current = setTimeout(() => {
      setText(DEMO_DREAM);
      setRecording(false);
    }, 2200);
  };
  useEffect(() => () => clearTimeout(timerRef.current), []);

  return (
    <div style={{ padding: "0 20px 120px" }}>
      <div style={{ display: "flex", flexDirection: "column", alignItems: "center", paddingTop: 36, paddingBottom: 26 }}>
        <Orb size={110} />
        <h1 style={{
          margin: "26px 0 6px", fontSize: 26, fontWeight: 600, letterSpacing: "-0.02em", color: T.ink,
        }}>Good morning</h1>
        <p style={{ margin: 0, fontSize: 14.5, color: T.inkSoft, textAlign: "center", lineHeight: 1.5 }}>
          What did you dream last night?
        </p>
      </div>

      <div style={glass({ padding: 18 })}>
        <textarea
          aria-label="Describe your dream"
          value={text}
          onChange={(e) => setText(e.target.value)}
          placeholder="Describe your dream while it's still fresh…"
          rows={7}
          style={{
            width: "100%", background: "transparent", border: "none", outline: "none",
            resize: "none", color: T.ink, fontSize: 15.5, lineHeight: 1.65,
            fontFamily: "Georgia, 'Times New Roman', serif", fontStyle: text ? "normal" : "italic",
          }}
        />
        <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", marginTop: 8 }}>
          <button onClick={toggleVoice} aria-label={recording ? "Stop voice input" : "Start voice input"}
            style={{
              display: "flex", alignItems: "center", gap: 8, cursor: "pointer",
              padding: "10px 14px", borderRadius: 999, minHeight: 44,
              background: recording ? "rgba(238,167,196,0.18)" : "rgba(255,255,255,0.07)",
              border: `1px solid ${recording ? "rgba(238,167,196,0.5)" : T.stroke}`,
              color: recording ? T.rose : T.inkSoft, fontSize: 13, fontWeight: 500,
              transition: "all 220ms ease",
            }}>
            <Mic size={16} />
            {recording ? (
              <span style={{ display: "flex", alignItems: "center", gap: 3 }}>
                Listening
                <span style={{ display: "inline-flex", gap: 2.5, marginLeft: 4 }} aria-hidden>
                  {[0, 1, 2, 3].map(i => (
                    <span key={i} style={{
                      width: 3, borderRadius: 2, background: T.rose,
                      animation: `wave 0.9s ease-in-out ${i * 0.12}s infinite`,
                      height: 12, display: "inline-block",
                    }} />
                  ))}
                </span>
              </span>
            ) : "Speak instead"}
          </button>
          <span style={{ fontSize: 11.5, color: T.inkFaint }}>{text.length} chars</span>
        </div>
      </div>

      {!text && (
        <button onClick={() => setText(DEMO_DREAM)} style={{
          marginTop: 14, width: "100%", cursor: "pointer",
          ...glass({ padding: "14px 16px", borderRadius: 18 }),
          display: "flex", alignItems: "center", gap: 10, textAlign: "left",
        }}>
          <Sparkles size={16} color={T.lavender} style={{ flexShrink: 0 }} />
          <span style={{ fontSize: 13, color: T.inkSoft, lineHeight: 1.45 }}>
            Try the sample dream — <em style={{ color: T.ink }}>a giant mosquito at a park in Japan</em>
          </span>
          <ChevronRight size={15} color={T.inkFaint} style={{ marginLeft: "auto", flexShrink: 0 }} />
        </button>
      )}

      <button
        onClick={onInterpret}
        disabled={!text.trim()}
        style={{
          marginTop: 18, width: "100%", padding: "16px 0", minHeight: 52,
          borderRadius: 999, border: "none", cursor: text.trim() ? "pointer" : "default",
          fontSize: 15.5, fontWeight: 600, letterSpacing: "0.01em",
          color: text.trim() ? "#171233" : T.inkFaint,
          background: text.trim()
            ? "linear-gradient(120deg, #CFC2FA, #9FE8D8)"
            : "rgba(255,255,255,0.06)",
          boxShadow: text.trim() ? "0 6px 28px rgba(185,168,247,0.35)" : "none",
          transition: "all 260ms ease",
        }}>
        Interpret this dream
      </button>
      <p style={{ textAlign: "center", fontSize: 11.5, color: T.inkFaint, marginTop: 12 }}>
        Reflections, not predictions · For self-exploration only
      </p>
    </div>
  );
}

function AnalyzingScreen() {
  const steps = [
    "Listening to the dream…",
    "Consulting six traditions…",
    "Weighing perspectives…",
    "Composing your reading…",
  ];
  const [i, setI] = useState(0);
  useEffect(() => {
    const t = setInterval(() => setI(v => Math.min(v + 1, steps.length - 1)), 700);
    return () => clearInterval(t);
  }, []);
  return (
    <div style={{
      minHeight: "70vh", display: "flex", flexDirection: "column",
      alignItems: "center", justifyContent: "center", padding: 20,
    }} aria-live="polite">
      <Orb size={140} />
      <p style={{ marginTop: 34, fontSize: 15.5, color: T.ink, fontWeight: 500 }}>{steps[i]}</p>
      <div style={{ display: "flex", gap: 6, marginTop: 14 }} aria-hidden>
        {steps.map((_, k) => (
          <span key={k} style={{
            width: k === i ? 18 : 6, height: 6, borderRadius: 99,
            background: k <= i ? T.lavender : "rgba(255,255,255,0.14)",
            transition: "all 300ms ease",
          }} />
        ))}
      </div>
    </div>
  );
}

function PerspectiveCard({ p, open, onToggle }) {
  const Icon = p.icon;
  return (
    <div style={glass({ padding: 0, overflow: "hidden", borderRadius: 20 })}>
      <button onClick={onToggle} aria-expanded={open}
        style={{
          width: "100%", display: "flex", alignItems: "center", gap: 12,
          padding: "14px 16px", background: "transparent", border: "none",
          cursor: "pointer", textAlign: "left", minHeight: 56,
        }}>
        <span style={{
          width: 38, height: 38, borderRadius: 12, flexShrink: 0,
          display: "flex", alignItems: "center", justifyContent: "center",
          background: `${p.color}22`, border: `1px solid ${p.color}55`,
        }}>
          <Icon size={18} color={p.color} />
        </span>
        <span style={{ flex: 1, minWidth: 0 }}>
          <span style={{ display: "block", fontSize: 14.5, fontWeight: 600, color: T.ink }}>{p.name}</span>
          <span style={{ display: "block", fontSize: 12, color: T.inkFaint }}>{p.tag} · {p.weight}% weight</span>
        </span>
        <ChevronDown size={17} color={T.inkFaint}
          style={{ transform: open ? "rotate(180deg)" : "none", transition: "transform 240ms ease", flexShrink: 0 }} />
      </button>
      <div style={{
        maxHeight: open ? 400 : 0, opacity: open ? 1 : 0, overflow: "hidden",
        transition: "max-height 320ms cubic-bezier(.22,1,.36,1), opacity 240ms ease",
      }}>
        <div style={{ padding: "0 16px 16px" }}>
          <p style={{ margin: "0 0 10px", fontSize: 13.5, lineHeight: 1.65, color: T.inkSoft }}>{p.full}</p>
          <div style={{
            padding: "10px 12px", borderRadius: 12, fontSize: 12.5, lineHeight: 1.55,
            background: `${p.color}14`, border: `1px solid ${p.color}33`, color: T.ink,
          }}>
            <strong style={{ fontWeight: 600 }}>Contributed:</strong> {p.contributed}
          </div>
        </div>
      </div>
      {!open && (
        <p style={{ margin: 0, padding: "0 16px 14px 66px", fontSize: 12.5, color: T.inkSoft, lineHeight: 1.5 }}>
          {p.short}
        </p>
      )}
    </div>
  );
}

function ResultScreen({ dreamText, onBack, onSave, saved }) {
  const [openId, setOpenId] = useState("jung");
  return (
    <div style={{ padding: "0 20px 130px" }}>
      <div style={{ display: "flex", alignItems: "center", gap: 10, paddingTop: 18, marginBottom: 14 }}>
        <button onClick={onBack} aria-label="Back"
          style={{
            width: 40, height: 40, borderRadius: 999, cursor: "pointer",
            display: "flex", alignItems: "center", justifyContent: "center",
            background: "rgba(255,255,255,0.07)", border: `1px solid ${T.stroke}`, color: T.inkSoft,
          }}>
          <ArrowLeft size={17} />
        </button>
        <div>
          <div style={{ fontSize: 15.5, fontWeight: 600, color: T.ink }}>Your reading</div>
          <div style={{ fontSize: 11.5, color: T.inkFaint }}>Thursday, July 9 · six perspectives</div>
        </div>
      </div>

      {/* The dream itself */}
      <div style={glass({ padding: 18 })}>
        <SectionLabel>The dream</SectionLabel>
        <p style={{
          margin: 0, fontFamily: "Georgia, 'Times New Roman', serif", fontStyle: "italic",
          fontSize: 15, lineHeight: 1.7, color: T.ink,
        }}>
          “{dreamText}”
        </p>
      </div>

      {/* Summary + confidence + tone */}
      <div style={glass({ padding: 18, marginTop: 14 })}>
        <div style={{ display: "flex", gap: 16, alignItems: "center" }}>
          <ConfidenceRing value={RESULT.confidence} />
          <p style={{ margin: 0, fontSize: 15, lineHeight: 1.6, color: T.ink, fontWeight: 500 }}>
            {RESULT.summary}
          </p>
        </div>
        <div style={{ marginTop: 16 }}>
          <SectionLabel>Emotional tone detected</SectionLabel>
          <div style={{ display: "flex", flexWrap: "wrap", gap: 8 }}>
            {RESULT.tones.map(t => <Chip key={t.label} label={t.label} color={t.color} />)}
          </div>
        </div>
      </div>

      {/* Six lenses */}
      <div style={{ marginTop: 26 }}>
        <SectionLabel>Six lenses</SectionLabel>
        <div style={{ display: "flex", flexDirection: "column", gap: 10 }}>
          {PERSPECTIVES.map(p => (
            <PerspectiveCard key={p.id} p={p} open={openId === p.id}
              onToggle={() => setOpenId(openId === p.id ? null : p.id)} />
          ))}
        </div>
      </div>

      {/* Contribution bar */}
      <div style={glass({ padding: 18, marginTop: 14 })}>
        <SectionLabel>How each lens shaped the conclusion</SectionLabel>
        <div style={{
          display: "flex", height: 14, borderRadius: 99, overflow: "hidden",
          border: `1px solid ${T.stroke}`,
        }} role="img" aria-label="Contribution of each perspective to the final interpretation">
          {PERSPECTIVES.map(p => (
            <div key={p.id} title={`${p.name} ${p.weight}%`}
              style={{ width: `${p.weight}%`, background: p.color, opacity: 0.85 }} />
          ))}
        </div>
        <div style={{ display: "flex", flexWrap: "wrap", gap: "6px 14px", marginTop: 12 }}>
          {PERSPECTIVES.map(p => (
            <span key={p.id} style={{ display: "flex", alignItems: "center", gap: 6, fontSize: 11.5, color: T.inkSoft }}>
              <span style={{ width: 8, height: 8, borderRadius: 3, background: p.color }} />
              {p.name.split(" ")[0]} {p.weight}%
            </span>
          ))}
        </div>
      </div>

      {/* Synthesis */}
      <div style={glass({
        padding: 20, marginTop: 26,
        background: "linear-gradient(140deg, rgba(185,168,247,0.14), rgba(143,227,210,0.10))",
        border: "1px solid rgba(185,168,247,0.35)",
      })}>
        <div style={{ display: "flex", alignItems: "center", gap: 8, marginBottom: 10 }}>
          <Sparkles size={15} color={T.lavender} />
          <span style={{ fontSize: 13, fontWeight: 650, letterSpacing: "0.06em", color: T.ink, textTransform: "uppercase" }}>
            Synthesis
          </span>
        </div>
        <p style={{ margin: 0, fontSize: 14.5, lineHeight: 1.75, color: T.ink }}>{RESULT.synthesis}</p>
      </div>

      {/* Sections */}
      <div style={glass({ padding: 18, marginTop: 14 })}>
        <SectionLabel>Main message</SectionLabel>
        <p style={{ margin: 0, fontSize: 14.5, lineHeight: 1.7, color: T.ink }}>{RESULT.mainMessage}</p>
      </div>

      <div style={glass({ padding: 18, marginTop: 14 })}>
        <SectionLabel>Possible subconscious concerns</SectionLabel>
        {RESULT.concerns.map((c, i) => (
          <p key={i} style={{
            margin: i ? "10px 0 0" : 0, fontSize: 13.5, lineHeight: 1.6, color: T.inkSoft,
            paddingLeft: 16, position: "relative",
          }}>
            <span style={{ position: "absolute", left: 0, top: 8, width: 5, height: 5, borderRadius: 99, background: T.rose }} />
            {c}
          </p>
        ))}
      </div>

      <div style={glass({ padding: 18, marginTop: 14 })}>
        <SectionLabel>Opportunities &amp; warnings</SectionLabel>
        <div style={{ display: "flex", flexDirection: "column", gap: 10 }}>
          {RESULT.opportunities.map((o, i) => (
            <div key={i} style={{
              display: "flex", gap: 10, padding: "10px 12px", borderRadius: 14,
              background: o.kind === "opportunity" ? "rgba(143,227,210,0.10)" : "rgba(238,167,196,0.10)",
              border: `1px solid ${o.kind === "opportunity" ? "rgba(143,227,210,0.30)" : "rgba(238,167,196,0.30)"}`,
            }}>
              <span style={{
                fontSize: 10, fontWeight: 700, letterSpacing: "0.08em", flexShrink: 0, marginTop: 3,
                color: o.kind === "opportunity" ? T.teal : T.rose, textTransform: "uppercase",
              }}>
                {o.kind === "opportunity" ? "Open" : "Watch"}
              </span>
              <span style={{ fontSize: 13.5, lineHeight: 1.55, color: T.ink }}>{o.text}</span>
            </div>
          ))}
        </div>
      </div>

      <div style={glass({ padding: 18, marginTop: 14 })}>
        <SectionLabel>Questions for reflection</SectionLabel>
        {RESULT.questions.map((q, i) => (
          <p key={i} style={{
            margin: i ? "12px 0 0" : 0, fontSize: 14, lineHeight: 1.65, color: T.ink,
            fontFamily: "Georgia, 'Times New Roman', serif", fontStyle: "italic",
          }}>
            {q}
          </p>
        ))}
      </div>

      <div style={glass({ padding: 18, marginTop: 14 })}>
        <SectionLabel>Gentle actions · next few days</SectionLabel>
        <div style={{ display: "flex", flexDirection: "column", gap: 10 }}>
          {RESULT.actions.map((a, i) => (
            <div key={i} style={{ display: "flex", gap: 12, alignItems: "flex-start" }}>
              <span style={{
                width: 24, height: 24, borderRadius: 99, flexShrink: 0, marginTop: 1,
                display: "flex", alignItems: "center", justifyContent: "center",
                background: "rgba(185,168,247,0.16)", border: "1px solid rgba(185,168,247,0.35)",
                fontSize: 11.5, fontWeight: 650, color: T.lavender,
              }}>{i + 1}</span>
              <span style={{ fontSize: 13.5, lineHeight: 1.6, color: T.inkSoft }}>{a}</span>
            </div>
          ))}
        </div>
      </div>

      <button onClick={onSave} disabled={saved}
        style={{
          marginTop: 22, width: "100%", padding: "15px 0", minHeight: 52, borderRadius: 999,
          border: `1px solid ${saved ? "rgba(143,227,210,0.5)" : T.stroke}`, cursor: saved ? "default" : "pointer",
          fontSize: 15, fontWeight: 600,
          color: saved ? T.teal : T.ink,
          background: saved ? "rgba(143,227,210,0.12)" : "rgba(255,255,255,0.08)",
          backdropFilter: "blur(20px)", WebkitBackdropFilter: "blur(20px)",
          display: "flex", alignItems: "center", justifyContent: "center", gap: 8,
          transition: "all 260ms ease",
        }}>
        {saved ? (<><Check size={17} /> Saved to journal</>) : "Save to dream journal"}
      </button>
    </div>
  );
}

function HistoryScreen({ dreams, onOpen }) {
  return (
    <div style={{ padding: "0 20px 120px" }}>
      <div style={{ paddingTop: 30, marginBottom: 20 }}>
        <h1 style={{ margin: 0, fontSize: 26, fontWeight: 600, letterSpacing: "-0.02em", color: T.ink }}>Dream journal</h1>
        <p style={{ margin: "6px 0 0", fontSize: 13.5, color: T.inkSoft }}>{dreams.length} dreams recorded · June – July</p>
      </div>
      <div style={{ display: "flex", flexDirection: "column", gap: 14 }}>
        {dreams.map(d => (
          <button key={d.id} onClick={() => d.isDemo && onOpen()}
            style={{
              ...glass({ padding: 18, borderRadius: 22 }),
              textAlign: "left", cursor: d.isDemo ? "pointer" : "default",
              position: "relative", overflow: "hidden", width: "100%",
            }}>
            <div aria-hidden style={{
              position: "absolute", top: -50, right: -50, width: 150, height: 150, borderRadius: "50%",
              background: `radial-gradient(circle, ${d.color}33, transparent 70%)`, pointerEvents: "none",
            }} />
            <div style={{ display: "flex", justifyContent: "space-between", alignItems: "baseline", gap: 10 }}>
              <span style={{ fontSize: 15.5, fontWeight: 600, color: T.ink, lineHeight: 1.35 }}>{d.title}</span>
              {d.isDemo && <ChevronRight size={16} color={T.inkFaint} style={{ flexShrink: 0 }} />}
            </div>
            <div style={{ fontSize: 11.5, color: T.inkFaint, marginTop: 3 }}>{d.date}</div>
            <p style={{
              margin: "10px 0 12px", fontSize: 13.5, lineHeight: 1.6, color: T.inkSoft,
              fontFamily: "Georgia, 'Times New Roman', serif", fontStyle: "italic",
            }}>“{d.excerpt}”</p>
            <div style={{ display: "flex", flexWrap: "wrap", gap: 6, alignItems: "center" }}>
              <Chip label={d.tone} color={d.color} />
              {d.symbols.map(s => (
                <span key={s} style={{ fontSize: 11.5, color: T.inkFaint, padding: "5px 9px", borderRadius: 99, border: `1px solid ${T.stroke}` }}>{s}</span>
              ))}
            </div>
          </button>
        ))}
      </div>
    </div>
  );
}

function DashboardScreen() {
  const maxFreq = Math.max(...FREQ);
  const w = 300, h = 96;
  const pts = TREND.map((v, i) => `${(i / (TREND.length - 1)) * w},${h - ((v - 40) / 40) * h}`).join(" ");
  const maxEmo = Math.max(...EMOTION_STATS.map(e => e.count));

  return (
    <div style={{ padding: "0 20px 120px" }}>
      <div style={{ paddingTop: 30, marginBottom: 20 }}>
        <h1 style={{ margin: 0, fontSize: 26, fontWeight: 600, letterSpacing: "-0.02em", color: T.ink }}>Insights</h1>
        <p style={{ margin: "6px 0 0", fontSize: 13.5, color: T.inkSoft }}>Patterns across your last 12 dreams</p>
      </div>

      {/* Recurring symbols */}
      <div style={glass({ padding: 18 })}>
        <SectionLabel>Recurring symbols</SectionLabel>
        <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 10 }}>
          {SYMBOL_STATS.map(s => {
            const Icon = s.icon;
            return (
              <div key={s.label} style={{
                padding: "14px 14px", borderRadius: 16,
                background: "rgba(255,255,255,0.05)", border: `1px solid ${T.stroke}`,
                display: "flex", alignItems: "center", gap: 11,
              }}>
                <span style={{
                  width: 36, height: 36, borderRadius: 11, flexShrink: 0,
                  display: "flex", alignItems: "center", justifyContent: "center",
                  background: "rgba(185,168,247,0.14)", border: "1px solid rgba(185,168,247,0.30)",
                }}>
                  <Icon size={17} color={T.lavender} />
                </span>
                <span>
                  <span style={{ display: "block", fontSize: 17, fontWeight: 650, color: T.ink }}>{s.count}×</span>
                  <span style={{ display: "block", fontSize: 11.5, color: T.inkFaint }}>{s.label}</span>
                </span>
              </div>
            );
          })}
        </div>
        <p style={{ margin: "12px 0 0", fontSize: 12.5, lineHeight: 1.55, color: T.inkSoft }}>
          Thresholds — gates, doors, boarding passes — appear in a third of your dreams. Your mind keeps returning to moments of crossing over.
        </p>
      </div>

      {/* Recurring emotions */}
      <div style={glass({ padding: 18, marginTop: 14 })}>
        <SectionLabel>Recurring emotions</SectionLabel>
        <div style={{ display: "flex", flexDirection: "column", gap: 10 }}>
          {EMOTION_STATS.map(e => (
            <div key={e.label} style={{ display: "flex", alignItems: "center", gap: 10 }}>
              <span style={{ width: 72, fontSize: 12.5, color: T.inkSoft, flexShrink: 0 }}>{e.label}</span>
              <div style={{ flex: 1, height: 10, borderRadius: 99, background: "rgba(255,255,255,0.06)", overflow: "hidden" }}>
                <div style={{
                  width: `${(e.count / maxEmo) * 100}%`, height: "100%", borderRadius: 99,
                  background: `linear-gradient(90deg, ${e.color}AA, ${e.color})`,
                }} />
              </div>
              <span style={{ width: 20, fontSize: 12, color: T.inkFaint, textAlign: "right" }}>{e.count}</span>
            </div>
          ))}
        </div>
      </div>

      {/* Frequency */}
      <div style={glass({ padding: 18, marginTop: 14 })}>
        <SectionLabel>Dream frequency · last 14 nights</SectionLabel>
        <div style={{ display: "flex", alignItems: "flex-end", gap: 5, height: 74 }}
          role="img" aria-label="Bar chart of dreams recalled per night over the last fourteen nights">
          {FREQ.map((v, i) => (
            <div key={i} style={{
              flex: 1, borderRadius: 6,
              height: v === 0 ? 5 : `${(v / maxFreq) * 100}%`,
              background: v === 0
                ? "rgba(255,255,255,0.08)"
                : "linear-gradient(180deg, #CFC2FA, rgba(185,168,247,0.35))",
              transition: "height 400ms ease",
            }} />
          ))}
        </div>
        <div style={{ display: "flex", justifyContent: "space-between", marginTop: 8, fontSize: 10.5, color: T.inkFaint }}>
          <span>Jun 26</span><span>Jul 2</span><span>Jul 9</span>
        </div>
        <p style={{ margin: "10px 0 0", fontSize: 12.5, color: T.inkSoft }}>
          11 dreams recalled · recall improves on nights you journal before bed.
        </p>
      </div>

      {/* Emotional trend */}
      <div style={glass({ padding: 18, marginTop: 14 })}>
        <SectionLabel>Emotional balance over time</SectionLabel>
        <svg viewBox={`0 0 ${w} ${h + 10}`} style={{ width: "100%", height: "auto", display: "block" }}
          role="img" aria-label="Line chart of emotional balance rising from 52 to 74 over ten dreams">
          <defs>
            <linearGradient id="trendFill" x1="0" y1="0" x2="0" y2="1">
              <stop offset="0%" stopColor="rgba(143,227,210,0.35)" />
              <stop offset="100%" stopColor="rgba(143,227,210,0)" />
            </linearGradient>
            <linearGradient id="trendLine" x1="0" y1="0" x2="1" y2="0">
              <stop offset="0%" stopColor={T.lavender} />
              <stop offset="100%" stopColor={T.teal} />
            </linearGradient>
          </defs>
          <polygon points={`0,${h} ${pts} ${w},${h}`} fill="url(#trendFill)" />
          <polyline points={pts} fill="none" stroke="url(#trendLine)" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" />
          {TREND.map((v, i) => (
            <circle key={i} cx={(i / (TREND.length - 1)) * w} cy={h - ((v - 40) / 40) * h}
              r={i === TREND.length - 1 ? 4.5 : 0} fill={T.teal} />
          ))}
        </svg>
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginTop: 8 }}>
          <span style={{ fontSize: 12.5, color: T.inkSoft }}>Trending calmer</span>
          <span style={{ fontSize: 12.5, fontWeight: 650, color: T.teal }}>+22 pts this month</span>
        </div>
      </div>
    </div>
  );
}

/* ------------------------------------------------------------------ */
/*  Shell                                                              */
/* ------------------------------------------------------------------ */
function AppShell({ onExit }) {
  const [tab, setTab] = useState("new");           // new | journal | insights
  const [stage, setStage] = useState("input");     // input | analyzing | result
  const [text, setText] = useState("");
  const [saved, setSaved] = useState(false);
  const scrollRef = useRef(null);

  useEffect(() => { scrollRef.current?.scrollTo({ top: 0 }); }, [tab, stage]);

  const interpret = () => {
    setStage("analyzing");
    setTimeout(() => setStage("result"), 2900);
  };

  const openDemoFromHistory = () => {
    setText(DEMO_DREAM);
    setSaved(true);
    setStage("result");
    setTab("new");
  };

  const dreams = saved ? HISTORY : HISTORY.slice(1);

  const tabs = [
    { id: "new", label: "Tonight", icon: Moon },
    { id: "journal", label: "Journal", icon: BookOpen },
    { id: "insights", label: "Insights", icon: BarChart3 },
  ];

  return (
    <div style={{
      minHeight: "100vh", display: "flex", justifyContent: "center",
      background: "#050410", fontFamily: "-apple-system, BlinkMacSystemFont, 'SF Pro Text', 'Segoe UI', Roboto, sans-serif",
    }}>
      <style>{`
        @keyframes breathe { 0%,100% { transform: scale(1); } 50% { transform: scale(1.06); } }
        @keyframes ringPulse { 0%,100% { transform: scale(1); opacity: .6 } 50% { transform: scale(1.12); opacity: .15 } }
        @keyframes wave { 0%,100% { height: 5px } 50% { height: 14px } }
        @keyframes drift1 { 0%,100% { transform: translate(0,0) } 50% { transform: translate(30px,-24px) } }
        @keyframes drift2 { 0%,100% { transform: translate(0,0) } 50% { transform: translate(-26px,20px) } }
        @keyframes fadeUp { from { opacity: 0; transform: translateY(14px) } to { opacity: 1; transform: none } }
        button:focus-visible, textarea:focus-visible { outline: 2px solid #B9A8F7; outline-offset: 2px; }
        textarea::placeholder { color: rgba(244,241,255,0.35); }
        ::-webkit-scrollbar { width: 0; height: 0; }
        @media (prefers-reduced-motion: reduce) {
          * { animation: none !important; transition: none !important; }
        }
      `}</style>

      {/* Phone canvas */}
      <div ref={scrollRef} style={{
        width: "100%", maxWidth: 430, minHeight: "100vh", maxHeight: "100vh",
        overflowY: "auto", position: "relative",
        background: "linear-gradient(175deg, #0B0A1E 0%, #171233 48%, #221A44 100%)",
      }}>
        {/* Aurora atmosphere */}
        <div aria-hidden style={{ position: "fixed", inset: 0, maxWidth: 430, margin: "0 auto", pointerEvents: "none", overflow: "hidden" }}>
          <div style={{
            position: "absolute", top: "-8%", left: "-22%", width: 320, height: 320, borderRadius: "50%",
            background: "radial-gradient(circle, rgba(124,106,232,0.34), transparent 68%)",
            filter: "blur(38px)", animation: "drift1 16s ease-in-out infinite",
          }} />
          <div style={{
            position: "absolute", top: "26%", right: "-26%", width: 300, height: 300, borderRadius: "50%",
            background: "radial-gradient(circle, rgba(143,227,210,0.20), transparent 68%)",
            filter: "blur(42px)", animation: "drift2 19s ease-in-out infinite",
          }} />
          <div style={{
            position: "absolute", bottom: "-6%", left: "8%", width: 280, height: 280, borderRadius: "50%",
            background: "radial-gradient(circle, rgba(238,167,196,0.16), transparent 68%)",
            filter: "blur(44px)", animation: "drift1 22s ease-in-out infinite",
          }} />
          {/* faint stars */}
          {[["12%","18%"],["78%","9%"],["64%","30%"],["22%","44%"],["88%","52%"],["34%","70%"],["70%","82%"],["10%","88%"]].map(([l, t], i) => (
            <span key={i} style={{
              position: "absolute", left: l, top: t, width: 2, height: 2, borderRadius: 99,
              background: "rgba(255,255,255,0.5)", opacity: 0.5,
            }} />
          ))}
        </div>

        {/* Content */}
        <div key={`${tab}-${stage}`} style={{ position: "relative", animation: "fadeUp 420ms cubic-bezier(.22,1,.36,1)" }}>
          {tab === "new" && stage === "input" && (
            <InputScreen text={text} setText={setText} onInterpret={interpret} />
          )}
          {tab === "new" && stage === "analyzing" && <AnalyzingScreen />}
          {tab === "new" && stage === "result" && (
            <ResultScreen dreamText={text} saved={saved}
              onBack={() => setStage("input")}
              onSave={() => { setSaved(true); setTab("journal"); }} />
          )}
          {tab === "journal" && <HistoryScreen dreams={dreams} onOpen={openDemoFromHistory} />}
          {tab === "insights" && <DashboardScreen />}
        </div>

        {/* Back to landing */}
        {onExit && (
          <button onClick={onExit} aria-label="Back to website"
            style={{
              position: "fixed", top: 14, right: "max(14px, calc(50% - 201px))", zIndex: 30,
              display: "flex", alignItems: "center", gap: 6, cursor: "pointer",
              padding: "8px 13px", minHeight: 36, borderRadius: 999,
              background: "rgba(20,16,42,0.6)", border: `1px solid ${T.stroke}`,
              backdropFilter: "blur(18px)", WebkitBackdropFilter: "blur(18px)",
              color: T.inkSoft, fontSize: 12, fontWeight: 500,
            }}>
            <ArrowLeft size={13} /> Site
          </button>
        )}

        {/* Tab bar */}
        <nav aria-label="Main navigation" style={{
          position: "fixed", bottom: 0, left: 0, right: 0, margin: "0 auto",
          maxWidth: 430, padding: "0 18px calc(14px + env(safe-area-inset-bottom))",
          pointerEvents: "none", zIndex: 20,
        }}>
          <div style={{
            ...glass({ borderRadius: 999, padding: 6 }),
            background: "rgba(20,16,42,0.72)",
            display: "flex", pointerEvents: "auto",
          }}>
            {tabs.map(t => {
              const Icon = t.icon;
              const active = tab === t.id;
              return (
                <button key={t.id}
                  onClick={() => { setTab(t.id); if (t.id === "new" && stage === "analyzing") setStage("input"); }}
                  aria-label={t.label} aria-current={active ? "page" : undefined}
                  style={{
                    flex: 1, display: "flex", flexDirection: "column", alignItems: "center", gap: 3,
                    padding: "9px 0", minHeight: 52, borderRadius: 999, cursor: "pointer",
                    border: "none",
                    background: active ? "rgba(185,168,247,0.16)" : "transparent",
                    color: active ? T.lavender : T.inkFaint,
                    transition: "all 220ms ease",
                  }}>
                  <Icon size={19} strokeWidth={active ? 2.2 : 1.8} />
                  <span style={{ fontSize: 10.5, fontWeight: active ? 650 : 500 }}>{t.label}</span>
                </button>
              );
            })}
          </div>
        </nav>
      </div>
    </div>
  );
}

/* ------------------------------------------------------------------ */
/*  Landing page                                                       */
/* ------------------------------------------------------------------ */
const STEPS = [
  {
    n: "I",
    title: "Tell your dream",
    body: "Type or speak while it's still fresh. Fragments are fine — the reading works with whatever the night left behind.",
    icon: Mic,
  },
  {
    n: "II",
    title: "Six readings appear",
    body: "Zhougong, Freud, Jung, neuroscience, cultural symbolism and spiritual tradition each interpret independently — and show how much weight they carry.",
    icon: Compass,
  },
  {
    n: "III",
    title: "One calm synthesis",
    body: "The lenses converge into a single message, honest questions for reflection, and gentle actions for the next few days.",
    icon: Sparkles,
  },
];

function PhoneMock({ onLaunch }) {
  return (
    <div aria-hidden style={{ position: "relative", width: 296, animation: "floaty 7s ease-in-out infinite" }}>
      <div style={{
        position: "absolute", inset: -30, borderRadius: "50%",
        background: "radial-gradient(circle, rgba(185,168,247,0.28), transparent 70%)",
        filter: "blur(30px)",
      }} />
      <div style={{
        position: "relative", borderRadius: 46, padding: 10,
        background: "rgba(255,255,255,0.06)", border: `1px solid ${T.stroke}`,
        boxShadow: "0 30px 80px rgba(5,4,16,0.6), inset 0 1px 0 rgba(255,255,255,0.10)",
        backdropFilter: "blur(20px)", WebkitBackdropFilter: "blur(20px)",
      }}>
        <div style={{
          borderRadius: 38, overflow: "hidden", padding: "22px 18px 24px",
          background: "linear-gradient(175deg, #0B0A1E 0%, #171233 55%, #221A44 100%)",
          border: "1px solid rgba(255,255,255,0.08)",
        }}>
          <div style={{ width: 84, height: 5, borderRadius: 99, background: "rgba(255,255,255,0.16)", margin: "0 auto 22px" }} />
          <div style={{ display: "flex", justifyContent: "center" }}><Orb size={78} /></div>
          <p style={{ textAlign: "center", margin: "18px 0 4px", fontSize: 18, fontWeight: 600, color: T.ink }}>Good morning</p>
          <p style={{ textAlign: "center", margin: 0, fontSize: 12, color: T.inkSoft }}>What did you dream last night?</p>
          <div style={{ ...glass({ borderRadius: 18, padding: 13, marginTop: 18 }) }}>
            <p style={{
              margin: 0, fontSize: 12, lineHeight: 1.65, color: T.inkSoft,
              fontFamily: "Georgia, 'Times New Roman', serif", fontStyle: "italic",
            }}>
              “…and then a giant black mosquito, larger than a football, flew out of the park.”
            </p>
            <div style={{ display: "flex", alignItems: "center", gap: 6, marginTop: 10, color: T.inkFaint, fontSize: 10.5 }}>
              <Mic size={12} /> Listening
              <span style={{ display: "inline-flex", gap: 2, marginLeft: 2 }}>
                {[0, 1, 2].map(i => (
                  <span key={i} style={{
                    width: 2.5, borderRadius: 2, background: T.rose, height: 9, display: "inline-block",
                    animation: `wave 0.9s ease-in-out ${i * 0.14}s infinite`,
                  }} />
                ))}
              </span>
            </div>
          </div>
          <div style={{
            marginTop: 14, padding: "12px 0", borderRadius: 999, textAlign: "center",
            fontSize: 12.5, fontWeight: 600, color: "#171233",
            background: "linear-gradient(120deg, #CFC2FA, #9FE8D8)",
          }}>Interpret this dream</div>
        </div>
      </div>
      {/* floating confidence chip */}
      <div style={{
        position: "absolute", top: 96, right: -34,
        ...glass({ borderRadius: 16, padding: "10px 13px" }),
        background: "rgba(20,16,42,0.75)",
        display: "flex", alignItems: "center", gap: 9,
        animation: "floaty 7s ease-in-out 1.2s infinite",
      }}>
        <span style={{ fontSize: 17, fontWeight: 650, color: T.teal }}>78%</span>
        <span style={{ fontSize: 10, color: T.inkSoft, lineHeight: 1.3 }}>reading<br />confidence</span>
      </div>
      <div style={{
        position: "absolute", bottom: 86, left: -30,
        ...glass({ borderRadius: 16, padding: "9px 12px" }),
        background: "rgba(20,16,42,0.75)",
        display: "flex", alignItems: "center", gap: 8,
        animation: "floaty 7s ease-in-out 2.1s infinite",
      }}>
        <Compass size={14} color={T.lavender} />
        <span style={{ fontSize: 10.5, color: T.inkSoft }}>Jungian lens · 24%</span>
      </div>
    </div>
  );
}

function Landing({ onLaunch }) {
  const w = 300, h = 84;
  const pts = TREND.map((v, i) => `${(i / (TREND.length - 1)) * w},${h - ((v - 40) / 40) * h}`).join(" ");

  const ghostBtn = {
    padding: "14px 22px", minHeight: 48, borderRadius: 999, cursor: "pointer",
    background: "rgba(255,255,255,0.06)", border: `1px solid ${T.stroke}`,
    color: T.ink, fontSize: 14.5, fontWeight: 500,
    backdropFilter: "blur(16px)", WebkitBackdropFilter: "blur(16px)",
  };
  const primaryBtn = {
    padding: "14px 26px", minHeight: 48, borderRadius: 999, cursor: "pointer", border: "none",
    background: "linear-gradient(120deg, #CFC2FA, #9FE8D8)", color: "#171233",
    fontSize: 14.5, fontWeight: 600, boxShadow: "0 8px 32px rgba(185,168,247,0.35)",
  };

  return (
    <div style={{
      minHeight: "100vh", position: "relative", overflowX: "hidden",
      background: "linear-gradient(178deg, #0B0A1E 0%, #171233 42%, #221A44 78%, #161129 100%)",
      color: T.ink,
      fontFamily: "-apple-system, BlinkMacSystemFont, 'SF Pro Text', 'Segoe UI', Roboto, sans-serif",
    }}>
      <style>{`
        @keyframes breathe { 0%,100% { transform: scale(1) } 50% { transform: scale(1.06) } }
        @keyframes ringPulse { 0%,100% { transform: scale(1); opacity:.6 } 50% { transform: scale(1.12); opacity:.15 } }
        @keyframes wave { 0%,100% { height: 5px } 50% { height: 12px } }
        @keyframes drift1 { 0%,100% { transform: translate(0,0) } 50% { transform: translate(34px,-26px) } }
        @keyframes drift2 { 0%,100% { transform: translate(0,0) } 50% { transform: translate(-30px,22px) } }
        @keyframes floaty { 0%,100% { transform: translateY(0) } 50% { transform: translateY(-10px) } }
        @keyframes fadeUp { from { opacity:0; transform: translateY(16px) } to { opacity:1; transform:none } }
        button:focus-visible { outline: 2px solid #B9A8F7; outline-offset: 2px; }
        @media (prefers-reduced-motion: reduce) { * { animation: none !important; transition: none !important; } }
      `}</style>

      {/* Atmosphere */}
      <div aria-hidden style={{ position: "absolute", inset: 0, pointerEvents: "none", overflow: "hidden" }}>
        <div style={{
          position: "absolute", top: "-160px", left: "-10%", width: 620, height: 620, borderRadius: "50%",
          background: "radial-gradient(circle, rgba(124,106,232,0.30), transparent 68%)",
          filter: "blur(60px)", animation: "drift1 18s ease-in-out infinite",
        }} />
        <div style={{
          position: "absolute", top: "18%", right: "-14%", width: 560, height: 560, borderRadius: "50%",
          background: "radial-gradient(circle, rgba(143,227,210,0.16), transparent 68%)",
          filter: "blur(70px)", animation: "drift2 22s ease-in-out infinite",
        }} />
        <div style={{
          position: "absolute", bottom: "4%", left: "6%", width: 520, height: 520, borderRadius: "50%",
          background: "radial-gradient(circle, rgba(238,167,196,0.13), transparent 68%)",
          filter: "blur(70px)", animation: "drift1 26s ease-in-out infinite",
        }} />
        {[["8%","12%"],["30%","6%"],["58%","10%"],["82%","16%"],["16%","38%"],["90%","44%"],["44%","58%"],["70%","70%"],["12%","78%"],["86%","86%"]].map(([l, t], i) => (
          <span key={i} style={{ position: "absolute", left: l, top: t, width: 2, height: 2, borderRadius: 99, background: "rgba(255,255,255,0.5)" }} />
        ))}
      </div>

      <div style={{ position: "relative", maxWidth: 1120, margin: "0 auto", padding: "0 24px" }}>
        {/* Nav */}
        <header style={{ display: "flex", alignItems: "center", justifyContent: "space-between", padding: "26px 0" }}>
          <div style={{ display: "flex", alignItems: "center", gap: 10 }}>
            <span style={{
              width: 34, height: 34, borderRadius: 11, display: "flex", alignItems: "center", justifyContent: "center",
              background: "rgba(185,168,247,0.16)", border: "1px solid rgba(185,168,247,0.35)",
            }}>
              <Moon size={16} color={T.lavender} />
            </span>
            <span style={{ fontSize: 15.5, fontWeight: 650, letterSpacing: "-0.01em" }}>Dream Interpreter</span>
          </div>
          <button onClick={onLaunch} style={{ ...ghostBtn, padding: "10px 18px", minHeight: 42, fontSize: 13.5 }}>
            Open the app
          </button>
        </header>

        {/* Hero */}
        <section className="flex flex-col md:flex-row items-center gap-12 md:gap-8"
          style={{ padding: "44px 0 96px", animation: "fadeUp 600ms cubic-bezier(.22,1,.36,1)" }}>
          <div style={{ flex: "1 1 480px", minWidth: 0 }}>
            <div style={{
              display: "inline-flex", alignItems: "center", gap: 8, marginBottom: 22,
              padding: "7px 14px", borderRadius: 999, border: `1px solid ${T.stroke}`,
              background: "rgba(255,255,255,0.05)", fontSize: 11.5, letterSpacing: "0.14em",
              textTransform: "uppercase", color: T.inkSoft, fontWeight: 600,
            }}>
              <Sparkles size={12} color={T.lavender} /> Six traditions · One reading
            </div>
            <h1 style={{
              margin: 0, fontFamily: "Georgia, 'Times New Roman', serif", fontWeight: 500,
              fontSize: "clamp(38px, 5.4vw, 60px)", lineHeight: 1.12, letterSpacing: "-0.015em",
            }}>
              Know what your night<br />
              was <em style={{
                fontStyle: "italic",
                background: "linear-gradient(120deg, #CFC2FA, #9FE8D8)",
                WebkitBackgroundClip: "text", backgroundClip: "text", color: "transparent",
              }}>trying to tell you.</em>
            </h1>
            <p style={{ margin: "22px 0 0", maxWidth: 480, fontSize: 16.5, lineHeight: 1.7, color: T.inkSoft }}>
              Record a dream in seconds. Dream Interpreter reads it through six traditions —
              from the classical Zhougong text to modern neuroscience — then composes one calm,
              honest synthesis, with questions worth sitting with.
            </p>
            <div style={{ display: "flex", flexWrap: "wrap", gap: 12, marginTop: 30 }}>
              <button onClick={onLaunch} style={primaryBtn}>Try the interactive demo</button>
              <button style={ghostBtn}
                onClick={() => document.getElementById("lenses")?.scrollIntoView({ behavior: "smooth" })}>
                Explore the six lenses
              </button>
            </div>
            <p style={{ margin: "18px 0 0", fontSize: 12, color: T.inkFaint }}>
              Reflections, not predictions · Free to try · No account needed
            </p>
          </div>
          <div style={{ flex: "0 0 auto", padding: "0 30px" }}>
            <PhoneMock onLaunch={onLaunch} />
          </div>
        </section>

        {/* Lenses */}
        <section id="lenses" style={{ padding: "24px 0 40px" }}>
          <div style={{ textAlign: "center", maxWidth: 560, margin: "0 auto 40px" }}>
            <SectionLabel>The six lenses</SectionLabel>
            <h2 style={{
              margin: 0, fontFamily: "Georgia, 'Times New Roman', serif", fontWeight: 500,
              fontSize: "clamp(26px, 3.4vw, 36px)", lineHeight: 1.2, letterSpacing: "-0.01em",
            }}>
              One dream. Six honest readings.
            </h2>
            <p style={{ margin: "14px 0 0", fontSize: 14.5, lineHeight: 1.65, color: T.inkSoft }}>
              No single tradition owns the truth about dreams. Each lens interprets independently,
              declares its weight, and shows exactly what it contributed to the final conclusion.
            </p>
          </div>
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
            {PERSPECTIVES.map(p => {
              const Icon = p.icon;
              return (
                <div key={p.id} style={glass({ padding: 20, borderRadius: 22 })}>
                  <div style={{ display: "flex", alignItems: "center", gap: 11, marginBottom: 12 }}>
                    <span style={{
                      width: 38, height: 38, borderRadius: 12, flexShrink: 0,
                      display: "flex", alignItems: "center", justifyContent: "center",
                      background: `${p.color}22`, border: `1px solid ${p.color}55`,
                    }}>
                      <Icon size={17} color={p.color} />
                    </span>
                    <div>
                      <div style={{ fontSize: 14.5, fontWeight: 600 }}>{p.name}</div>
                      <div style={{ fontSize: 11.5, color: T.inkFaint }}>{p.tag}</div>
                    </div>
                  </div>
                  <p style={{ margin: 0, fontSize: 13, lineHeight: 1.6, color: T.inkSoft }}>{p.short}</p>
                </div>
              );
            })}
          </div>
        </section>

        {/* How it works */}
        <section style={{ padding: "72px 0 40px" }}>
          <div style={{ textAlign: "center", marginBottom: 40 }}>
            <SectionLabel>How it works</SectionLabel>
            <h2 style={{
              margin: "0 auto", maxWidth: 520, fontFamily: "Georgia, 'Times New Roman', serif",
              fontWeight: 500, fontSize: "clamp(26px, 3.4vw, 36px)", lineHeight: 1.2,
            }}>
              From half-remembered fragment to a reading you can use.
            </h2>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            {STEPS.map(s => {
              const Icon = s.icon;
              return (
                <div key={s.n} style={glass({ padding: 24, borderRadius: 24 })}>
                  <div style={{ display: "flex", alignItems: "center", justifyContent: "space-between", marginBottom: 16 }}>
                    <span style={{
                      fontFamily: "Georgia, 'Times New Roman', serif", fontStyle: "italic",
                      fontSize: 26, color: T.lavender,
                    }}>{s.n}</span>
                    <Icon size={18} color={T.inkFaint} />
                  </div>
                  <div style={{ fontSize: 16.5, fontWeight: 600, marginBottom: 8 }}>{s.title}</div>
                  <p style={{ margin: 0, fontSize: 13.5, lineHeight: 1.65, color: T.inkSoft }}>{s.body}</p>
                </div>
              );
            })}
          </div>
        </section>

        {/* Insights preview */}
        <section className="flex flex-col md:flex-row items-center gap-10" style={{ padding: "72px 0 40px" }}>
          <div style={{ flex: "1 1 420px", minWidth: 0 }}>
            <SectionLabel>Over the weeks</SectionLabel>
            <h2 style={{
              margin: 0, fontFamily: "Georgia, 'Times New Roman', serif", fontWeight: 500,
              fontSize: "clamp(26px, 3.4vw, 36px)", lineHeight: 1.2,
            }}>
              Patterns emerge that a single night can't show.
            </h2>
            <p style={{ margin: "16px 0 0", maxWidth: 440, fontSize: 14.5, lineHeight: 1.7, color: T.inkSoft }}>
              Your journal quietly tracks recurring symbols, recurring emotions, and how your
              nights are trending — thresholds you keep standing at, fears that keep shrinking.
            </p>
            <div style={{ display: "flex", flexWrap: "wrap", gap: 8, marginTop: 20 }}>
              {SYMBOL_STATS.map(s => (
                <span key={s.label} style={{
                  fontSize: 12.5, color: T.inkSoft, padding: "7px 13px",
                  borderRadius: 999, border: `1px solid ${T.stroke}`, background: "rgba(255,255,255,0.05)",
                }}>
                  {s.label} ×{s.count}
                </span>
              ))}
            </div>
          </div>
          <div style={{ flex: "1 1 380px", width: "100%", maxWidth: 460 }}>
            <div style={glass({ padding: 22, borderRadius: 26 })}>
              <SectionLabel>Emotional balance · last 10 dreams</SectionLabel>
              <svg viewBox={`0 0 ${w} ${h + 10}`} style={{ width: "100%", height: "auto", display: "block" }}
                role="img" aria-label="Emotional balance trend rising over the last ten dreams">
                <defs>
                  <linearGradient id="lpFill" x1="0" y1="0" x2="0" y2="1">
                    <stop offset="0%" stopColor="rgba(143,227,210,0.35)" />
                    <stop offset="100%" stopColor="rgba(143,227,210,0)" />
                  </linearGradient>
                  <linearGradient id="lpLine" x1="0" y1="0" x2="1" y2="0">
                    <stop offset="0%" stopColor={T.lavender} />
                    <stop offset="100%" stopColor={T.teal} />
                  </linearGradient>
                </defs>
                <polygon points={`0,${h} ${pts} ${w},${h}`} fill="url(#lpFill)" />
                <polyline points={pts} fill="none" stroke="url(#lpLine)" strokeWidth="2.5"
                  strokeLinecap="round" strokeLinejoin="round" />
              </svg>
              <div style={{ display: "flex", justifyContent: "space-between", marginTop: 10 }}>
                <span style={{ fontSize: 12.5, color: T.inkSoft }}>Trending calmer</span>
                <span style={{ fontSize: 12.5, fontWeight: 650, color: T.teal }}>+22 pts this month</span>
              </div>
            </div>
          </div>
        </section>

        {/* Pull quote */}
        <section style={{ padding: "80px 0", textAlign: "center" }}>
          <p style={{
            margin: "0 auto", maxWidth: 640, fontFamily: "Georgia, 'Times New Roman', serif",
            fontStyle: "italic", fontSize: "clamp(20px, 2.8vw, 28px)", lineHeight: 1.55, color: T.ink,
          }}>
            “The dream never harmed you. You paused, you observed — and the exaggerated fear revealed itself.”
          </p>
          <p style={{ margin: "18px 0 0", fontSize: 12, letterSpacing: "0.12em", textTransform: "uppercase", color: T.inkFaint, fontWeight: 600 }}>
            From a sample reading · The giant mosquito at the park gate
          </p>
        </section>

        {/* Final CTA */}
        <section style={{ padding: "0 0 90px" }}>
          <div style={glass({
            padding: "56px 28px", borderRadius: 32, textAlign: "center",
            background: "linear-gradient(140deg, rgba(185,168,247,0.14), rgba(143,227,210,0.09))",
            border: "1px solid rgba(185,168,247,0.30)",
          })}>
            <div style={{ display: "flex", justifyContent: "center", marginBottom: 22 }}><Orb size={72} /></div>
            <h2 style={{
              margin: 0, fontFamily: "Georgia, 'Times New Roman', serif", fontWeight: 500,
              fontSize: "clamp(26px, 3.6vw, 40px)", lineHeight: 1.2,
            }}>
              Tonight's dream is waiting.
            </h2>
            <p style={{ margin: "14px auto 0", maxWidth: 420, fontSize: 14.5, lineHeight: 1.65, color: T.inkSoft }}>
              Open the interactive demo and read the sample dream through all six lenses — no account, no setup.
            </p>
            <button onClick={onLaunch} style={{ ...primaryBtn, marginTop: 28 }}>
              Open Dream Interpreter
            </button>
          </div>
        </section>

        {/* Footer */}
        <footer style={{
          display: "flex", flexWrap: "wrap", gap: 12, alignItems: "center", justifyContent: "space-between",
          padding: "0 0 36px", borderTop: `1px solid ${T.stroke}`, paddingTop: 26,
        }}>
          <div style={{ display: "flex", alignItems: "center", gap: 8, fontSize: 13, color: T.inkSoft }}>
            <Moon size={14} color={T.lavender} /> Dream Interpreter
          </div>
          <span style={{ fontSize: 11.5, color: T.inkFaint }}>
            Reflections, not predictions · For self-exploration only · © 2026
          </span>
        </footer>
      </div>
    </div>
  );
}

export default function DreamInterpreter() {
  const [view, setView] = useState("landing"); // landing | app
  useEffect(() => { window.scrollTo?.(0, 0); }, [view]);
  return view === "landing"
    ? <Landing onLaunch={() => setView("app")} />
    : <AppShell onExit={() => setView("landing")} />;
}
