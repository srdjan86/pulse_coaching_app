import { useState } from "react";
import { Sun, Moon, Monitor } from "lucide-react";
import { OnboardingScreen } from "./components/OnboardingScreen";
import { LoginScreen } from "./components/LoginScreen";
import { HomeScreen } from "./components/HomeScreen";
import { LibraryScreen } from "./components/LibraryScreen";
import { LessonDetailScreen } from "./components/LessonDetailScreen";
import { SettingsScreen } from "./components/SettingsScreen";

type Screen = "onboarding" | "login" | "home" | "library" | "lesson" | "settings";
type ThemeMode = "system" | "light" | "dark";

const SCREENS: { id: Screen; label: string }[] = [
  { id: "onboarding", label: "Onboarding" },
  { id: "login", label: "Login" },
  { id: "home", label: "Home" },
  { id: "library", label: "Library" },
  { id: "lesson", label: "Lesson" },
  { id: "settings", label: "Settings" },
];

function PhoneFrame({ children, isDark }: { children: React.ReactNode; isDark: boolean }) {
  const frameBg = isDark ? "#1A1A1A" : "#2A2A2A";
  const screenBg = isDark ? "#0E1A1A" : "#F5F9F9";

  return (
    <div
      style={{
        width: 393,
        height: 852,
        background: frameBg,
        borderRadius: 52,
        padding: "10px",
        boxShadow: isDark
          ? "0 40px 80px rgba(0,0,0,0.7), inset 0 0 0 1px rgba(255,255,255,0.05)"
          : "0 40px 80px rgba(0,0,0,0.25), inset 0 0 0 1px rgba(0,0,0,0.15)",
        position: "relative",
        flexShrink: 0,
      }}
    >
      {/* Side buttons */}
      <div style={{ position: "absolute", left: -3, top: 100, width: 3, height: 36, background: isDark ? "#333" : "#444", borderRadius: "3px 0 0 3px" }} />
      <div style={{ position: "absolute", left: -3, top: 148, width: 3, height: 64, background: isDark ? "#333" : "#444", borderRadius: "3px 0 0 3px" }} />
      <div style={{ position: "absolute", left: -3, top: 224, width: 3, height: 64, background: isDark ? "#333" : "#444", borderRadius: "3px 0 0 3px" }} />
      <div style={{ position: "absolute", right: -3, top: 164, width: 3, height: 80, background: isDark ? "#333" : "#444", borderRadius: "0 3px 3px 0" }} />

      <div
        style={{
          width: "100%",
          height: "100%",
          background: screenBg,
          borderRadius: 44,
          overflow: "hidden",
          position: "relative",
        }}
      >
        {/* Dynamic island */}
        <div
          style={{
            position: "absolute",
            top: 12,
            left: "50%",
            transform: "translateX(-50%)",
            width: 126,
            height: 37,
            background: "#000",
            borderRadius: 20,
            zIndex: 100,
          }}
        />
        {children}
      </div>
    </div>
  );
}

