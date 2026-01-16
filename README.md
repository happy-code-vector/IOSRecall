# ThinkFirst iOS

> AI-powered active recall learning app for iOS - Think First, Then Unlock

## Overview

ThinkFirst iOS is a complete port of the web version, featuring:
- **Dark Focus aesthetic** - Terminal-inspired UI with neon accents
- **Active recall learning** - Students explain before AI reveals answers
- **Gamification** - Streaks, badges, XP, and levels
- **Family features** - Parent dashboard and leaderboard
- **Premium subscriptions** - Solo and Family plans
- **Smooth animations** - All transitions match PRD specifications

## Project Status

### ✅ Complete
- Core architecture and app structure
- All data models (User, Learning, Badge, Family)
- Services (Storage, API)
- Complete design system (Dark Focus theme)
- Animation system with all PRD specs
- Shared UI components (GlassCard, Buttons, Rings, etc.)
- Onboarding flow structure
- Root navigation

### 🚧 In Progress
- Onboarding screens (2/8 complete)
- Main app screens

### ⏳ To Do
- Learning loop (Home, Attempt, Evaluation, Answer)
- Progress and history screens
- Badge system UI
- Family features UI
- Pricing and subscriptions
- Voice input
- Haptic feedback

## Quick Start

### Prerequisites
- Xcode 15+
- iOS 16+ deployment target
- Supabase account
- OpenAI API key

### Setup

1. **Open Project**
   ```bash
   cd iOS
   open ThinkFirst.xcodeproj
   ```

2. **Add New Files to Xcode**
   - Right-click `ThinkFirst` folder in Xcode
   - Select "Add Files to ThinkFirst"
   - Add: Models, Services, Theme, Views folders
   - Check "Copy items if needed"
   - Select "Create groups"

3. **Configure API**
   - Edit `Services/APIService.swift`
   - Replace `baseURL` with your Supabase URL
   - Replace `apiKey` with your Supabase anon key

4. **Build and Run**
   - Select iPhone 15 Pro simulator
   - Press Cmd+R

## Architecture

### Models
- **User.swift** - User accounts, types, subscriptions
- **Learning.swift** - Questions, attempts, evaluations
- **Badge.swift** - 20 badges across 3 categories
- **Family.swift** - Family features and leaderboard

### Services
- **StorageService** - Local persistence (UserDefaults)
- **APIService** - Backend communication (Supabase)

### Theme
- **ThinkFirstTheme** - Complete design system
- **Animations** - All animation presets and helpers

### Views
```
Views/
├── Onboarding/    - 8 screens (splash to login)
├── Auth/          - Login and signup
├── Home/          - Main learning interface
├── Learning/      - Attempt, evaluation, answer
├── Progress/      - Stats and history
├── Badges/        - Badge collection
├── Family/        - Parent dashboard and leaderboard
├── Profile/       - Settings and account
├── Pricing/       - Subscription plans
├── Techniques/    - Study methods library
└── Shared/        - Reusable components
```

## Design System

### Colors
```swift
// Backgrounds
ThinkFirstTheme.Colors.pureBlack        // #000000
ThinkFirstTheme.Colors.voidGrey         // #121212
ThinkFirstTheme.Colors.surfaceGlass     // rgba(20,20,20,0.95)

// Text
ThinkFirstTheme.Colors.ghostWhite       // #EDEDED
ThinkFirstTheme.Colors.textSecondary    // 70% opacity
ThinkFirstTheme.Colors.textTertiary     // 50% opacity

// Accents
ThinkFirstTheme.Colors.electricViolet   // #8B5CF6
ThinkFirstTheme.Colors.cyberMint        // #00FF94
ThinkFirstTheme.Colors.safetyOrange     // #FF5F1F
ThinkFirstTheme.Colors.cyan             // #22D3EE
ThinkFirstTheme.Colors.gold             // #FFBF00
```

### Typography
```swift
ThinkFirstTheme.Typography.largeTitle   // 34pt bold
ThinkFirstTheme.Typography.title1       // 28pt bold
ThinkFirstTheme.Typography.title2       // 22pt semibold
ThinkFirstTheme.Typography.headline     // 17pt semibold
ThinkFirstTheme.Typography.body         // 17pt regular
ThinkFirstTheme.Typography.subheadline  // 15pt regular
```

