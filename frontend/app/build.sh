#!/bin/bash

# ১. Flutter SDK ডাউনলোড
if [ ! -d "flutter" ]; then
  echo "Downloading Flutter SDK..."
  git clone https://github.com/flutter/flutter.git -b stable --depth 1
fi

# ২. পাথ সেট করা
export PATH="$PATH:`pwd`/flutter/bin"

# ৩. টুলস কনফিগার করা
flutter config --enable-web

# ৪. প্যাকেজ গেট করা
flutter pub get

# ৫. ওয়েব বিল্ড তৈরি করা (Vercel থেকে API Key নিয়ে)
echo "Building for web..."
# --dart-define ব্যবহার করে Vercel-এর কী-টি অ্যাপের ভেতর পাস করা হচ্ছে
flutter build web --release --base-href "/" --dart-define=OPENROUTER_API_KEY="$OPENROUTER_API_KEY"
