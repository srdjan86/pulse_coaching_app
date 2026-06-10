import { useState } from "react";
import { ArrowLeft, Play, Clock } from "lucide-react";

const LESSONS = [
  {
    id: "1",
    title: "Morning Mobility Reset",
    category: "Mobility",
    duration: "8 min",
    description: "Start your day with a full-body mobility flow targeting hips, spine, and shoulders.",
    thumbnail: "https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400&h=225&fit=crop&auto=format",
    color: "#14BDBC",
  },
  {
    id: "2",
    title: "Strength Foundations",
    category: "Strength",
    duration: "14 min",
    description: "Build functional strength with compound bodyweight movements and progressive cues.",
    thumbnail: "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=225&fit=crop&auto=format",
    color: "#0D7377",
  },
  {
    id: "3",
    title: "Mindful Breathing Break",
    category: "Mindfulness",
    duration: "5 min",
    description: "A short guided breathing session to reset your nervous system and sharpen focus.",
    thumbnail: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&h=225&fit=crop&auto=format",
    color: "#7AACAC",
  },
  {
    id: "4",
    title: "Post-Workout Recovery",
    category: "Recovery",
    duration: "11 min",
    description: "Ease muscle soreness with targeted stretches and breathwork after intense training.",
    thumbnail: "https://images.unsplash.com/photo-1518611012118-696072aa579a?w=400&h=225&fit=crop&auto=format",
    color: "#4A6B6B",
  },
];

const CATEGORIES = ["All", "Mindfulness", "Strength", "Mobility", "Recovery"];

const CATEGORY_COLORS: Record<string, { bg: string; text: string }> = {
  Mindfulness: { bg: "rgba(122,172,172,0.18)", text: "#0D7377" },
  Strength: { bg: "rgba(13,115,119,0.14)", text: "#0D7377" },
  Mobility: { bg: "rgba(20,189,188,0.14)", text: "#0A5A5E" },
  Recovery: { bg: "rgba(74,107,107,0.14)", text: "#4A6B6B" },
};

type ViewState = "list" | "loading" | "empty" | "error";