### Animations
```swift
// Presets
.animation(.thinkFirstFast, value: x)      // 150ms
.animation(.thinkFirstStandard, value: x)  // 220ms
.animation(.thinkFirstSlow, value: x)      // 300ms

// Transitions
.transition(.screenPush)   // Forward navigation
.transition(.screenPop)    // Back navigation
.transition(.slideUp)      // Modals

// Modifiers
.unlockAnimation(isUnlocked: true)
.streakAnimation(trigger: streakIncreased)
.badgeUnlockAnimation(isUnlocked: true)
.pulse()
.shimmer()
```

### Components
```swift
// Glass card
GlassCard {
    Text("Content")
}

// Primary button
PrimaryButton("Continue", style: .primary) {
    // Action
}

// Score ring
ScoreRing(
    score: 8,
    maxScore: 10,
    color: ThinkFirstTheme.Colors.electricViolet,
    label: "Effort"
)

// Streak badge
StreakBadge(count: 7)
```

## Features

### Core Learning Loop
1. **Home** - Ask a question
2. **Attempt Gate** - Explain in your own words
3. **Evaluation** - AI scores effort + understanding
4. **Answer** - Unlock full explanation

### Gamification
- **Streaks** - Daily learning habit tracking
- **Badges** - 20 achievements across 3 categories
- **XP & Levels** - Progress through learning milestones
- **Mastery Mode** - 2× streak rewards for harder challenges

### Family Features
- **Parent Dashboard** - Monitor children's progress
- **Family Leaderboard** - Friendly competition
- **Guardian Settings** - PIN-protected controls
- **Invite System** - Connect up to 5 family members

### Premium
- **Free** - 3 questions/day, 5 unlocks/day
- **Solo ($9.99/mo)** - Unlimited + voice input + mastery mode
- **Family ($14.99/mo)** - All Solo + 5 seats + parent dashboard

## API Integration

### Endpoints
```swift
// Evaluation
POST /evaluate
Body: { question, attempt, userId, masteryMode, gradeLevel }

// Streak
GET /streak/:userId
POST /streak/:userId/increment

// Badges
GET /badges/:userId
POST /badges/:userId/check

// Family
POST /family/generate-invite
POST /family/connect-student
GET /family/members/:userId
```

### Configuration
1. Create Supabase project
2. Deploy edge functions from `web/supabase/functions`
3. Add OpenAI API key to Supabase secrets
4. Update `APIService.swift` with credentials

## Development

### File Structure
```
iOS/ThinkFirst/
├── Models/              ✅ Complete
├── Services/            ✅ Complete
├── Theme/               ✅ Complete
├── Views/
│   ├── Onboarding/     🟡 2/8 screens
│   ├── Shared/         🟡 4 components
│   └── [Others]        ⏳ TODO
├── ThinkFirstApp.swift  ✅ Complete
└── ContentView.swift    ✅ Complete
```

### Next Steps
1. Complete onboarding screens
2. Implement learning loop
3. Add gamification UI
4. Build family features
5. Integrate subscriptions
6. Polish animations
7. Test and launch

### Testing
```bash
# Run tests
Cmd+U

# Run on simulator
Cmd+R

# Run on device
1. Connect iPhone
2. Select device in Xcode
3. Cmd+R
```

## Documentation

- **GETTING_STARTED.md** - Setup and first steps
- **IMPLEMENTATION_PLAN.md** - Complete development roadmap
- **Reference/PRD.md** - Product requirements
- **Reference/PRODUCT_SPEC.md** - Detailed specifications

## Resources

### Design Reference
- Web version: `web/src/components`
- Figma: [Active Recall Learning App](https://www.figma.com/design/Q0pJQGinaFgEJmVVmb7Odj/)

### Dependencies
- Supabase Swift SDK (planned)
- StoreKit 2 (subscriptions)
- Speech framework (voice input)
- AVFoundation (audio)

## Timeline

- **Week 1-2**: Onboarding + Auth
- **Week 2-3**: Learning loop
- **Week 3-4**: Gamification
- **Week 4-5**: Family features
- **Week 5-6**: Premium + Polish
- **Week 6-8**: Testing + Launch

**Total**: 6-8 weeks for full feature parity

## Success Criteria

- ✅ All features from web version
- ✅ Animations match PRD specs
- ✅ 60fps performance
- ✅ No crashes or bugs
- ✅ 4.5+ star rating target

## Contributing

1. Follow SwiftUI best practices
2. Match design system exactly
3. Test on real device
4. Keep animations smooth (60fps)
5. Add comments for complex logic

## License

Proprietary - All rights reserved

## Contact

For questions or support, refer to documentation or web implementation.

---

**Status**: Foundation Complete ✅  
**Next**: Implement learning loop screens  
**Priority**: Home → Attempt → Evaluation → Answer
