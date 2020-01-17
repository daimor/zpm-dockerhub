ARG IMAGE=store/intersystems/iris-community:2019.4.0.383.0
ARG DEV=1
FROM $IMAGE

USER root

WORKDIR /opt/irisapp
RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/irisapp

RUN mkdir -p /tmp/deps \
 && cd /tmp/deps \
 && wget -q https://pm.community.intersystems.com/packages/zpm/latest/installer -O zpm.xml

USER irisowner
COPY irissession.sh /

SHELL ["/irissession.sh"]
RUN \
  zn "%SYS" do ##class(SYS.Container).QuiesceForBundling() \
  If $DEV Do ##class(Security.Users).UnExpireUserPasswords("*") \

  Do $system.OBJ.Load("/tmp/deps/zpm.xml", "ck")

