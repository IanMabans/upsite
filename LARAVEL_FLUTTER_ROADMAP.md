# Laravel & Flutter Implementation Roadmap

## 🎯 Overview

Your Go microservice is now handling all the backend monitoring, alerting, and incident management. Now you need to build:

1. **Laravel Dashboard** - Web interface for configuration and monitoring
2. **Flutter Mobile App** - Mobile monitoring and push notifications

---

## 📱 FLUTTER APP - Priority Features

### Phase 1: Core Monitoring (Week 1-2)

#### 1.1 Authentication
```dart
// Screens needed:
- LoginScreen
- RegisterScreen
- ForgotPasswordScreen
- ProfileScreen
```

**API Integration:**
```dart
// Use Laravel Sanctum for API tokens
POST /api/login
POST /api/register
POST /api/logout
GET /api/user
```

#### 1.2 Dashboard/Home Screen
```dart
// Features:
- Overview cards (Total endpoints, Active, Down, Up)
- Recent incidents list
- Quick actions (Add endpoint, View alerts)
- Refresh pull-to-refresh
```

**API Endpoints:**
```dart
GET /api/dashboard/stats
GET /api/incidents?status=open&limit=5
GET /api/endpoints?with=latest_check
```

#### 1.3 Endpoints List & Details
```dart
// EndpointsListScreen:
- Search/filter endpoints
- Status badges (up/down/degraded)
- Response time indicators
- Pull to refresh

// EndpointDetailScreen:
- Endpoint info (URL, method, interval)
- Recent checks graph (last 24h)
- Current status with uptime %
- Edit/Delete actions
- Quick test button
```

**API Endpoints:**
```dart
GET /api/endpoints
GET /api/endpoints/{id}
GET /api/endpoints/{id}/checks?last=24h
POST /api/endpoints/{id}/test-now
PUT /api/endpoints/{id}
DELETE /api/endpoints/{id}
```

#### 1.4 Add/Edit Endpoint Form
```dart
// Form fields:
- Name (TextField)
- URL (TextField with validation)
- Method (Dropdown: GET, POST, PUT, DELETE)
- Expected Status (NumberField)
- Interval (Slider: 1-60 min)
- Timeout (Slider: 5-60 sec)
- Enable SSL monitoring (Switch)
- Enable DNS checking (Switch)
- Headers (Key-Value pairs)
- Expected content (Optional TextField)
```

**API:**
```dart
POST /api/endpoints
PUT /api/endpoints/{id}
```

### Phase 2: Alerting & Notifications (Week 3)

#### 2.1 Push Notifications Setup
```dart
// Use Firebase Cloud Messaging (FCM)
- Request notification permissions
- Store FCM token in Laravel backend
- Handle foreground notifications
- Handle background notifications
- Notification tap actions
```

**API:**
```dart
POST /api/push-tokens
{
  "token": "fcm_device_token",
  "device_type": "android", // or "ios"
  "device_name": "Pixel 7"
}
```

#### 2.2 Incidents Screen
```dart
// IncidentsListScreen:
- Tab bar: Open / Resolved / All
- Incident cards with severity colors
- Time since started (for open)
- Duration (for resolved)
- Affected endpoint name
- Failed checks count

// IncidentDetailScreen:
- Full incident timeline
- Service checks during incident
- Resolution notes
- Duration graph
```

**API:**
```dart
GET /api/incidents?status=open
GET /api/incidents/{id}
GET /api/incidents/{id}/checks
```

#### 2.3 Alert Settings Screen
```dart
// Features:
- Alert channels list (Slack, Discord, Email, SMS)
- Add new channel button
- Edit/Delete channels
- Test channel button
- Enable/Disable toggle per channel
```

**API:**
```dart
GET /api/alert-channels
POST /api/alert-channels
PUT /api/alert-channels/{id}
DELETE /api/alert-channels/{id}
POST /api/alert-channels/{id}/test
```

#### 2.4 Alert Rules Screen
```dart
// AlertRulesScreen:
- List of rules per endpoint
- Rule type badges
- Add rule button

// AddRuleScreen:
- Endpoint selector (Dropdown)
- Rule type (Dropdown):
  * Consecutive failures
  * Response time threshold
  * SSL expiry warning
  * Downtime duration
- Configuration (dynamic based on type)
- Alert channels (Multi-select)
```

