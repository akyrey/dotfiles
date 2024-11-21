# Aky dotfiles

Configure Arch Linux, Ubuntu and macOS using Ansible.  
Inspired by [this](https://medium.com/espinola-designs/manage-your-dotfiles-with-ansible-6dbedd5532bb) medium post and related [GitHub repository](https://github.com/kespinola/dotfiles)

## Bootstrap

Run the bootstrap script passing up to one tag.

> `$ ./bin/bootstrap.sh`
> If no tag is given, all roles are performed.

The bootstrap script will install `pip` and `ansible` if they are not found.

### Ansible vault

Files can be encrypted using `ansible-vault create --vault-id project@prompt foo.yml`.

## Common commands/issues

### Import GPG keys

Use the command `gpg --import <keyfile>`

### sudo commands slow to ask for password

The `/etc/hosts` file is missing current hostname. Retrieve it using `hostname` command and add a line to `/etc/hosts`

```
127.0.0.1   localhost <hostname>
```
