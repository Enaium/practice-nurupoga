import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

plugins {
    id("org.springframework.boot") version "3.0.4"
    id("io.spring.dependency-management") version "1.1.0"
    kotlin("jvm") version "1.8.10"
    kotlin("plugin.spring") version "1.8.10"
    kotlin("kapt") version "1.8.10"
}

allprojects {
    group = "cn.enaium"
    version = "0.0.1"
}

subprojects {
    apply(plugin = "org.springframework.boot")
    apply(plugin = "io.spring.dependency-management")
    apply(plugin = "org.jetbrains.kotlin.jvm")
    apply(plugin = "org.jetbrains.kotlin.kapt")
    apply(plugin = "org.jetbrains.kotlin.plugin.spring")

    java.sourceCompatibility = JavaVersion.VERSION_17

    repositories {
        mavenCentral()
    }

    dependencies {
        implementation("org.springframework.cloud:spring-cloud-dependencies:2022.0.1")
        implementation("com.alibaba.cloud:spring-cloud-alibaba-dependencies:2022.0.0.0-RC1")

        implementation("com.fasterxml.jackson.module:jackson-module-kotlin")
        implementation("org.jetbrains.kotlin:kotlin-reflect")
        implementation("org.jetbrains.kotlin:kotlin-stdlib")
        runtimeOnly("org.mariadb.jdbc:mariadb-java-client")
        testImplementation("org.springframework.boot:spring-boot-starter-test")
    }

    tasks.withType<KotlinCompile> {
        kotlinOptions {
            freeCompilerArgs = listOf("-Xjsr305=strict")
            jvmTarget = "17"
        }
    }

    tasks.withType<Test> {
        useJUnitPlatform()
    }

    project.extra.apply {
        val mybatisPlus = "3.5.3.1"
        val nacos = "2022.0.0.0-RC1"
        val saToken = "1.34.0"
        val cloud = "4.0.1"
        val doc = "2.0.2"
        val therapi = "0.15.0"

        this["mp"] = "com.baomidou:mybatis-plus-boot-starter:$mybatisPlus"
        this["nacos"] = "com.alibaba.cloud:spring-cloud-starter-alibaba-nacos-discovery:$nacos"
        this["sa"] = "cn.dev33:sa-token-spring-boot3-starter:$saToken"
        this["sa-reactor"] = "cn.dev33:sa-token-reactor-spring-boot3-starter:$saToken"
        this["sa-redis"] = "cn.dev33:sa-token-dao-redis-jackson:$saToken"
        this["pool"] = "org.apache.commons:commons-pool2"
        this["gateway"] = "org.springframework.cloud:spring-cloud-starter-gateway:$cloud"
        this["web"] = "org.springframework.boot:spring-boot-starter-web"
        this["webflux"] = "org.springframework.boot:spring-boot-starter-webflux"
        this["loadbalancer"] = "org.springframework.cloud:spring-cloud-starter-loadbalancer:$cloud"
        this["redis"] = "org.springframework.boot:spring-boot-starter-data-redis"
        this["openfeign"] = "org.springframework.cloud:spring-cloud-starter-openfeign:$cloud"
        this["doc"] = "org.springdoc:springdoc-openapi-starter-webmvc-ui:$doc"
        this["doc-webflux"] = "org.springdoc:springdoc-openapi-starter-webflux-ui:$doc"
        this["therapi"] = "com.github.therapi:therapi-runtime-javadoc:$therapi"
        this["therapi-ap"] = "com.github.therapi:therapi-runtime-javadoc-scribe:$therapi"
        this["aop"] = "org.springframework.boot:spring-boot-starter-aop"
        this["devtools"] = "org.springframework.boot:spring-boot-devtools"
        this["config-ap"] = "org.springframework.boot:spring-boot-configuration-processor"
    }
}
