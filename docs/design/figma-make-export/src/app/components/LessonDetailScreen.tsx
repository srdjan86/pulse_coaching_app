import { useState } from "react";
import { ArrowLeft, Play, Clock, Pause } from "lucide-react";

const LESSONS: Record<string, { title: string; category: string; duration: string; description: string; thumbnail: string; catColor: string }> = {
  "1": {
    title: "Morning Mobility Reset",
    category: "Mobility",
    duration: "8 min",
    description:
      "Start your day with a full-body mobility flow designed to open up the hips, decompress the spine, and activate the shoulders. This routine is ideal first thing in the morning before any other movement.\n\nEach movement is cued with breath, so you build both flexibility and body awareness at the same time. No equipment needed — just a mat and a few feet of space.",
    thumbnail: "https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=800&h=450&fit=crop&auto=format",
    catColor: "#14BDBC",
  },
  "2": {
    title: "Strength Foundations",
    category: "Strength",
    duration: "14 min",
    description:
      "Build a solid base with compound bodyweight movements: squat patterns, hip hinges, push variations, and core stability. Progressive coaching cues help you find depth and form before adding load.\n\nSuitable for all levels — scale to your current strength by adjusting range of motion and tempo.",
    thumbnail: "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=800&h=450&fit=crop&auto=format",
    catColor: "#0D7377",
  },
  "3": {
    title: "Mindful Breathing Break",
    category: "Mindfulness",
    duration: "5 min",
    description:
      "A short guided session using box breathing and diaphragmatic breath to reset your nervous system. Use this any time you feel scattered, anxious, or need a mental reset mid-day.\n\nNo movement required — you can do this at your desk, in a car, or lying on the floor.",
    thumbnail: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&h=450&fit=crop&auto=format",
    catColor: "#7AACAC",
  },
  "4": {
    title: "Post-Workout Recovery",
    category: "Recovery",
    duration: "11 min",
    description:
      "Ease muscle soreness with targeted passive stretches and slow breathwork designed to lower heart rate, reduce inflammation markers, and accelerate tissue repair.\n\nBest done within 30 minutes of training. Pair with hydration and a protein-rich meal for optimal recovery.",
    thumbnail: "https://images.unsplash.com/photo-1518611012118-696072aa579a?w=800&h=450&fit=crop&auto=format",
    catColor: "#4A6B6B",
  },
};

const CATEGORY_COLORS: Record<string, { bg: string; text: string }> = {
  Mindfulness: { bg: "rgba(122,172,172,0.18)", text: "#0D7377" },
  Strength: { bg: "rgba(13,115,119,0.14)", text: "#0D7377" },
  Mobility: { bg: "rgba(20,189,188,0.14)", text: "#0A5A5E" },
  Recovery: { bg: "rgba(74,107,107,0.14)", text: "#4A6B6B" },
};

