FROM kasmweb/core-ubuntu-bionic:1.10.0
USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
WORKDIR $HOME

######### Customize Container Here ###########

RUN apt update && \
	apt upgrade -y && \
	apt install -y sudo \
		openssh-server nano wget \ 
		curl geany tree git gedit && \
	curl -fsSL https://get.docker.com -o get-docker.sh && \
	sh get-docker.sh && \
	rm -rf get-docker.sh && \
	apt-get clean && \
	apt-get autoremove -y && \
	apt-get autoclean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN 

RUN /usr/bin/ssh-keygen -A && \
	addgroup --gid 1000 kasm-user && \
	useradd -m -s /bin/bash -g kasm-user -G sudo,root,docker -u 1000 kasm-user && \
	mkdir -vp /run/sshd && \
	mkdir -vp /var/run/sshd && \
	sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
	sed -i 's/#StrictModes yes/StrictModes no/' /etc/ssh/sshd_config && \
	sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config && \
	sed -i 's/PrintMotd no/PrintMotd yes/' /etc/ssh/sshd_config && \
	sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
	echo "root:password" | chpasswd && \
	echo "kasm-user:password" | chpasswd && \
	echo "kasm-user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

COPY assets/generate_container_user /dockerstartup/generate_container_user

COPY assets/kasm_default_profile.sh /dockerstartup/kasm_default_profile.sh
COPY assets/custom_startup.sh ${STARTUPDIR}/custom_startup.sh
RUN chmod +x ${STARTUPDIR}/custom_startup.sh

######### End Customizations ###########

RUN chown kasm-user:kasm-user $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R kasm-user:kasm-user $HOME

USER kasm-user
