package com.lz.client;

import com.lz.skeleton.api.GreeterGrpc;
import com.lz.skeleton.api.HelloRequest;
import net.devh.boot.grpc.client.inject.GrpcClient;
import org.springframework.stereotype.Service;

@Service
public class HelloClient {

    @GrpcClient("hello-server")
    private static GreeterGrpc.GreeterBlockingStub helloService;

    public String receiveGreeting(String name) {
        HelloRequest request = HelloRequest.newBuilder()
                .setName(name)
                .build();
        return helloService.sayHello(request).getMessage();
    }

    public String sayHelloAgain(String name) {
        HelloRequest request = HelloRequest.newBuilder()
                .setName(name)
                .build();
        return helloService.sayHelloAgain(request).getMessage();
    }

    public String getServerConfig(String name) {
        HelloRequest request = HelloRequest.newBuilder()
                .setName(name)
                .build();
        return helloService.getServerConfig(request).getMessage();
    }

}