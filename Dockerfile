FROM circleci/openjdk:13-buster-node-browsers-legacy
CMD ["bash"]
CMD /bin/sh -c sudo apt -y -qq update && sudo apt install -y awscli
CMD /bin/sh -c sudo apt-get install -y gettext-base
CMD /bin/sh -c sudo sudo npm install -g snyk
CMD /bin/sh -c mkdir ~/.npm-global
CMD /bin/sh -c npm config set prefix '~/.npm-global'
CMD /bin/sh -c echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.profile
CMD /bin/sh -c source ~/.profile
CMD /bin/sh -c sudo npm install redoc@2.0.0-rc.23 -g
CMD /bin/sh -c sudo npm install redoc-cli -g
CMD ["/bin/sh"]
