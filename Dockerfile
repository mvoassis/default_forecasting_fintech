# importa o python pra dentro do container
FROM python:3.9-slim

# copia o requirements pra dentro do container
COPY ./requirements.txt /usr/requirements.txt

# seta a pasta usr como o diretorio de trabalho
WORKDIR /usr

# instala os pacores requisitos do projeto
RUN pip3 install -r requirements.txt

# copia para o container os arquivos do projeto
COPY ./src /usr/src
COPY ./models /usr/models

# o que vai ser executado no início
#ENTRYPOINT [ "python3" ]

# o que vai abrir com o python3
#CMD [ "src/app/main.py" ]

CMD [ "uvicorn", "src.app.main:app", "--host", "0.0.0.0", "--port", "8000" ]

