# OMD
#

FROM debian:jessie
MAINTAINER David Dejaeghere, david.dejaeghere@tarpit.be

ENV DEBIAN_FRONTEND="noninteractive"

# Make sure package repository is up to date
RUN apt-get update
RUN apt-get upgrade -y

# Install OMD, see http://labs.consol.de/OMD/
RUN gpg --keyserver keys.gnupg.net --recv-keys F8C1CA08A57B9ED7
RUN gpg --armor --export F8C1CA08A57B9ED7 | apt-key add -
RUN echo "deb http://labs.consol.de/repo/stable/debian jessie main" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y libpython2.7 omd

# Set up a default site
RUN omd create default
# We don't want TMPFS as it requires higher privileges
RUN omd config default set TMPFS off
# Accept connections on any IP address, since we get a random one
RUN omd config default set APACHE_TCP_ADDR 0.0.0.0

ADD entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]

# Set up runtime options
EXPOSE 5000