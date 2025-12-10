plugins {
    // Align the versions with the ones already on the classpath.
    id("com.android.application") version "8.7.0" apply false
    id("org.jetbrains.kotlin.android") version "1.8.22" apply false
}

tasks.register("clean", Delete::class) {
    delete(rootProject.buildDir)
}
