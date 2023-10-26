# Keep all classes in a specific package intact
-keep class com.example.myplugin.** { *; }

# Keep specific class intact
-keep class com.example.myplugin.MyClass { *; }
-keep class com.dexterous.** { *; }