pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        file("local.properties").inputStream().use { properties.load(it) }
        val flutterSdkPath = properties.getProperty("flutter.sdk")
        require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
        flutterSdkPath
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    // Flutter loader – must stay here
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"

    // Android Gradle Plugin (fixes your 8.3.1 → 8.6.0 error)
    id("com.android.application") version "8.6.0" apply false

    // Kotlin plugin (fixes your 1.9.24 → 2.1.0 warning)
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false

    // Firebase / Google Sign-In plugin (needed for google-services.json)
    id("com.google.gms.google-services") version "4.4.2" apply false
}

rootProject.name = "kolor_kash_3d_mobile_new"
include(":app")
