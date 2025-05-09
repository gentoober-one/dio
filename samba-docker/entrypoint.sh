#!/bin/sh

if ! id sambauser 2>/dev/null; then
    useradd -M -s /sbin/nologin sambauser
fi

chown -R sambauser:sambauser /samba/share
chmod -R 775 /samba/share

if ! pdbedit -L | grep -q sambauser; then
    echo -e "sambapass\nsambapass" | smbpasswd -a -s sambauser
fi

exec /usr/sbin/smbd --foreground --no-process-group --configfile=/etc/samba/smb.conf

