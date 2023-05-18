package ving.vingterview.config;

import com.amazonaws.auth.EnvironmentVariableCredentialsProvider;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class AwsConfig {

    @Value("${cloud.region}")
    private String region;

    @Bean
    public AmazonS3 amazonS3() {
//        AWSCredentials awsCredentials = new BasicAWSCredentials(accessKey, secretKey);

        return AmazonS3ClientBuilder.standard()
                .withRegion(region)
//                .withCredentials(new AWSStaticCredentialsProvider(awsCredentials))
                .withCredentials(new EnvironmentVariableCredentialsProvider())
                .build();
    }



}
