package ving.vingterview;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableAsync;
import ving.vingterview.dto.member.MemberCreateDTO;

@SpringBootApplication
public class VingterviewApplication {

	public static void main(String[] args) {
		SpringApplication.run(VingterviewApplication.class, args);}
}
