# ThinkFirst iOS - Getting Started

## What's Been Created

I've set up the complete foundation for the ThinkFirst iOS app with all the architecture needed to match the web version's features, interface, animations, and styles.

### ✅ Core Architecture

**Models** (Complete data structures)
- `User.swift` - User accounts, types, subscription tiers
- `Learning.swift` - Questions, evaluations, attempts
- `Badge.swift` - All 20 badges with categories
- `Family.swift` - Family features, invites, leaderboard

**Services** (Backend integration)
- `StorageService.swift` - Local data persistence (UserDefaults)
- `APIService.swift` - Supabase API integration with all endpoints

**Theme** (Dark Focus Design System)
- `ThinkFirstTheme.swift` - Complete design system:
  - Colors (Void Grey, Electric Violet, Cyber Mint, etc.)
  - Typography (all font sizes and weights)
  - Spacing and corner radius
  - Animation durations
  - Glassmorphism styles

**App Structure**
- `ThinkFirstApp.swift` - Main app with AppState management
- `ContentView.swift` - Root navigation (renamed to RootView)
- `OnboardingFlow.swift` - Complete onboarding coordinator

**Shared UI Components**
- `GlassCard.swift` - Glassmorphic card component
- `PrimaryButton.swift` - Animated button with tap feedback
- `ScoreRing.swift` - Circular progress rings for scores
- `StreakBadge.swift` - Streak counter with fire emoji

**Onboarding Screens**
- `SplashScreen.swift` - Animated logo intro
- `AccountTypeScreen.swift` - Student vs Parent selection

### 📋 Implementation Plan

Created `IMPLEMENTATION_PLAN.md` with:
- Complete project structure
- All 50+ screens to implement
- Detailed animation specifications
- API integration guide
- Testing checklist
- 8-week development roadmap

## Project Structure

```
iOS/ThinkFirst/
├── Models/                    ✅ Complete
│   ├── User.swift
│   ├── Learning.swift
│   ├── Badge.swift
│   └── Family.swift
├── Services/                  ✅ Complete
│   ├── StorageService.swift
│   └── APIService.swift
├── Theme/                     ✅ Complete
│   └── ThinkFirstTheme.swift
├── Views/
│   ├── Onboarding/           🟡 Started (2/8 screens)
│   │   ├── OnboardingFlow.swift
│   │   ├── SplashScreen.swift
│   │   ├── AccountTypeScreen.swift
│   │   ├── GradeSelectionScreen.swift      ⏳ TODO
│   │   ├── GoalSelectionScreen.swift       ⏳ TODO
│   │   ├── MethodologyScreen.swift         ⏳ TODO
│   │   ├── TryItDemoScreen.swift           ⏳ TODO
│   │   └── NotificationPermissionScreen.swift ⏳ TODO
│   ├── Auth/                 ⏳ TODO
│   ├── Home/                 ⏳ TODO
│   ├── Learning/             ⏳ TODO
│   ├── Progress/             ⏳ TODO
│   ├── Badges/               ⏳ TODO
│   ├── Family/               ⏳ TODO
│   ├── Profile/              ⏳ TODO
│   ├── Pricing/              ⏳ TODO
│   ├── Techniques/           ⏳ TODO
│   └── Shared/               🟡 Started (4 components)
│       ├── GlassCard.swift
│       ├── PrimaryButton.swift
│       ├── ScoreRing.swift
│       └── StreakBadge.swift
├── ThinkFirstApp.swift        ✅ Complete
└── ContentView.swift          ✅ Complete (RootView)
```

## Next Steps

### Immediate (To Get App Running)

1. **Add Files to Xcode Project**
   - Open `ThinkFirst.xcodeproj` in Xcode
   - Right-click on `ThinkFirst` folder
   - Select "Add Files to ThinkFirst"
   - Add all the new folders: Models, Services, Theme, Views
   - Make sure "Copy items if needed" is checked
   - Select "Create groups" (not folder references)

