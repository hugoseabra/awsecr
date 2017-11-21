import os

from renderer import create

BASE_DIR = '/usr/local/etc/awsecr'
TEMPLATE_DIR = BASE_DIR + '/templates'
CONF_DIR = BASE_DIR + '/conf'
HOME_DIR = '/root'

# Prepare home configuration
for dir in (BASE_DIR, '/root/.aws', '/root/.docker'):
    if os.path.isdir(dir):
        continue

    print("Criando diretório: {0}".format(dir))
    os.mkdir(dir)

aws_required_vars = (
    'AWS_KEY',
    'AWS_SECRET',
    'AWS_ACCOUNT_ID',
)

missing_vars = [
    env_var
    for env_var in aws_required_vars
    if env_var not in os.environ
]

if missing_vars:
    raise Exception(
        "You must provide the following environment variables: {0}'".format(
            ", ".join(missing_vars)
        )
    )

if 'AWS_REGION' not in os.environ:
    print("'AWS_REGION' not provided. Default value will be applied.")

if 'AWS_FORMAT' not in os.environ:
    print("'AWS_FORMAT' not provided. Default value will be applied.")

# create dictionary of environment variables
env_dict = {
    'AWS_KEY': os.environ.get('AWS_KEY'),
    'AWS_SECRET': os.environ.get('AWS_SECRET'),
    'AWS_REGION': os.environ.get('AWS_REGION', 'us-east-1'),
    'AWS_ACCOUNT_ID': os.environ.get('AWS_ACCOUNT_ID'),
    'AWS_FORMAT': os.environ.get('AWS_FORMAT', 'json'),
}

# aws configs
create(TEMPLATE_DIR + '/aws-config', '/root/.aws/config', env_dict)
create(TEMPLATE_DIR + '/aws-credentials', '/root/.aws/credentials', env_dict)
create(TEMPLATE_DIR + '/ecr-config', '/root/.aws/ecr', env_dict)

# docker configs
create(CONF_DIR + '/docker-config.json', '/root/.docker/config.json', env_dict)
