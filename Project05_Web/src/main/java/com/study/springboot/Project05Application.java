package com.study.springboot;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.security.crypto.factory.PasswordEncoderFactories;
import org.springframework.security.crypto.factory.PasswordEncoderFactories;

@SpringBootApplication
public class Project05Application {

	public static void main(String[] args) {
		SpringApplication.run(Project05Application.class, args);
		
//		String encoded=PasswordEncoderFactories.createDelegatingPasswordEncoder().encode("123456");
//		System.out.println(encoded);
//		{bcrypt}$2a$10$BUQ9y5x4ThxwwLxB4.Ps/.i3CT3UnQV71pY3CHFi.VDSjhf/.nfJ6
	}

}
