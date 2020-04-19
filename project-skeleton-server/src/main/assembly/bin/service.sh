#!/bin/bash
# 涉及到的语法说明：
# $? : 获取最后运行命令的结束代码.本脚本中用来获取函数返回值（0为真，1为假）
# -eq 等于。-ne 不等于；-gt 大于；-lt 小于；-ge 大于等于；-le 小于等于
# command1 && command2 ：只有command1返回为真，则执行command2
# command1 || command2 ：若command1返回为假，才执行command2
# 双引号 会解析双引号里面的变量；单引号只会原样输出
APP_NAME=project-skeleton-server
FILE_TYPE=.jar

JAR_FILE_NAME=$APP_NAME$FILE_TYPE
BIN_ABSOLUTE_PATH=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

usage() {
    echo ">>> 脚本语法：server.sh [start|stop|restart|status]"
    echo ">>> 示例：server.sh start | server.sh stop | server.sh restart | server.sh status"
    exit 1
}

is_exist(){
    pid=$( ps -ef | grep "$APP_NAME" | grep -v grep | awk '{print $2}')
    if [ -z "${pid}" ]; then #判断pid是否为空
        return 1
    else
        return 0
    fi
}


start(){
    is_exist
    if [ $? -eq 0 ]; then
        echo ">>> 服务 ${APP_NAME} 当前正在运行！ pid=${pid}"
    else
        echo ">>> 开始启动服务：${APP_NAME} "
        cd "$BIN_ABSOLUTE_PATH" || (echo ">>> 未获取到bin/路径信息，无法启动服务，请检查脚本相应行数以排除问题" ; exit);
        cd ..
        nohup java -jar $JAR_FILE_NAME --spring.profiles.active=test > /dev/null 2>&1 &
        while true
        do
          if [ -f "$JAR_FILE_NAME" ];then
            break
          fi
        done
        tail -fn 200 logs/project-skeleton-server.log
        is_exist
        if [ $? -eq 0 ]; then
          echo ">>> 服务 ${APP_NAME} 启动成功！ pid=${pid}"
        else
          echo ">>> 服务 ${APP_NAME} 启动失败"
        fi
    fi
}

stop(){
    is_exist
    if [ $? -eq 0 ]; then
        kill -9 $pid
        echo ">>> 服务 ${APP_NAME} 已关闭！PID = ${pid} "
    else
        echo ">>> 服务 ${APP_NAME} 没有运行"
    fi
}


status(){
    is_exist
    if [ $? -eq 0 ]; then
        echo ">>> 服务 ${APP_NAME} 正在运行中(Running). PID = ${pid}"
    else
        echo ">>> 服务 ${APP_NAME} 未运行(Dead)"
    fi
}

restart(){
    stop
    start
}

case "$1" in
    "start")
        start
        ;;
    "stop")
        stop
        ;;
    "status")
        status
        ;;
    "restart")
        restart
        ;;
    *)
    usage
    ;;
esac