**API:**
```dart
GET /api/alert-rules?endpoint_id=1
POST /api/alert-rules
PUT /api/alert-rules/{id}
DELETE /api/alert-rules/{id}
```

### Phase 3: Real-Time Updates (Week 4)

#### 3.1 WebSocket Integration
```dart
// Use Laravel Echo + Pusher or Socket.io
// Real-time events:
- endpoint.checked -> Update endpoint status
- incident.created -> Show notification
- incident.resolved -> Update UI
- alert.sent -> Show alert history
```

**Setup:**
```dart
// pubspec.yaml
dependencies:
  pusher_channels_flutter: ^2.0.0
  
// In app:
PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
await pusher.init(
  apiKey: 'your-pusher-key',
  cluster: 'your-cluster',
);

Channel channel = await pusher.subscribe(
  channelName: 'user.${userId}',
);

channel.bind('endpoint.checked', (event) {
  // Update UI
});
```

#### 3.2 Live Status Indicators
```dart
// Features:
- Real-time endpoint status updates
- Live uptime percentage
- Response time graphs updating
- Incident counters
```

### Phase 4: Advanced Features (Week 5+)

#### 4.1 Statistics & Graphs
```dart
// Screens:
- UptimeScreen (per endpoint)
  * 7-day uptime graph
  * 30-day uptime percentage
  * Average response time
  
- ResponseTimeScreen
  * Response time trends
  * Percentiles (p50, p95, p99)
```

**API:**
```dart
GET /api/endpoints/{id}/uptime?days=7
GET /api/endpoints/{id}/response-times?days=7
GET /api/endpoints/{id}/stats
```

#### 4.2 Teams/Organizations
```dart
// If multi-user:
- OrganizationsScreen
- Team members management
- Role-based permissions
```

#### 4.3 Settings & Preferences
```dart
// App settings:
- Theme (Light/Dark/System)
- Notification preferences
- Auto-refresh interval
- Language selection
```

---

## 🌐 LARAVEL DASHBOARD - Priority Features

### Phase 1: Core Dashboard (Week 1-2)

#### 1.1 Authentication & User Management

**Already have Laravel? Use existing auth or:**
```php
// Use Laravel Breeze or Jetstream
composer require laravel/breeze --dev
php artisan breeze:install
```

**Additional:**
- Profile management
- API token management (Sanctum)
- Two-factor authentication (optional)

#### 1.2 Dashboard Home

**Route:** `/dashboard`

**Features:**
- Overview cards (Total endpoints, Active incidents, Recent alerts)
- Recent activity timeline
- Quick actions sidebar
- Endpoints status summary table

**Controller:**
```php
// app/Http/Controllers/DashboardController.php
public function index()
{
    $stats = [
        'total_endpoints' => Endpoint::count(),
        'active_endpoints' => Endpoint::where('is_active', true)->count(),
        'open_incidents' => Incident::where('status', 'open')->count(),
        'alerts_today' => Alert::whereDate('created_at', today())->count(),
    ];
    
    $recentIncidents = Incident::with('endpoint')
        ->where('status', 'open')
        ->latest()
        ->take(5)
        ->get();
    
    $recentChecks = ServiceCheck::with('endpoint')
        ->latest('checked_at')
        ->take(10)
        ->get();
    
    return view('dashboard.index', compact('stats', 'recentIncidents', 'recentChecks'));
}
```

**View:** `resources/views/dashboard/index.blade.php`

#### 1.3 Endpoints Management

**Routes:**
```php
// routes/web.php
Route::resource('endpoints', EndpointController::class);
Route::post('endpoints/{endpoint}/test', [EndpointController::class, 'test']);
Route::post('endpoints/{endpoint}/toggle', [EndpointController::class, 'toggleActive']);
```

