# Project 0 Design Document

> Denison cs372  
> Fall 2018

## Author(s)

> Fill in your name and email address.

FirstName LastName <email@domain.example>

## Preliminaries

> If you have any preliminary comments on your submission, notes for the
> TAs, or extra credit, please give them here.

> Please cite any offline or online sources you consulted while
> preparing your submission, other than the Pintos documentation, course
> text, lecture notes, and course staff

## Report Sections
### Booting Pintos
-----------

#### QUESTIONS
> Put the screenshots of Pintos running in src/p0.
> A1: Is there any particular issue that you would like us to know?

#### Debugging

##### QUESTIONS: BIOS

> B1: What is the first instruction that gets executed?

> B2: At which physical address is this instruction located?

> B3: Can you guess why the first instruction is like this?

> B4: What are the next three instructions?

##### QUESTIONS: BOOTLOADER
> B5: How does the bootloader read disk sectors? In particular, what BIOS interrupt is used?

> B6: How does the bootloader decides whether it finds the Pintos kernel?

> B7: What happens when the bootloader could not find the Pintos kernel?

> B8: At what point does the bootloader transfer control to the Pintos kernel?

##### QUESTIONS: KERNEL
> B9: Is there any issue in particular that you would like us to know?

### Kernel Monitor
-----------

#### DATA STRUCTURES

> C1: Copy here the declaration of each new or changed `struct` or
> `struct` member, global or static variable, `typedef`, or
> enumeration.  Identify the purpose of each in 25 words or less.

#### ALGORITHMS

> C2: Explain how you read and write to the console for the kernel monitor.

> C3: Any additional enhancement you implemented?