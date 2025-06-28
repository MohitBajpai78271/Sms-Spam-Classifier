FROM python:3.10-slim

WORKDIR /app

# Copy and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Create a shared NLTK data folder and download all needed corpora
RUN mkdir -p /usr/local/share/nltk_data \
 && python - <<EOF
import nltk
# Download the standard punkt tokenizer and the punkt_tab variant
nltk.download('punkt',      download_dir='/usr/local/share/nltk_data')
nltk.download('punkt_tab',  download_dir='/usr/local/share/nltk_data')
nltk.download('stopwords',  download_dir='/usr/local/share/nltk_data')
EOF

# Tell NLTK to look here
ENV NLTK_DATA=/usr/local/share/nltk_data

# Copy your app code and models
COPY . .

EXPOSE 8501

CMD ["streamlit", "run", "app.py", "--server.port=8501", "--server.address=0.0.0.0"]
