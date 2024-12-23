# Keep all javax.annotation classes and annotations
-keep class javax.annotation.** { *; }

# Specifically keep the Nullable annotation
-keep @javax.annotation.Nullable class * { *; }

# Specifically keep the GuardedBy annotation
-keep @javax.annotation.concurrent.GuardedBy class * { *; }
