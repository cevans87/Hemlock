FROM ubuntu AS base
FROM base AS bootstrap-opam
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        opam \
    && rm -rf /var/lib/apt/lists/*
ARG OCAML_VERSION
ENV OPAMROOTISOK=1
ENV OPAMROOT=/opt/opam
COPY bootstrap/Hemlock.opam .
RUN opam init -a --disable-sandboxing --dot-profile="/etc/profile.d/opam-init.sh" \
    && opam switch create ${OCAML_VERSION} \
    && opam install -y --deps-only . \
    && opam install -y ocaml-lsp-server
#ENV PATH=/opt/opam/${OCAML_VERSION}/bin:$PATH \
#    OPAM_SWITCH_PREFIX=/opt/opam/${OCAML_VERSION} \
#    OCAML_TOPLEVEL_PATH=/opt/opam/${OCAML_VERSION}/lib/toplevel \
#    CAML_LD_LIBRARY_PATH=/opt/opam/${OCAML_VERSION}/lib/stublibs:/opt/opam/${OCAML_VERSION}/lib/ocaml/stublibs:/opt/opam/${OCAML_VERSION}/lib/ocaml \
#    MANPATH=$MANPATH:/opt/opam/${OCAML_VERSION}/man

FROM base AS bootstrap-user
ARG USER GROUP HOME UID GID SHELL
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        git \
        python3 \
        sudo \
    && rm -rf /var/lib/apt/lists/*
# TODO be explicit about home directory location
RUN groupadd -r -o -g ${GID} ${GROUP} \
    && useradd -l -m -r -g ${GID} -G sudo -s ${SHELL} -u ${UID} ${USER} \
    && touch ${HOME}/.sudo_as_admin_successful \
    && echo "${USER} ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
USER ${USER}
WORKDIR /home/${USER}
ARG DOTFILES_GIT_REPO DOTFILES_GIT_HASH DOTFILES_INSTALL
#RUN --mount=type=ssh \
#    mkdir -p ~/.ssh \
#    && ssh-keyscan github.com >> ~/.ssh/known_hosts \
#    && ([[ -z ${DOTFILES_GIT_REPO+x} ]] || git clone ${DOTFILES_GIT_REPO})
#    && ([[ -z "${DOTFILES_GIT_HASH}" ]] || git checkout ${DOTFILES_GIT_HASH}) \
#    && ([[ -z "${DOTFILES_INSTALL}" ]] || ./bootstrap/${DOTFILES_INSTALL})
#RUN --mount=type=ssh \
#    ([[ -z "${DOTFILES_REPO}" ]] || git clone ${DOTFILES_REPO}) \
#    && ([[ -z "${DOTFILES_BOOTSTRAP}" ]] || ./${DOTFILES_BOOTSTRAP})
#CMD ["${SHELL}"]

FROM bootstrap-user as bootstrap
COPY --from=bootstrap-opam /etc/profile.d/opam-init.sh /etc/profile.d/opam-init.sh
COPY --from=bootstrap-opam /opt/opam /opt/opam