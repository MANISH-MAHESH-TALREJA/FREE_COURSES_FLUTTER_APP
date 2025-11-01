plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "net.manish.blog"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "net.manish.blog"
        minSdk = 24
        targetSdk = 36
        versionCode = 21
        versionName = "2.1"

        multiDexEnabled =  true
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}


// build.gradle.kts (Module: app)

dependencies {
    implementation("androidx.multidex:multidex:2.0.1")
    implementation("com.google.android.recaptcha:recaptcha:18.8.0")
    //implementation("com.android.tools:desugar_jdk_libs:2.1.5")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}
