FROM python:2.7.15-slim-stretch

COPY requirements.txt /

# Install gcc and libc6-dev in order to install pycrypto
# Install python-dev default-libmysqlclient-dev in order to install MySQLdb
RUN set -ex; \
	\
	savedAptMark="$(apt-mark showmanual)"; \
	apt-get update; \
	apt-get install -y --no-install-recommends gcc libc6-dev python-dev default-libmysqlclient-dev; \
	\
	pip install --no-cache-dir -r /requirements.txt; \
	\
	apt-mark auto '.*' > /dev/null; \
	[ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; \
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	rm -rf /var/lib/apt/lists/*;

# libmysqlclient and related packages have been removed above,
# Reinstall default-libmysqlclient-dev, otherwise, MySQLdb will not be available
RUN apt-get update; \
	apt-get install -y --no-install-recommends default-libmysqlclient-dev; \
	\
	rm -rf /var/lib/apt/lists/*;
