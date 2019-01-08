# Perl application that generates Spring Boot Logback Logs
## Creator
[George Bouras](https://github.com/GeorgeBouras)
## How it works
Spring Boot logs are Logback formatted as the following samples:
```
service1.log:2016-02-26 11:15:47.561  INFO [service1,2485ec27856c56f4,2485ec27856c56f4,true] 68058 --- [nio-8081-exec-1] i.s.c.sleuth.docs.service1.Application   : Hello from service1. Calling service2
service2.log:2016-02-26 11:15:47.710  INFO [service2,2485ec27856c56f4,9aa10ee6fbde75fa,true] 68059 --- [nio-8082-exec-1] i.s.c.sleuth.docs.service2.Application   : Hello from service2. Calling service3 and then service4
service3.log:2016-02-26 11:15:47.895  INFO [service3,2485ec27856c56f4,1210be13194bfe5,true] 68060 --- [nio-8083-exec-1] i.s.c.sleuth.docs.service3.Application   : Hello from service3
service2.log:2016-02-26 11:15:47.924  INFO [service2,2485ec27856c56f4,9aa10ee6fbde75fa,true] 68059 --- [nio-8082-exec-1] i.s.c.sleuth.docs.service2.Application   : Got response from service3 [Hello from service3]
service4.log:2016-02-26 11:15:48.134  INFO [service4,2485ec27856c56f4,1b1845262ffba49d,true] 68061 --- [nio-8084-exec-1] i.s.c.sleuth.docs.service4.Application   : Hello from service4
service2.log:2016-02-26 11:15:48.156  INFO [service2,2485ec27856c56f4,9aa10ee6fbde75fa,true] 68059 --- [nio-8082-exec-1] i.s.c.sleuth.docs.service2.Application   : Got response from service4 [Hello from service4]
service1.log:2016-02-26 11:15:48.182  INFO [service1,2485ec27856c56f4,2485ec27856c56f4,true] 68058 --- [nio-8081-exec-1] i.s.c.sleuth.docs.service1.Application   : Got response from service2 [Hello from service2, response from service3 [Hello from service3] and from service4 [Hello from service4]]
```
It also generates radomly JAVA exception in the message field
```
java.net.SocketException: Unrecognized Windows Sockets error: 0: JVM_Bind
        at java.net.PlainSocketImpl.socketBind(Native Method)
        at java.net.PlainSocketImpl.bind(PlainSocketImpl.java:359)
        at java.net.ServerSocket.bind(ServerSocket.java:319)
        at org.jboss.mx.interceptor.ReflectedDispatcher.invoke(ReflectedDispatcher.java:141)
        at org.jboss.mx.server.MBeanServerImpl.invoke(MBeanServerImpl.java:644)
        mpl.invoke(DelegatingMethodAccessorImpl.java:25)
        at java.lang.reflect.Method.invoke(Method.java:592)
        at org.jboss.Main\$1.run(Main.java:438)
        at java.lang.Thread.run(Thread.java:595)
```
## How to use it in OpenShift
1. Log in to OpenShift Console.
2. Type Perl in the Catalog and select Perl Builder
3. Select a new project name, give it an application name, the latest Perl version and the the GitHub URL: https://github.com/SLionB/logbackgen.git
4. After the pod is deployed edit deployment config yaml file and apply the following change
```
   spec:
      containers:
        - args:
            - /opt/app-root/src/logbackgen.pl
          command:
            - perl
 ``` 
 5. This change will trigger a new deployment and a new pod will be created.
 6. Check in the pod logs that the Spring Boot logs are printed in stdout
 7. Check also the arhived logs in Kibana
