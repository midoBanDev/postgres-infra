FROM postgres:13

# 환경 변수 설정
ENV POSTGRES_USER=loan-user
ENV POSTGRES_PASSWORD=loan-1234
ENV POSTGRES_DB=mydb
ENV TZ=Asia/Seoul

# 환경별 변수
ARG ENV=dev


# 설정 파일 복사
COPY ./config/custom.${ENV}.conf /etc/postgresql/custom.conf
# conf.d에 있는 파일이 custom.conf에 include 되어 있기 때문에 경로 맞춰주어야 한다.
COPY ./config/conf.d/ /etc/postgresql/conf.d/


# 초기화 스크립트 복사
COPY ./init/01-init.sql /docker-entrypoint-initdb.d/
#COPY ./init/02-functions.sql /docker-entrypoint-initdb.d/
#COPY ./init/03-data.sql /docker-entrypoint-initdb.d/

# 볼륨 설정
#VOLUME ["/var/lib/postgresql/data"]

# 포트 설정
EXPOSE 5432

# 설정 파일 적용
CMD ["postgres", "-c", "config_file=/etc/postgresql/custom.conf"]
