# ─── Flutter ────────────────────────────────────────────────
-keep class io.flutter.** { *; }
-keep class io.flutter.embedding.** { *; }

# ─── Drift (SQLite) ─────────────────────────────────────────
-keep class com.drift.** { *; }
-keep @androidx.room.** class * { *; }

# ─── flutter_blue_plus ──────────────────────────────────────
-keep class com.boskokg.flutter_blue_plus.** { *; }

# ─── flutter_foreground_task ────────────────────────────────
-keep class com.pravera.flutter_foreground_task.** { *; }

# ─── audioplayers ───────────────────────────────────────────
-keep class xyz.luan.audioplayers.** { *; }

# ─── permission_handler ─────────────────────────────────────
-keep class com.baseflow.permissionhandler.** { *; }

# ─── Kotlin coroutines ──────────────────────────────────────
-keepnames class kotlinx.coroutines.internal.MainDispatcherFactory {}
-keepnames class kotlinx.coroutines.CoroutineExceptionHandler {}


# ─── General ────────────────────────────────────────────────
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
-dontwarn **
