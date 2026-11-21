allprojects {
    repositories {
        google()
        mavenCentral()
    }

    configurations.all {
        resolutionStrategy.dependencySubstitution {
            // Replaces Play dependant cronet with embdedded.
            // See: https://pub.dev/packages/cronet_http#use-embedded-cronet
            // This is a work-around for using dart-define.
            // Keep the version in sync with cronet_http's android/build.gradle
            substitute(module("com.google.android.gms:play-services-cronet"))
                .using(module("org.chromium.net:cronet-embedded:143.7445.0"))
        }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
