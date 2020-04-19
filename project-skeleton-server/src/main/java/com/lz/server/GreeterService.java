package com.lz.server;

import com.lz.server.config.CustomConfig1;
import com.lz.skeleton.api.GreeterGrpc;
import com.lz.skeleton.api.HelloReply;
import com.lz.skeleton.api.HelloRequest;
import io.grpc.stub.StreamObserver;
import net.devh.boot.grpc.server.service.GrpcService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;

@GrpcService
public class GreeterService extends GreeterGrpc.GreeterImplBase {
    /**
     * 获取指定名称的Logger。
     * LoggerFactory.getLogger(loggerName) 会获取日志的具体实现
     * 相同loggerName下获取到的实例对象是同一个
     */
    private final static Logger logger = LoggerFactory.getLogger(GreeterService .class);

    /**
     * 用于Debug目的使用的日志记录器
     */
    private final static Logger debugLogger = LoggerFactory.getLogger("DebugLogger");


    private static ApplicationContext applicationContext;

    @Override
    public void sayHello(HelloRequest request, StreamObserver<HelloReply> responseObserver) {
        if (debugLogger.isDebugEnabled()) {
            debugLogger.debug("sayHello(HelloRequest,StreamObserver) 接收到请求，开始服务.请求信息：{}", request);
        }
        HelloReply reply = HelloReply.newBuilder()
                .setMessage("Hello ==> " + request.getName())
                .build();
        if (debugLogger.isDebugEnabled()) {
            debugLogger.debug("sayHello(HelloRequest,StreamObserver) 服务完成.返回信息：{}", reply);
        }
        responseObserver.onNext(reply);
        responseObserver.onCompleted();
    }

    @Override
    public void sayHelloAgain(HelloRequest request, StreamObserver<HelloReply> responseObserver) {
        if (logger.isInfoEnabled()) {
            logger.info("未实现的服务sayHelloAgain(request,StreamObserver)收到请求！");
        }
        HelloReply reply = HelloReply.newBuilder().setMessage("Service no implementation!").build();
        if (logger.isErrorEnabled()) {
            logger.error("sayHelloAgain(HelloRequest,StreamObserver) 此服务未实现！.返回信息：{}", reply);
        }
        responseObserver.onNext(reply);

        responseObserver.onCompleted();
    }

    @Override
    public void getServerConfig(HelloRequest request, StreamObserver<HelloReply> responseObserver) {
        CustomConfig1 config1 = applicationContext.getAutowireCapableBeanFactory().getBean(CustomConfig1.class);
        if (debugLogger.isDebugEnabled()) {
            debugLogger.debug("getServerConfig(HelloRequest,StreamObserver) 接收到请求，开始服务.请求信息：{}", request);
        }
    }

    @Autowired
    public void setApplicationContext(ApplicationContext applicationContext) {
        GreeterService.applicationContext = applicationContext;
    }

}
