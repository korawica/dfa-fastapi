# Start from the official Python base image.
FROM python:3.9.13-slim

# Set the current working directory to /code.
# This is where we'll put the requirements.txt file and the app directory.
WORKDIR /code

# Copy the file with the requirements to the /code directory.
# Copy only the file with the requirements first, not the rest of the code.
# ---
# As this file doesn't change often, Docker will detect it
# and use the cache for this step, enabling the cache for the next step too.
COPY ./requirements.txt /code/requirements.txt

# The --no-cache-dir option tells pip to not save the downloaded packages
# locally, as that is only if pip was going to be run again to install the
# same packages, but that's not the case when working with containers.
RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt

# Copy the ./app directory inside the /code directory.
# So, it's important to put this near the end of the Dockerfile, to optimize
# the container image build times.
COPY ./app /code/app
COPY ./main.py /code/main.py

EXPOSE 8000

# Because the program will be started at /code and inside of it is the
# directory ./app with your code, Uvicorn will be able to see and import app
# from app.main.
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
