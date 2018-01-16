FROM aietes/rpi3

ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y \
    chromium \
    x11-xserver-utils \
    xinit \
    sqlite3 \
    fbset \
    xwit \
    matchbox \
    unclutter

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV URL="http://node-red:1880/ui"

RUN echo "allowed_users=anybody" > /etc/X11/Xwrapper.config
ADD 99-pitft.conf /usr/share/X11/xorg.conf.d/99-pitft.conf

RUN useradd -m pi

USER pi

RUN mkdir -p /home/pi/.config/chromium/Default
RUN sqlite3 /home/pi/.config/chromium/Default/Web\ Data "CREATE TABLE meta(key LONGVARCHAR NOT NULL UNIQUE PRIMARY KEY, value LONGVARCHAR); INSERT INTO meta VALUES('version','46'); CREATE TABLE keywords (foo INTEGER);";

RUN touch /home/pi/.url && chmod +x /home/pi/.url

ADD xinitrc /home/pi/.xinitrc

ENTRYPOINT echo $URL >> /home/pi/.url && FRAMEBUFFER=/dev/fb1 startx /home/pi/.xinitrc