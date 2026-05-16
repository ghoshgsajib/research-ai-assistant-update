#!/bin/bash

# Flutter SDK ডাউনলোড করা (যদি আগে থেকে না থাকে)
if [ ! -d "flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b stable
fi

# পাথ সেট করা
export PATH="$PATH:`pwd`/flutter/bin"

# ওয়েব এনাবল করা
flutter config --enable-web

# ডিপেন্ডেন্সি গেট করা
flutter pub get

# ওয়েব বিল্ড তৈরি করা (Release mode)
flutter build web --release --base-href "/"
