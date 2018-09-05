# Remote Access and Computation Tips

## Passwordless SSH

This enables you to log in to the remote machine without needing to type
a password.  It relies on the asymmetric cryptography of public/private
keys.  

Consider your laptop as the **client**.  Your goal is to *prove* to
a remote server that you are who you say you are.  Normally this is done
by, for a given username, providing a password.  But in a public/private key
system, if you have the private key and can provide it upon request, then a
server entity, holding the public key, can verify that you are who you say
you are, because only you can have the corresponding private key.

To keep the private key truly private, and to be able to store them in disk
files on your client machine, we must make sure that the file permissions
associated with the private key file are restricted to only yourself.

### Directory structure

It is important to remember that there are **two** directory structures
involved.  Say you are user `foo` on your laptop, and user `studen_j1` on the remote
machine(s), where for us, the remote machines are `red1` through `red18` and
`gold1` through `gold4`.  Also realize that, by the magic of a shared and
network file system, **all** of the remote machines have the exact same files
for you underneath your home directory.  This is good, because when we get
passwordless ssh set up to any **one** of the remote machines, it will then work
for **all** of them.

So assume that, on your laptop, your home directory is `/Users/foo` (`~foo`)
and on the remote machines, your home directory is `/users/studen_j1` (`~studen_j1`).
On both sides, ssh-related files are stored in a directory named `.ssh`, which
is a subdirectory directly below the home directory.

### Generating the key pair

On the **client**, from **`~foo`** (your home directory on the client)

0. `mkdir -p .ssh` -- create the `.ssh` directory if it does not already exist; does nothing if the directory already exists
1. `ssh-keygen -t rsa` -- generate the key pair.  When asked for the file in which to save the key, answer `.ssh/cs372_rsa`.  So you are putting the key pair in the client's `.ssh` directory, and we are naming it something non-generic so that processing by default names does not obscure what is happening, which can be helpful if we need to debug the situation.  Accept **no** passphrase.
2. `ls -lt .ssh` -- ask for a full listing of the `.ssh` directory.  You should see both the `.pub` public part of the generated key, and the private part (without the `.pub` suffix), and should see that the public key is readable in the file system for user, group, and other, and that the private key is only readable (and writeable) by user, and no other permissions.

### Putting the public key into place on the remote machine

The goal is for there to be a file named `authorized_keys` on the remote machine such that the public key is appended to the file (so becomes the last set of lines in the file), in case the file already exists.  This file resides in `~bar/.ssh`, i.e. the `.ssh` subdirectory under your home directory on the remote machine(s).

On the **client**, from **`~foo`** (your home directory on the client laptop)

0. `ssh studen_j1@red1.mathsci.denison.edu mkdir -p .ssh` -- create the `.ssh` directory if it does not already exist; does nothing if the directory already exists; you will have to provide your password
1. `cat .ssh/cs372_rsa.pub | ssh studen_j1@red1.mathsci.denison.edu 'cat >> .ssh/authorized_keys'`
2. `type .ssh\cs372_rsa.pub | ssh studen_j1@red1.mathsci.denison.edu "cat >> .ssh/authorized_keys"`

### Checking

On the **client**

```
ssh studen_j1@red1.mathsci.denison.edu -i .ssh/cs372_rsa
```

## Customizing SSH

On the **client**, you can create or modify a file named `config`.  Here, you
can create entries that give you a shorthand for what you do in ssh.  For instance, if, per the example above, I wanted to be able to just say:
```
ssh red1
```
and have ssh "know" the user, the fully qualified domain name for the `red1` machine, and the key/identity file to use, I would add the following to my `.ssh/config` file:
```
Host red1
HostName red1.mathsci.denison.edu
User studen_j1
IdentityFile ~/.ssh/cs372_rsa
```

## Editing remote files using a client editor

The way that this works is really an issue that involves parts on "both sides".  On the remote server side, we want to navigate to a directory where we want a edit an existing file and then issue a command that invokes the editor.  But since the editor is going to be running on our client laptop, the server side command is really going to communicate over an ssh **tunnel**.  The tunnel makes use of an additional bidirectional channel, using very specific known ports, and handles the protocol of providing the data over the tunnel to the client editor (who is listening), and, on each "save" of the file on the client, the editor sends the data over the tunnel back to the running command on the server.

### Server side

From the home directory on the **remote**:

1. `mkdir -p bin` -- create a bin directory under your home directory where you will install the server side command (which is a ruby script)
2. `curl -Lo ~/bin/rmate https://raw.githubusercontent.com/textmate/rmate/master/bin/rmate` -- fetch the github version of the script and put it into your `~/bin` directory
3. `chmod a+x ~/bin/rmate` -- make the script executable
4. At the end of your `~/.profile` or perhaps `~/.bashrc`, depending on what exists and what customization that you have done before, add the following line:
    ```
    export PATH="$PATH:$HOME/bin"
    ```
5. logout and log back in again, or in some manner, restart your bash shell
6. You should be able to type `rmate --help` and get the server command's help message.

### Client side

#### SSH Tunnel

While this can be done with command line arguments to ssh, the easiest way to take care of the ssh tunnel is through an additional entry in the `config` file for ssh.  I tend to add a logical host whose name indicates
the `rmate` function.  So if I wanted to use `ssh red1-rmate`, I would add the following to my config:
```
Host red1-rmate
HostName red1.mathsci.denison.edu
User studen_j1
IdentityFile ~/.ssh/cs372_rsa
RemoteForward 52698 localhost:52698
```

#### Client Editor

My text editor of choice on my laptop is Atom.  Go to `Preferences ...` and the side panel option labeled `+ Install`.  In the search dialog, search for `rmate`, and one of the top hits should be for a package name `remote-atom`.  Click the button to install.

Once installed, under Settings for remote-atom, I have selected both Keep alive, and Launch at startup.  I have left the Port alone at the default of 52698, so that it matches my ssh tunnel.

To test right away, you can navigate to `Packages->Remote Atom->Start Server`

### Running

At this point, you should be able to `ssh red1-rmate` to get a passwordless login to `red1`, or whatever host you have chosen, and also establish the tunnel.  Try something simple like navigating to a directory with a file with known contents, and then typing `rmate <file>`.  On your laptop, navigate to Atom and you should see the remote file.  Whenever you Save in atom, it will get saved on the remote machine.
