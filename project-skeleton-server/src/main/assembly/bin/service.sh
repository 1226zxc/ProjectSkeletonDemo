#!/bin/bash
# 涉及到的语法说明：
# $? : 获取最后运行命令的结束代码.本脚本中用来获取函数返回值（0为真，1为假）
# -eq 等于。-ne 不等于；-gt 大于；-lt 小于；-ge 大于等于；-le 小于等于；-ne 不等于
# command1 && command2 ：只有command1返回为真，则执行command2
# command1 || command2 ：若command1返回为假，才执行command2
# 双引号 会解析双引号里面的变量；单引号只会原样输出
# $0：获取脚本文件名;$*：获取所有参数，并当做整体使用$1取得 $@获取所有参数，但可以分别取值

# 应用信息设置
APP_NAME=project-skeleton-server
JAR_FILE_NAME=$APP_NAME.jar
LOG_PATH=logs/$APP_NAME.log
CONSOLE_LOG=$APP_NAME-console.log

# 路径设置
BIN_ABSOLUTE_PATH=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# 脚本信息设置
SCRIPT_FILE_NAME=$0

# echo输出格式设置,可以在这里全局设置选项的语法
SCRIPT_SYNTAX=" ${SCRIPT_FILE_NAME} start|stop|restart|status"
START_OPTION_SYNTAX="${SCRIPT_FILE_NAME} start/restart dev| test| prod"
STOP_OPTION_SYNTAX="${SCRIPT_FILE_NAME} stop"
RESTART_OPTION_SYNTAX="${SCRIPT_FILE_NAME} restart"
STATUS_OPTION_SYNTAX="${SCRIPT_FILE_NAME} status"

show_usage() {
    echo ">>> 脚本语法：${SCRIPT_SYNTAX}"
    echo ">>> 示例：${START_OPTION_SYNTAX}"
    echo ">>> 示例：${RESTART_OPTION_SYNTAX}"
    echo ">>> 示例：${STOP_OPTION_SYNTAX}"
    echo ">>> 示例：${STATUS_OPTION_SYNTAX}"
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
        echo ">>> 正在启动服务${APP_NAME}，请稍等，成功后直接跳转日志... "
        cd "$BIN_ABSOLUTE_PATH" || (echo ">>> 未获取到bin/路径信息，无法启动服务，请检查脚本相应行数以排除问题" ; exit 1);
        cd ..
        nohup java -jar $JAR_FILE_NAME "--spring.profiles.active=$1" > ${CONSOLE_LOG} 2>&1 &
        i=300000
        while true
        do
          if [ -e "${LOG_PATH}" ];then
            break
          fi

          if [ $i -le 0 ];then
             echo ">>> 服务 ${APP_NAME} 启动失败,请查看控制台(${CONSOLE_LOG})输出以排查问题！"
             exit 1
          fi
          ((i--))
        done
        tail -fn 50 ${LOG_PATH}
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
    start "$1"
}

if  [ "$1" = "start" ] || [ "$1" = "restart" ]  ; then
   if [ X"$2" = X ]; then
     echo ">>> 启动选项缺少必要的 Spring profile, 示例：${START_OPTION_SYNTAX}"
     exit 1
   fi
   if [ "$#" -ge 3  ]; then
       show_usage
   fi
fi

if  [ "$1" != "start" ] && [ "$1" != "restart" ] && [ "$#" -ge 2 ] ;then
  show_usage
fi

case "$1" in
  "start")
      start "$2"
      ;;
  "stop")
      stop
      ;;
  "status")
      status
      ;;
  "restart")
      restart "$2"
      ;;
  *)
  show_usage
  ;;
esac
