dependencies {
    implementation("${project.extra["nacos"]}")
    implementation("${project.extra["gateway"]}")
    implementation("${project.extra["webflux"]}")
    implementation("${project.extra["sa-reactor"]}")
    implementation("${project.extra["sa-redis"]}")
    implementation("${project.extra["pool"]}")
    implementation("${project.extra["loadbalancer"]}")
    implementation("${project.extra["doc-webflux"]}")
    implementation("${project.extra["devtools"]}")
    kapt("${project.extra["config-ap"]}")
    implementation(project(":nurupoga-common-configuration"))
    implementation(project(":nurupoga-result"))
}