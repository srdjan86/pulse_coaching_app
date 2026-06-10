import { Settings, ChevronRight, Play } from "lucide-react";

export function HomeScreen({ isDark, onNavigate }: { isDark: boolean; onNavigate?: (screen: string) => void }) {
  const bg = isDark ? "#0E1A1A" : "#F5F9F9";
  const fg = isDark ? "#E8F2F2" : "#1A2E2E";
  const muted = isDark ? "#7AACAC" : "#4A6B6B";
  const card = isDark ? "#162424" : "#ffffff";
  const cardBorder = isDark ? "rgba(255,255,255,0.07)" : "rgba(13,115,119,0.1)";
  const primary = "#0D7377";
  const accent = isDark ? "#0A5A5E" : "#E8F0F0";
  const accentFg = isDark ? "#14BDBC" : primary;

  const cards = [
    {
      id: "library",
      icon: (
        <svg width="22" height="22" viewBox="0 0 22 22" fill="none">
          <rect x="2" y="4" width="18" height="14" rx="3" stroke={accentFg} strokeWidth="1.6" />
          <path d="M9 8.5l5 2.5-5 2.5V8.5z" fill={accentFg} />
        </svg>
      ),
      title: "Coaching library",
      subtitle: "Browse guided workout and recovery lessons",
      badge: "4 sessions",
      screen: "library",
    },
  ];

  const recentItems = [
    { title: "Morning Mobility Reset", category: "Mobility", duration: "8 min", color: "#14BDBC" },
    { title: "Mindful Breathing Break", category: "Mindfulness", duration: "5 min", color: "#0D7377" },
  ];

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
          padding: "52px 24px 20px",
          display: "flex",
          alignItems: "flex-end",
          justifyContent: "space-between",
          background: bg,
          position: "sticky",
          top: 0,
          zIndex: 10,
        }}
      >
        <div>
          <p style={{ fontSize: 13, color: muted, margin: 0, marginBottom: 2 }}>Good morning</p>
          <h1 style={{ fontSize: 26, fontWeight: 700, letterSpacing: "-0.5px", margin: 0, color: fg }}>
            Pulse
          </h1>
        </div>
        <button
          onClick={() => onNavigate?.("settings")}
          style={{
            background: "none",
            border: "none",
            color: muted,
            cursor: "pointer",
            padding: 6,
            borderRadius: 8,
          }}
        >
          <Settings size={22} />
        </button>
      </div>

      <div style={{ padding: "0 24px", flex: 1, paddingBottom: 32 }}>
        {/* Hero quote */}
        <div
          style={{
            background: `linear-gradient(135deg, ${primary} 0%, #0A5A5E 100%)`,
            borderRadius: 18,
            padding: "24px 20px",
            marginBottom: 28,
            position: "relative",
            overflow: "hidden",
          }}
        >
          <div
            style={{
              position: "absolute",
              top: -20,
              right: -20,
              width: 100,
              height: 100,
              borderRadius: "50%",
              background: "rgba(255,255,255,0.06)",
            }}
          />
          <div
            style={{
              position: "absolute",
              bottom: -30,
              right: 20,
              width: 80,
              height: 80,
              borderRadius: "50%",
              background: "rgba(255,255,255,0.04)",
            }}
          />
          <p style={{ fontSize: 13, color: "rgba(255,255,255,0.7)", margin: 0, marginBottom: 6 }}>
            Today's focus
          </p>
          <p style={{ fontSize: 17, fontWeight: 600, color: "#ffffff", margin: 0, lineHeight: 1.4, maxWidth: 220 }}>
            Small consistent steps build lasting change.
          </p>
        </div>

        {/* Feature cards */}
        <h2 style={{ fontSize: 13, fontWeight: 600, color: muted, letterSpacing: "0.6px", textTransform: "uppercase", margin: 0, marginBottom: 12 }}>
          Explore
        </h2>
        <div style={{ display: "flex", flexDirection: "column", gap: 10, marginBottom: 28 }}>
          {cards.map((c) => (
            <button
              key={c.id}
              onClick={() => onNavigate?.(c.screen)}
              style={{
                background: card,
                border: `1px solid ${cardBorder}`,
                borderRadius: 16,
                padding: "18px 18px",
                display: "flex",
                alignItems: "center",
                gap: 14,
                textAlign: "left",
                cursor: "pointer",
                width: "100%",
              }}
            >
              <div
                style={{
                  width: 44,
                  height: 44,
                  borderRadius: 12,
                  background: accent,
                  display: "flex",
                  alignItems: "center",
                  justifyContent: "center",
                  flexShrink: 0,
                }}
              >
                {c.icon}
              </div>
              <div style={{ flex: 1 }}>
                <p style={{ fontSize: 15, fontWeight: 600, color: fg, margin: 0, marginBottom: 3 }}>
                  {c.title}
                </p>
                <p style={{ fontSize: 13, color: muted, margin: 0, lineHeight: 1.4 }}>{c.subtitle}</p>
              </div>
              <div style={{ display: "flex", flexDirection: "column", alignItems: "flex-end", gap: 4, flexShrink: 0 }}>
                <span
                  style={{
                    fontSize: 11,
                    fontWeight: 600,
                    background: accent,
                    color: accentFg,
                    padding: "2px 8px",
                    borderRadius: 20,
                    letterSpacing: "0.2px",
                  }}
                >
                  {c.badge}
                </span>
                <ChevronRight size={16} color={muted} />
              </div>
            </button>
          ))}
        </div>

        {/* Continue section */}
        <h2 style={{ fontSize: 13, fontWeight: 600, color: muted, letterSpacing: "0.6px", textTransform: "uppercase", margin: 0, marginBottom: 12 }}>
          Continue
        </h2>
        <div style={{ display: "flex", flexDirection: "column", gap: 10 }}>
          {recentItems.map((item) => (
            <div
              key={item.title}
              style={{
                background: card,
                border: `1px solid ${cardBorder}`,
                borderRadius: 14,
                padding: "14px 16px",
                display: "flex",
                alignItems: "center",
                gap: 12,
                cursor: "pointer",
              }}
            >
              <div
                style={{
                  width: 40,
                  height: 40,
                  borderRadius: 10,
                  background: item.color,
                  display: "flex",
                  alignItems: "center",
                  justifyContent: "center",
                  flexShrink: 0,
                }}
              >
                <Play size={16} fill="white" color="white" />
              </div>
              <div style={{ flex: 1 }}>
                <p style={{ fontSize: 14, fontWeight: 600, color: fg, margin: 0 }}>{item.title}</p>
                <p style={{ fontSize: 12, color: muted, margin: 0 }}>
                  {item.category} · {item.duration}
                </p>
              </div>
              <ChevronRight size={16} color={muted} />
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
