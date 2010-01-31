config() {
  NEW="$1"
  OLD="$(dirname $NEW)/$(basename $NEW .new)"
  # If there's no config file by that name, mv it over:
  if [ ! -r $OLD ]; then
    mv $NEW $OLD
  elif [ "$(cat $OLD | md5sum)" = "$(cat $NEW | md5sum)" ]; then
    # toss the redundant copy
    rm $NEW
  fi
  # Otherwise, we leave the .new copy for the admin to consider...
}

# Keep same perms on rc files:
for i in dir mrc osd vivaldi; do
  if [ -e etc/rc.d/rc.xtreemfs-$i ]; then
    cp -a etc/rc.d/rc.xtreemfs-$i etc/rc.d/rc.xtreemfs-$i.new.incoming
    cat etc/rc.d/rc.xtreemfs-$i.new > etc/rc.d/rc.xtreemfs-$i.new.incoming
    mv etc/rc.d/rc.xtreemfs-$i.new.incoming etc/rc.d/rc.xtreemfs-$i.new
  fi

  config etc/rc.d/rc.xtreemfs-$i.new
done