function DesignTokens({ isDark }: { isDark: boolean }) {
  const bg = isDark ? "#162424" : "#ffffff";
  const fg = isDark ? "#E8F2F2" : "#1A2E2E";
  const muted = isDark ? "#7AACAC" : "#4A6B6B";
  const border = isDark ? "rgba(255,255,255,0.07)" : "rgba(13,115,119,0.1)";
  const primary = "#0D7377";

  const tokens = [
    { name: "Primary", value: "#0D7377", use: "CTAs, accents, links" },
    { name: "Surface", value: "#F5F9F9", use: "App background" },
    { name: "On Surface", value: "#1A2E2E", use: "Body text, headings" },
    { name: "Surface Container", value: "#E8F0F0", use: "Cards, elevated areas" },
    { name: "Error", value: "#B3261E", use: "Validation, errors" },
    { name: "Accent", value: "#14BDBC", use: "Highlights, teal pop" },
  ];

  const typeSizes = [
    { name: "Display", size: "34px", weight: "700", use: "Onboarding headline" },
    { name: "Headline", size: "28px", weight: "700", use: "Screen titles" },
    { name: "Title", size: "20px", weight: "600", use: "Card headings, app bars" },
    { name: "Body", size: "15–16px", weight: "400", use: "Content, descriptions" },
    { name: "Label", size: "12–13px", weight: "500–600", use: "Chips, metadata, captions" },
  ];

  const radii = [
    { name: "Inputs", value: "12px" },
    { name: "Cards", value: "14–16px" },
    { name: "Buttons", value: "14px" },
    { name: "Chips", value: "20px (pill)" },
    { name: "Phone notch", value: "20px" },
  ];

  const Section = ({ title, children }: { title: string; children: React.ReactNode }) => (
    <div style={{ marginBottom: 32 }}>
      <h3 style={{ fontSize: 12, fontWeight: 700, color: muted, letterSpacing: "0.8px", textTransform: "uppercase", margin: 0, marginBottom: 12 }}>
        {title}
      </h3>
      {children}
    </div>
  );

  return (
    <div
      style={{
        background: bg,
        borderRadius: 20,
        padding: "28px 24px",
        border: `1px solid ${border}`,
        color: fg,
        fontFamily: "'DM Sans', system-ui, sans-serif",
        width: 340,
        flexShrink: 0,
        maxHeight: 852,
        overflowY: "auto",
        scrollbarWidth: "none",
      }}
    >
      <div style={{ display: "flex", alignItems: "center", gap: 10, marginBottom: 28 }}>
        <div style={{ width: 10, height: 10, borderRadius: "50%", background: primary }} />
        <h2 style={{ fontSize: 16, fontWeight: 700, margin: 0, color: fg }}>Design tokens</h2>
      </div>

      <Section title="Color tokens">
        <div style={{ display: "flex", flexDirection: "column", gap: 8 }}>
          {tokens.map((t) => (
            <div key={t.name} style={{ display: "flex", alignItems: "center", gap: 10 }}>
              <div
                style={{
                  width: 28,
                  height: 28,
                  borderRadius: 7,
                  background: t.value,
                  border: `1px solid ${border}`,
                  flexShrink: 0,
                }}
              />
              <div style={{ flex: 1 }}>
                <p style={{ fontSize: 13, fontWeight: 600, color: fg, margin: 0 }}>{t.name}</p>
                <p style={{ fontSize: 11, color: muted, margin: 0 }}>{t.value} · {t.use}</p>
              </div>
            </div>
          ))}
        </div>
      </Section>

      <Section title="Typography · DM Sans">
        <div style={{ display: "flex", flexDirection: "column", gap: 10 }}>
          {typeSizes.map((t) => (
            <div key={t.name} style={{ borderBottom: `1px solid ${border}`, paddingBottom: 8 }}>
              <div style={{ display: "flex", justifyContent: "space-between", alignItems: "baseline" }}>
                <span style={{ fontSize: 13, fontWeight: 600, color: fg }}>{t.name}</span>
                <span style={{ fontSize: 11, color: muted }}>{t.size} / {t.weight}</span>
              </div>
              <p style={{ fontSize: 11, color: muted, margin: "2px 0 0" }}>{t.use}</p>
            </div>
          ))}
        </div>
      </Section>

      <Section title="Corner radius">
        <div style={{ display: "flex", flexDirection: "column", gap: 6 }}>
          {radii.map((r) => (
            <div key={r.name} style={{ display: "flex", justifyContent: "space-between" }}>
              <span style={{ fontSize: 13, color: fg }}>{r.name}</span>
              <span style={{ fontSize: 13, fontWeight: 600, color: primary }}>{r.value}</span>
            </div>
          ))}
        </div>
      </Section>

      <Section title="Spacing grid">
        <div style={{ display: "flex", flexDirection: "column", gap: 6 }}>
          {[["Base unit", "8dp"], ["Min tap target", "48dp"], ["Content padding", "24dp"], ["Card padding", "16–18dp"], ["Section gap", "24–32dp"]].map(([k, v]) => (
            <div key={k} style={{ display: "flex", justifyContent: "space-between" }}>
              <span style={{ fontSize: 13, color: fg }}>{k}</span>
              <span style={{ fontSize: 13, fontWeight: 600, color: primary }}>{v}</span>
            </div>
          ))}
        </div>
      </Section>

      <Section title="Dark mode surfaces">
        {[
          { name: "Background", value: "#0E1A1A" },
          { name: "Card", value: "#162424" },
          { name: "Muted surface", value: "#1F3333" },
          { name: "Muted text", value: "#7AACAC" },
          { name: "Primary (same)", value: "#0D7377" },
        ].map((t) => (
          <div key={t.name} style={{ display: "flex", alignItems: "center", gap: 10, marginBottom: 6 }}>
            <div style={{ width: 20, height: 20, borderRadius: 5, background: t.value, border: "1px solid rgba(255,255,255,0.1)", flexShrink: 0 }} />
            <span style={{ fontSize: 13, color: fg }}>{t.name}</span>
            <span style={{ fontSize: 11, color: muted, marginLeft: "auto" }}>{t.value}</span>
          </div>
        ))}
      </Section>
    </div>
  );
}