2. **Fix Compilation Errors**
   - Build the project (Cmd+B)
   - Fix any missing imports or references
   - Ensure all files are in the correct target

3. **Complete Remaining Onboarding Screens**
   - GradeSelectionScreen.swift
   - GoalSelectionScreen.swift
   - MethodologyScreen.swift
   - TryItDemoScreen.swift
   - NotificationPermissionScreen.swift
   - LoginScreen.swift

4. **Create Placeholder Screens**
   Create empty placeholder views for:
   - HomeScreen.swift
   - ProgressScreen.swift
   - HistoryScreen.swift
   - TechniquesScreen.swift
   - ProfileScreen.swift
   - ParentDashboard.swift
   - FamilyLeaderboard.swift
   - ParentProfileScreen.swift

### Phase 1: Core Learning Loop (Priority)

The most important feature is the learning loop. Implement in this order:

1. **HomeScreen** - Question input with:
   - Large text field with purple halo
   - Streak badge in top right
   - Starter quest chips
   - Voice input button (locked for free users)

2. **AttemptGate** - Where students write their attempt:
   - Question display
   - Large text area
   - Character counter
   - Mastery mode toggle
   - Submit button (disabled until >10 words)

3. **EvaluationScreen** - AI evaluation results:
   - Loading animation with cycling text
   - Dual score rings (Effort + Understanding)
   - Feedback sections
   - Unlock button or Retry with coach tip

4. **AnswerScreen** - Final answer reveal:
   - Question recap
   - User's attempt
   - Full AI explanation
   - Streak update animation

### Phase 2: Gamification

1. **Badge System**
   - BadgesScreen with grid layout
   - BadgeUnlockModal with celebration
   - Auto-check after unlocks

2. **Progress Tracking**
   - ProgressScreen with stats
   - HistoryScreen with question log
   - XP and level system

### Phase 3: Family Features

1. **Parent Dashboard**
   - Student cards
   - Family Squad Streak
   - Quick actions

2. **Family Connection**
   - Invite code generation
   - Join family flow
   - Leaderboard

### Phase 4: Premium & Polish

1. **Subscription System**
   - PricingScreen
   - StoreKit integration
   - Paywall modals

2. **Animations & Haptics**
   - All transitions polished
   - Haptic feedback
   - Unlock animation

## Design System Usage

### Colors
```swift
// Backgrounds
ThinkFirstTheme.Colors.pureBlack
ThinkFirstTheme.Colors.voidGrey
ThinkFirstTheme.Colors.surfaceGlass

// Text
ThinkFirstTheme.Colors.ghostWhite
ThinkFirstTheme.Colors.textSecondary
ThinkFirstTheme.Colors.textTertiary

// Accents
ThinkFirstTheme.Colors.electricViolet
ThinkFirstTheme.Colors.cyberMint
ThinkFirstTheme.Colors.safetyOrange
ThinkFirstTheme.Colors.cyan
ThinkFirstTheme.Colors.gold
```

### Typography
```swift
ThinkFirstTheme.Typography.largeTitle
ThinkFirstTheme.Typography.title1
ThinkFirstTheme.Typography.title2
ThinkFirstTheme.Typography.headline
ThinkFirstTheme.Typography.body
ThinkFirstTheme.Typography.subheadline
```

### Spacing
```swift
ThinkFirstTheme.Spacing.xs  // 4
ThinkFirstTheme.Spacing.sm  // 8
ThinkFirstTheme.Spacing.md  // 16
ThinkFirstTheme.Spacing.lg  // 24
ThinkFirstTheme.Spacing.xl  // 32
```

### Animations
```swift
// Duration
ThinkFirstTheme.Animation.fast      // 0.15s
ThinkFirstTheme.Animation.standard  // 0.22s
ThinkFirstTheme.Animation.slow      // 0.3s

// Usage
.animation(.easeInOut(duration: ThinkFirstTheme.Animation.standard), value: someValue)
```

