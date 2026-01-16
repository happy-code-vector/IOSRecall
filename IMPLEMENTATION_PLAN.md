# ThinkFirst iOS Implementation Plan

## Overview
This document outlines the complete implementation of the ThinkFirst iOS app, matching all features from the web version with identical interface, animations, and styles.

## Architecture

### Project Structure
```
iOS/ThinkFirst/
├── Models/
│   ├── User.swift ✅
│   ├── Learning.swift ✅
│   ├── Badge.swift ✅
│   └── Family.swift ✅
├── Services/
│   ├── StorageService.swift ✅
│   ├── APIService.swift ✅
│   ├── BadgeService.swift
│   └── HapticService.swift
├── Theme/
│   ├── ThinkFirstTheme.swift ✅
│   └── Animations.swift
├── Views/
│   ├── Onboarding/
│   │   ├── OnboardingFlow.swift ✅
│   │   ├── SplashScreen.swift
│   │   ├── AccountTypeScreen.swift
│   │   ├── GradeSelectionScreen.swift
│   │   ├── GoalSelectionScreen.swift
│   │   ├── MethodologyScreen.swift
│   │   ├── TryItDemoScreen.swift
│   │   └── NotificationPermissionScreen.swift
│   ├── Auth/
│   │   └── LoginScreen.swift
│   ├── Home/
│   │   ├── HomeScreen.swift
│   │   └── ClipboardPill.swift
│   ├── Learning/
│   │   ├── AttemptGate.swift
│   │   ├── EvaluationScreen.swift
│   │   ├── AnswerScreen.swift
│   │   ├── VoiceInputWaveform.swift
│   │   └── MasteryModeToggle.swift
│   ├── Progress/
│   │   ├── ProgressScreen.swift
│   │   ├── HistoryScreen.swift
│   │   └── ProgressTimeline.swift
│   ├── Badges/
│   │   ├── BadgesScreen.swift
│   │   ├── BadgeShowcase.swift
│   │   └── BadgeUnlockModal.swift
│   ├── Family/
│   │   ├── ParentDashboard.swift
│   │   ├── AddStudentScreen.swift
│   │   ├── JoinFamilyScreen.swift
│   │   ├── FamilyLeaderboard.swift
│   │   ├── FamilySquadStreakCard.swift
│   │   └── GuardianSettings.swift
│   ├── Profile/
│   │   ├── ProfileScreen.swift
│   │   ├── ParentProfileScreen.swift
│   │   └── SettingsScreen.swift
│   ├── Pricing/
│   │   ├── PricingScreen.swift
│   │   └── UpgradePrompt.swift
│   ├── Techniques/
│   │   └── TechniquesScreen.swift
│   └── Shared/
│       ├── GlassCard.swift
│       ├── PrimaryButton.swift
│       ├── ScoreRing.swift
│       ├── StreakBadge.swift
│       ├── MercyModal.swift
│       ├── LimitReachedModal.swift
│       └── NudgeBanner.swift
├── ThinkFirstApp.swift ✅
└── ContentView.swift ✅ (renamed to RootView)
```

## Design System Implementation

