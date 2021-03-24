# How to install docker on Oracle Linux 7.9?

## My Installation
As Oracle Linux is a clone of RHEL, so the applications are compitible with CentOS packages.

I had an error to install it when following the docker official doc: https://docs.docker.com/engine/install/centos/, 

```shell
$ sudo yum install docker-ce docker-ce-cli containerd.io
Loaded plugins: langpacks, ulninfo
https://download.docker.com/linux/centos/7Server/x86_64/stable/repodata/repomd.xml: [Errno 14] HTTPS Error 404 - Not Found
Trying other mirror.


 One of the configured repositories failed (Docker CE Stable - x86_64),
 and yum doesn't have enough cached data to continue. At this point the only
 safe thing yum can do is fail. There are a few ways to work "fix" this:

     1. Contact the upstream for the repository and get them to fix the problem.

     2. Reconfigure the baseurl/etc. for the repository, to point to a working
        upstream. This is most often useful if you are using a newer
        distribution release than is supported by the repository (and the
        packages for the previous distribution release still work).

     3. Run the command with the repository temporarily disabled
            yum --disablerepo=docker-ce-stable ...

     4. Disable the repository permanently, so yum won't use it by default. Yum
        will then just ignore the repository until you permanently enable it
        again or use --enablerepo for temporary usage:

            yum-config-manager --disable docker-ce-stable
        or
            subscription-manager repos --disable=docker-ce-stable

     5. Configure the failing repository to be skipped, if it is unavailable.
        Note that yum will try to contact the repo. when it runs most commands,
        so will have to try and fail each time (and thus. yum will be be much
        slower). If it is a very temporary problem though, this is often a nice
        compromise:

            yum-config-manager --save --setopt=docker-ce-stable.skip_if_unavailable=true

failure: repodata/repomd.xml from docker-ce-stable: [Errno 256] No more mirrors to try.
https://download.docker.com/linux/centos/7Server/x86_64/stable/repodata/repomd.xml: [Errno 14] HTTPS Error 404 - Not Found
```

The reason is that the added docker-ce repo is broken, (URL in /etc/yum.repos.d/docker-ce.repo, like https://download.docker.com/linux/centos/7/$basearch/stable is not valid to get the packages. This issue is disccused here: https://github.com/docker/for-linux/issues/1111

Fix: Use Centos 7 repo url to replace it,

```shell
$ sudo sed -i 's/$releasever/7/g' /etc/yum.repos.d/docker-ce.repo
```

After fixed the repo issue, I came into another dependency error:
```shell
$ sudo yum install docker-ce docker-ce-cli containerd.io

Error: Package: docker-ce-rootless-extras-20.10.5-3.el7.x86_64 (docker-ce-stable)
           Requires: slirp4netns >= 0.4
Error: Package: docker-ce-rootless-extras-20.10.5-3.el7.x86_64 (docker-ce-stable)
           Requires: fuse-overlayfs >= 0.7
 You could try using --skip-broken to work around the problem
 ```

 I tried to add `epel` repository and install the dependencies, but they are not in the epel packages list. I installed them by searching the packages manually.

 ```shell
 $ wget http://mirror.centos.org/centos/7/extras/x86_64/Packages/slirp4netns-0.4.3-4.el7_8.x86_64.rpm
$ wget http://mirror.centos.org/centos/7/extras/x86_64/Packages/fuse3-libs-3.6.1-4.el7.x86_64.rpm
$ wget http://mirror.centos.org/centos/7/extras/x86_64/Packages/fuse-overlayfs-0.7.2-6.el7_8.x86_64.rpm

$ sudo rpm -Uvh slirp4netns-0.4.3-4.el7_8.x86_64.rpm fuse3-libs-3.6.1-4.el7.x86_64.rpm fuse-overlayfs-0.7.2-6.el7_8.x86_64.rpm
```

Finnaly I was able to install docker after fixing the dependencies.

`$ sudo yum install docker-ce docker-ce-cli containerd.io -y`

Then, we can use a script to install by one-time execution the [shell script file](./install_docker_on_oracle_linux_7.9.sh) here.


## Oracle official guide
I found anther guide from oracle official website.
https://docs.huihoo.com/oracle/linux/7/E87205/html/section_install_upgrade_yum_docker.html

If your system is registered with ULN, enable the ol7_x86_64_addons channel.

If you use the Oracle Linux yum server, enable the ol7_addons channel. You can do this easily using yum-config-manager:

`# yum-config-manager --enable ol7_addons`
Alternatively, edit the /etc/yum.repos.d/public-yum-ol7.repo file to set the ol7_addons enabled option to 1, for example:

[ol7_addons]
name=Oracle Linux $releasever Add ons ($basearch)
baseurl=http://yum.oracle.com/repo/OracleLinux/OL7/addons/$basearch/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle
gpgcheck=1
enabled=1
You can download an up-to-date version of this file from http://yum.oracle.com/public-yum-ol7.repo, if required.

Install the docker-engine package.

`# yum install docker-engine