**Controller:**
```php
// app/Http/Controllers/EndpointController.php
class EndpointController extends Controller
{
    public function index()
    {
        $endpoints = Endpoint::withCount(['checks', 'incidents'])
            ->with(['latestCheck', 'currentIncident'])
            ->paginate(20);
        
        return view('endpoints.index', compact('endpoints'));
    }
    
    public function create()
    {
        return view('endpoints.create');
    }
    
    public function store(StoreEndpointRequest $request)
    {
        $endpoint = auth()->user()->endpoints()->create($request->validated());
        
        return redirect()
            ->route('endpoints.show', $endpoint)
            ->with('success', 'Endpoint created successfully');
    }
    
    public function show(Endpoint $endpoint)
    {
        $endpoint->load(['latestCheck', 'currentIncident', 'alertRules']);
        
        $checksLast24h = $endpoint->checks()
            ->where('checked_at', '>=', now()->subDay())
            ->orderBy('checked_at')
            ->get();
        
        $uptime = $this->calculateUptime($endpoint, 30); // 30 days
        
        return view('endpoints.show', compact('endpoint', 'checksLast24h', 'uptime'));
    }
    
    public function test(Endpoint $endpoint)
    {
        // Could trigger immediate check or just return latest
        $latestCheck = $endpoint->latestCheck;
        
        return response()->json([
            'status' => $latestCheck->status,
            'response_time' => $latestCheck->response_time_ms,
            'checked_at' => $latestCheck->checked_at,
        ]);
    }
}
```

**Views:**
- `resources/views/endpoints/index.blade.php` - List with filters
- `resources/views/endpoints/create.blade.php` - Add form
- `resources/views/endpoints/edit.blade.php` - Edit form
- `resources/views/endpoints/show.blade.php` - Detail page with graphs

### Phase 2: Alerting & Incidents (Week 3)

#### 2.1 Incidents Management

**Routes:**
```php
Route::get('incidents', [IncidentController::class, 'index'])->name('incidents.index');
Route::get('incidents/{incident}', [IncidentController::class, 'show'])->name('incidents.show');
Route::post('incidents/{incident}/resolve', [IncidentController::class, 'resolve'])->name('incidents.resolve');
Route::post('incidents/{incident}/notes', [IncidentController::class, 'addNote'])->name('incidents.notes');
```

**Controller:**
```php
public function index()
{
    $incidents = Incident::with('endpoint')
        ->when(request('status'), function ($q, $status) {
            $q->where('status', $status);
        })
        ->latest('started_at')
        ->paginate(20);
    
    return view('incidents.index', compact('incidents'));
}

public function show(Incident $incident)
{
    $incident->load(['endpoint', 'checks']);
    
    return view('incidents.show', compact('incident'));
}
```

**Views:**
- `resources/views/incidents/index.blade.php` - List with tabs (Open/Resolved)
- `resources/views/incidents/show.blade.php` - Timeline and details

#### 2.2 Alert Channels Configuration

**Routes:**
```php
Route::resource('alert-channels', AlertChannelController::class);
Route::post('alert-channels/{channel}/test', [AlertChannelController::class, 'test']);
```

**Controller:**
```php
public function create()
{
    $channelTypes = [
        'slack' => 'Slack',
        'discord' => 'Discord',
        'webhook' => 'Custom Webhook',
        'email' => 'Email',
        'sms' => 'SMS',
    ];
    
    return view('alert-channels.create', compact('channelTypes'));
}

public function store(Request $request)
{
    $validated = $request->validate([
        'name' => 'required|string|max:255',
        'channel_category' => 'required|in:slack,discord,webhook,email,sms',
        'config' => 'required|array',
        'is_default' => 'boolean',
    ]);
    
    $channel = auth()->user()->alertChannels()->create($validated);
    
    return redirect()->route('alert-channels.index');
}

public function test(AlertChannel $channel)
{
    // Create a test alert in database
    $alert = Alert::create([
        'alert_channel_id' => $channel->id,
        'user_id' => auth()->id(),
        'subject' => 'Test Alert',
        'message' => 'This is a test alert from Laravel',
        'payload' => json_encode(['test' => true]),
        'status' => 'pending',
        'queued_at' => now(),
    ]);
    
    return back()->with('success', 'Test alert queued. Check your channel in a few seconds.');
}
```

**Views:**
- `resources/views/alert-channels/index.blade.php` - List of channels
- `resources/views/alert-channels/create.blade.php` - Add channel form (dynamic config based on type)
- `resources/views/alert-channels/edit.blade.php` - Edit channel

#### 2.3 Alert Rules

