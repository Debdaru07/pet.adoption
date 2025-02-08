# Keep all OkHttp3 classes
-keep class okhttp3.** { *; }

# Keep all Gson classes
-keep class com.google.gson.** { *; }

# Keep method signatures for generic types
-keepattributes Signature
