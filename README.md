# jenkins-install

### Role "jenkins"

Dependences:
- "java" - installing jdk with default version 1.8.0. To tuning this, please change it in default.
- "nginx-jenkins" - install and configure nginx to upstream into jenkins instalations.

> There are role named "prerequest" to install packages with `install_packages` var and initial setting, using as dependency to any role. Check setting in meta.

### Installing

`vagrant up`
