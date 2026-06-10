import { ArrowLeft, Monitor, Sun, Moon, ChevronRight, Bell, Shield, CircleHelp } from "lucide-react";

type ThemeMode = "system" | "light" | "dark";

export function SettingsScreen({
  isDark,
  themeMode,
  onThemeChange,
  onBack,
}: {
  isDark: boolean;
  themeMode: ThemeMode;
  onThemeChange: (mode: ThemeMode) => void;
  onBack?: () => void;
}) {
  const bg = isDark ? "#0E1A1A" : "#F5F9F9";
  const fg = isDark ? "#E8F2F2" : "#1A2E2E";
  const muted = isDark ? "#7AACAC" : "#4A6B6B";
  const card = isDark ? "#162424" : "#ffffff";
  const cardBorder = isDark ? "rgba(255,255,255,0.07)" : "rgba(13,115,119,0.1)";
  const primary = "#0D7377";
  const segBg = isDark ? "#1F3333" : "#E8F0F0";

  const modes: { id: ThemeMode; label: string; icon: React.ReactNode }[] = [
    { id: "system", label: "System", icon: <Monitor size={16} /> },
    { id: "light", label: "Light", icon: <Sun size={16} /> },
    { id: "dark", label: "Dark", icon: <Moon size={16} /> },
  ];

  const extraRows = [
    { icon: <Bell size={18} />, label: "Notifications", subtitle: "Manage reminders" },
    { icon: <Shield size={18} />, label: "Privacy", subtitle: "Data and permissions" },
    { icon: <CircleHelp size={18} />, label: "Help & support", subtitle: "FAQ, contact us" },
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
      <div style={{ padding: "52px 24px 20px", display: "flex", alignItems: "center", gap: 12 }}>
        <button
          onClick={onBack}
          style={{ background: "none", border: "none", color: muted, cursor: "pointer", padding: 4 }}
        >
          <ArrowLeft size={22} />
        </button>
        <h1 style={{ fontSize: 22, fontWeight: 700, letterSpacing: "-0.4px", margin: 0, color: fg }}>
          Settings
        </h1>
      </div>

      <div style={{ padding: "0 24px", flex: 1, paddingBottom: 40 }}>
        {/* Appearance section */}
        <h2
          style={{
            fontSize: 12,
            fontWeight: 700,
            color: muted,
            letterSpacing: "0.7px",
            textTransform: "uppercase",
            margin: 0,
            marginBottom: 10,
          }}
        >
          Appearance
        </h2>
        <div
          style={{
            background: card,
            border: `1px solid ${cardBorder}`,
            borderRadius: 16,
            overflow: "hidden",
            marginBottom: 24,
          }}
        >
          <div style={{ padding: "16px 16px 12px" }}>
            <p style={{ fontSize: 15, fontWeight: 600, color: fg, margin: 0, marginBottom: 4 }}>Theme</p>
            <p style={{ fontSize: 13, color: muted, margin: 0 }}>Choose how Pulse looks on your device</p>
          </div>
          {/* Segmented control */}
          <div style={{ padding: "0 16px 16px" }}>
            <div
              style={{
                display: "flex",
                background: segBg,
                borderRadius: 12,
                padding: 4,
                gap: 2,
              }}
            >
              {modes.map((mode) => {
                const active = themeMode === mode.id;
                return (
                  <button
                    key={mode.id}
                    onClick={() => onThemeChange(mode.id)}
                    style={{
                      flex: 1,
                      padding: "9px 8px",
                      border: "none",
                      borderRadius: 9,
                      background: active ? (isDark ? "#0D7377" : "#ffffff") : "transparent",
                      color: active ? (isDark ? "#ffffff" : primary) : muted,
                      fontSize: 13,
                      fontWeight: active ? 600 : 500,
                      fontFamily: "'DM Sans', system-ui, sans-serif",
                      cursor: "pointer",
                      display: "flex",
                      alignItems: "center",
                      justifyContent: "center",
                      gap: 5,
                      boxShadow: active ? (isDark ? "none" : "0 1px 4px rgba(0,0,0,0.1)") : "none",
                      transition: "all 0.15s",
                    }}
                  >
                    {mode.icon}
                    {mode.label}
                  </button>
                );
              })}
            </div>
          </div>
        </div>

        {/* Other settings */}
        <h2
          style={{
            fontSize: 12,
            fontWeight: 700,
            color: muted,
            letterSpacing: "0.7px",
            textTransform: "uppercase",
            margin: 0,
            marginBottom: 10,
          }}
        >
          General
        </h2>
        <div
          style={{
            background: card,
            border: `1px solid ${cardBorder}`,
            borderRadius: 16,
            overflow: "hidden",
            marginBottom: 32,
          }}
        >
          {extraRows.map((row, i) => (
            <div
              key={row.label}
              style={{
                padding: "16px",
                display: "flex",
                alignItems: "center",
                gap: 12,
                borderBottom: i < extraRows.length - 1 ? `1px solid ${cardBorder}` : "none",
                cursor: "pointer",
              }}
            >
              <div
                style={{
                  width: 36,
                  height: 36,
                  borderRadius: 9,
                  background: isDark ? "#1F3333" : "#E8F0F0",
                  display: "flex",
                  alignItems: "center",
                  justifyContent: "center",
                  color: primary,
                  flexShrink: 0,
                }}
              >
                {row.icon}
              </div>
              <div style={{ flex: 1 }}>
                <p style={{ fontSize: 15, fontWeight: 500, color: fg, margin: 0 }}>{row.label}</p>
                <p style={{ fontSize: 13, color: muted, margin: 0 }}>{row.subtitle}</p>
              </div>
              <ChevronRight size={16} color={muted} />
            </div>
          ))}
        </div>

        {/* Version */}
        <p style={{ textAlign: "center", fontSize: 13, color: muted }}>Pulse v1.0.0</p>
      </div>
    </div>
  );
}
