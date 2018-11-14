# CS 372 Pintos Project Guide

> Fall 2018
------

Pintos Project Guide
--------------------

A significant element of this class are the programming projects using [Pintos](http://pintos-os.org). Pintos is a teaching operating system for 80x86. It is simple and small (compared to Linux). On the other hand, it is realistic enough to help you understand core OS concepts in depth. It supports kernel threads, virtual memory, user programs, and file system. But its original implementations are premature or incomplete. Through the projects, you will be strengthening all of these areas of Pintos to make it complete.

These projects can be hard. They have a reputation of taking a lot of time. But they are also as rewarding as they are challenging. Since Pintos is designed for the 80x86 architecture, at the end of the projects, you could run theoretically the OS that you built on a regular IBM-compatible PC! Of course, during development, running Pintos on bare metal machines each time could be way too time consuming. Instead, you will run the projects in an x86 emulator, in particular, [Bochs](http://bochs.sourceforge.net) or [QEMU](http://fabrice.bellard.free.fr/qemu/).

We will start with a pre-project and then do four substantial projects:

Project    |   Weight  |   Due
-----------|-----------|-----------------------
[Lab 0: Getting Real](project0.md) | 2% | 09/14 11:59 pm
[Lab 1: Threads](project1.md) | 6% | 09/26 11:59 pm
[Lab 2: User Programs](project2.md) | 8% | 10/17 11:59 pm
[Lab 3: Virtual Memory](project3.md) | 12% | 11/16 11:59 pm
[Lab 4: File Systems](project4.md) | 12% | 12/14 11:59 pm
[Lab 4 Indiv.: File System Checker](project4-individual.md)  | 12%  |  12/14 11:59 pm

* * *

### Groups

Lab 0 is an individual project. For Labs 1 and 2, I will randomly assign teams of 3, ensuring that teams between the two labs do not overlap.  For Labs 3 and 4, teams of from 1 to 3 students may self select.  All group labs will have student-reported assessment of their team members.

* * *

### Documentation

*   Pintos source code
*   [Brief overview of the source tree](listing_0.md)
*   [Reference guide](pintos_7.md)
*   The original Pintos [paper](https://benpfaff.org/papers/pintos.pdf)
*   **Pintos documentation contents** [Markdown Links](pintos.md).

* * *

### Version Control

We will be using Git for version control in the class. If you are new to Git, there are plenty of tutorials online that you can read, e.g., [this one](https://www.atlassian.com/git/tutorials).

* * *

### Grading

We will grade your assignments based on test results (**70% of your grade**) as well as design quality (**30% of your grade**). Note that the testing grades are fully automated. So please turn in working code or there is no credit. The instructor will give additional advice on how the design quality will be graded, but most of that 30% comes from the design document for the individual project.

* * *

### Submission

We will be using [GitHub classroom](https://education.github.com) to distribute and collect assignments. You do not have to do anything special to submit your project. We will use a snapshot of your GitHub repository as it exists at the deadline, and grade that version. You can still make changes to your repository after the deadline. But we will be only using the snapshot of your code as of the deadline.

* * *

### Late Policies

Each student receives exactly three days of grace period.  In teams, all team members must have grace period to allow the team to take a grace.  You can take a grace period in units less than a day.  If a project is delayed by a 24 hour day, all team members have used 24 hours of their allotted grace.  Late submissions without or exceeding grace period will receive penalties as follows: 0-23:59 day late, 10% deduction; 24-47:59 days late, 30% deduction; 3 days late, 60% deduction; after 4 days, no credit.

* * *

### Tips

#### GDB Port

If you are using gdb on the lab machines to debug Pintos, you may encounter a port conflict error. That’s because `pintos --gdb` will invoke the `-s` option with QEMU, which in turn is a short-hand for `-gdb tcp::1234`. So multiple users running on the same lab machine might try to compete for the same port. We’ve modified the `pintos` script to add two options to work around this.

*   `--gdb-port` to specify a port explicitly. You can choose any port that’s available to bind gdb, e.g., `pintos --gdb --gdb-port=2430`.
*   `--uport` to calculate a port number deterministically based on the user id. So different users on the lab machines will get a different port. Example: `pintos --gdb --uport`. You can find the generated port in the command verbose output (e.g., `qemu-system-i386 ... -gdb tcp::25501`).

When you use these two options, you also need to change the `target remote` command in the gdb session to point to the specified/calculated port instead of 1234.

#### Mac Users

The original Pintos was mainly developed and tested for Linux (Debian and Ubuntu in particular) and Solaris. It has some issues to run on Mac OS. We have fixed a number of issues and provided scripts to make it run more smoothly with Mac OS. They should be working mostly. But one caveat that you should be aware of is that the `setitimer` system call (used by the `pintos` script to control runtime of tests) in Mac OS seems to have some bug, which may trigger premature timeout when using `pintos` with `--qemu`. To work around this, you can either use the Bochs simulator `--bochs` instead (modify the `src/{threads,userprog,vm,filesys}/Make.vars`) or increase the timeout passed to `pintos` (e.g., change TIMEOUT in `src/tests/Make.tests` to 400).

* * *

### Cheating and Collaboration

**Warning!**

This class has zero tolerance for cheating. We will run tools to check your submission against a comprehensive database of solutions including past and present submissions as well as solutions inappropriately placed on public GitHub repositories, for potential cheating. These tools account for non-substantive differences like changing of variable names, line spacing, and differences in comments.  The consequences of cheating are very high Please read the Denison University's [academic integrity code](https://denison.edu/forms/code-of-academic-integrity).

The basic policies are:

*   Never share code or text on the project. _That also means do not make your solutions public on the Internet, e.g., GitHub public repo_.
*   Never use someone else’s code or text in your solutions.
*   Never consult project code or text found on the Internet.
*   You may read but not copy Linux or BSD source code. _But you must cite any code that inspired your code_. As long as you cite what you used, it’s not cheating. In the worst case, we deduct points if it undermines the assignment.

On the other hand, we encourage collaboration in the following form:

*   Share ideas (but do not give code to others).
*   Explain your code to someone to see if they know why it does not work.
*   Help someone else debug if they’ve got stuck.

* * *
