FROM redhat/ubi8-minimal:8.5-230.1645809059

ENV TF_VERSION="1.1.7"

WORKDIR /tmp/

RUN microdnf update

RUN microdnf install git \
    wget \
    unzip \
    python3 \
    nc

RUN pip-3 install requests \
	pyyaml

RUN wget https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip && \
    unzip terraform_${TF_VERSION}_linux_amd64.zip && \
    mv terraform /usr/local/bin/terraform && \
    rm terraform_${TF_VERSION}_linux_amd64.zip

RUN wget https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm &&  \
    rpm -ivh pgdg-redhat-repo-latest.noarch.rpm && \
    rm -rf pgdg-redhat-repo-latest.noarch.rpm && \
    microdnf install postgresql13 && \
    microdnf update

RUN wget https://github.com/aquasecurity/tfsec/releases/download/v1.7.2/tfsec-linux-amd64 && \
	mv tfsec-linux-amd64 /usr/local/bin/tfsec && \
	chmod +x /usr/local/bin/tfsec

RUN rm -rf /var/cache/yum

RUN useradd -ms /bin/bash jenkins

USER jenkins
