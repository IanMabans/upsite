add # 🚀 API Monitoring SaaS — Project Overview

This system consists of **three separate projects** working together:

1. Flutter Mobile App (iOS + Android)
2. Laravel Backend (API + Admin)
3. Go Microservice (Monitoring Engine)

Each project has a clear responsibility and must NOT overlap.

---

# 1️⃣ Flutter Mobile App (User Facing Application)

## 🎯 Purpose
The Flutter app is the main user-facing interface where customers:

- Create and manage endpoints they want monitored
- View uptime and downtime data
- Visualize latency charts
- Receive outage alerts
- Manage profile & settings

Flutter is ONLY responsible for UI + consuming the API.

## ✔ Responsibilities
### User Features
- Login / Register
- Dashboard overview
- Add, edit, delete endpoints
- See endpoint status (Up/Down)
- View monitoring history (logs)
- Latency charts (fl_chart)
- See alerts (outage notifications)
- Manage user profile

### Technical Responsibilities
- Call Laravel API endpoints
- Store auth token securely
- Display monitoring data fetched from Laravel
- Local caching (optional)
- Push notifications (later phase)

## ❌ Flutter Does NOT
- Perform monitoring
- Communicate with Go directly
- Handle business logic outside UI
- Perform authentication logic (other than token storage)
- Connect to the database
- Send alerts

---

# 2️⃣ Laravel Backend (API Gateway + Admin)

## 🎯 Purpose
Laravel acts as the **central API**, database owner, and admin dashboard.

It does NOT perform monitoring.  
It does NOT send alerts.  
It only manages user accounts, endpoints, results retrieval, and provides API for Flutter.

## ✔ Responsibilities
### Core Backend
- User registration, login, logout (Sanctum tokens)
- Managing endpoints (CRUD)
- Returning monitoring results (read-only)
- Returning alerts (read-only)
- Providing secure API for Flutter
- Admin dashboard (web)

### Database Management
- Migrations for all tables
- Models for:
  - User
  - MonitorEndpoint
  - MonitorResult
  - MonitorAlert

### Admin Panel
- View all users
- View all endpoints
- View recent results
- Basic reporting for internal use

## ❌ Laravel Does NOT
- Check uptime / HTTP requests
- Execute background monitoring
- Compute uptime percentages
- Generate alerts
- Communicate directly with Go
- Run cron for monitoring
- Process queues in Phase 1
- Integrate billing (future phase)

Laravel is a **pure API + Admin layer**.

---

# 3️⃣ Go Microservice (Monitoring Engine)

## 🎯 Purpose
The Go microservice performs **actual monitoring checks** and writes results into the shared database.

It runs continuously and independently from Laravel.

## ✔ Responsibilities
### Monitoring Logic
- Periodically fetch endpoints from DB
- Perform checks based on monitor_type:
  - HTTP status check
  - Latency measurement
  - Ping checks (phase 2)
  - DNS lookup checks (phase 2)
  - SSL certificate validation (phase 2)
- Write results to `monitor_results` table

### Alerts & Events
- Detect downtime
- Insert alert records into `monitor_alerts`
- (Later phases) trigger external alerting services

### System Responsibilities
- Scheduling monitoring jobs
- Handling errors and retries
- Logging for debugging
- Loading env variables

## ❌ Go Microservice Does NOT
- Expose any API endpoint
- Host a web server
- Handle authentication
- Send user-facing response
- Serve front-end
- Do anything with UI
- Manage users or endpoints
- Read/write anything except:
  - endpoints
  - results
  - alerts

Go is a **worker engine**, not a server.

---

# 🔄 How All 3 Projects Work Together

## Data Flow

**User → Flutter → Laravel → MariaDB → Go → MariaDB → Laravel → Flutter → User**

### Example Monitoring Cycle

1. User adds endpoint in Flutter.
2. Flutter sends it to Laravel API.
3. Laravel stores it in `monitor_endpoints`.
4. Go service wakes every X seconds.
5. Go reads endpoints from DB.
6. Go performs the check.
7. Go writes results to `monitor_results`.
8. Flutter dashboard requests results from Laravel.
9. Laravel returns results.
10. Flutter displays real-time charts.

---

# 🧱 Shared Infrastructure

All three depend on:

- **MariaDB** (shared database)
- **Docker** (optional but recommended)
- **Nginx** for Laravel hosting
- **API tokens** (Sanctum)

---

# 🚫 Zero Responsibility Overlap (IMPORTANT)

| Task | Flutter | Laravel | Go |
|------|---------|---------|-----|
| UI | ✔ | ❌ | ❌ |
| API auth | ❌ | ✔ | ❌ |
| User storage | ❌ | ✔ | ❌ |
| Monitoring checks | ❌ | ❌ | ✔ |
| Writing results | ❌ | ❌ | ✔ |
| Reading results | ✔ (via API) | ✔ | ❌ |
| Sending alerts | ❌ | ❌ (phase 1) | ✔ (phase 2) |
| Admin dashboard | ❌ | ✔ | ❌ |
| Business logic | ❌ | ✔ | ❌ |

---

# 📦 Final Output of Each Project

## Flutter → Compiled mobile app  
### Outputs:
- iOS IPA / App Store release  
- Android AAB / Play Store release  

---

## Laravel → Backend API  
### Outputs:
- Public API endpoints
- Admin dashboard
- Database schema
- Authentication system

---

## Go → Background monitoring binary  
### Outputs:
- monitor-engine (binary)
- Writes monitoring results
- Creates alert records

---

# 🌟 This file should be placed at the root of your workspace so AI agents understand the architecture.


