FROM ubuntu:18.04
CMD ["bash"]
CMD /bin/sh -c apt-get update && apt-get install -y --no-install-recommends 		ca-certificates 		curl 		netbase 		wget 	&& rm -rf /var/lib/apt/lists/*
CMD /bin/sh -c set -ex; 	if ! command -v gpg > /dev/null; then 		apt-get update; 		apt-get install -y --no-install-recommends 			gnupg 			dirmngr 		; 		rm -rf /var/lib/apt/lists/*; 	fi
CMD /bin/sh -c apt-get update && apt-get install -y --no-install-recommends 		git 		mercurial 		openssh-client 		subversion 				procps 	&& rm -rf /var/lib/apt/lists/*
CMD /bin/sh -c set -eux; 	apt-get update; 	apt-get install -y --no-install-recommends 		bzip2 		unzip 		xz-utils 				ca-certificates p11-kit 				binutils 		fontconfig libfreetype6 	; 	rm -rf /var/lib/apt/lists/*
ENV LANG=C.UTF-8
ENV JAVA_HOME=/usr/java/openjdk-12
ENV PATH=/usr/java/openjdk-13/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
CMD /bin/sh -c { echo '#CMD /bin/sh'; echo 'echo "$JAVA_HOME"'; } > /usr/local/bin/docker-java-home && chmod +x /usr/local/bin/docker-java-home && [ "$JAVA_HOME" = "$(docker-java-home)" ]
ENV JAVA_VERSION=12.0.2  
ENV JAVA_URL=https://download.java.net/java/GA/jdk12.0.2/e482c34c86bd4bf8b56c0b35558996b9/10/GPL/openjdk-12.0.2_osx-x64_bin.tar.gz
ENV JAVA_SHA256=675a739ab89b28a8db89510f87cb2ec3206ec6662fb4b4996264c16c72cdd2a1
CMD /bin/sh -c set -eux; 		wget -O openjdk.tgz "$JAVA_URL"; 	echo "$JAVA_SHA256 */openjdk.tgz" | sha256sum -c -; 		mkdir -p "$JAVA_HOME"; 	tar --extract 		--file openjdk.tgz 		--directory "$JAVA_HOME" 		--strip-components 1 		--no-same-owner 	; 	rm openjdk.tgz; 		{ 		echo '#!/usr/bin/env bash'; 		echo 'set -Eeuo pipefail'; 		echo 'if ! [ -d "$JAVA_HOME" ]; then echo >&2 "error: missing JAVA_HOME environment variable"; exit 1; fi'; 		echo 'cacertsFile=; for f in "$JAVA_HOME/lib/security/cacerts" "$JAVA_HOME/jre/lib/security/cacerts"; do if [ -e "$f" ]; then cacertsFile="$f"; break; fi; done'; 		echo 'if [ -z "$cacertsFile" ] || ! [ -f "$cacertsFile" ]; then echo >&2 "error: failed to find cacerts file in $JAVA_HOME"; exit 1; fi'; 		echo 'trust extract --overwrite --format=java-cacerts --filter=ca-anchors --purpose=server-auth "$cacertsFile"'; 	} > /etc/ca-certificates/update.d/docker-openjdk; 	chmod +x /etc/ca-certificates/update.d/docker-openjdk; 	/etc/ca-certificates/update.d/docker-openjdk; 		find "$JAVA_HOME/lib" -name '*.so' -exec dirname '{}' ';' | sort -u > /etc/ld.so.conf.d/docker-openjdk.conf; 	ldconfig; 		java -Xshare:dump; 		javac --version; 	java --version
CMD ["jshell"]
CMD /bin/sh -c echo 'APT::Get::Assume-Yes "true";' > /etc/apt/apt.conf.d/90circleci   && echo 'DPkg::Options "--force-confnew";' >> /etc/apt/apt.conf.d/90circleci
ENV DEBIAN_FRONTEND=noninteractive
CMD /bin/sh -c if grep -q Debian /etc/os-release && grep -q jessie /etc/os-release; then 	rm /etc/apt/sources.list     && echo "deb http://archive.debian.org/debian/ jessie main" >> /etc/apt/sources.list     && echo "deb http://security.debian.org/debian-security jessie/updates main" >> /etc/apt/sources.list 	; fi
CMD /bin/sh -c echo 'PATH="$HOME/.local/bin:$PATH"' >> /etc/profile.d/user-local-path.sh
CMD /bin/sh -c apt-get update   && mkdir -p /usr/share/man/man1   && apt-get install -y     git mercurial xvfb apt     locales sudo openssh-client ca-certificates tar gzip parallel     net-tools netcat unzip zip bzip2 gnupg curl wget make
CMD /bin/sh -c ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime
CMD /bin/sh -c locale-gen C.UTF-8 || true
ENV LANG=C.UTF-8
CMD /bin/sh -c JQ_URL="https://circle-downloads.s3.amazonaws.com/circleci-images/cache/linux-amd64/jq-latest"   && curl --silent --show-error --location --fail --retry 3 --output /usr/bin/jq $JQ_URL   && chmod +x /usr/bin/jq   && jq --version
CMD /bin/sh -c set -ex   && export DOCKER_VERSION=$(curl --silent --fail --retry 3 https://download.docker.com/linux/static/stable/x86_64/ | grep -o -e 'docker-[.0-9]*\.tgz' | sort -r | head -n 1)   && DOCKER_URL="https://download.docker.com/linux/static/stable/x86_64/${DOCKER_VERSION}"   && echo Docker URL: $DOCKER_URL   && curl --silent --show-error --location --fail --retry 3 --output /tmp/docker.tgz "${DOCKER_URL}"   && ls -lha /tmp/docker.tgz   && tar -xz -C /tmp -f /tmp/docker.tgz   && mv /tmp/docker/* /usr/bin   && rm -rf /tmp/docker /tmp/docker.tgz   && which docker   && (docker version || true)
CMD /bin/sh -c COMPOSE_URL="https://circle-downloads.s3.amazonaws.com/circleci-images/cache/linux-amd64/docker-compose-latest"   && curl --silent --show-error --location --fail --retry 3 --output /usr/bin/docker-compose $COMPOSE_URL   && chmod +x /usr/bin/docker-compose   && docker-compose version
CMD /bin/sh -c DOCKERIZE_URL="https://circle-downloads.s3.amazonaws.com/circleci-images/cache/linux-amd64/dockerize-latest.tar.gz"   && curl --silent --show-error --location --fail --retry 3 --output /tmp/dockerize-linux-amd64.tar.gz $DOCKERIZE_URL   && tar -C /usr/local/bin -xzvf /tmp/dockerize-linux-amd64.tar.gz   && rm -rf /tmp/dockerize-linux-amd64.tar.gz   && dockerize --version
CMD /bin/sh -c groupadd --gid 3434 circleci   && useradd --uid 3434 --gid circleci --shell /bin/bash --create-home circleci   && echo 'circleci ALL=NOPASSWD: ALL' >> /etc/sudoers.d/50-circleci   && echo 'Defaults    env_keep += "DEBIAN_FRONTEND"' >> /etc/sudoers.d/env_keep
CMD /bin/sh -c if java -fullversion 2>&1 | grep -q '"9.'; then   curl --silent --show-error --location --fail --retry 3 --output /etc/ssl/certs/java/cacerts        https://circle-downloads.s3.amazonaws.com/circleci-images/cache/linux-amd64/openjdk-9-slim-cacerts;  fi
CMD /bin/sh -c curl --silent --show-error --location --fail --retry 3 --output /tmp/apache-maven.tar.gz     https://www.apache.org/dist/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz   && tar xf /tmp/apache-maven.tar.gz -C /opt/   && rm /tmp/apache-maven.tar.gz   && ln -s /opt/apache-maven-* /opt/apache-maven   && /opt/apache-maven/bin/mvn -version
CMD /bin/sh -c curl --silent --show-error --location --fail --retry 3 --output /tmp/apache-ant.tar.gz     https://archive.apache.org/dist/ant/binaries/apache-ant-1.10.7-bin.tar.gz   && tar xf /tmp/apache-ant.tar.gz -C /opt/   && ln -s /opt/apache-ant-* /opt/apache-ant   && rm -rf /tmp/apache-ant.tar.gz   && /opt/apache-ant/bin/ant -version
ENV ANT_HOME=/opt/apache-ant
CMD /bin/sh -c curl --silent --show-error --location --fail --retry 3 --output /tmp/gradle.zip     https://services.gradle.org/distributions/gradle-6.2.2-bin.zip   && unzip -d /opt /tmp/gradle.zip   && rm /tmp/gradle.zip   && ln -s /opt/gradle-* /opt/gradle   && /opt/gradle/bin/gradle -version
CMD /bin/sh -c curl --silent --show-error --location --fail --retry 3 --output /tmp/sbt.tgz https://circle-downloads.s3.amazonaws.com/circleci-images/cache/linux-amd64/sbt-latest.tgz   && tar -xzf /tmp/sbt.tgz -C /opt/   && rm /tmp/sbt.tgz   && /opt/sbt/bin/sbt sbtVersion
CMD /bin/sh -c apt-get update     && apt-get install -y --no-install-recommends openjfx     && apt-get install -y build-essential     && rm -rf /var/lib/apt/lists/*
ENV PATH=/opt/sbt/bin:/opt/apache-maven/bin:/opt/apache-ant/bin:/opt/gradle/bin:/usr/java/openjdk-13/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
CMD /bin/sh -c mvn -version   && ant -version   && gradle -version   && sbt sbtVersion
USER circleci
ENV PATH=/home/circleci/.local/bin:/home/circleci/bin:/opt/sbt/bin:/opt/apache-maven/bin:/opt/apache-ant/bin:/opt/gradle/bin:/usr/java/openjdk-13/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
CMD /bin/sh -c whoami
USER root
CMD /bin/sh -c groupadd --gid 1000 node   && useradd --uid 1000 --gid node --shell /bin/bash --create-home node
ENV NODE_VERSION=12.16.1
CMD /bin/sh -c ARCH= && dpkgArch="$(dpkg --print-architecture)"   && case "${dpkgArch##*-}" in     amd64) ARCH='x64';;     ppc64el) ARCH='ppc64le';;     s390x) ARCH='s390x';;     arm64) ARCH='arm64';;     armhf) ARCH='armv7l';;     i386) ARCH='x86';;     *) echo "unsupported architecture"; exit 1 ;;   esac   && set -ex   && for key in     94AE36675C464D64BAFA68DD7434390BDBE9B9C5     FD3A5288F042B6850C66B31F09FE44734EB7990E     71DCFD284A79C3B38668286BC97EC7A07EDE3FC1     DD8F2338BAE7501E3DD5AC78C273792F7D83545D     C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8     B9AE9905FFD7803F25714661B63B535A4C206CA9     77984A986EBC2AA786BC0F66B01FBB92821C587A     8FCCA13FEF1D0C2E91008E09770F7A9A5AE15600     4ED778F539E3634C779C87C6D7062848A1AB005C     A48C2BEE680E841632CD4E44F07496B3EB3C1762     B9E2F5981AA6E0CD28160D9FF13993A75599653C   ; do     gpg --batch --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" ||     gpg --batch --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys "$key" ||     gpg --batch --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key" ;   done   && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-$ARCH.tar.xz"   && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc"   && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc   && grep " node-v$NODE_VERSION-linux-$ARCH.tar.xz\$" SHASUMS256.txt | sha256sum -c -   && tar -xJf "node-v$NODE_VERSION-linux-$ARCH.tar.xz" -C /usr/local --strip-components=1 --no-same-owner   && rm "node-v$NODE_VERSION-linux-$ARCH.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt   && ln -s /usr/local/bin/node /usr/local/bin/nodejs   && node --version   && npm --version
ENV YARN_VERSION=1.22.0
CMD /bin/sh -c set -ex   && for key in     6A010C5166006599AA17F08146C2130DFD2497F5   ; do     gpg --batch --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" ||     gpg --batch --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys "$key" ||     gpg --batch --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key" ;   done   && curl -fsSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz"   && curl -fsSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz.asc"   && gpg --batch --verify yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz   && mkdir -p /opt   && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/   && ln -s /opt/yarn-v$YARN_VERSION/bin/yarn /usr/local/bin/yarn   && ln -s /opt/yarn-v$YARN_VERSION/bin/yarnpkg /usr/local/bin/yarnpkg   && rm yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz   && yarn --version
CMD /bin/sh -c node --version
USER circleci
CMD /bin/sh -c if grep -q Debian /etc/os-release && grep -q stretch /etc/os-release; then 		echo 'deb http://deb.debian.org/debian stretch-backports main' | sudo tee -a /etc/apt/sources.list.d/stretch-backports.list; 	elif grep -q Ubuntu /etc/os-release && grep -q xenial /etc/os-release; then 		sudo apt-get update && sudo apt-get install -y software-properties-common && 		sudo add-apt-repository -y ppa:openjdk-r/ppa; 	fi && 	sudo apt-get update && sudo apt-get install -y openjdk-12-jre openjdk-12-jre-headless openjdk-12-jdk openjdk-12-jdk-headless && 	sudo apt-get install -y bzip2 libgconf-2-4 # for extracting firefox and running chrome, respectively
ENV OPENSSL_CONF=/
CMD /bin/sh -c sudo apt-get install -y libgconf-2-4
CMD /bin/sh -c sudo apt -y -qq update && sudo apt install -y awscli
CMD /bin/sh -c sudo apt-get install -y gettext-base
CMD /bin/sh -c sudo sudo npm install -g snyk
CMD /bin/sh -c mkdir ~/.npm-global
CMD /bin/sh -c npm config set prefix '~/.npm-global'
CMD /bin/sh -c echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.profile
CMD /bin/sh -c source ~/.profile
CMD /bin/sh -c sudo npm install redoc@2.0.0-rc.23 -g
CMD /bin/sh -c sudo npm install redoc-cli -g
LABEL com.circleci.preserve-entrypoint=true
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/bin/sh"]
