FROM python

WORKDIR /app 

COPY requirments.txt ./

RUN pip install -r   requirments.txt

COPY mysqlClient.py ./ 

CMD ["python", "mysqlClient.py"]

