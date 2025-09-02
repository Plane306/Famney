# Guide for deploying Famney prototype

## Extensions 
Must install these extensions:
+  Extension Pack for Java
+  JSP Language Support
+  Maven for Java
+  Community Server Connector

## Environment Setup
- Install Java JDK
- Setup environment path for Java
- Download Maven
- Setup environment path for Maven

## How to Deploy
1. In the “SERVERS” panel in the bottom left corner, right click on Community Server Connector and press "Create New Server", then press yes at the top and select apache-tomcat-11.0.0-M6
2. Open terminal and type "cd famney"
3. Run ```mvn clean compile package``` on terminal. This should create a target folder with a folder called "famney" inside.
4. Right click on the "famney" folder and select "run on server", then select the apache tomcat server.
5. Access the prototype at http://localhost:8080/famney/index.jsp

## After editing or adding a new file
1. Run ```mvn clean compile package```
2. Restart the apache tomcat server. This will make sure any changes are then updated to the website.