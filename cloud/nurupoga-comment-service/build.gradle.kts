dependencies {
    implementation("${project.extra["nacos"]}")
    implementation("${project.extra["web"]}")
    kapt("${project.extra["therapi-ap"]}")
    implementation(project(":nurupoga-common-dependency"))
    implementation(project(":nurupoga-common-configuration"))
}