### Colors (Dark Focus)
- ✅ Void Grey (#121212)
- ✅ Pure Black (#000000)
- ✅ Ghost White (#EDEDED)
- ✅ Electric Violet (#8B5CF6)
- ✅ Cyber Mint (#00FF94)
- ✅ Safety Orange (#FF5F1F)
- ✅ Gold/Amber for family features

### Typography
- ✅ System font with proper weights
- ✅ Sizes matching web version

### Animations
All animations must match PRD specifications:
- Fast: 150-180ms (taps, ripple feedback)
- Standard: 220-260ms (screen transitions, cards)
- Slow: 300-350ms (unlock animation, streak progress)
- Use easeInOut curves

### Glassmorphism
- ✅ Background: rgba(20, 20, 20, 0.95)
- ✅ Backdrop blur
- ✅ 1px white border (10% opacity)
- ✅ Shadow: 0 8px 32px rgba(0, 0, 0, 0.4)

## Core Features Implementation

### 1. Onboarding Flow
**Status**: Structure created ✅

**Screens to implement**:
1. Splash Screen - Animated logo
2. Account Type Selection - Student vs Parent
3. Grade Selection - Only for students
4. Goal Selection - Different for student/parent
5. Methodology - Explain 3 principles
6. Try It Demo - Interactive sample
7. Notification Permission
8. Login/Signup - Apple/Google OAuth

**Key Requirements**:
- Parents skip grade selection
- Smooth transitions (220ms slide + fade)
- Dark focus aesthetic throughout

### 2. Learning Loop (Core Experience)

#### Home Screen
- Large input field with purple halo
- Placeholder: "What are we learning tonight?"
- Streak counter (top right)
- Clipboard detection pill
- Starter quest chips (horizontal scroll)
- Voice input button (premium only)

#### Attempt Gate
- Question display at top
- Large text area for attempt
- Character counter
- Mastery Mode toggle:
  - Standard: Cyan glow
  - Mastery: Orange/red with heat shimmer
- Voice input with waveform (premium)
- Submit button (disabled until >10 words)
- "I'm Stuck" and "Reveal Answer" options

#### Evaluation Screen
- Loading states with cycling text:
  - "Reading your attempt..."
  - "Analyzing logic..."
  - "Checking accuracy..."
  - "Unlocking..."
- 3D lock animation (300ms)
- Dual score rings:
  - Effort (purple)
  - Understanding (cyan)
- Feedback sections:
  - ✅ What You Got Right
  - ⚠️ What's Missing
- Unlock button or Retry with coach tip
- Badge check after unlock

#### Answer Screen
- Question recap
- User's attempt (editable)
- Full AI explanation
- Follow-up prompts
- "Save to History" button
- Streak update animation

### 3. Gamification

#### Streak System
- Fire emoji indicator
- Daily increment on first unlock
- 3 AM reset rule (not midnight)
- Streak freeze consumable
- Milestone badges at 3, 7, 14, 30, 100 days

#### Badge System
- 20 badges total (defined in Badge.swift ✅)
- Categories: Streaks, Mastery, Milestones
- Grid layout with locked/unlocked states
- Unlock modal with celebration animation
- Auto-check after each unlock

#### XP & Levels
- Formula: (effort + understanding) × 10
- Max 200 XP per question
- Exponential level progression
- Progress bar on Progress screen

### 4. Premium Features

#### Subscription Tiers
- Free: 3 questions/day, 5 unlocks/day
- Solo ($9.99/mo): Unlimited, voice input, mastery mode
- Family ($14.99/mo): All Solo + 5 seats + parent dashboard

#### Voice Input
- Microphone button in input field
- Animated waveform during recording
- Speech-to-text conversion
- Review before submit (no auto-submit)
- Premium-only with paywall

#### Mastery Mode
- 2× streak rewards
- Higher effort threshold
- Gold badge on unlock
- Guardian can force-enable

### 5. Family Features

#### Parent Dashboard
- Student cards (scrollable)
- Family Squad Streak card (gold theme)
- Quick actions:
  - Add Student
  - Guardian Settings
  - View Leaderboard
  - Download Report
- Student detail view with graphs

#### Family Invite System
- Parent generates 8-character code
- Code valid 24 hours
- Student enters code (OTP-style inputs)
- Up to 5 students per family
- Premium unlocks immediately

#### Family Leaderboard
- Time toggle: Daily/Weekly/All-Time
- Top 3 podium with medals
- Animated entrance (stagger)
- Nudge button per member
- Gold theme throughout

#### Guardian Settings
- PIN-protected access
- Force Mastery Mode toggle
- Block Mercy Button toggle
- Content filters
- Daily time limits
- Weekly report email config

### 6. Additional Screens

#### Progress Screen
- Total questions/unlocks
- Average score
- Current streak
- Level + XP bar
- Weekly activity graph
- Category breakdown
- Premium stats (locked for free)

#### History Screen
- Chronological question list
- Each card shows:
  - Question (truncated)
  - Date/time
  - Score badges
- Filter by date/score
- Retry button
- Tap to view full details

#### Techniques Screen
- Grid of study technique cards
- Categories:
  - Active Recall
  - Spaced Repetition
  - Feynman Technique
  - Pomodoro
  - Mind Mapping
  - Interleaving
- Tap for full explanation

#### Profile Screen (Student)
- Avatar + name
- Streak counter
- Level badge
- Actions:
  - Join Family Squad
  - View Badges
  - Settings
  - Upgrade to Premium
  - Log Out

#### Profile Screen (Parent)
- Avatar + name
- Family plan badge
- Actions:
  - Parent Dashboard
  - Guardian Settings
  - Family Leaderboard
  - Manage Plan
  - Settings
  - Log Out

## Motion & Animation Specifications

### Screen Transitions
- Push (forward): Slide right 16-24px + fade in, 220ms
- Pop (back): Slide right 16-24px + fade out, 200ms
- No zoom or overshoot

### Button Taps
- Tap down: Scale 100% → 97%, 80ms
- Release: Scale 97% → 100%, 80ms
- Slight darkening (5-8%)

### Loading States
- Fade out keyboard: 150ms
- Pulse animation: 800ms cycle
- Fade in content: 220ms with 12px slide up

### Unlock Animation (Signature)
1. Lock icon:
   - Rotation: 0° → -12° → 0°
   - Shackle moves up 4px
   - Duration: 300ms
2. Background glow:
   - Opacity: 0 → 50% → 0
   - Duration: 250ms
3. Answer section:
   - Slide up 16px + fade in
   - Duration: 260ms

### Streak Animations
- Increase: Scale 100% → 110% → 100%, 350ms
- Opacity flash: 70% → 100% → 70%
- Tiny spark on flame icon

### Badge Unlock
- 3D asset scale: 0% → 110% → 100%
- Radial glow rotates behind
- Confetti particles
- Celebration sound (optional)

### Haptic Feedback
- Input Tick: Light tap per character (optional toggle)
- Unlock Thud: Heavy impact on unlock
- Mastery Rev: Revving texture on toggle
- Error Shake: Warning double-tap for validation

## API Integration

### Endpoints (Supabase Edge Functions)
All implemented in APIService.swift ✅

- POST /evaluate - AI evaluation
- GET /streak/:userId - Get streak
- POST /streak/:userId/increment - Update streak
- GET /badges/:userId - Get badges
- POST /badges/:userId/check - Check new badges
- POST /family/generate-invite - Generate code
- POST /family/connect-student - Link accounts
- GET /family/children/:parentId - Get children
- GET /family/members/:userId - Get leaderboard

### Configuration
- Base URL: Supabase project URL
- API Key: Supabase anon key
- OpenAI API key for evaluation

## Data Storage

### Local Storage (UserDefaults)
Implemented in StorageService.swift ✅

- Current user
- User progress
- Grade level
- Question history
- Daily question count
- Onboarding status
- Guardian PIN
- Guardian settings

### Backend Storage (Supabase)
- User accounts
- Subscription data
- Family relationships
- Streak data
- Badge unlocks
- Question history (synced)

## Testing Checklist

### Onboarding
- [ ] Splash animation plays
- [ ] Account type selection works
- [ ] Students see grade selection
- [ ] Parents skip grade selection
- [ ] All transitions smooth (220ms)
- [ ] Data persists after completion

### Learning Loop
- [ ] Question input works
- [ ] Voice input (premium only)
- [ ] Clipboard detection
- [ ] Attempt validation (>10 words)
- [ ] Mastery mode toggle
- [ ] API evaluation call
- [ ] Loading states cycle
- [ ] Unlock animation plays
- [ ] Score rings animate
- [ ] Retry flow with coach tip
- [ ] Mercy modal works
- [ ] Streak increments
- [ ] Badge check triggers

### Gamification
- [ ] Streak counter updates
- [ ] Streak resets at 3 AM
- [ ] Badges unlock correctly
- [ ] Badge modal animates
- [ ] XP calculates correctly
- [ ] Level progression works

### Premium
- [ ] Free limits enforced (3 questions, 5 unlocks)
- [ ] Paywall shows correctly
- [ ] Voice input locked for free
- [ ] Mastery mode locked for free
- [ ] Upgrade flow works
- [ ] Subscription restores

### Family
- [ ] Parent dashboard loads
- [ ] Invite code generates
- [ ] Student can join with code
- [ ] Premium unlocks for student
- [ ] Leaderboard displays
- [ ] Nudge notifications work
- [ ] Guardian PIN protects settings
- [ ] Force mastery mode works
- [ ] Block mercy button works

### Animations
- [ ] All transitions 220ms
- [ ] Button taps scale correctly
- [ ] Unlock animation smooth
- [ ] Streak animation plays
- [ ] Badge unlock celebrates
- [ ] Haptics fire correctly

### Edge Cases
- [ ] Network errors handled
- [ ] Invalid invite codes rejected
- [ ] Expired codes rejected
- [ ] Daily limits reset at midnight
- [ ] Streak logic handles edge cases
- [ ] Concurrent operations safe

## Next Steps

### Phase 1: Core Foundation (Week 1)
1. ✅ Create all models
2. ✅ Implement theme system
3. ✅ Build storage service
4. ✅ Build API service
5. ✅ Create app structure
6. Create shared UI components
7. Implement animations helper

### Phase 2: Onboarding (Week 1-2)
1. Build all onboarding screens
2. Implement transitions
3. Add animations
4. Test flow end-to-end

### Phase 3: Learning Loop (Week 2-3)
1. Home screen with input
2. Attempt gate with validation
3. Evaluation screen with API
4. Answer screen
5. Voice input (premium)
6. Mastery mode toggle

### Phase 4: Gamification (Week 3-4)
1. Streak system
2. Badge system
3. XP and levels
4. Progress screen
5. History screen

### Phase 5: Family Features (Week 4-5)
1. Parent dashboard
2. Invite system
3. Family leaderboard
4. Guardian settings
5. Nudge notifications

### Phase 6: Premium & Polish (Week 5-6)
1. Pricing screen
2. Subscription integration
3. Paywall modals
4. All animations polished
5. Haptic feedback
6. Error handling
7. Loading states

### Phase 7: Testing & Launch (Week 6-8)
1. Comprehensive testing
2. Bug fixes
3. Performance optimization
4. App Store assets
5. Submit for review

## Resources Needed

### Assets
- App icon (1024x1024)
- Launch screen logo
- Badge icons (20 total)
- Technique card icons
- Placeholder avatars

### Third-Party SDKs
- Supabase Swift SDK
- StoreKit 2 (subscriptions)
- Speech framework (voice input)
- AVFoundation (audio)

### Backend Setup
- Supabase project
- Edge functions deployed
- OpenAI API key configured
- Database tables created
- KV store initialized

## Success Criteria

### Performance
- App launch < 2 seconds
- Screen transitions smooth (60fps)
- API calls < 3 seconds
- No memory leaks
- Battery efficient

### User Experience
- Onboarding < 60 seconds
- First unlock < 45 seconds
- All animations feel premium
- No confusing UI
- Accessible (VoiceOver support)

### Business Metrics
- 60% onboarding completion
- 30% day 7 retention
- 5% free-to-paid conversion
- 4.5+ star rating

## Notes

- All colors, spacing, and animations must match web version exactly
- Dark mode only (no light mode)
- iOS 16+ minimum
- iPhone and iPad support
- Portrait orientation primary
- Landscape support for iPad

## Contact

For questions or clarifications, refer to:
- Reference/PRD.md - Full product requirements
- Reference/PRODUCT_SPEC.md - Detailed specifications
- web/src/components - Web implementation reference
