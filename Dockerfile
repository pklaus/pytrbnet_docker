FROM pklaus/epics_base:debian-stretch

USER root

# For production use (before uploading to docker hub):
RUN apt-get update \
 && apt-get upgrade --no-install-recommends -yq \
 && apt-get install --no-install-recommends -yq \
  python3 \
  python3-dev \
  python3-pip \
  python3-lxml \
  # to get the repos:
  git \
  # for trbnettools:
  #libtirpc-dev \
  # to cache the daqtools/xml-db for Perl:
  libxml-libxml-perl \
  libdata-treedumper-perl \
  libfile-chdir-perl \
  # for pcaspy:
  swig \
 && apt-get clean && rm -rf /var/lib/apt/lists/* && rm -rf /var/cache/apt

#RUN apt-get update
#RUN apt-get install --no-install-recommends -yq \
#  python3 \
#  python3-dev \
#  python3-pip \
#  python3-lxml \
#  # to get the repos:
#  git \
#  # for trbnettools:
#  #libtirpc-dev \
#  # to cache the daqtools/xml-db for Perl:
#  libxml-libxml-perl \
#  libdata-treedumper-perl \
#  libfile-chdir-perl \
# && echo "done"

RUN ln -s /usr/bin/python3 /usr/bin/python \
 && ln -s /usr/bin/pip3 /usr/bin/pip

### trbnettools ##

RUN cd /var/lib/ \
 #&& git clone git://jspc29.x-matter.uni-frankfurt.de/projects/trbnettools.git --branch libtirpc
 && git clone git://jspc29.x-matter.uni-frankfurt.de/projects/trbnettools.git

RUN cd /var/lib/trbnettools \
 && make TRB3=1 

### daqtools (containing the xml-db) ###

RUN cd /var/lib/ \
 && git clone git://jspc29.x-matter.uni-frankfurt.de/projects/daqtools.git

RUN cd /var/lib/daqtools/xml-db/ \
 && ./xml-db.pl

### PyTrbNet ###

RUN pip install setuptools wheel
RUN pip install pcaspy
RUN pip install trbnet==1.0.2

### Environment variables for PyTrbNet ###

ENV LIBTRBNET /var/lib/trbnettools/trbnetd/libtrbnet.so
ENV XMLDB=/var/lib/daqtools/xml-db/database/
