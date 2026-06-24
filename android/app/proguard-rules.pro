# Razorpay SDK keep rules
# Keeps Razorpay classes and the annotation-based payment callbacks from being
# stripped/obfuscated when minification is enabled for release builds.
-keepattributes *Annotation*
-dontwarn com.razorpay.**
-keep class com.razorpay.** { *; }
-optimizations !method/inlining/*
-keepclasseswithmembers class * {
  public void onPayment*(...);
}

# ProGuard sometimes flags these optional Google Pay / annotation deps that
# Razorpay references reflectively. Suppress the warnings.
-dontwarn proguard.annotation.**
-keep class proguard.annotation.** { *; }
