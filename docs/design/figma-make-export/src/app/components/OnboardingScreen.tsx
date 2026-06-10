import { useState } from "react";
import { ArrowRight, Loader2 } from "lucide-react";

type OnboardingState = "default" | "invalid" | "loading";

export function OnboardingScreen({ isDark }: { isDark: boolean }) {
  const [email, setEmail] = useState("");
  const [state, setState] = useState<OnboardingState>("default");

  const handleSubmit = () => {
    if (!email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
      setState("invalid");
      return;
    }
    setState("loading");
    setTimeout(() => setState("default"), 2000);
  };

  const bg = isDark ? "#0E1A1A" : "#F5F9F9";
  const fg = isDark ? "#E8F2F2" : "#1A2E2E";
  const muted = isDark ? "#7AACAC" : "#4A6B6B";
  const inputBg = isDark ? "#1F3333" : "#EDF4F4";
  const border = isDark ? "rgba(255,255,255,0.08)" : "rgba(13,115,119,0.15)";
  const errorBorder = "#B3261E";
  const primary = "#0D7377";

  return (
    <div
      style={{
        background: bg,
        color: fg,
        fontFamily: "'DM Sans', system-ui, sans-serif",
        height: "100%",
        display: "flex",
        flexDirection: "column",
        padding: "0 24px",
        justifyContent: "space-between",
      }}
    >
      {/* Status bar spacer */}
      <div style={{ height: 52 }} />

      {/* Logo mark */}
      <div style={{ display: "flex", flexDirection: "column", gap: 0 }}>
        <div style={{ display: "flex", alignItems: "center", gap: 8, marginBottom: 48 }}>
          <div
            style={{
              width: 36,
              height: 36,
              borderRadius: 10,
              background: primary,
              display: "flex",
              alignItems: "center",
              justifyContent: "center",
            }}
          >
            <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
              <path
                d="M10 3C6.13 3 3 6.13 3 10s3.13 7 7 7 7-3.13 7-7-3.13-7-7-7zm0 2c1.1 0 2.1.3 2.95.82L5.82 12.95A4.97 4.97 0 015 10c0-2.76 2.24-5 5-5zm0 10c-1.1 0-2.1-.3-2.95-.82l7.13-7.13c.52.85.82 1.85.82 2.95 0 2.76-2.24 5-5 5z"
                fill="white"
              />
            </svg>
          </div>
          <span style={{ fontSize: 20, fontWeight: 700, letterSpacing: "-0.3px", color: fg }}>
            Pulse
          </span>
        </div>

        {/* Hero text */}
        <div style={{ marginBottom: 40 }}>
          <h1
            style={{
              fontSize: 34,
              fontWeight: 700,
              letterSpacing: "-0.8px",
              lineHeight: 1.1,
              color: fg,
              margin: 0,
              marginBottom: 12,
            }}
          >
            Welcome to<br />Pulse
          </h1>
          <p style={{ fontSize: 16, lineHeight: 1.5, color: muted, margin: 0, maxWidth: 280 }}>
            Guided coaching for movement, recovery, and mindfulness — all in one place.
          </p>
        </div>

        {/* Form */}
        <div style={{ display: "flex", flexDirection: "column", gap: 8 }}>
          <label style={{ fontSize: 13, fontWeight: 500, color: muted, letterSpacing: "0.2px" }}>
            Email address
          </label>
          <div style={{ position: "relative" }}>
            <input
              type="email"
              placeholder="you@example.com"
              value={email}
              onChange={(e) => {
                setEmail(e.target.value);
                if (state === "invalid") setState("default");
              }}
              style={{
                width: "100%",
                padding: "14px 16px",
                fontSize: 16,
                fontFamily: "'DM Sans', system-ui, sans-serif",
                background: inputBg,
                border: `1.5px solid ${state === "invalid" ? errorBorder : border}`,
                borderRadius: 12,
                color: fg,
                outline: "none",
                boxSizing: "border-box",
                transition: "border-color 0.15s",
              }}
            />
          </div>
          {state === "invalid" && (
            <p style={{ fontSize: 13, color: "#B3261E", margin: 0, display: "flex", alignItems: "center", gap: 4 }}>
              <svg width="14" height="14" viewBox="0 0 14 14" fill="none">
                <circle cx="7" cy="7" r="6.5" stroke="#B3261E" />
                <path d="M7 4v3.5M7 9.5v.5" stroke="#B3261E" strokeWidth="1.4" strokeLinecap="round" />
              </svg>
              Please enter a valid email address.
            </p>
          )}
        </div>
      </div>

      {/* CTA */}
      <div style={{ paddingBottom: 40 }}>
        <button
          onClick={handleSubmit}
          disabled={state === "loading"}
          style={{
            width: "100%",
            padding: "16px",
            background: state === "loading" ? "#0A5A5E" : primary,
            color: "#ffffff",
            border: "none",
            borderRadius: 14,
            fontSize: 16,
            fontWeight: 600,
            fontFamily: "'DM Sans', system-ui, sans-serif",
            cursor: state === "loading" ? "default" : "pointer",
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            gap: 8,
            letterSpacing: "-0.1px",
            transition: "background 0.15s",
          }}
        >
          {state === "loading" ? (
            <>
              <Loader2 size={18} style={{ animation: "spin 1s linear infinite" }} />
              Getting started…
            </>
          ) : (
            <>
              Get started
              <ArrowRight size={18} />
            </>
          )}
        </button>
        <p style={{ textAlign: "center", fontSize: 13, color: muted, marginTop: 16 }}>
          Already have an account?{" "}
          <span style={{ color: primary, fontWeight: 500, cursor: "pointer" }}>Sign in</span>
        </p>
      </div>

      <style>{`@keyframes spin { to { transform: rotate(360deg); } }`}</style>
    </div>
  );
}
