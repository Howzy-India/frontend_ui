import express from "express";
import { createServer } from "http";
import { Server } from "socket.io";
import { createServer as createViteServer } from "vite";
import path from "path";
import { fileURLToPath } from "url";
import cookieParser from "cookie-parser";
import { google } from "googleapis";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Google OAuth Setup
const getGoogleOAuthClient = (redirectUri: string) => {
  return new google.auth.OAuth2(
    process.env.GOOGLE_CLIENT_ID,
    process.env.GOOGLE_CLIENT_SECRET,
    redirectUri
  );
};

async function startServer() {
  const app = express();
  
  // Add CORS headers for PWABuilder and other external tools
  app.use((req, res, next) => {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
    next();
  });

  app.use(express.json());
  app.use(cookieParser());
  const httpServer = createServer(app);
  const io = new Server(httpServer, {
    cors: {
      origin: "*",
      methods: ["GET", "POST"]
    }
  });

  const PORT = 3000;

  // Socket.io logic
  io.on("connection", (socket) => {
    console.log("A user connected:", socket.id);

    // Join rooms based on role (simple simulation)
    socket.on("join", (role) => {
      socket.join(role);
      console.log(`User ${socket.id} joined room: ${role}`);
    });

    // Handle broadcast from Super Admin to Pilots
    socket.on("send-broadcast", (notification) => {
      console.log("Broadcasting notification to pilots:", notification);
      // In a real app, we'd save this to a DB
      io.to("pilot").emit("new-notification", {
        ...notification,
        id: Date.now(),
        time: "Just now",
        unread: true
      });
    });

    // Handle new lead creation
    socket.on("new-lead", (lead) => {
      console.log("New lead added:", lead.name);
      io.to("pilot").emit("new-notification", {
        id: Date.now(),
        type: "new-lead",
        title: "New Lead Added",
        message: `${lead.name} is looking for a ${lead.lookingBhk} in ${lead.locationPreferred}.`,
        time: "Just now",
        unread: true,
        icon: "Users",
        color: "emerald"
      });
    });

    socket.on("disconnect", () => {
      console.log("User disconnected:", socket.id);
    });
  });

  // API routes
  app.get("/api/health", (req, res) => {
    res.json({ status: "ok" });
  });

  // --- Google Calendar Integration ---

  app.get("/api/auth/google/url", (req, res) => {
    const redirectUri = req.query.redirectUri as string;
    if (!redirectUri) {
      return res.status(400).json({ error: "redirectUri is required" });
    }
    const oauth2Client = getGoogleOAuthClient(redirectUri);
    const url = oauth2Client.generateAuthUrl({
      access_type: "offline",
      scope: ["https://www.googleapis.com/auth/calendar.events"],
      prompt: "consent"
    });
    res.json({ url });
  });

  app.get(["/auth/google/callback", "/auth/google/callback/"], async (req, res) => {
    const { code, state } = req.query;
    // We expect the client to pass the original redirectUri in the state, or we can reconstruct it
    // For simplicity, we can reconstruct it from the request if needed, but the client should use window.location.origin
    // We will just use the APP_URL or reconstruct it.
    // Actually, the redirect URI must match exactly what was sent.
    // Let's pass the redirectUri in the state parameter during the /api/auth/google/url call.
    
    // Wait, the client will just use window.location.origin + "/auth/google/callback"
    const protocol = req.headers["x-forwarded-proto"] || req.protocol;
    const host = req.headers["x-forwarded-host"] || req.headers.host;
    const redirectUri = `${protocol}://${host}/auth/google/callback`;

    try {
      const oauth2Client = getGoogleOAuthClient(redirectUri);
      const { tokens } = await oauth2Client.getToken(code as string);
      
      // Set cookies
      res.cookie("google_access_token", tokens.access_token, {
        secure: true,
        sameSite: "none",
        httpOnly: true,
        maxAge: 3600000 // 1 hour
      });
      if (tokens.refresh_token) {
        res.cookie("google_refresh_token", tokens.refresh_token, {
          secure: true,
          sameSite: "none",
          httpOnly: true,
          maxAge: 30 * 24 * 3600000 // 30 days
        });
      }

      res.send(`
        <html>
          <body>
            <script>
              if (window.opener) {
                window.opener.postMessage({ type: 'OAUTH_AUTH_SUCCESS' }, '*');
                window.close();
              } else {
                window.location.href = '/';
              }
            </script>
            <p>Authentication successful. This window should close automatically.</p>
          </body>
        </html>
      `);
    } catch (error) {
      console.error("OAuth error:", error);
      res.status(500).send("Authentication failed");
    }
  });

  app.get("/api/calendar/events", async (req, res) => {
    const accessToken = req.cookies.google_access_token;
    const refreshToken = req.cookies.google_refresh_token;

    if (!accessToken && !refreshToken) {
      return res.status(401).json({ error: "Not authenticated" });
    }

    try {
      const oauth2Client = new google.auth.OAuth2();
      oauth2Client.setCredentials({
        access_token: accessToken,
        refresh_token: refreshToken
      });

      const calendar = google.calendar({ version: "v3", auth: oauth2Client });
      const response = await calendar.events.list({
        calendarId: "primary",
        timeMin: new Date().toISOString(),
        maxResults: 10,
        singleEvents: true,
        orderBy: "startTime",
      });

      res.json({ events: response.data.items });
    } catch (error) {
      console.error("Calendar API error:", error);
      res.status(500).json({ error: "Failed to fetch events" });
    }
  });

  app.post("/api/calendar/events", async (req, res) => {
    const accessToken = req.cookies.google_access_token;
    const refreshToken = req.cookies.google_refresh_token;

    if (!accessToken && !refreshToken) {
      return res.status(401).json({ error: "Not authenticated" });
    }

    try {
      const oauth2Client = new google.auth.OAuth2();
      oauth2Client.setCredentials({
        access_token: accessToken,
        refresh_token: refreshToken
      });

      const calendar = google.calendar({ version: "v3", auth: oauth2Client });
      const { summary, description, start, end } = req.body;

      const response = await calendar.events.insert({
        calendarId: "primary",
        requestBody: {
          summary,
          description,
          start: { dateTime: start },
          end: { dateTime: end },
        },
      });

      res.json({ event: response.data });
    } catch (error) {
      console.error("Calendar API error:", error);
      res.status(500).json({ error: "Failed to create event" });
    }
  });

  app.get("/api/calendar/status", (req, res) => {
    const accessToken = req.cookies.google_access_token;
    const refreshToken = req.cookies.google_refresh_token;
    res.json({ connected: !!(accessToken || refreshToken) });
  });

  // --- End Google Calendar Integration ---

  // Vite middleware for development
  if (process.env.NODE_ENV !== "production") {
    const vite = await createViteServer({
      server: { middlewareMode: true },
      appType: "spa",
    });
    app.use(vite.middlewares);
  } else {
    // Serve static files in production
    app.use(express.static(path.join(__dirname, "dist"), {
      setHeaders: (res, filePath) => {
        if (filePath.endsWith('.webmanifest') || filePath.endsWith('manifest.json')) {
          res.setHeader('Content-Type', 'application/manifest+json');
        }
      }
    }));
    app.get("*", (req, res) => {
      res.sendFile(path.join(__dirname, "dist", "index.html"));
    });
  }

  httpServer.listen(PORT, "0.0.0.0", () => {
    console.log(`Server running on http://localhost:${PORT}`);
  });
}

startServer();