### Components
```swift
// Glass card
GlassCard {
    Text("Content")
}

// Button
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

## API Configuration

Before the app can communicate with the backend:

1. **Get Supabase Credentials**
   - Create a Supabase project at https://supabase.com
   - Get your project URL and anon key
   - Add OpenAI API key to Supabase secrets

2. **Update APIService.swift**
   ```swift
   private let baseURL = "https://your-project.supabase.co/functions/v1"
   private let apiKey = "your-supabase-anon-key"
   ```

3. **Deploy Edge Functions**
   - Deploy all functions from web/supabase/functions
   - Test endpoints with Postman or curl

## Testing the App

### Run in Simulator
1. Open project in Xcode
2. Select iPhone 15 Pro simulator
3. Press Cmd+R to build and run
4. Test onboarding flow

### Test on Device
1. Connect iPhone via USB
2. Select your device in Xcode
3. Sign with your Apple Developer account
4. Build and run

### Key Flows to Test
- [ ] Onboarding completes successfully
- [ ] Student vs Parent paths work
- [ ] Grade selection (students only)
- [ ] Data persists after app restart
- [ ] All animations smooth (60fps)
- [ ] Dark mode looks correct

## Common Issues & Solutions

### Build Errors
- **"Cannot find type 'X'"** → File not added to target
- **"Module not found"** → Missing import statement
- **"Ambiguous use"** → Name conflict, use full path

### Runtime Errors
- **App crashes on launch** → Check AppState initialization
- **Data not persisting** → Verify StorageService keys
- **API calls fail** → Check network permissions in Info.plist

### UI Issues
- **Colors look wrong** → Ensure .preferredColorScheme(.dark)
- **Animations choppy** → Reduce animation complexity
- **Layout broken** → Check safe area insets

## Resources

### Documentation
- `IMPLEMENTATION_PLAN.md` - Complete development roadmap
- `Reference/PRD.md` - Full product requirements
- `Reference/PRODUCT_SPEC.md` - Detailed specifications

### Web Reference
- `web/src/components` - React components to port
- `web/src/styles` - CSS styles to convert
- `web/package.json` - Feature list

### Design Assets Needed
- App icon (1024x1024)
- Launch screen logo
- Badge icons (20 total)
- Technique card icons

### Third-Party Libraries
Consider adding via SPM:
- Supabase Swift SDK
- Lottie (for complex animations)
- Kingfisher (for image loading)

## Development Tips

### SwiftUI Best Practices
- Use `@State` for local view state
- Use `@EnvironmentObject` for shared app state
- Extract complex views into separate files
- Use `#Preview` for rapid iteration

### Performance
- Lazy load lists with `LazyVStack`
- Cache images and data
- Debounce text input
- Use `Task` for async operations

### Animations
- Match web timings exactly (220ms standard)
- Use `.easeInOut` for most animations
- Add haptic feedback for important actions
- Test on real device (simulator is faster)

### Code Organization
- One screen per file
- Group related screens in folders
- Keep models separate from views
- Reuse components via Shared folder

## Support

For questions or issues:
1. Check `IMPLEMENTATION_PLAN.md` for detailed specs
2. Reference web implementation in `web/src/components`
3. Review PRD for feature requirements
4. Test on real device, not just simulator

## Success Criteria

The iOS app is ready when:
- ✅ All screens implemented
- ✅ Animations match web version
- ✅ API integration working
- ✅ Subscriptions functional
- ✅ No crashes or bugs
- ✅ 60fps performance
- ✅ Passes App Store review

## Timeline Estimate

- **Week 1-2**: Complete onboarding + auth
- **Week 2-3**: Core learning loop
- **Week 3-4**: Gamification (streaks, badges, XP)
- **Week 4-5**: Family features
- **Week 5-6**: Premium & subscriptions
- **Week 6-8**: Polish, testing, launch

Total: **6-8 weeks** for full feature parity with web version.

---

**Current Status**: Foundation complete ✅  
**Next Step**: Add files to Xcode project and complete onboarding screens  
**Priority**: Get the learning loop working first (Home → Attempt → Evaluation → Answer)
