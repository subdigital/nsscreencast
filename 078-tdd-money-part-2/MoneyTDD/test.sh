command -v xctool >/dev/null 2>&1 || { echo >&2 "xctool not found. Please install with:  brew install xctool"; exit 1; }

xctool -workspace MoneyTDD.xcworkspace -scheme MoneyTDD -sdk iphonesimulator test ONLY_ACTIVE_ARCH=NO
