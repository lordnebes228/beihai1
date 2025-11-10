plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    // УДАЛИТЕ эту строку: id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.dwlq"
    compileSdk = 34

    defaultConfig {
        applicationId = "com.example.dwlq"
        minSdk = 21
        targetSdk = 34
        versionCode = 1
        versionName = "1.0.0"
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = false
            isShrinkResources = false
            // signingConfig = signingConfigs.debug
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    sourceSets {
        getByName("main").java.srcDirs("src/main/kotlin")
    }
}

// УДАЛИТЕ весь блок flutter { }