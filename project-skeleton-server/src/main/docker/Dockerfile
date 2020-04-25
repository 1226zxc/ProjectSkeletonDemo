FROM openjdk:8-jre-slim

ARG MAIN_SERVICE_ROOT_PATH=/service
ENV MAIN_SERVICE_PATH=$MAIN_SERVICE_ROOT_PATH/${project.build.finalName}

ADD ${project.build.directory}/${project.build.finalName}-assembly.tar.gz $MAIN_SERVICE_ROOT_PATH

WORKDIR ${MAIN_SERVICE_PATH}

# 默认暴露生产端口
EXPOSE 10086

# 容器入口定参
ENTRYPOINT ["bin/service.sh", "start"]
# 默认使用生产Spring profile
CMD ["prod"]