package com.lz.server.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;

@Configuration
@PropertySource("${custom-config.file.path}")
@ConfigurationProperties(prefix = "config1")
public class CustomConfig1 {
    private String type;

    private Integer id;

    private String name;

    public void setType(String type) {
        this.type = type;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getType() {
        return type;
    }

    public Integer getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    @Override
    public String toString() {
        return "CustomConfig1{" +
                "type='" + type + '\'' +
                ", id=" + id +
                ", name='" + name + '\'' +
                '}';
    }
}
