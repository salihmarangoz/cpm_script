# cpm_script

I made this script for managing packages built with cmake;

- To be able to easily uninstall packages.
- To be able to move compiled packages across other computers (which are using this script)
- To be able to keep installed packages across distro updates or full re-install of the OS.
- To be able to see how much disk space these packages are using

## Install

```bash
BIND_FOLDER="/cpm"
INSTALL_FOLDER="$HOME/.cpm"

$ sudo mkdir "$BIND_FOLDER"
$ sudo chown "$USER":"$USER" "$BIND_FOLDER"
$ mkdir "$INSTALL_FOLDER"

$ sudo mount --bind "$INSTALL_FOLDER" "$BIND_FOLDER"
```

- Run the following command and copy its output. 

```bash
$ echo "$INSTALL_FOLDER $BIND_FOLDER none defaults,bind 0 0"
```

- Run `sudo nano /etc/fstab` and place the text you copied at the end of the file.
- To install the script, run the following commands:

```bash
$ cp cpm_script.sh ~/.cpm_script.sh
$ echo "source ~/.cpm_script.sh" >> ~/.bashrc
```