**Routes:**
```php
Route::resource('alert-rules', AlertRuleController::class);
```

**Controller:**
```php
public function create()
{
    $endpoints = Endpoint::where('is_active', true)->get();
    $channels = AlertChannel::where('is_active', true)->get();
    
    $ruleTypes = [
        'consecutive_failures' => 'Consecutive Failures',
        'response_time_threshold' => 'Response Time Threshold',
        'ssl_expiry' => 'SSL Certificate Expiry',
        'downtime_duration' => 'Downtime Duration',
    ];
    
    return view('alert-rules.create', compact('endpoints', 'channels', 'ruleTypes'));
}

public function store(Request $request)
{
    $validated = $request->validate([
        'endpoint_id' => 'required|exists:monitor_endpoints,id',
        'name' => 'required|string|max:255',
        'rule_type' => 'required|in:consecutive_failures,response_time_threshold,ssl_expiry,downtime_duration',
        'rule_config' => 'required|array',
        'channel_ids' => 'required|array',
    ]);
    
    $rule = auth()->user()->alertRules()->create([
        'endpoint_id' => $validated['endpoint_id'],
        'name' => $validated['name'],
        'rule_type' => $validated['rule_type'],
        'rule_config' => json_encode($validated['rule_config']),
        'is_active' => true,
    ]);
    
    // Attach channels
    $rule->channels()->attach($validated['channel_ids']);
    
    return redirect()->route('endpoints.show', $validated['endpoint_id']);
}
```

### Phase 3: Statistics & Reports (Week 4)

#### 3.1 Uptime Reports

**Route:** `/endpoints/{endpoint}/uptime`

**Features:**
- Daily uptime percentage (last 30 days)
- Monthly uptime (last 12 months)
- Downtime incidents summary
- Response time trends

**Controller:**
```php
public function uptimeReport(Endpoint $endpoint)
{
    $days = request('days', 30);
    
    $dailyUptime = DB::table('service_checks')
        ->select(
            DB::raw('DATE(checked_at) as date'),
            DB::raw('COUNT(*) as total_checks'),
            DB::raw('SUM(CASE WHEN status = "up" THEN 1 ELSE 0 END) as up_checks')
        )
        ->where('endpoint_id', $endpoint->id)
        ->where('checked_at', '>=', now()->subDays($days))
        ->groupBy('date')
        ->get()
        ->map(function ($row) {
            return [
                'date' => $row->date,
                'uptime_percentage' => ($row->up_checks / $row->total_checks) * 100,
            ];
        });
    
    $incidents = $endpoint->incidents()
        ->where('started_at', '>=', now()->subDays($days))
        ->get();
    
    return view('endpoints.uptime', compact('endpoint', 'dailyUptime', 'incidents'));
}
```

#### 3.2 Response Time Analytics

**Features:**
- Average response time graph
- Percentiles (p50, p95, p99)
- Slowest checks
- Geographic latency (if monitoring from multiple locations)

### Phase 4: Real-Time Features (Week 5)

#### 4.1 WebSocket Events Setup

**Install Laravel Echo & Pusher:**
```bash
composer require pusher/pusher-php-server
npm install --save-dev laravel-echo pusher-js
```

**Configure:**
```php
// config/broadcasting.php
'pusher' => [
    'driver' => 'pusher',
    'key' => env('PUSHER_APP_KEY'),
    'secret' => env('PUSHER_APP_SECRET'),
    'app_id' => env('PUSHER_APP_ID'),
    'options' => [
        'cluster' => env('PUSHER_APP_CLUSTER'),
        'useTLS' => true,
    ],
],
```

**Create Events:**
```php
// app/Events/EndpointChecked.php
class EndpointChecked implements ShouldBroadcast
{
    public $endpoint;
    public $check;
    
    public function broadcastOn()
    {
        return new PrivateChannel('user.' . $this->endpoint->user_id);
    }
}

// app/Events/IncidentCreated.php
class IncidentCreated implements ShouldBroadcast
{
    public $incident;
    
    public function broadcastOn()
    {
        return new PrivateChannel('user.' . $this->incident->endpoint->user_id);
    }
}
```

