# Screenshot configuration for fastlane snapshot
# Run with: fastlane snapshot

# The only device screenshots are captured on
devices([
  "iPhone 16 Pro"
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
