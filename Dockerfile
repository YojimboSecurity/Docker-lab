# kali
FROM kalilinux/kali-linux-docker

# update upgrade
RUN apt-get -y update \
    && apt-get -y upgrade

# Install via apt-get
RUN apt-get install -y git \
    vim nmap python3-dev python3-pip make\
    build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev\
    wget curl llvm libncurses5 libncursesw5-dev\
    xz-utils tk-dev python python-dev python-pip

# Install Metasploit-Framework
RUN apt-get install -y metasploit-framework

# Install Doublepulsar 
RUN git clone https://github.com/ElevenPaths/Eternalblue-Doublepulsar-Metasploit.git ~/Eternalblue-Doublepulsar-Metasploit \
    && cp ~/Eternalblue-Doublepulsar-Metasploit/eternalblue_doublepulsar.rb /usr/share/metasploit-framework/modules/exploits/windows/smb/eternalblue_doublepulsar.rb

# Install impacket
RUN git clone https://github.com/CoreSecurity/impacket.git ~/impacket \
    && cd ~/impacket \
    && python setup.py install

# Install pyenv
RUN git clone https://github.com/pyenv/pyenv.git ~/.pyenv \
    && echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc \
    && echo 'eval "$(pyenv init -)"' >> ~/.bashrc \
    && echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc \
    && echo 'eval "$(pyenv init -)"' >> ~/.bashrc \
    && echo 'export PYENV_VERSION="3.6.1"' \
    && exec $SHELL \
    && . ~/.bashrc  \
    && pyenv install 3.6.1 \
    && pyenv global 3.6.1

# Install requirements
WORKDIR /root
COPY . /root

RUN pip install -r requirements.txt

# Install wine
RUN apt-get update \
    && apt-get install -y wine winbind winetricks \
    && dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y wine32 \
    && WINEPREFIX="$HOME/.wine" \
    && WINEARCH=win32 wine wineboot \
    && echo "export WINEPREFIX=$HOME/.wine" >> ~/.bashrc

# Clean up
RUN apt-get autoclean \
    && apt-get autoremove


