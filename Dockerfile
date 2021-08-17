FROM public.ecr.aws/lambda/python:3.7

# Copy function code
COPY app.py ${LAMBDA_TASK_ROOT}
COPY artifacts/models ${LAMBDA_TASK_ROOT}/artifacts/models

# Install the function's dependencies using file requirements.txt
# from your project folder.
RUN yum install -y git

COPY requirements.txt .
RUN pip3 install -r requirements.txt --target "${LAMBDA_TASK_ROOT}"

# Set the CMD to your handler (could also be done as a parameter override outside of the Dockerfile)
CMD [ "app.handler" ]
