import { useState } from "react";
import { Eye, EyeOff, Loader2 } from "lucide-react";

type LoginState = "default" | "error" | "loading";

export function LoginScreen({ isDark }: { isDark: boolean }) {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [showPass, setShowPass] = useState(false);
  const [loginState, setLoginState] = useState<LoginState>("default");

  const bg = isDark ? "#0E1A1A" : "#F5F9F9";
  const fg = isDark ? "#E8F2F2" : "#1A2E2E";
  const muted = isDark ? "#7AACAC" : "#4A6B6B";
  const inputBg = isDark ? "#1F3333" : "#EDF4F4";
  const border = isDark ? "rgba(255,255,255,0.08)" : "rgba(13,115,119,0.15)";
  const primary = "#0D7377";
  const errorColor = isDark ? "#CF6679" : "#B3261E";

  const hasError = loginState === "error";

  const handleSignIn = () => {
    if (!email || !password) {
      setLoginState("error");
      return;
    }
    setLoginState("loading");
    setTimeout(() => setLoginState("default"), 2000);
  };

  const Field = ({
    label,
    type,
    value,
    onChange,
    placeholder,
    trailingIcon,
  }: {
    label: string;
    type: string;
    value: string;
    onChange: (v: string) => void;
    placeholder: string;
    trailingIcon?: React.ReactNode;
  }) => (
    <div style={{ display: "flex", flexDirection: "column", gap: 6 }}>
      <label style={{ fontSize: 13, fontWeight: 500, color: muted }}>{label}</label>
      <div style={{ position: "relative" }}>
        <input
          type={type}
          placeholder={placeholder}
          value={value}
          onChange={(e) => {
            onChange(e.target.value);
            if (hasError) setLoginState("default");
          }}
          style={{
            width: "100%",
            padding: trailingIcon ? "14px 48px 14px 16px" : "14px 16px",
            fontSize: 16,
            fontFamily: "'DM Sans', system-ui, sans-serif",
            background: inputBg,
            border: `1.5px solid ${hasError && !value ? errorColor : border}`,
            borderRadius: 12,
            color: fg,
            outline: "none",
            boxSizing: "border-box",
          }}
        />
        {trailingIcon && (
          <button
            onClick={() => setShowPass(!showPass)}
            style={{
              position: "absolute",
              right: 14,
              top: "50%",
              transform: "translateY(-50%)",
              background: "none",
              border: "none",
              color: muted,
              cursor: "pointer",
              padding: 4,
              display: "flex",
            }}
          >
            {trailingIcon}
          </button>
        )}
      </div>
    </div>
  );

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
      <div style={{ height: 52 }} />

      <div>
        {/* Logo */}
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
          <span style={{ fontSize: 20, fontWeight: 700, letterSpacing: "-0.3px" }}>Pulse</span>
        </div>

        <h1 style={{ fontSize: 30, fontWeight: 700, letterSpacing: "-0.6px", margin: 0, marginBottom: 6 }}>
          Sign in to Pulse
        </h1>
        <p style={{ fontSize: 15, color: muted, margin: 0, marginBottom: 36 }}>Welcome back.</p>

        <div style={{ display: "flex", flexDirection: "column", gap: 16 }}>
          <Field
            label="Email"
            type="email"
            placeholder="you@example.com"
            value={email}
            onChange={setEmail}
          />
          <Field
            label="Password"
            type={showPass ? "text" : "password"}
            placeholder="••••••••"
            value={password}
            onChange={setPassword}
            trailingIcon={showPass ? <EyeOff size={18} /> : <Eye size={18} />}
          />

          {hasError && (
            <div
              style={{
                background: isDark ? "rgba(207,102,121,0.12)" : "rgba(179,38,30,0.08)",
                border: `1px solid ${errorColor}`,
                borderRadius: 10,
                padding: "10px 14px",
                fontSize: 14,
                color: errorColor,
              }}
            >
              Email or password is incorrect. Please try again.
            </div>
          )}

          <div style={{ textAlign: "right", marginTop: -8 }}>
            <span style={{ fontSize: 14, color: primary, fontWeight: 500, cursor: "pointer" }}>
              Forgot password?
            </span>
          </div>
        </div>
      </div>

      <div style={{ paddingBottom: 40 }}>
        <button
          onClick={handleSignIn}
          disabled={loginState === "loading"}
          style={{
            width: "100%",
            padding: "16px",
            background: loginState === "loading" ? "#0A5A5E" : primary,
            color: "#ffffff",
            border: "none",
            borderRadius: 14,
            fontSize: 16,
            fontWeight: 600,
            fontFamily: "'DM Sans', system-ui, sans-serif",
            cursor: loginState === "loading" ? "default" : "pointer",
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            gap: 8,
          }}
        >
          {loginState === "loading" ? (
            <>
              <Loader2 size={18} style={{ animation: "spin 1s linear infinite" }} />
              Signing in…
            </>
          ) : (
            "Sign in"
          )}
        </button>
        <p style={{ textAlign: "center", fontSize: 13, color: muted, marginTop: 16 }}>
          New to Pulse?{" "}
          <span style={{ color: primary, fontWeight: 500, cursor: "pointer" }}>Get started</span>
        </p>
      </div>

      <style>{`@keyframes spin { to { transform: rotate(360deg); } }`}</style>
    </div>
  );
}
