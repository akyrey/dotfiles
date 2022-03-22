# Aky dotfiles
Configure Arch Linux, Ubuntu and macOS using Ansible.  
Inspired by [this](https://medium.com/espinola-designs/manage-your-dotfiles-with-ansible-6dbedd5532bb) medium post and related [GitHub repository](https://github.com/kespinola/dotfiles)

## Bootstrap
Run the bootstrap script passing up to one tag. 
> `$ ./bin/bootstrap.sh` 
If no tag is given, all roles are performed. 

The bootstrap script will install `pip` and `ansible` if they are not found. 
