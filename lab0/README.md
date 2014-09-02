# Lab 0

---

## Virtual Box

[Virtual Box](https://www.virtualbox.org/) is a virtualization software package (similar to VMWare or Parallels). We will use it to create a work environment for you to
complete assignments. We will provide an image with latest Ubuntu Linux, with many of the required packages pre-installed.

You are welcome to set up an environment on your own machine, but we won't be able to support it or help you with it. 

- Download and Install Virtual Box on your machine. 
- **Option 1:** 
    - Download the virtual image at: [Virtual Image](http://www.cs.umd.edu/class/fall2014/cmsc498o/UMD-CMSC498-VM.ova) (**Warning**: This is a 2GB file)
    - Start Virtual Box
    - From the main menu, do "Import Appliance", and point at the OVA file that you have downloaded
    - The username and password are both "terrapin"
    - Press Start
    - **Tip:** On Macs, if the Command-Tab stops working, press Command by itself once, and then try Command-Tab again (the first "Command" makes the virtual machine release the keyboard)
    - Move on to **Confirm Things Work** below
- **Option 2:** It is not particularly complicated to recreate the above virtual image yourselves, but we likely won't be able to help you if you
run into problems. Here are the steps we followed:
    - Download the latest Ubuntu ISO from http://www.ubuntu.com/download/desktop. We used the 32-bit version.
    - Create a new virtual machine with options: Type = Linux, Version = Ubuntu (32 bit). 
    - Recommended memory size: 2GB (you would want at least 1GB)
    - Select: "Create a Virtual Hard Drive Now". 
        - Leave the setting for Hard Drive File Type unchanged (i.e., VDI). 
        - Set the hard drive to be "Dynamically Allocated".
        - Size: 8GB
    - The virtual machine is now created. 
    - Press "Start"
        - On the screen asking you to select a virtual optical disk file: Navigate to the Ubuntu ISO that you have downloaded, and Press Start.
        - On the Boot Screen: "Install Ubuntu"
        - Deselect both of "Download Updates while Installing" and "Install Third-Party Software"
        - **Tip:** On Macs, if the Command-Tab stops working, press Command by itself once, and then try Command-Tab again (the first "Command" makes the virtual machine release the keyboard)
        - Press Continue
        - Select "Erase disk and install Ubuntu"
        - Who are you?
            - Name = "Terrapin"; username = "terrapin"; password = "terrapin"; 
            - Select "Log In Automatically"
        - Go get a coffee !!
        - Press "Restart Now"
    - If you are having trouble getting the machine to restart, the problem is likely the boot order. 
        - Go to the Virtual Box Window 
        - Power Off the machine (right click the machine name -- the option is under "Close")
        - Go to "Settings" (under "Machine")
        - Under "System --> Motherboard", you will see the boot order. Deselect CD/DVD, and Press Okay.
        - Press Start again.
    - Hopefully the machine starts now. 
    - Open a Terminal. 
        - Get the setup script: `wget http://www.cs.umd.edu/class/fall2014/cmsc498o/setup-script.sh`
        - Make it executable: `chmod +x setup-script.sh`
        - Run it: `./setup-script.sh`
            - Password: terrapin (unless you used a different password)
            - Say "yes" if you want to be prompted for each package install
    - **Note: You will likely not be able to resize the virtual machine window. After the setup script has finished executing, `restart` the machine to fix that (the setup script installs several packages including `dkms` that take care of it)**
- Confirm things work:
    - **java**: Run `javac` and `java -version` to ensure the programs are running

    - **Git**: See below for more details

    - **Python**: Type `python` and ensure that you see the following:

        ```
        Python 2.7.6 (default, Mar 22 2014, 22:59:38) 
        [GCC 4.8.2] on linux2
        Type "help", "copyright", "credits" or "license" for more information.
        ```

        If you do, push `ctrl+d` to exit the prompt.

    - **sqlite3**: 

        SQLite is an "embedded" SQL database (it doesn't depend on a dedicated server process;  instead the client just manipulated a stored
        datbase file directly.)

        To ensure it is installed, type `sqlite3` and verify that you see the following:

        ```
        SQLite version 3.8.2 2013-12-06 14:53:30
        Enter ".help" for instructions
        Enter SQL statements terminated with a ";"
        sqlite>
        ```

        If you do, push `ctrl+d` to exit the prompt.

    - **MongoDB**:

        MongoDB is a "document database" that stores and queries collections
        of JSON-like documents.  More details at the [the MongoDB
        website](http://www.mongodb.org). We will cover MongoDB later in the semester.

        To ensure that you have it installed correctly, type `mongo` and verify that you see the following:

        ```
        MongoDB shell version: 2.4.9
        connecting to: test
        > 
        ```

        If you do, push `ctrl+d` to exit the prompt.

    - **IPython**: See below

---

## Git & Github

Git is one of  the most widely used version control management system today, and invaluable when working in a team. Github is a web-based hosting service built around Git --
it supports hosting git repositories, user management, etc. There are other similar services, e.g., bitbucket.

We will use Github to distribute the assignments, and other class materials. Our use of git/github for the class will be minimal; however, we encourage you to use it for
collaboration for your class project, or for other classes. 

Repositories hosted on github for free accounts are public; however, you can easily sign up for an educational account which allows you to host 5 private repositories. More
details: https://education.github.com/

- Create an account on Github: https://github.com
- Generate and associate an SSH key with your account
    - Instructions to generate SSH Keys: https://help.github.com/articles/generating-ssh-keys#platform-linux
        - Make sure to remember the passphrase
    - Go to Profile: https://github.com/settings/profile, and SSH Keys (or directly: https://github.com/settings/ssh)
    - Add SSH Key
- Clone the class repository:
    - In Terminal: `git clone git@github.com:umddb/datascience-fall14.git`
    - The master branch should be checked out in a new directory 
- Familiarize yourself with the basic git commands
    - At a minimum, you would need to know: `clone`, `add`, `commit`, `push`, `pull`, `status`
    - But you should also be familiar with how to use **branches**

---

## Python, IPython, and IPython Notebook

Python is becoming the de facto language for data scientists (the most popular alternative being R -- R is perhaps better suited for the analysis/machine learning part,
but less suited for the data cleaning, manipulation parts).

IPython is an enhanced command shell for Python, that offers enhanced introspection, rich media, additional shell syntax, tab completion, and rich history.

IPython Notebook is a web browser-based interface to IPython, and one that we will use for most of the class.

- In Terminal, run: `ipython notebook`
- In the opened browser window, click `New Notebook` to get started
- Follow along with this notebook for further instructions: http://nbviewer.ipython.org/github/umddb/datascience-fall14/blob/master/lab0/IPython-Getting-Started.ipynb

---

## Due (September 12, 2014)

- Create a `fork` of the Github repository above and clone it on your machine
    - Go to: https://github.com/umddb/datascience-fall14
    - You will see the option to `fork`
    - Here is more information on forking: https://help.github.com/articles/fork-a-repo
- Create a new IPython Notebook: call it "My Notebook" (any other name is also fine)
    - (Optional) Experiment with Python commands, including Matplotlib and Pandas command
    - (Required) Download and load one of the datasets from the provided list in the `data` directory, and make any one plot using that data
        - You can use a small portion of the original dataset if it is too big
        - The first link (R Datasets) has lots of small datasets for this purpose
    - Save the Notebook into the github fork that you created
        - Also add the dataset you analyzed
    - Don't forget to `add` and `push` the changes to github
- Email the Notebook Viewer URL for your notebook to us
    - Go to http://nbviewer.ipython.org
    - Put in your github username, and follow to the right file in `lab0`
    - Once you can see the notebook through nbviewer, copy the URL and send it to us