export function LessonDetailScreen({
  lessonId,
  isDark,
  onBack,
}: {
  lessonId: string;
  isDark: boolean;
  onBack?: () => void;
}) {
  const [playing, setPlaying] = useState(false);
  const lesson = LESSONS[lessonId] || LESSONS["1"];

  const bg = isDark ? "#0E1A1A" : "#F5F9F9";
  const fg = isDark ? "#E8F2F2" : "#1A2E2E";
  const muted = isDark ? "#7AACAC" : "#4A6B6B";
  const card = isDark ? "#162424" : "#ffffff";
  const cardBorder = isDark ? "rgba(255,255,255,0.07)" : "rgba(13,115,119,0.1)";
  const primary = "#0D7377";

  const catStyle = CATEGORY_COLORS[lesson.category] || { bg: "#E8F0F0", text: muted };

  if (!lessonId) {
    return (
      <div style={{ background: bg, color: fg, fontFamily: "'DM Sans', system-ui, sans-serif", height: "100%", display: "flex", flexDirection: "column", alignItems: "center", justifyContent: "center", gap: 12 }}>
        <span style={{ fontSize: 40 }}>🔍</span>
        <p style={{ fontSize: 16, fontWeight: 600, color: fg, margin: 0 }}>Lesson not found</p>
        <p style={{ fontSize: 14, color: muted, margin: 0 }}>This lesson may have moved or been removed.</p>
        <button onClick={onBack} style={{ marginTop: 12, padding: "10px 24px", background: primary, color: "#fff", border: "none", borderRadius: 10, fontSize: 14, fontWeight: 600, fontFamily: "'DM Sans', system-ui, sans-serif", cursor: "pointer" }}>Go back</button>
      </div>
    );
  }

  return (
    <div
      style={{
        background: bg,
        color: fg,
        fontFamily: "'DM Sans', system-ui, sans-serif",
        height: "100%",
        display: "flex",
        flexDirection: "column",
        overflowY: "auto",
      }}
    >
      {/* Video area */}
      <div style={{ position: "relative", aspectRatio: "16/9", background: "#000", flexShrink: 0 }}>
        <img
          src={lesson.thumbnail}
          alt={lesson.title}
          style={{ width: "100%", height: "100%", objectFit: "cover", display: "block", opacity: playing ? 0.7 : 1 }}
        />
        <div style={{ position: "absolute", inset: 0, background: "linear-gradient(to top, rgba(0,0,0,0.5) 0%, rgba(0,0,0,0.15) 40%, transparent 70%)" }} />

        {/* Back button */}
        <button
          onClick={onBack}
          style={{
            position: "absolute",
            top: 52,
            left: 16,
            background: "rgba(0,0,0,0.4)",
            border: "none",
            color: "#fff",
            borderRadius: 10,
            width: 36,
            height: 36,
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            cursor: "pointer",
            backdropFilter: "blur(8px)",
          }}
        >
          <ArrowLeft size={18} />
        </button>

        {/* Play/pause */}
        <button
          onClick={() => setPlaying(!playing)}
          style={{
            position: "absolute",
            bottom: "50%",
            left: "50%",
            transform: "translate(-50%, 50%)",
            background: "rgba(255,255,255,0.18)",
            border: "2px solid rgba(255,255,255,0.6)",
            borderRadius: "50%",
            width: 56,
            height: 56,
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            cursor: "pointer",
            backdropFilter: "blur(8px)",
          }}
        >
          {playing ? (
            <Pause size={22} fill="white" color="white" />
          ) : (
            <Play size={22} fill="white" color="white" style={{ marginLeft: 3 }} />
          )}
        </button>

        {/* Progress bar */}
        <div style={{ position: "absolute", bottom: 0, left: 0, right: 0, height: 3, background: "rgba(255,255,255,0.2)" }}>
          <div style={{ height: "100%", width: playing ? "35%" : "0%", background: "#14BDBC", transition: "width 0.3s" }} />
        </div>
      </div>

      {/* Content */}
      <div style={{ padding: "20px 24px 40px", flex: 1 }}>
        {/* Chips */}
        <div style={{ display: "flex", gap: 8, marginBottom: 12, flexWrap: "wrap" }}>
          <span
            style={{
              fontSize: 11,
              fontWeight: 700,
              letterSpacing: "0.3px",
              padding: "3px 9px",
              borderRadius: 20,
              background: catStyle.bg,
              color: catStyle.text,
            }}
          >
            {lesson.category}
          </span>
          <span style={{ fontSize: 12, color: muted, display: "flex", alignItems: "center", gap: 3 }}>
            <Clock size={12} /> {lesson.duration}
          </span>
        </div>

        <h1 style={{ fontSize: 22, fontWeight: 700, letterSpacing: "-0.4px", margin: 0, marginBottom: 16, color: fg }}>
          {lesson.title}
        </h1>

        {/* Description */}
        <div
          style={{
            background: card,
            border: `1px solid ${cardBorder}`,
            borderRadius: 14,
            padding: "16px",
            marginBottom: 24,
          }}
        >
          <h3 style={{ fontSize: 13, fontWeight: 600, color: muted, margin: 0, marginBottom: 8, letterSpacing: "0.3px", textTransform: "uppercase" }}>
            About this session
          </h3>
          {lesson.description.split("\n\n").map((para, i) => (
            <p key={i} style={{ fontSize: 14, color: fg, lineHeight: 1.6, margin: 0, marginBottom: i < 1 ? 12 : 0, opacity: 0.85 }}>
              {para}
            </p>
          ))}
        </div>

        {/* CTA */}
        <button
          onClick={() => setPlaying(!playing)}
          style={{
            width: "100%",
            padding: "16px",
            background: primary,
            color: "#ffffff",
            border: "none",
            borderRadius: 14,
            fontSize: 16,
            fontWeight: 600,
            fontFamily: "'DM Sans', system-ui, sans-serif",
            cursor: "pointer",
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            gap: 8,
          }}
        >
          {playing ? <><Pause size={18} /> Pause session</> : <><Play size={18} fill="white" /> Start session</>}
        </button>
      </div>
    </div>
  );
}
