# Official SageMaker Python base image
FROM amazon/aws-sagemaker-pytorch:1.8.1-cpu-py3

# Set the working directory
WORKDIR /opt/ml/code

# Copy the necessary files into the container
COPY model/ /opt/ml/model/
COPY code/ /opt/ml/code/

# Install any additional Python packages required
RUN pip install -r /opt/ml/code/requirements.txt

# Set the entry point to your inference script
ENTRYPOINT ["python", "inference.py"]