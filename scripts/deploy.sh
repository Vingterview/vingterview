#! /bin/bash
REPOSITORY=/home/ubuntu/app/deploy
PROJECT_NAME=vingterview

echo "> 현재 구동중인 어플리케이션 확인"
CURRENT_PID=$(pgrep -f "vingterview.*\.jar" | awk '{print $1}')

echo "> 현재 구동중인 어플리케이션 pid: $CURRENT_PID"

if [ -z "$CURRENT_PID" ]; then
    echo "> 현재 구동중인 어플리케이션이 없으므로 종료하지 않습니다."
else
  echo "> kill -15 $CURRENT_PID"
  kill -15 $CURRENT_PID
  sleep 5
fi

echo "> 새 어플리케이션 배포"
JAR_NAME=$(ls -tr $REPOSITORY/*.jar | tail -n 1)

echo "> JAR_NAME: $JAR_NAME"

echo "> $JAR_NAME에 실행 권한 추가"
chmod +x $JAR_NAME

echo ">$JAR_NAME 실행"
nohup java -jar \
  -Dspring.config.location=classpath:/application.properties,classpath:/application-security.yml,\
  /home/ubuntu/app/deploy/application-db.yml \
  -Dspring.profiles.active=real \
  $JAR_NAME > $REPOSITORY/nohup.out 2>&1 &