**Frontend (Blade):**
```javascript
// resources/js/app.js
import Echo from 'laravel-echo';
import Pusher from 'pusher-js';

window.Echo = new Echo({
    broadcaster: 'pusher',
    key: process.env.MIX_PUSHER_APP_KEY,
    cluster: process.env.MIX_PUSHER_APP_CLUSTER,
    forceTLS: true
});

// Listen for events
Echo.private(`user.${userId}`)
    .listen('EndpointChecked', (e) => {
        // Update endpoint status in UI
        updateEndpointStatus(e.endpoint.id, e.check.status);
    })
    .listen('IncidentCreated', (e) => {
        // Show notification
        showIncidentNotification(e.incident);
    });
```

#### 4.2 Live Dashboard

**Features:**
- Real-time endpoint status updates
- Live incident counter
- Toast notifications for new incidents
- Auto-refreshing graphs

---

## 📊 Integration Architecture

```
┌─────────────────┐
│   Flutter App   │
│  (Mobile/Web)   │
└────────┬────────┘
         │ REST API + WebSocket
         │ (Laravel Sanctum Auth)
         ▼
┌─────────────────┐
│     Laravel     │◄──────────┐
│   (Dashboard)   │           │
└────────┬────────┘           │
         │                    │
         │ Shared Database    │ Database
         ▼                    │ Read/Write
┌─────────────────┐           │
│  MySQL Database │◄──────────┘
│  (api_monitor)  │
└────────┬────────┘
         ▲
         │ Read Endpoints
         │ Write Results
         │
┌────────┴────────┐
│ Go Microservice │
│   (Monitoring)  │
└─────────────────┘
```

---

## 🚀 Quick Start Checklist

### Laravel (Priority 1)

- [ ] Set up authentication (Breeze/Jetstream)
- [ ] Create Eloquent models (see LARAVEL_INTEGRATION.md)
- [ ] Build dashboard controller and views
- [ ] Create endpoints CRUD (index, create, edit, show)
- [ ] Build incidents list and detail pages
- [ ] Create alert channels management
- [ ] Create alert rules management
- [ ] Set up API routes for Flutter (Sanctum)
- [ ] Implement WebSocket broadcasting (optional)

### Flutter (Priority 2)

- [ ] Set up project structure
- [ ] Implement authentication screens
- [ ] Create API service layer (Dio/http)
- [ ] Build home dashboard screen
- [ ] Create endpoints list and detail screens
- [ ] Implement add/edit endpoint forms
- [ ] Set up FCM push notifications
- [ ] Create incidents screen
- [ ] Build alert settings screens
- [ ] Implement WebSocket connection (optional)
- [ ] Add state management (Provider/Riverpod/Bloc)

### Testing

- [ ] Test endpoint creation flow (Laravel → Go checks it)
- [ ] Test alert rule creation (Laravel → Go triggers alerts)
- [ ] Test push notifications (Go → Laravel → FCM → Flutter)
- [ ] Test real-time updates (Go → Laravel broadcasts → Flutter receives)

---

## 📚 Recommended Packages

### Laravel
```bash
composer require laravel/sanctum  # API authentication
composer require spatie/laravel-permission  # Role-based permissions
composer require pusher/pusher-php-server  # WebSocket
composer require barryvdh/laravel-debugbar  # Development debugging
```

### Flutter
```yaml
dependencies:
  dio: ^5.3.0  # HTTP client
  flutter_secure_storage: ^9.0.0  # Secure token storage
  provider: ^6.0.5  # State management
  firebase_messaging: ^14.7.0  # Push notifications
  fl_chart: ^0.65.0  # Charts/graphs
  pusher_channels_flutter: ^2.0.0  # WebSocket
  intl: ^0.18.1  # Date formatting
  shared_preferences: ^2.2.2  # Local storage
```

---

## 💡 Next Steps

1. **Start with Laravel Dashboard** - Build the web interface first so you can configure endpoints and test the Go service
2. **Add API Routes** - Create RESTful API endpoints for Flutter to consume
3. **Build Flutter App** - Once API is ready, build the mobile app
4. **Implement Push Notifications** - Set up FCM and test end-to-end
5. **Add Real-Time Updates** - Implement WebSocket for live monitoring

Want me to generate specific code for any of these sections? Just ask! 🚀