export default function App() {
  const [activeScreen, setActiveScreen] = useState<Screen>("onboarding");
  const [themeMode, setThemeMode] = useState<ThemeMode>("light");
  const [activeLessonId, setActiveLessonId] = useState("1");

  const systemDark = window.matchMedia?.("(prefers-color-scheme: dark)").matches ?? false;
  const isDark =
    themeMode === "dark" ? true : themeMode === "light" ? false : systemDark;

  const panelBg = isDark ? "#0A1414" : "#EDF4F4";
  const panelFg = isDark ? "#E8F2F2" : "#1A2E2E";
  const panelMuted = isDark ? "#7AACAC" : "#4A6B6B";
  const chipActive = "#0D7377";
  const chipInactive = isDark ? "#162424" : "#ffffff";
  const chipInactiveFg = isDark ? "#7AACAC" : "#4A6B6B";
  const chipActiveBorder = isDark ? "rgba(13,115,119,0.5)" : "rgba(13,115,119,0.3)";
  const chipInactiveBorder = isDark ? "rgba(255,255,255,0.07)" : "rgba(13,115,119,0.15)";

  const renderScreen = () => {
    switch (activeScreen) {
      case "onboarding":
        return <OnboardingScreen isDark={isDark} />;
      case "login":
        return <LoginScreen isDark={isDark} />;
      case "home":
        return (
          <HomeScreen
            isDark={isDark}
            onNavigate={(s) => {
              if (s === "library") setActiveScreen("library");
              if (s === "settings") setActiveScreen("settings");
            }}
          />
        );
      case "library":
        return (
          <LibraryScreen
            isDark={isDark}
            onBack={() => setActiveScreen("home")}
            onLesson={(id) => {
              setActiveLessonId(id);
              setActiveScreen("lesson");
            }}
          />
        );
      case "lesson":
        return (
          <LessonDetailScreen
            lessonId={activeLessonId}
            isDark={isDark}
            onBack={() => setActiveScreen("library")}
          />
        );
      case "settings":
        return (
          <SettingsScreen
            isDark={isDark}
            themeMode={themeMode}
            onThemeChange={(mode) => setThemeMode(mode)}
            onBack={() => setActiveScreen("home")}
          />
        );
    }
  };

  return (
    <div
      style={{
        minHeight: "100vh",
        background: panelBg,
        fontFamily: "'DM Sans', system-ui, sans-serif",
        display: "flex",
        flexDirection: "column",
        alignItems: "center",
        padding: "32px 24px",
        gap: 32,
        transition: "background 0.3s",
      }}
    >
      {/* Header */}
      <div style={{ display: "flex", alignItems: "center", gap: 16, width: "100%", maxWidth: 1200 }}>
        <div style={{ display: "flex", alignItems: "center", gap: 10 }}>
          <div
            style={{
              width: 32,
              height: 32,
              borderRadius: 9,
              background: "#0D7377",
              display: "flex",
              alignItems: "center",
              justifyContent: "center",
            }}
          >
            <svg width="18" height="18" viewBox="0 0 20 20" fill="none">
              <path d="M10 3C6.13 3 3 6.13 3 10s3.13 7 7 7 7-3.13 7-7-3.13-7-7-7zm0 2c1.1 0 2.1.3 2.95.82L5.82 12.95A4.97 4.97 0 015 10c0-2.76 2.24-5 5-5zm0 10c-1.1 0-2.1-.3-2.95-.82l7.13-7.13c.52.85.82 1.85.82 2.95 0 2.76-2.24 5-5 5z" fill="white" />
            </svg>
          </div>
          <span style={{ fontSize: 18, fontWeight: 700, color: panelFg, letterSpacing: "-0.3px" }}>
            Pulse · Design System
          </span>
        </div>
        <div style={{ marginLeft: "auto", display: "flex", gap: 4, background: isDark ? "#162424" : "#ffffff", borderRadius: 10, padding: 4, border: `1px solid ${isDark ? "rgba(255,255,255,0.07)" : "rgba(13,115,119,0.12)"}` }}>
          {([["system", <Monitor size={14} />], ["light", <Sun size={14} />], ["dark", <Moon size={14} />]] as [ThemeMode, React.ReactNode][]).map(([mode, icon]) => (
            <button
              key={mode}
              onClick={() => setThemeMode(mode)}
              style={{
                padding: "6px 10px",
                borderRadius: 7,
                border: "none",
                background: themeMode === mode ? "#0D7377" : "transparent",
                color: themeMode === mode ? "#fff" : panelMuted,
                cursor: "pointer",
                display: "flex",
                alignItems: "center",
                gap: 5,
                fontSize: 12,
                fontWeight: 500,
                fontFamily: "'DM Sans', system-ui, sans-serif",
                transition: "all 0.15s",
              }}
            >
              {icon}
              <span style={{ textTransform: "capitalize" }}>{mode}</span>
            </button>
          ))}
        </div>
      </div>

      {/* Screen tabs */}
      <div style={{ display: "flex", gap: 6, flexWrap: "wrap", justifyContent: "center" }}>
        {SCREENS.map((s) => (
          <button
            key={s.id}
            onClick={() => setActiveScreen(s.id)}
            style={{
              padding: "8px 16px",
              borderRadius: 22,
              border: `1.5px solid ${activeScreen === s.id ? chipActiveBorder : chipInactiveBorder}`,
              background: activeScreen === s.id ? chipActive : chipInactive,
              color: activeScreen === s.id ? "#ffffff" : chipInactiveFg,
              fontSize: 13,
              fontWeight: 600,
              fontFamily: "'DM Sans', system-ui, sans-serif",
              cursor: "pointer",
              transition: "all 0.15s",
            }}
          >
            {s.label}
          </button>
        ))}
      </div>

      {/* Content area */}
      <div
        style={{
          display: "flex",
          gap: 32,
          alignItems: "flex-start",
          flexWrap: "wrap",
          justifyContent: "center",
          width: "100%",
          maxWidth: 1200,
        }}
      >
        {/* Phone */}
        <PhoneFrame isDark={isDark}>
          {renderScreen()}
        </PhoneFrame>

        {/* Tokens panel */}
        <DesignTokens isDark={isDark} />
      </div>

      {/* Footer note */}
      <p style={{ fontSize: 12, color: panelMuted, textAlign: "center", maxWidth: 480, lineHeight: 1.6 }}>
        Pulse · iOS + Android · Flutter widget system · DM Sans · 8dp grid · WCAG AA contrast
        <br />
        Pages: 🎨 Design system · 📱 Screens – Light · 📱 Screens – Dark
      </p>
    </div>
  );
}
