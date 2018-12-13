# start from an official image
FROM python:3.6

# arbitrary location choice: you can change the directory
RUN mkdir -p /opt/services/djangoapp/src
WORKDIR /opt/services/djangoapp/src

# install our dependencies
# we use --system flag because we don't need an extra virtualenv
COPY Pipfile Pipfile.lock /opt/services/djangoapp/src/
RUN pip3 install pipenv && pipenv install --system

# copy our project code
COPY . /opt/services/djangoapp/src
RUN cd core && python3 manage.py collectstatic --no-input  # <-- here && python3 manage.py migrate

# expose the port 8000
EXPOSE 8000

# define the default command to run when starting the container
CMD ["gunicorn", "-c", "config/gunicorn/conf.py", "--chdir", "core", "--bind", ":8000", "core.wsgi:application"]
