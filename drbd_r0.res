resource r0 {
        protocol C;
        startup {
                wfc-timeout 2;
                degr-wfc-timeout 2;
              #  become-primary-on both;
        }
        handlers {
                pri-on-incon-degr "/usr/lib/drbd/notify-pri-on-incon-degr.sh; /usr/lib/drbd/notify-emergency-reboot.sh; echo b > /pr
oc/sysrq-trigger ; reboot -f";
                pri-lost-after-sb "/usr/lib/drbd/notify-pri-lost-after-sb.sh; /usr/lib/drbd/notify-emergency-reboot.sh; echo b > /pr
oc/sysrq-trigger ; reboot -f";
                local-io-error "/usr/lib/drbd/notify-io-error.sh; /usr/lib/drbd/notify-emergency-shutdown.sh; echo o > /proc/sysrq-t
rigger ; halt -f";
                out-of-sync "/usr/lib/drbd/notify-out-of-sync.sh root";
                fence-peer "/usr/lib/drbd/crm-fence-peer.sh";
                split-brain "/usr/lib/drbd/notify-split-brain.sh root";
                after-resync-target "/usr/lib/drbd/crm-unfence-peer.sh";
        }
        net {
          cram-hmac-alg "sha1";
          shared-secret "password";
          after-sb-0pri discard-zero-changes;
          after-sb-1pri discard-secondary;
          after-sb-2pri disconnect;
        }
        disk {
          on-io-error   detach;
#          fencing resource-only;
        }
        syncer {
          rate 500M;
          al-extents 257;
        }
        on host31qm {
                device /dev/drbd0;
                disk /dev/vdd;
                address 192.168.1.31:7789;
                meta-disk internal;
        }
        on host32qm {
                device /dev/drbd0;
                disk /dev/vdd;
                address 192.168.1.32:7789;
                meta-disk internal;
        }
}