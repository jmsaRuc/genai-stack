FROM langchain/langchain

WORKDIR /app

RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

RUN pip install poetry==1.8.3
RUN poetry config virtualenvs.create false

COPY pyproject.toml .
COPY poetry.lock .
RUN poetry install --only main

COPY loader.py .
COPY utils.py .
COPY chains.py .
COPY images ./images

EXPOSE 8502

HEALTHCHECK CMD curl --fail http://localhost:8502/_stcore/health

ENTRYPOINT ["streamlit", "run", "loader.py", "--server.port=8502", "--server.address=0.0.0.0"]
