FROM alpine:3.15

RUN apk add curl bash git python3
RUN git clone https://github.com/mazerte/dotfiles /root/.dotfiles && \
  cd /root/.dotfiles && \
  ./install

RUN mkdir /root/workspaces

WORKDIR /root/workspaces

CMD ["zsh"]
