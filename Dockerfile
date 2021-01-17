FROM kulbhushanmayer/tomcat:8.5.61
COPY target/LiquorShop.war /opt/app/apache-tomcat-8.5.61/webapps/liquorshop.war
