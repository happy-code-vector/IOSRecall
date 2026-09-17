# Screenshot configuration for fastlane snapshot
# Run with: fastlane snapshot

# The only device screenshots are captured on.
# iPhone 17 Pro: same 6.3" logical resolution (402x874 pt) as iPhone 16 Pro —
# Xcode 26.x doesn't ship an iPhone 16 Pro simulator on the iOS 26.2 runtime,
# so this is the equivalent device that exists on the build Mac.
devices([
  "iPhone 17 Pro"
])

languages(["en-US"])

# Scheme containing the ThinkFirstUITests UI tests
scheme("ThinkFirst")

# Run only the screenshot test class (skips unit tests and other test targets)
only_testing(["ThinkFirstUITests/ThinkFirstUITests"])

# Where the resulting screenshots are stored
output_directory("./screenshots")

# Start fresh on every run
clear_previous_screenshots(true)

# Clean status bar (9:41 AM, full battery and reception)
override_status_bar(true)

# Don't keep running other work after a failure
stop_after_first_error(true)
