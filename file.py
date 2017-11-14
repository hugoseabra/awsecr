from jinja2 import Template


# function to add environment variables to file
def add_env_variables(content, kwargs):
    content = Template(content)
    return content.render(kwargs)


def create(file_path, destination_path, kwargs):
    with open(file_path) as in_file:
        text = in_file.read()
        in_file.close()

    with open(destination_path, 'w+') as out_file:
        out_file.write(add_env_variables(text, kwargs))
        out_file.close()
