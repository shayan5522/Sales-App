// allprojects {
//     repositories {
//         google()
//         mavenCentral()
//     }
// }

// // Set a normal build directory (avoids empty path errors)
// rootProject.layout.buildDirectory.set(file("../build"))

// subprojects {
//     layout.buildDirectory.set(file("${rootProject.layout.buildDirectory.get()}/${project.name}"))
//     project.evaluationDependsOn(":app")
// }

// tasks.register<Delete>("clean") {
//     delete(rootProject.layout.buildDirectory)
// }
