ARG FEDORA_MAJOR_VERSION=37

FROM quay.io/fedora-ostree-desktops/silverblue:${FEDORA_MAJOR_VERSION}

RUN rpm-ostree override remove firefox firefox-langpacks && \
    # Enable repo's.
    sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/  vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo' && \
    rpm-ostree install https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm && \
    # Install packages.
    rpm-ostree install akmod-nvidia xorg-x11-drv-nvidia stow podman-docker podman-compose steam-devices code wireguard distrobox gnome-tweaks && \
    # Update kernel parameters.
    rpm-ostree kargs --append=rd.driver.blacklist=nouveau --append=modprobe.blacklist=nouveau --append=nvidia-drm.modeset=1 initcall_blacklist=simpledrm_platform_driver_init && \
    # Cleanup and commit.
    rpm-ostree cleanup -m && \
    ostree container commit
