FROM asensei/vapor:latest

EXPOSE 8080

WORKDIR /app

ADD . /app

RUN vapor build

CMD ["vapor", "run"]


