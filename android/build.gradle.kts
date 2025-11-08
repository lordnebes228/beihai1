// android/build.gradle.kts

buildscript {
    extra["kotlinVersion"] = "1.9.24"

    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath("com.android.tools.build:gradle:8.9.0") // обновлено до 8.9
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:${extra["kotlinVersion"]}")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Настройка директорий сборки
rootProject.buildDir = file("../build")

subprojects {
    buildDir = file("${rootProject.buildDir}/${name}")
    evaluationDependsOn(":app")
}

// Clean task
tasks.register<Delete>("clean") {
    delete(rootProject.buildDir)
}
