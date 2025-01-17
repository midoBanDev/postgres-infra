FROM postgres:13

# 기본 유틸리티 설치
# apt-get update: 패키지 목록을 최신 상태로 갱신.
# apt-get install: 필요한 패키지를 설치.
# rm -rf /var/lib/apt/lists/*: 패키지 설치 후 더 이상 필요 없는 캐시를 삭제.
RUN apt-get update && apt-get install -y \
    iputils-ping \
    net-tools \
    curl \
    vim \
    && rm -rf /var/lib/apt/lists/*

# 환경별 변수
ENV POSTGRESQL_POSTGRES_PASSWORD=${POSTGRESQL_POSTGRES_PASSWORD}
ENV POSTGRES_DB=${POSTGRES_DB}
ENV POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
ENV POSTGRES_USER=${POSTGRES_USER}
ENV TZ=${TZ}

ARG PROFILE=local

# 설정 파일 복사
COPY ./config/custom.${PROFILE}.conf /etc/postgresql/custom.conf
# conf.d에 있는 파일이 custom.conf에 include 되어 있기 때문에 파일 복사 이후 컨테이너 내부 경로도 문제가 없도록 맞춰주어야 한다.
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