export function LibraryScreen({
  isDark,
  onBack,
  onLesson,
}: {
  isDark: boolean;
  onBack?: () => void;
  onLesson?: (id: string) => void;
}) {
  const [activeCategory, setActiveCategory] = useState("All");
  const [viewState] = useState<ViewState>("list");

  const bg = isDark ? "#0E1A1A" : "#F5F9F9";
  const fg = isDark ? "#E8F2F2" : "#1A2E2E";
  const muted = isDark ? "#7AACAC" : "#4A6B6B";
  const card = isDark ? "#162424" : "#ffffff";
  const cardBorder = isDark ? "rgba(255,255,255,0.07)" : "rgba(13,115,119,0.1)";
  const primary = "#0D7377";
  const chipActiveBg = primary;
  const chipInactiveBg = isDark ? "#1F3333" : "#E8F0F0";
  const chipInactiveFg = muted;

  const filtered =
    activeCategory === "All" ? LESSONS : LESSONS.filter((l) => l.category === activeCategory);

  const catStyle = (cat: string) =>
    CATEGORY_COLORS[cat] || { bg: isDark ? "#1F3333" : "#E8F0F0", text: muted };

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
      {/* App bar */}
      <div
        style={{
          padding: "52px 24px 16px",
          background: bg,
          position: "sticky",
          top: 0,
          zIndex: 10,
        }}
      >
        <div style={{ display: "flex", alignItems: "center", gap: 12, marginBottom: 20 }}>
          <button
            onClick={onBack}
            style={{ background: "none", border: "none", color: muted, cursor: "pointer", padding: 4 }}
          >
            <ArrowLeft size={22} />
          </button>
          <h1 style={{ fontSize: 22, fontWeight: 700, letterSpacing: "-0.4px", margin: 0, color: fg }}>
            Coaching library
          </h1>
        </div>

        {/* Category chips */}
        <div style={{ display: "flex", gap: 8, overflowX: "auto", paddingBottom: 4, scrollbarWidth: "none" }}>
          {CATEGORIES.map((cat) => (
            <button
              key={cat}
              onClick={() => setActiveCategory(cat)}
              style={{
                padding: "7px 14px",
                borderRadius: 20,
                border: "none",
                fontSize: 13,
                fontWeight: 600,
                fontFamily: "'DM Sans', system-ui, sans-serif",
                cursor: "pointer",
                whiteSpace: "nowrap",
                background: activeCategory === cat ? chipActiveBg : chipInactiveBg,
                color: activeCategory === cat ? "#ffffff" : chipInactiveFg,
                transition: "all 0.15s",
              }}
            >
              {cat}
            </button>
          ))}
        </div>
      </div>

      <div style={{ padding: "8px 24px 32px", flex: 1 }}>
        {viewState === "loading" && (
          <div style={{ display: "flex", justifyContent: "center", padding: "60px 0", color: muted }}>
            <div
              style={{
                width: 32,
                height: 32,
                border: `3px solid ${isDark ? "#1F3333" : "#E8F0F0"}`,
                borderTopColor: primary,
                borderRadius: "50%",
                animation: "spin 0.8s linear infinite",
              }}
            />
          </div>
        )}

        {viewState === "empty" && (
          <div style={{ textAlign: "center", padding: "60px 0" }}>
            <div style={{ fontSize: 40, marginBottom: 12 }}>📭</div>
            <p style={{ fontSize: 16, fontWeight: 600, color: fg, margin: 0, marginBottom: 6 }}>No lessons available yet.</p>
            <p style={{ fontSize: 14, color: muted, margin: 0 }}>Check back soon for new content.</p>
          </div>
        )}

        {viewState === "error" && (
          <div style={{ textAlign: "center", padding: "60px 0" }}>
            <div style={{ fontSize: 40, marginBottom: 12 }}>⚠️</div>
            <p style={{ fontSize: 16, fontWeight: 600, color: fg, margin: 0, marginBottom: 6 }}>Couldn't load lessons</p>
            <p style={{ fontSize: 14, color: muted, margin: 0, marginBottom: 20 }}>Please check your connection and try again.</p>
            <button
              style={{
                padding: "10px 24px",
                background: primary,
                color: "#fff",
                border: "none",
                borderRadius: 10,
                fontSize: 14,
                fontWeight: 600,
                fontFamily: "'DM Sans', system-ui, sans-serif",
                cursor: "pointer",
              }}
            >
              Retry
            </button>
          </div>
        )}

        {viewState === "list" && (
          <div style={{ display: "flex", flexDirection: "column", gap: 14 }}>
            {filtered.map((lesson) => {
              const cs = catStyle(lesson.category);
              return (
                <button
                  key={lesson.id}
                  onClick={() => onLesson?.(lesson.id)}
                  style={{
                    background: card,
                    border: `1px solid ${cardBorder}`,
                    borderRadius: 16,
                    overflow: "hidden",
                    textAlign: "left",
                    cursor: "pointer",
                    width: "100%",
                    padding: 0,
                  }}
                >
                  {/* Thumbnail */}
                  <div style={{ position: "relative", aspectRatio: "16/9", background: isDark ? "#1F3333" : "#E8F0F0" }}>
                    <img
                      src={lesson.thumbnail}
                      alt={lesson.title}
                      style={{ width: "100%", height: "100%", objectFit: "cover", display: "block" }}
                      loading="lazy"
                    />
                    <div
                      style={{
                        position: "absolute",
                        inset: 0,
                        background: "linear-gradient(to top, rgba(0,0,0,0.4) 0%, transparent 50%)",
                      }}
                    />
                    <div
                      style={{
                        position: "absolute",
                        bottom: 10,
                        right: 10,
                        width: 36,
                        height: 36,
                        borderRadius: "50%",
                        background: "rgba(255,255,255,0.92)",
                        display: "flex",
                        alignItems: "center",
                        justifyContent: "center",
                      }}
                    >
                      <Play size={16} fill={primary} color={primary} style={{ marginLeft: 2 }} />
                    </div>
                  </div>

                  {/* Content */}
                  <div style={{ padding: "14px 16px" }}>
                    <div style={{ display: "flex", alignItems: "center", gap: 8, marginBottom: 6 }}>
                      <span
                        style={{
                          fontSize: 11,
                          fontWeight: 700,
                          letterSpacing: "0.3px",
                          padding: "3px 9px",
                          borderRadius: 20,
                          background: cs.bg,
                          color: cs.text,
                        }}
                      >
                        {lesson.category}
                      </span>
                      <span style={{ fontSize: 12, color: muted, display: "flex", alignItems: "center", gap: 3 }}>
                        <Clock size={11} /> {lesson.duration}
                      </span>
                    </div>
                    <p style={{ fontSize: 15, fontWeight: 600, color: fg, margin: 0, marginBottom: 4 }}>
                      {lesson.title}
                    </p>
                    <p style={{ fontSize: 13, color: muted, margin: 0, lineHeight: 1.45, display: "-webkit-box", WebkitLineClamp: 2, WebkitBoxOrient: "vertical", overflow: "hidden" }}>
                      {lesson.description}
                    </p>
                  </div>
                </button>
              );
            })}
          </div>
        )}
      </div>

      <style>{`@keyframes spin { to { transform: rotate(360deg); } }`}</style>
    </div>
  );
}
