allprojects {
    repositories {
        google()
        mavenCentral()
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

// Fix for older plugins (e.g. isar_flutter_libs) that don't declare a namespace,
// which is required by AGP 8+. Listen for the android library plugin to be applied,
// then immediately set the namespace from AndroidManifest.xml if missing.
subprojects {
    plugins.withId("com.android.library") {
        val androidExtension = project.extensions.getByType(com.android.build.gradle.LibraryExtension::class.java)
        if (androidExtension.namespace.isNullOrEmpty()) {
            val manifestFile = project.file("src/main/AndroidManifest.xml")
            if (manifestFile.exists()) {
                val manifest = javax.xml.parsers.DocumentBuilderFactory.newInstance()
                    .newDocumentBuilder()
                    .parse(manifestFile)
                val packageName = manifest.documentElement.getAttribute("package")
                if (packageName.isNotEmpty()) {
                    androidExtension.namespace = packageName
                }
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
