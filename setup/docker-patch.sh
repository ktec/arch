cat > /etc/modprobe.d/disable-overlay-redirect-dir.conf <<-FILE
options overlay metacopy=off redirect_dir=off
FILE
