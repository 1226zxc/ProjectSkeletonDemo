package com.lz.client;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ConfigurableApplicationContext;

@SpringBootApplication
public class Client {

	public static void main(String[] args) {
		ConfigurableApplicationContext context = SpringApplication.run(Client.class, args);
		HelloClient bean = context.getBean(HelloClient.class);
		System.out.println(bean.receiveGreeting(args[0]));
	}

}
