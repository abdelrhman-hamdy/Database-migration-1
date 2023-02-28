FROM python

WORKDIR /app 

COPY requirments.txt ./

RUN pip install -r   requirments.txt

COPY mongoClient.py ./

CMD ["python", "mongoClient.py"]

